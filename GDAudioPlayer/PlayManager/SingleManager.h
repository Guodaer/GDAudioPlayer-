//
//  SingleManager.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleManager : NSObject

+ (instancetype)defaultManager;

- (NSInteger)indexofMid:(NSString*)mid where:(NSArray*)array;

#pragma mark - 指示器
- (void)loadIndicatiorView ;
- (void)IndicatiorStartAnimation;
- (void)IndicatiorStopAnimation;
@end
