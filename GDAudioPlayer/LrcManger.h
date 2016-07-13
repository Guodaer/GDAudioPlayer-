//
//  LrcManger.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LrcModel.h"
//#import "LrcTimeContentModel.h"
@interface LrcManger : NSObject
/**
 *  歌曲信息：题目，作曲等
 */
@property (nonatomic, strong) LrcModel *lrc_headModel;

/**
 *  时间和歌词
 */
@property (nonatomic, copy) NSArray *lrc_tcArray;


@end
