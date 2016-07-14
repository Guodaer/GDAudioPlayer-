//
//  SingleManager.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "SingleManager.h"

@implementation SingleManager

+ (instancetype)defaultManager {
    static SingleManager *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (NSInteger)indexofMid:(NSString *)mid where:(NSArray *)array{
    __block NSInteger index;
    [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary*)obj;
        if ([dic[@"mid"] isEqualToString:mid]) {
            index = idx;
            *stop = YES;
        }
    }];//遍历最快的方法
    return index;
}

@end
