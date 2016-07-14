//
//  PlayListSQL.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListSQL : NSObject

+ (instancetype)shareInstance;

- (void)createPlaylistSQL;


- (void)insert_playlistWithMid:(NSString*)mid Mname:(NSString *)mname MSinger:(NSString *)msinger MState:(NSString*)mstate;
//查询sql----------------
- (NSString *)getplaylsit_mid;
- (NSString *)getplaylsit_mname;
- (NSString *)getplaylsit_msinger;
- (NSString *)getplaylsit_mstate;
//更新state
- (BOOL)update_plMState:(NSString*)mstate whereMid:(NSString*)mid;
- (BOOL)delete_playlistdata;

@end
