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
@interface RootViewController ()<HomePageCollectionViewDelegate>
{
    NSMutableArray *arr;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgimageView.image = XUIImage(@"side_bg1");
    [self.view addSubview:bgimageView];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"10405520" ofType:@"lrc"];
    //    [[GDLrcAnalysis defaultManager] analysisLrc:path];//解析歌词的类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMenuViewController:) name:Notification_Menu_Present object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAudioPlayDetailViewController:) name:Notification_AudioPlayDetail_Present object:nil];
    
    [self createHomePageCollection];
    
}
- (void)createHomePageCollection{
    HomePageCollectionView *hpcv = [[HomePageCollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-60)];
    hpcv.gd_delegate = self;
    [self.view addSubview:hpcv];
    
}
- (void)collectiondidSelectItemAtIndexPathModel:(MusicModel *)model{
    MusicDetailVController *md = [[MusicDetailVController alloc] init];
    md.needModel = model;
    [self.navigationController pushViewController:md animated:YES];
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
