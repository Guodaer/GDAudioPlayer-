//
//  SingleManager.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SingleSetTotalTime(time) [[SingleManager defaultManager]setSingle_totalTime:time]
#define SingleSetCurrentTime(time) [[SingleManager defaultManager]setSingle_currentTime:time]
#define SingleGetTotalTime [SingleManager defaultManager].single_totalTime
#define SingleGetCurrentTime [SingleManager defaultManager].single_currentTime

@interface SingleManager : NSObject

@property (nonatomic, assign) float single_totalTime;

@property (nonatomic, assign) float single_currentTime;


+ (instancetype)defaultManager;

- (NSInteger)indexofMid:(NSString*)mid where:(NSArray*)array;

#pragma mark - 指示器
- (void)loadIndicatiorView ;
- (void)IndicatiorStartAnimation;
- (void)IndicatiorStopAnimation;
@end
