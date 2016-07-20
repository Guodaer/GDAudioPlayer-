//
//  AudioPlayDetailView.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AudioPlayDetailView.h"
#import "GDSlider.h"
#import "LrcManger.h"
#import "GDLrcAnalysis.h"
#import "LrcModel.h"
#import "LrcTimeContentModel.h"
@interface AudioPlayDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL audio_PlayState;
    float _musicTime;
    NSInteger currentRow;//当前在第几行
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

@property (nonatomic, strong) UITableView *tableView;         //歌词显示
@property (nonatomic, strong) NSMutableArray *audio_LrcArray;

/** 负责更新歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *updateLrcLink;

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
    [_tableView removeFromSuperview];_tableView = nil;
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
    
    [self lrcPickerView];//歌词显示

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

    _audio_progress = [[UIProgressView alloc] initWithFrame:CGRectMake(42, CGRectGetMidY(self.controlView.frame)-48, SCREENWIDTH-84, 2)];
    _audio_progress.progressTintColor = [UIColor grayColor];
    [self addSubview:_audio_progress];
    _audio_slider = [[GDSlider alloc] initWithFrame:CGRectMake(40, CGRectGetMidY(self.controlView.frame)-60, SCREENWIDTH-80, 25)];
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
        _totalTime.text =calculateTimeWithTimeFormatter([dic[@"totalTime"]floatValue]);
    }
    if (_currentTime) {
        _currentTime.text = calculateTimeWithTimeFormatter([dic[@"currsecond"] floatValue]);
        _musicTime = [dic[@"currsecond"] floatValue];
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
    if (!_updateLrcLink) {
        GDLog(@"🍎开始通知");
        [self updateLrcLink];
    }
}
- (void)pauseMusic:(NSNotification *)noti{
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateHighlighted];
    audio_PlayState = NO;
    if (_updateLrcLink) {
        [self.updateLrcLink invalidate];
        self.updateLrcLink = nil;
        GDLog(@"🍌通知invalidate");
    }
}
- (void)changeTime:(NSString *)time {
    
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-40, CGRectGetMidY(self.controlView.frame)-60, 40, 25)];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.controlView.frame)-60, 40, 25)];
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
#pragma mark - PickerView
- (void)lrcPickerView {
    _audio_LrcArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 120, SCREENWIDTH-60, SCREENHEIGHT-320)];
    [self addSubview:_tableView];
    // 设置tableview内边距, 可以让第一行和最后一行歌词显示到中间位置
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height * 0.5, 0, self.tableView.frame.size.height * 0.5, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self analysisLrc];

}
#pragma mark - 歌词解析
- (void)analysisLrc {
    
    //解析歌词
    NSString *path = [[NSBundle mainBundle] pathForResource:@"10736444" ofType:@"lrc"];//10405520
    LrcManger *manager = [[GDLrcAnalysis defaultManager] analysisLrc:path];//解析歌词的类
    [_audio_LrcArray addObjectsFromArray:manager.lrc_tcArray];
    [_tableView reloadData];
    if ([[PlayManager defaultManager] currentPlay]) {
        GDLog(@"🍊 创建定时器");
        [self updateLrcLink];
        if (SingleGetCurrentTime){
            NSInteger row = [self getRowWithCurrentTime:SingleGetCurrentTime];
            [self scrollViewToIndexPathRow:row];
        }
    }
}
#pragma mark - 判断当前时间
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _audio_LrcArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    for (id view in cell.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-60, 40)];
    [cell addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    if (indexPath.row == currentRow) {
        label.textColor = [UIColor yellowColor];
    }
    LrcTimeContentModel *lrc_tcModel = _audio_LrcArray[indexPath.row];
    label.text = lrc_tcModel.lrcEach;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  负责更新歌词的时钟
 *
 *  @return updateLrcLink
 */
- (CADisplayLink *)updateLrcLink
{
    if (!_updateLrcLink) {
        _updateLrcLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
        [_updateLrcLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _updateLrcLink;
}
- (void)updateLrc
{
    if (!_musicTime) {
        return;
    }
    NSInteger row = [self getRowWithCurrentTime:_musicTime];
    [self scrollViewToIndexPathRow:row];
}
- (void)scrollViewToIndexPathRow:(NSInteger)row {
    if (currentRow == row) {
        return;
    }
    currentRow = row;
    // 获取需要滚动的IndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
    // 刷新表格
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    
    // 滚动到对应行
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];


}
- (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime {
    
    // 遍历每一个歌词数据模型, 如果发现当歌曲播放时间 大于歌词的开始时间, 并且小于歌词的结束时间, 就返回
//    NSInteger i = 0;
    NSInteger count = _audio_LrcArray.count;
    for (NSInteger i = 0; i < count-1; i++) {
        LrcTimeContentModel *lrcModel = _audio_LrcArray[i];
        LrcTimeContentModel *lrcModel_end = _audio_LrcArray[i+1];
        if (currentTime >= lrcModel.seconds && currentTime < lrcModel_end.seconds) {
            return i;
        }
    }
    // 如果都没查找到, 并且是存在时间, 是当做最后一行处理, 防止跳回到第一行
    if (currentTime > 0) {
        return count - 1;
    }
    return 0;
}
- (void)invalidateLrc {
    if (_updateLrcLink) {
        [self.updateLrcLink invalidate];self.updateLrcLink = nil;
    }
}
@end
