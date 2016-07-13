//
//  PlayManager.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "PlayManager.h"
#import <MediaPlayer/MediaPlayer.h>

NSString * const Player_Status = @"status";                                 //获取到视频信息的状态, 成功就可以进行播放, 失败代表加载失败
NSString * const Player_LoadedTimeRanges = @"loadedTimeRanges";             //当缓冲进度有变化的时候
NSString * const Player_PlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp"; //当视频播放因为各种状态播放停止的时候, 这个属性会发生变化
NSString * const Player_PlaybackBufferEmpty = @"playbackBufferEmpty";       //当没有任何缓冲部分可以播放的时候
NSString * const Player_PlaybackBufferFull = @"playbackBufferFull";         //缓冲完成
NSString * const Player_PresentationSize = @"presentationSize";             //获取到视频的大小的时候调用

@interface PlayManager ()
{
    BOOL isPlaying;
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

- (void)prepareToPlayMusicWithURl:(NSString *)urlString {
    if (isPlaying) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    }else{
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        [self.playerItem addObserver:self forKeyPath:Player_Status options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    
}

- (void)gd_play{
    isPlaying = YES;
    [self.player play];
}
- (void)gd_pause{
    isPlaying = NO;
    [self.player pause];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:Player_Status]) {
        
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {   //准备好播放
            GDLog(@"贮备好播放");
            
            [self gd_play];
            
        }else if(self.playerItem.status == AVPlayerItemStatusFailed){    //加载失败
            
        }else if(self.playerItem.status == AVPlayerItemStatusUnknown){   //未知错误

        }
        
    }else if([keyPath isEqualToString:Player_LoadedTimeRanges]){         //当缓冲进度有变化的时候
        
//        NSTimeInterval timeInterval = [self availableDuration];
//        CMTime duration = _playerItem.duration;
//        CGFloat totalDuration = CMTimeGetSeconds(duration);

        
    }else if ([keyPath isEqualToString:Player_PlaybackLikelyToKeepUp]){         //当视频播放因为各种状态播放停止的时候, 这个属性会发生变化
    }else if([keyPath isEqualToString:Player_PlaybackBufferEmpty]){             //当没有任何缓冲部分可以播放的时候

    }else if ([keyPath isEqualToString:Player_PlaybackBufferFull]){
        
        NSLog(@"playbackBufferFull: change : %@", change);
        
    }else if([keyPath isEqualToString:Player_PresentationSize]){                //获取到视频的大小的时候调用
        //       CGSize size = _playerItem.presentationSize;
    }
    
}
- (void)audioPlayDidEnd:(NSNotification *)noti{
    [self gd_pause];
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





- (void)backgrounddisplay:(NSString *)name Singer:(NSString*)singer AVlayer:(AVPlayerItem*)player{
    //建议:锁屏信息最好在程序退出到后台的时候再设置
    //设置锁屏音乐信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //设置专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"网络热曲";
    //设置歌曲名
    info[MPMediaItemPropertyTitle] = name;
    //设置歌手
    info[MPMediaItemPropertyArtist] = singer;
    //设置专辑图片
    UIImage *image = [UIImage imageNamed:@"side_bg"];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    info[MPMediaItemPropertyArtwork] = artwork;
    //设置歌曲时间
    float durationSeconds = CMTimeGetSeconds(player.duration);
    info[MPMediaItemPropertyPlaybackDuration] = @(durationSeconds);
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:

                break;
            case UIEventSubtypeRemoteControlPause:
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}

@end
