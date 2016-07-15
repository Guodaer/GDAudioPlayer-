//
//  GDTabbarController.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "GDTabbarController.h"
#import "RootViewController.h"
#import "GDNavigationController.h"
@interface GDTabbarController ()
{
    BOOL playButton_Play;                   //播放按钮状态
    
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *next_control;

@property (nonatomic, strong) UIButton *listMenu_control;

@property (nonatomic, strong) UILabel *music_message1;

@property (nonatomic, strong) UILabel *music_message2;
@end

@implementation GDTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    playButton_Play = NO;
    // Do any additional setup after loading the view.
    self.tabBar.hidden = YES;
    CGRect rect = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, SCREENHEIGHT-60, rect.size.width, 60)];
    _bgView.backgroundColor = XUIColor(0x000000, 0.35 );
    [self.view addSubview:_bgView];
    
    RootViewController *root = [[RootViewController alloc] init];
    GDNavigationController *nav = [[GDNavigationController alloc] initWithRootViewController:root];
    [nav.navigationBar setBackgroundImage:XUIImage(@"navAlpha0") forBarMetrics:0];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.viewControllers = @[nav];
    
    [self drawContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusic:) name:Notification_PLAY_Start object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMusic:) name:Notification_PLAY_Pause object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMusicMessage:) name:Notification_PLAY_NowMusicMessage object:nil];
}

#pragma mark - 播放过程通知
- (void)updateMusicMessage:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    _music_message1.text = dic[@"name"];
    _music_message2.text = dic[@"singer"];
}
- (void)playMusic:(NSNotification *)noti{
    [self.music_IconSquare.layer addAnimation:[self iconRotate] forKey:nil];
    [self.play_control setImage:XUIImage(@"tabbar_audio_pause_normal") forState:UIControlStateNormal];
    [self.play_control setImage:XUIImage(@"tabbar_audio_pause_highlight") forState:UIControlStateNormal];
    playButton_Play = YES;

}
- (void)pauseMusic:(NSNotification *)noti{
    [self.music_IconSquare.layer removeAllAnimations];
    [self.play_control setImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
    [self.play_control setImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateNormal];
    playButton_Play = NO;

}
#pragma mark - UI
- (void)drawContext{
    
    self.music_IconSquare.image = XUIImage(@"musicIcon");
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-(40*3+40), 10, 40, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button addTarget:self action:@selector(playControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
    _play_control = button;
    [self.play_control setImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
    [self.play_control setImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateNormal];

    [_bgView addSubview:self.listMenu_control];
    [_bgView addSubview:self.next_control];
    [_bgView addSubview:self.music_message1];
    [_bgView addSubview:self.music_message2];
    
    //加tap
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-180, 60)];
    view.userInteractionEnabled = YES;
    [_bgView addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPostNotification:)];
    [view addGestureRecognizer:tap];
    
}
- (void)tapPostNotification:(UITapGestureRecognizer *)tap {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AudioPlayDetail_Present object:nil];
}
/**
 *  列表按钮
 *
 *  @return _listMenu_control
 */
- (UIButton *)listMenu_control{
    if (!_listMenu_control) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREENWIDTH-(40+14), 10, 40, 40);
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(presentListMenu:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:XUIImage(@"list_menu_normal") forState:UIControlStateNormal];
        [button setImage:XUIImage(@"list_menu_highlight") forState:UIControlStateNormal];
        _listMenu_control = button;
    }
    return _listMenu_control;
}
- (void)presentListMenu:(UIButton *)button {
    [self currentMusicMenu];
}
#pragma mark - listMenu
- (void)currentMusicMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Menu_Present object:nil];
}

/**
 *  下一首按钮
 *
 *  @return _next_control
 */
- (UIButton *)next_control{
    if (!_next_control) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREENWIDTH-(40*2+27), 10, 40, 40);
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button setImage:XUIImage(@"tabbar_audio_next_normal") forState:UIControlStateNormal];
        [button setImage:XUIImage(@"tabbar_audio_next_highlight") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(nextMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _next_control = button;
    }
    return _next_control;
}
- (void)nextMusicBtnClick:(UIButton*)sender {
    UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
    [[PlayManager defaultManager] next];
}
/**
 *  播放按钮点击事件
 *
 *  @param sender
 */
- (void)playControlClick:(UIButton *)sender {
    
    if (!playButton_Play) {
//        [self.music_IconSquare.layer addAnimation:[self iconRotate] forKey:nil];
//        [self.play_control setImage:XUIImage(@"tabbar_audio_pause_normal") forState:UIControlStateNormal];
//        [self.play_control setImage:XUIImage(@"tabbar_audio_pause_highlight") forState:UIControlStateNormal];
        playButton_Play = YES;
        UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
        [[PlayManager defaultManager] gd_play];
        
    }else{
//        [self.music_IconSquare.layer removeAllAnimations];
//        [self.play_control setImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
//        [self.play_control setImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateNormal];
        playButton_Play = NO;
        UD_SetValue([NSNumber numberWithInteger:HandPause], Hand_pause);
        [[PlayManager defaultManager] gd_pause];
    }
}
#pragma mark - 头像旋转
- (CABasicAnimation*)iconRotate{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    animation.duration = 2.50;
    //旋转效果累计
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

- (UIImageView*)music_IconSquare{
    if (!_music_IconSquare) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_bgView addSubview:imageView];
        _music_IconSquare = imageView;
    }
    return _music_IconSquare;
}
- (UILabel *)music_message1{
    if (!_music_message1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH-160-60, 30)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        _music_message1 = label;
    }
    return _music_message1;
}
- (UILabel *)music_message2{
    if (!_music_message2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, SCREENWIDTH-160-60, 20)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        _music_message2 = label;
    }
    return _music_message2;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.music_IconSquare.layer removeAllAnimations];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.music_IconSquare.layer addAnimation:[self iconRotate] forKey:nil];
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
