//
//  MusicModel.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (copy,nonatomic) NSString *maid;
@property (copy,nonatomic) NSString *maname;
@property (copy,nonatomic) NSString *malable;
@property (copy,nonatomic) NSString *madesc;
@property (copy,nonatomic) NSString *mashow_b;
@property (copy,nonatomic) NSString *mashow_s;

@end
//音乐列表
@interface DetailMusicListModel : NSObject
@property (copy,nonatomic) NSString *mname;
@property (copy,nonatomic) NSString *mid;
@property (copy,nonatomic) NSString *msinger;
@property (copy,nonatomic) NSString *mtime;
@property (copy,nonatomic) NSString *msize;
@property (copy,nonatomic) NSString *mstate;
@end
//获取音乐URL
@interface GetMusicFileUrlModel : NSObject
@property (copy,nonatomic) NSString *result;
@property (copy,nonatomic) NSString *mfname;
@property (copy,nonatomic) NSString *mfsize;
@property (copy,nonatomic) NSString *mid;
@property (copy,nonatomic) NSString *msname;
@property (copy,nonatomic) NSString *err;
@property (copy,nonatomic) NSString *mfile;
@property (copy,nonatomic) NSString *mssize;
@property (copy,nonatomic) NSString *mname;
@property (copy,nonatomic) NSString *msimg;
@end