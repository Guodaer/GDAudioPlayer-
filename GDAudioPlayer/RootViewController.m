//
//  RootViewController.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "RootViewController.h"
#import "GDLrcAnalysis.h"
#import "MenuViewController.h"
#import "AudioPlayDetailVC.h"
#import "HomePageCollectionView.h"
#import "MusicDetailVController.h"
#import "HomeManagerView.h"
#import "DownloadVController.h"

@interface RootViewController ()<HomePageCollectionViewDelegate,HomeMangerViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *arr;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navbgView;
@property (nonatomic, strong) UIButton *navbtn1;
@property (nonatomic, strong) UIButton *navbtn2;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgimageView.image = XUIImage(@"side_bg1");
    [self.view addSubview:bgimageView];
    [self drawnavigation];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"10405520" ofType:@"lrc"];
    //    [[GDLrcAnalysis defaultManager] analysisLrc:path];//解析歌词的类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMenuViewController:) name:Notification_Menu_Present object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAudioPlayDetailViewController:) name:Notification_AudioPlayDetail_Present object:nil];
    
    [self.view addSubview:self.scrollView];

    [self createHomePageCollection];
    [self createHomeManagerView];
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-60)];
        scrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, SCREENHEIGHT-64-60);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}
#pragma mark - 下载管理
- (void)createHomeManagerView {
    HomeManagerView *hmv = [[HomeManagerView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame))];
    hmv.gd_delegate = self;
    [self.scrollView addSubview:hmv];
}
- (void)HomeManagerDelegateSelected:(UIButton *)sender{
    DownloadVController *dvc = [[DownloadVController alloc] init];
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 专辑
- (void)createHomePageCollection{
    HomePageCollectionView *hpcv = [[HomePageCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame))];
    hpcv.gd_delegate = self;
    [self.scrollView addSubview:hpcv];
    
}
- (void)collectiondidSelectItemAtIndexPathModel:(MusicModel *)model{
    MusicDetailVController *md = [[MusicDetailVController alloc] init];
    md.needModel = model;
    [self.navigationController pushViewController:md animated:YES];
}
- (void)drawnavigation {
    UIView *albumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.navigationItem.titleView = albumView;
    
    _navbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150/2, 30)];
    _navbgView.userInteractionEnabled = YES;
    _navbgView.backgroundColor = XUIColor(0xededed, 0.2);
    _navbgView.layer.cornerRadius = 5;
    _navbgView.clipsToBounds = YES;
    [albumView addSubview:_navbgView];
    
    UIButton *navBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    navBtn1.frame = CGRectMake(0, 0, 150/2, 30);
    navBtn1.tag = 100000;
    [navBtn1 setTitle:@"专辑" forState:UIControlStateNormal];
    [navBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navBtn1 addTarget:self action:@selector(navbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [albumView addSubview:navBtn1];
    _navbtn1 = navBtn1;
    
    UIButton *navBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    navBtn2.frame = CGRectMake(150/2, 0, 150/2, 30);
    [navBtn2 setTitle:@"我的" forState:UIControlStateNormal];
    navBtn2.tag = 100001;
    [navBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [navBtn2 addTarget:self action:@selector(navbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [albumView addSubview:navBtn2];
    _navbtn2 = navBtn2;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float offsetx = scrollView.contentOffset.x;
    _navbgView.frame = CGRectMake(75*offsetx/SCREENWIDTH, 0, 150/2, 30);
    if (offsetx>SCREENWIDTH/2) {
        [_navbtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_navbtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_navbtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_navbtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)navbtnClick:(UIButton *)sender {

    if (sender.tag == 100000) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-60-64) animated:YES];
    }else if (sender.tag == 100001){
        [self.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH, 64, SCREENWIDTH, SCREENHEIGHT-60-64) animated:YES];
    }
    
}
- (void)presentAudioPlayDetailViewController:(NSNotification *)notifi {
    AudioPlayDetailVC *apd = [[AudioPlayDetailVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:apd animated:YES completion:nil];
}
- (void)presentMenuViewController:(NSNotification*)notifi {
    MenuViewController *menu = [[MenuViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:menu animated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
