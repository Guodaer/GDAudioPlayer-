//
//  GDLrcAnalysis.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LrcManger.h"

@interface GDLrcAnalysis : NSObject

+ (instancetype)defaultManager;

- (LrcManger *)analysisLrc:(NSString *)lrcUrl;

@end
