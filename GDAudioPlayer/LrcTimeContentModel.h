//
//  LrcTimeContentModel.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcTimeContentModel : NSObject

/**
 *  第多少秒
 */
@property (nonatomic, assign) float seconds;
/**
 *  相应秒数对应的歌词
 */
@property (nonatomic, copy) NSString *lrcEach;


@end
