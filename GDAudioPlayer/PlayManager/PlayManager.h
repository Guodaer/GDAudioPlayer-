//
//  PlayManager.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayManager : NSObject

+ (instancetype) defaultManager;

/**
 *  准备播放
 *
 *  @param urlString 
 */
- (void)prepareToPlayMusicWithURl:(NSString *)urlString mname:(NSString *)mname Singer:(NSString*)singer Album:(NSString*)album Mid:(NSString *)mid;

- (void)gd_play;

- (void)gd_pause;

- (void)tabbar_play;

/**
 *  当前是否播放
 *
 *  @return 是否播放
 */
- (BOOL)currentPlay;

/**
 *  下一首
 */
- (void)next;
/**
 *  上一首
 */
- (void)previous;

/**
 *  滑动调整歌曲进度
 *
 *  @param value 进度
 */
- (void)seekToTheTimeValue:(float)value;
/**
 *  滑动结束
 */
- (void)pansSliderValueFinfished;

@end
