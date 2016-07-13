//
//  LrcTimeContentModel.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "LrcTimeContentModel.h"

@implementation LrcTimeContentModel
- (void)setSeconds:(float)seconds{
    _seconds = seconds;
}
- (void)setLrcEach:(NSString *)lrcEach{
    _lrcEach = lrcEach;
}
@end
