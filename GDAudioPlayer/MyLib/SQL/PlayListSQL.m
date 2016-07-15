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
 
 
 mlrc:
 micon:
 mfile:本地歌曲地址
 malbum
 */
- (void)createPlaylistSQL {
    
    _database = [[FMDatabase alloc] initWithPath:Local_Home_DB_Path];
    if (!_database.open) {
        GDLog(@"playlist-openError");
        return;
    }
    NSString *sql = @"create table if not exists playlist(mid varchar(32),mname varchar(32),msinger varchar(32),mstate varchar(32),mlrc varchar(32),micon varchar(32),mfile varchar(32),malbum varchar(32))";
    [_database executeUpdate:sql];
//    GDLog(@"playlist-%d",b);
}
- (void)insert_playlistWithMid:(NSString*)mid Mname:(NSString *)mname MSinger:(NSString *)msinger MState:(NSString*)mstate Mlrc:(NSString *)mlrc MIcon:(NSString *)icon MFile:(NSString *)file Malbum:(NSString *)album{
    NSString *sql = @"insert into playlist(mid,mname,msinger,mstate,mlrc,micon,mfile,malbum) values(?,?,?,?,?,?,?,?)";
    [_database executeUpdate:sql,mid,mname,msinger,mstate,mlrc,icon,file,album];
}
//查询sql----------------
- (NSString *)getplaylsit_midWhereMid:(NSString *)mid{
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mid1= nil;
    while ([result next]) {
        mid1 = [result stringForColumnIndex:0];
    }
    return mid;
}
- (NSString *)getplaylsit_mnameWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mname= nil;
    while ([result next]) {
        mname = [result stringForColumnIndex:1];
    }
    return mname;
}
- (NSString *)getplaylsit_msingerWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *msinger= nil;
    while ([result next]) {
        msinger = [result stringForColumnIndex:2];
    }
    return msinger;
}
- (NSString *)getplaylsit_mstateWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mstate= nil;
    while ([result next]) {
        mstate = [result stringForColumnIndex:3];
    }
    return mstate;
}
- (NSString *)getplaylsit_mlrcWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mlrc= nil;
    while ([result next]) {
        mlrc = [result stringForColumnIndex:4];
    }
    return mlrc;
}
- (NSString *)getplaylsit_miconWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *micon= nil;
    while ([result next]) {
        micon = [result stringForColumnIndex:5];
    }
    return micon;
}
- (NSString *)getplaylsit_mfileWhereMid:(NSString *)mid {
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *mfile= nil;
    while ([result next]) {
        mfile = [result stringForColumnIndex:6];
    }
    return mfile;
}
- (NSString*)getplaylsit_malbumWhereMid:(NSString *)mid{
    NSString *sql = [NSString stringWithFormat:@"select * from playlist where mid='%@'",mid];
    FMResultSet *result = [_database executeQuery:sql];
    NSString *malbum= nil;
    while ([result next]) {
        malbum = [result stringForColumnIndex:7];
    }
    return malbum;
    
}
//更新state
- (BOOL)update_plMState:(NSString*)mstate whereMid:(NSString*)mid{
    NSString *sql = [NSString stringWithFormat:@"update playlist set mstate='%@' where mid='%@'",mstate,mid];
    BOOL b = [_database executeUpdate:sql];
//    GDLog(@"update mid:%@-state:%d",mid,b);
    return b;
}
- (BOOL)update_plMlrc:(NSString *)mlrc whereMid:(NSString *)mid{
    NSString *sql = [NSString stringWithFormat:@"update playlist set mlrc='%@' where mid='%@'",mlrc,mid];
    BOOL b = [_database executeUpdate:sql];
//    GDLog(@"update mid:%@-lrc:%d",mid,b);
    return b;
}
- (BOOL)update_plMicon:(NSString *)micon whereMid:(NSString *)mid{
    NSString *sql = [NSString stringWithFormat:@"update playlist set micon='%@' where mid='%@'",micon,mid];
    BOOL b = [_database executeUpdate:sql];
//    GDLog(@"update mid:%@-icon:%d",mid,b);
    return b;
}
- (BOOL)update_plMfile:(NSString *)mfile whereMid:(NSString *)mid{
    NSString *sql = [NSString stringWithFormat:@"update playlist set mfile='%@' where mid='%@'",mfile,mid];
    BOOL b = [_database executeUpdate:sql];
//    GDLog(@"update mid:%@-file:%d",mid,b);
    return b;
}
- (BOOL)delete_MusicWhereMid:(NSString*)mid {
    NSString *sql = [NSString stringWithFormat:@"delete from playlist where mid='%@'",mid];
    BOOL b= [_database executeUpdate:sql];
    return b;
}
- (BOOL)delete_playlistdata {
    NSString *sql = @"delete from playlist";
    BOOL b = [_database executeUpdate:sql];
//    GDLog(@"delete - %d",b);
    return b;
}
- (NSArray *)SQL_getPlaylist_FromDB{
     NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from playlist";
    FMResultSet *resultSet = [_database executeQuery:sql];
    while ([resultSet next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[resultSet stringForColumnIndex:0] forKey:@"mid"];
        [dic setObject:[resultSet stringForColumnIndex:1] forKey:@"mname"];
        [dic setObject:[resultSet stringForColumnIndex:2] forKey:@"msinger"];
        [dic setObject:[resultSet stringForColumnIndex:3] forKey:@"mstate"];
        [dic setObject:[resultSet stringForColumnIndex:4] forKey:@"mlrc"];
        [dic setObject:[resultSet stringForColumnIndex:5] forKey:@"micon"];
        [dic setObject:[resultSet stringForColumnIndex:6] forKey:@"mfile"];
        [dic setObject:[resultSet stringForColumnIndex:7] forKey:@"malbum"];
        [array addObject:dic];
    }
    return array;
}

@end
