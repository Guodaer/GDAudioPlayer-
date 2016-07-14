//
//  PlayListSQL.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "PlayListSQL.h"

@interface PlayListSQL ()
{
    FMDatabase *_database;
}

@end

@implementation PlayListSQL

+ (instancetype)shareInstance {
    static PlayListSQL *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
/**
 mid:musicID
 mname:music_name
 msinger:music_singer
 mstate:music_state
 */
- (void)createPlaylistSQL {
    
    _database = [[FMDatabase alloc] initWithPath:Local_Home_DB_Path];
    if (!_database.open) {
        GDLog(@"playlist-openError");
        return;
    }
    NSString *sql = @"create table if not exists playlist(mid varchar(32),mname varchar(32),msinger varchar(32),mstate varchar(32))";
    BOOL b = [_database executeUpdate:sql];
    GDLog(@"playlist-%d",b);
}
- (void)insert_playlistWithMid:(NSString*)mid Mname:(NSString *)mname MSinger:(NSString *)msinger MState:(NSString*)mstate{
    NSString *sql = @"insert into playlist(mid,mname,msinger,mstate)";
    [_database executeUpdate:sql,mid,mname,msinger,mstate];
}
//查询sql----------------
- (NSString *)getplaylsit_mid {
    NSString *sql = @"selected * from playlist";
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mid= nil;
    while ([result next]) {
        mid = [result stringForColumnIndex:0];
    }
    return mid;
}
- (NSString *)getplaylsit_mname {
    NSString *sql = @"selected * from playlist";
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mname= nil;
    while ([result next]) {
        mname = [result stringForColumnIndex:1];
    }
    return mname;
}
- (NSString *)getplaylsit_msinger {
    NSString *sql = @"selected * from playlist";
    FMResultSet *result = [_database executeQuery:sql];
    NSString *msinger= nil;
    while ([result next]) {
        msinger = [result stringForColumnIndex:2];
    }
    return msinger;
}
- (NSString *)getplaylsit_mstate {
    NSString *sql = @"selected * from playlist";
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mstate= nil;
    while ([result next]) {
        mstate = [result stringForColumnIndex:3];
    }
    return mstate;
}
//更新state
- (BOOL)update_plMState:(NSString*)mstate whereMid:(NSString*)mid{
    NSString *sql = [NSString stringWithFormat:@"update playlist set mstate='%@' where mid='%@'",mstate,mid];
    BOOL b = [_database executeUpdate:sql];
    GDLog(@"update mid-%@-%d",mid,b);
    return b;
}
- (BOOL)delete_playlistdata {
    NSString *sql = @"delete from playlist";
    BOOL b = [_database executeUpdate:sql];
    GDLog(@"delete - %d",b);
    return b;
}
@end
