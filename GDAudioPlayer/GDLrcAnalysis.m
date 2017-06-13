//
//  GDLrcAnalysis.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "GDLrcAnalysis.h"
#import "LrcModel.h"
#import "LrcTimeContentModel.h"
@interface GDLrcAnalysis ()

@property (nonatomic, strong) NSMutableArray *tcArray;

@property (nonatomic, strong) LrcModel *lrcModel; //ar,ti,al,by

@property (nonatomic, strong) LrcManger *lrcManager;

//@property (nonatomic, strong) LrcTimeContentModel *lrc_tcModel;

@end

@implementation GDLrcAnalysis

+ (instancetype)defaultManager{
    static GDLrcAnalysis *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
#pragma mark - 解析数据
- (LrcManger *)analysisLrc:(NSString *)lrcUrl{
    
    _tcArray = [NSMutableArray array];
    
    _lrcModel = [[LrcModel alloc] init];
    
    _lrcManager = [[LrcManger alloc] init];
    
    NSString *lrc = [self readFile:lrcUrl];
    
    [self paserLrcWithContents:lrc];//解析歌词

    _lrcManager.lrc_headModel = _lrcModel;
    _lrcManager.lrc_tcArray = _tcArray;
    
//    LrcTimeContentModel *model = [[LrcTimeContentModel alloc] init];
//    model = [_lrcManager.lrc_tcArray lastObject];
//    NSLog(@"%f--%@++",model.seconds,model.lrcEach?model.lrcEach:@"没有");
    return _lrcManager;
}
- (void)paserLrcWithContents:(NSString *)lrcContent{
    NSArray *allContent = [lrcContent componentsSeparatedByString:@"\n"];
    for (NSString *content in allContent) {
        if ([content isEqualToString:@""]) {
            continue;
        }
        //判断头信息
        if ([content hasPrefix:@"[ti"]||[content hasPrefix:@"[ar"]||[content hasPrefix:@"[al"]||[content hasPrefix:@"[by"]) {
            [self paserLrcHead:content];//头信息
        }else if([content hasPrefix:@"["]){
            [self paserLrcMessage:content];//time，歌词
        }
    }
}
#pragma mark - 内容信息
- (void)paserLrcMessage:(NSString *)lrcMessage{
    
    NSArray *array = [lrcMessage componentsSeparatedByString:@"]"];
    LrcTimeContentModel *lrc_tcModel = [[LrcTimeContentModel alloc] init];
    for (NSString *lrc in array) {
        if ([lrc hasPrefix:@"["]) {//时间
            lrc_tcModel.seconds = [self secondsForTime:lrc];
        }else{//内容
            lrc_tcModel.lrcEach = lrc;
        }
    }
//    GDLog(@"%f,%@",lrc_tcModel.secon、ds,lrc_tcModel.lrcEach);
    [_tcArray addObject:lrc_tcModel];
//    GDLog(@"\n");
}
#pragma mark - 时间解析
- (float)secondsForTime:(NSString *)time{
    NSArray * timeArray = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[:"]];
    //取出分
    float minute = [timeArray[1] floatValue];
    //取出秒
    float seconds = [timeArray[2] floatValue];
    return minute * 60 + seconds;
}
#pragma mark - 头信息
- (void)paserLrcHead:(NSString *)lrcHead{
    NSArray *array = [lrcHead componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[:]"]];
    if ([array[1] isEqualToString:@"ar"]) {
        _lrcModel.lrc_ar = array[2];
    }else if ([array[1] isEqualToString:@"ti"]){
        _lrcModel.lrc_ti = array[2];
    }else if ([array[1] isEqualToString:@"al"]){
        _lrcModel.lrc_al = array[2];
    }else if ([array[1] isEqualToString:@"by"]){
        _lrcModel.lrc_by = array[2];
    }
}
#pragma mark - 读取数据
- (NSString *)readFile:(NSString *)url{
    NSString *contents = [[NSString alloc] initWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];
    return contents;
}


@end
