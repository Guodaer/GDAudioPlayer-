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


- (void)insert_playlistWithMid:(NSString*)mid Mname:(NSString *)mname MSinger:(NSString *)msinger MState:(NSString*)mstate Mlrc:(NSString*)mlrc MIcon:(NSString *)icon MFile:(NSString*)file;
//查询sql----------------
- (NSString *)getplaylsit_midWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_mnameWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_msingerWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_mstateWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_mlrcWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_miconWhereMid:(NSString*)mid;
- (NSString *)getplaylsit_mfileWhereMid:(NSString*)mid;
//更新state
- (BOOL)update_plMState:(NSString*)mstate whereMid:(NSString*)mid;
- (BOOL)update_plMlrc:(NSString*)mlrc whereMid:(NSString*)mid;
- (BOOL)update_plMicon:(NSString*)micon whereMid:(NSString*)mid;
- (BOOL)update_plMfile:(NSString*)mfile whereMid:(NSString*)mid;



- (BOOL)delete_playlistdata;

- (NSArray *)SQL_getPlaylist_FromDB;


@end
