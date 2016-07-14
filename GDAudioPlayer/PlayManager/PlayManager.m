//
//  PlayManager.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "PlayManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicModel.h"
#import "GetMusicUrlManager.h"
NSString * const Player_Status = @"status";                                 //获取到视频信息的状态, 成功就可以进行播放, 失败代表加载失败
NSString * const Player_LoadedTimeRanges = @"loadedTimeRanges";             //当缓冲进度有变化的时候
NSString * const Player_PlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp"; //当视频播放因为各种状态播放停止的时候, 这个属性会发生变化
NSString * const Player_PlaybackBufferEmpty = @"playbackBufferEmpty";       //当没有任何缓冲部分可以播放的时候
NSString * const Player_PlaybackBufferFull = @"playbackBufferFull";         //缓冲完成
NSString * const Player_PresentationSize = @"presentationSize";             //获取到视频的大小的时候调用

@interface PlayManager ()
{
    BOOL isPlaying;
    NSString *_name;
    NSString *_singer;
    NSString *_album;
    NSString *_mid;
    NSInteger currentMusicIndex;//当前播放的歌的位置
}
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation PlayManager

+ (instancetype) defaultManager{
    static PlayManager *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)prepareToPlayMusicWithURl:(NSString *)urlString mname:(NSString *)mname Singer:(NSString*)singer Album:(NSString*)album Mid:(NSString *)mid{
    _name = mname;_singer = singer;_album = album;_mid = mid;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PLAY_NowMusicMessage object:self userInfo:@{@"name":mname,@"singer":singer}];
    if (isPlaying)[self gd_destroy];
    if (!self.player) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        isPlaying = YES;
    }else{
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        isPlaying = YES;
    }
    [self.playerItem addObserver:self forKeyPath:Player_Status options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:Player_Status]) {
        
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {   //准备好播放
            GDLog(@"贮备好播放");
            
            [self gd_play];

        }else if(self.playerItem.status == AVPlayerItemStatusFailed){    //加载失败
            GDLog(@"失败");
            [self gd_pause];
        }else if(self.playerItem.status == AVPlayerItemStatusUnknown){   //未知错误
            [self gd_pause];
            GDLog(@"未知错误");
        }
        
    }else if([keyPath isEqualToString:Player_LoadedTimeRanges]){         //当缓冲进度有变化的时候
        
        if (!isPlaying) {
            [self gd_play];
        }
        
    }else if ([keyPath isEqualToString:Player_PlaybackLikelyToKeepUp]){         //当视频播放因为各种状态播放停止的时候, 这个属性会发生变化
    }else if([keyPath isEqualToString:Player_PlaybackBufferEmpty]){             //当没有任何缓冲部分可以播放的时候

    }else if ([keyPath isEqualToString:Player_PlaybackBufferFull]){
        
        NSLog(@"playbackBufferFull: change : %@", change);
        
    }else if([keyPath isEqualToString:Player_PresentationSize]){                //获取到视频的大小的时候调用
//               CGSize size = _playerItem.presentationSize;;
    }
    
}
#pragma mark - 当前item播放完成
- (void)audioPlayDidEnd:(NSNotification *)noti{
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf gd_destroy];
        [weakSelf autoPlayNextMusic];
    }];
}
#pragma mark - 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)gd_play{
    isPlaying = YES;
    [self.player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PLAY_Start object:nil];
}
- (void)gd_pause{
    isPlaying = NO;
    [self.player pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PLAY_Pause object:nil];
}
- (void)gd_destroy{
    if (self.playerItem) {
        [self gd_pause];
        [self.playerItem removeObserver:self forKeyPath:Player_Status context:nil];
        self.playerItem = nil;
    }
}
- (BOOL)currentPlay{
    return isPlaying;
}
- (void)backgroundNotification:(NSNotification *)noti{
    if (isPlaying) {
        [self backgrounddisplay:_name Singer:_singer AVlayer:self.player.currentItem];
    }
}
#pragma mark - 锁屏显示
- (void)backgrounddisplay:(NSString *)name Singer:(NSString*)singer AVlayer:(AVPlayerItem*)player{
    //建议:锁屏信息最好在程序退出到后台的时候再设置
    //设置锁屏音乐信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //设置专辑名称
    info[MPMediaItemPropertyAlbumTitle] = name;
    //设置歌曲名
    info[MPMediaItemPropertyTitle] = name;
    //设置歌手
    info[MPMediaItemPropertyArtist] = singer;
    //设置专辑图片
    UIImage *image = [UIImage imageNamed:@"side_bg"];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    info[MPMediaItemPropertyArtwork] = artwork;
    //设置歌曲时间
    info[MPMediaItemPropertyPlaybackDuration] = @(CMTimeGetSeconds(player.duration));
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}


/**
 *  切歌
 */
- (void)autoPlayNextMusic {
   //之前播放的歌在list中的位置
    isPlaying = YES;
    NSArray *array = [[PlayListSQL shareInstance] SQL_getPlaylist_FromDB];
    if (array<=0) {
        isPlaying = NO;
        return;
    }
    currentMusicIndex = [[SingleManager defaultManager] indexofMid:[NSString stringWithFormat:@"%@",_mid] where:array];
    GDLog(@"%ld",currentMusicIndex);
    currentMusicIndex++;
    if (currentMusicIndex > array.count-1) {
        currentMusicIndex = 0;
    }
    GDLog(@"%ld",currentMusicIndex);
    NSDictionary *dic = array[currentMusicIndex];
    [[GetMusicUrlManager shareInstance] getlistenMusicURL:[NSString stringWithFormat:@"%@",dic[@"mid"]] Singer:dic[@"msinger"] Album:_album];
    
}
- (void)next{
    
    
    
}
- (void)Previous{
    
}
@end
