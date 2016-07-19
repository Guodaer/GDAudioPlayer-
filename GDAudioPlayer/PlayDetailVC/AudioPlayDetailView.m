//
//  AudioPlayDetailView.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AudioPlayDetailView.h"
#import "GDSlider.h"
@interface AudioPlayDetailView ()
{
    BOOL audio_PlayState;
}
@property (nonatomic, strong) UILabel *titlelabel;              //musictitle

@property (nonatomic, strong) UILabel *singerlabel;             //singer

@property (nonatomic, strong) UIView *controlView;              //

@property (nonatomic, strong) UIButton *nextButton;             //下一首

@property (nonatomic, strong) UIButton *forwardButton;          //上一首

@property (nonatomic, strong) UIButton *playButton;             //播放按钮

@property (nonatomic, strong) UIProgressView *audio_progress;   //进度条

@property (nonatomic, strong) GDSlider *audio_slider;           //silder

@property (nonatomic, strong) UILabel *currentTime;

@property (nonatomic, strong) UILabel *totalTime;

@end


@implementation AudioPlayDetailView
- (void)dealloc{
    [_titlelabel removeFromSuperview];_titlelabel = nil;
    [_singerlabel removeFromSuperview];_singerlabel = nil;
    [_controlView removeFromSuperview];_controlView = nil;
    [_nextButton removeFromSuperview];_nextButton = nil;
    [_forwardButton removeFromSuperview];_forwardButton = nil;
    [_playButton removeFromSuperview];_playButton = nil;
    [_totalTime removeFromSuperview];_totalTime = nil;
    [_currentTime removeFromSuperview];_currentTime = nil;
    NSLog(@"audio dealloc");
}
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XUIColor(0x000000, 0.90);
        [self AudioCreateUIView];
    }
    return self;
}
- (void)AudioCreateUIView {
    [self createHeader];
    [self createUIControl];
    
  

}
- (void)createUIControl {
    //初次进来显示之前保存的当前播放
    NSDictionary *dic = UserDefault(CurrentPlay_Music);
    if (dic) {
        self.titlelabel.text = dic[@"mname"];self.singerlabel.text = dic[@"msinger"];
    }
    self.controlView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT-90);
    [self addSubview:self.controlView];
    [self.controlView addSubview:self.nextButton];
    [self.controlView addSubview:self.forwardButton];
    [self.controlView addSubview:self.playButton];
    
    if ([[PlayManager defaultManager] currentPlay]) {
        [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_pause_normal") forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_pause_highlight") forState:UIControlStateHighlighted];
        audio_PlayState = YES;
    }else{
        audio_PlayState = NO;
    }
    
    _audio_progress = [[UIProgressView alloc] initWithFrame:CGRectMake(32, CGRectGetMidY(self.controlView.frame)-48, SCREENWIDTH-64, 2)];
    _audio_progress.progressTintColor = [UIColor grayColor];
    [self addSubview:_audio_progress];
    _audio_slider = [[GDSlider alloc] initWithFrame:CGRectMake(30, CGRectGetMidY(self.controlView.frame)-60, SCREENWIDTH-60, 25)];
    [_audio_slider addTarget:self action:@selector(audioSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_audio_slider addTarget:self action:@selector(audioSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audio_slider];
    
    //时间label
    [self addSubview:self.totalTime];
    [self addSubview:self.currentTime];
    if (SingleGetTotalTime) {self.totalTime.text = calculateTimeWithTimeFormatter(SingleGetTotalTime);}
    else{self.totalTime.text = calculateTimeWithTimeFormatter(0);}
    if (SingleGetCurrentTime) {self.currentTime.text = calculateTimeWithTimeFormatter(SingleGetCurrentTime);}
    else {self.currentTime.text = calculateTimeWithTimeFormatter(0);}
    if (SingleGetCurrentTime&&SingleGetTotalTime) {
        _audio_slider.value = SingleGetCurrentTime/SingleGetTotalTime;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusic:) name:Notification_PLAY_Start object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMusic:) name:Notification_PLAY_Pause object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMusicMessage:) name:Notification_PLAY_NowMusicMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressValuenotification:) name:Notification_Audio_Progress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChangeSliderValue:) name:Notification_Audio_SliderValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTime:) name:Notification_Audio_Time object:nil];
}
- (void)audioSliderValueChanged:(UISlider*)slider{
    [[PlayManager defaultManager] seekToTheTimeValue:slider.value];
}
- (void)audioSliderTouchUpInside:(UISlider*)slider{
    [[PlayManager defaultManager] pansSliderValueFinfished];
}

#pragma mark - 播放过程通知
- (void)notificationTime:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    if (_totalTime) {
        _totalTime.text = dic[@"totalTime"];
    }
    if (_currentTime) {
        _currentTime.text = dic[@"currsecond"];
    }
}
- (void)notificationChangeSliderValue:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    if (_audio_slider) {
        _audio_slider.value = [dic[@"value"] floatValue];
    }
}
- (void)progressValuenotification:(NSNotification*)nofi {
    NSDictionary *dic = [nofi userInfo];
    if (_audio_progress) {
        _audio_progress.progress = [dic[@"progress"] floatValue];
    }
}
- (void)updateMusicMessage:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    self.titlelabel.text = dic[@"name"];
    self.singerlabel.text = dic[@"singer"];
}
- (void)playMusic:(NSNotification *)noti{
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_pause_normal") forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_pause_highlight") forState:UIControlStateHighlighted];
    audio_PlayState = YES;
    
}
- (void)pauseMusic:(NSNotification *)noti{
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateHighlighted];
    audio_PlayState = NO;
    
}
//header
- (void)createHeader{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 25, 40, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button setImage:XUIImage(@"APD_dismiss") forState:UIControlStateNormal];
    [button setImage:XUIImage(@"APD_dismiss") forState:UIControlStateHighlighted];
    [self addSubview:button];
    [button addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.titlelabel];
    [self addSubview:self.singerlabel];
    }
#pragma mark - 按钮点击事件

#pragma mark - 懒加载
//totalTime
- (UILabel *)totalTime{
    if(!_totalTime){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-30, CGRectGetMidY(self.controlView.frame)-60, 30, 25)];
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        _totalTime = label;
    }
    return _totalTime;
}
//currentTime
- (UILabel *)currentTime{
    if(!_currentTime){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.controlView.frame)-60, 30, 25)];
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        _currentTime = label;
    }
    return _currentTime;
}
//播放
- (UIButton *)playButton{
    if(!_playButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(82.5, 2.5, 55, 55);
        [button setBackgroundImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_PlayButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton = button;
    }
    return _playButton;
}
//下一首
-(UIButton *)nextButton{
    if(!_nextButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(220-40, 10, 40, 40);
        [button setBackgroundImage:XUIImage(@"tabbar_audio_next_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"tabbar_audio_next_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_NextButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton = button;
        
    }
    return _nextButton;
}
//上一首
- (UIButton *)forwardButton{
    if (!_forwardButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 10, 40, 40);
        [button setBackgroundImage:XUIImage(@"APD_audio_forward_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"APD_audio_forward_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_ForwardButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _forwardButton = button;
    }
    return _forwardButton;
}
- (UIView *)controlView{
    if (!_controlView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
        view.userInteractionEnabled = YES;
        _controlView = view;
    }
    return _controlView;
}
//singer
- (UILabel *)singerlabel{
    if (!_singerlabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        label.center = CGPointMake(SCREENWIDTH/2, 65);
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        _singerlabel = label;
    }
    return _singerlabel;
}
//歌曲名
- (UILabel *)titlelabel{
    if (!_titlelabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.center = CGPointMake(SCREENWIDTH/2, 40);
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        _titlelabel = label;
    }
    return _titlelabel;
}
#pragma mark - 点击事件
- (void)dismissVC:(UIButton *)sender {
    if ([_gd_delegate respondsToSelector:@selector(audioViewdismiss:)]) {
        [_gd_delegate audioViewdismiss:sender];
    }
}
- (void)audioBtnClick:(UIButton*)sender{
//    if ([_gd_delegate respondsToSelector:@selector(audioViewBtnclick:)]) {
//        [_gd_delegate audioViewBtnclick:sender];
//    }
    if (sender.tag == Audio_PlayButtonTag) {
        if (audio_PlayState) {
            audio_PlayState = NO;
            UD_SetValue([NSNumber numberWithInteger:HandPause], Hand_pause);
            [[PlayManager defaultManager] gd_pause];
        }else{
            audio_PlayState = YES;
            UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
            [[PlayManager defaultManager] tabbar_play];
        }
    }else if (sender.tag == Audio_NextButtonTag){
        UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
        [[PlayManager defaultManager] next];
    }else if (sender.tag == Audio_ForwardButtonTag){
        UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
        [[PlayManager defaultManager] previous];
    }
}
@end
