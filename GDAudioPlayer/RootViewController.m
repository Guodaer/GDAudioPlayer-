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
#import "HomePageCollectionView.h"
#import "MusicDetailVController.h"
#import "HomeManagerView.h"
#import "DownloadVController.h"
#import "PlayListSQL.h"
#import "AudioPlayDetailView.h"
@interface RootViewController ()<HomePageCollectionViewDelegate,HomeMangerViewDelegate,UIScrollViewDelegate,AudioPlayDetailDelegate>
{
    NSMutableArray *arr;
    AudioPlayDetailView *_audioView;
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
//    LrcManger *manager = [[GDLrcAnalysis defaultManager] analysisLrc:path];//解析歌词的类
//    GDLog(@"%@",manager.lrc_tcArray);
    
    
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
#pragma mark - 音乐歌词展示界面Delegate
- (void)audioViewdismiss:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        _audioView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        [_audioView invalidateLrc];
        [_audioView removeFromSuperview];
        _audioView = nil;
    }];
}
#pragma mark - 手势的滑动效果
- (void)handlePans:(UIPanGestureRecognizer *)recognizer{
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    CGPoint center = recognizer.view.center;
    CGPoint translation = [recognizer translationInView:self.view];//返回在横纵坐标上拖动了多少像素
    recognizer.view.center = CGPointMake(center.x+translation.x, center.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    CGPoint newCenter = recognizer.view.center;
    CGFloat newX = newCenter.x;
    CGFloat wid = self.view.frame.size.width/2;
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        recognizer.view.center = CGPointMake(center.x + translation.x, _audioView.frame.size.height/2+fabs(wid-newX)/wid*50);
        CGFloat angle = M_PI_4/2.5*(wid-newX)/wid;
        //判断x位置变化
        CGAffineTransform transform = CGAffineTransformMakeRotation(-angle);
        _audioView.transform = transform;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(wid-newX) > 200) {
            [UIView animateWithDuration:0.3 animations:^{
                if (newX < wid) {
                    recognizer.view.center = CGPointMake(newCenter.x-wid*2, newCenter.y);
                }else{
                    recognizer.view.center = CGPointMake(newCenter.x+wid*2, newCenter.y);
                }
            } completion:^(BOOL finished) {
                [_audioView removeFromSuperview];_audioView = nil;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                
                _audioView.transform = transform;
                
                _audioView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
#pragma mark - tabbar Notification
- (void)presentAudioPlayDetailViewController:(NSNotification *)notifi {
    _audioView = [[AudioPlayDetailView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
    _audioView.gd_delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_audioView];
    [UIView animateWithDuration:0.3 animations:^{
        _audioView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        [_audioView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePans:)]];
    }];
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
