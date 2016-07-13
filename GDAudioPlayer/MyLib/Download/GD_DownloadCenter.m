//
//  GD_DownloadCenter.m
//  GDDownloadManager
//
//  Created by xiaoyu on 15/11/20.
//  Copyright © 2015年 guoda. All rights reserved.
//

#import "GD_DownloadCenter.h"
@implementation GD_DownloadCenter
+ (GD_DownloadCenter*)manager {
    static GD_DownloadCenter *gdmanager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        gdmanager = [[self alloc] init];
        gdmanager.requestManager = [AFHTTPRequestOperationManager manager];
        gdmanager.requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    });
    return gdmanager;
}
- (void)postRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callBlock:(GD_ResultBlockSuccess)callBlock callError:(GD_ResultBlockError)callerror
{
    self.requestManager.requestSerializer.timeoutInterval = 20;
    [self.requestManager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        callBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        callerror(error);
    }];
    
}
- (void)getRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callBlock:(GD_ResultBlockError)callBlock callError:(GD_ResultBlockError)callerror{
    
    self.requestManager.requestSerializer.timeoutInterval = 20;
    [self.requestManager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        callerror(error);
    }];
    
}

@end
