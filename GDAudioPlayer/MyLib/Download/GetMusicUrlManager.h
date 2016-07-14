//
//  GetMusicUrlManager.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMusicUrlManager : NSObject

+ (instancetype)shareInstance;

- (void)getlistenMusicURL:(NSString *)mid Singer:(NSString*)singer Album:(NSString*)album;

@end
