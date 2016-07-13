//
//  GD_DownloadCenter.h
//  GDDownloadManager
//
//  Created by xiaoyu on 15/11/20.
//  Copyright © 2015年 guoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^GD_ResultBlockSuccess)(id responseObject);
typedef void(^GD_ResultBlockError)(id Error);

@interface GD_DownloadCenter : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;



+ (GD_DownloadCenter *)manager;
/**
 *  POST 请求
 *
 *  @param url        接口
 *  @param parameters 参数
 *  @param callBlock  成功返回
 *  @param callerror  err返回
 */
- (void)postRequestWithURL:(NSString*)url parameters:(NSDictionary*)parameters callBlock:(GD_ResultBlockSuccess)callBlock callError:(GD_ResultBlockError)callerror;
/**
 *  GET 请求
 *
 *  @param url        接口
 *  @param parameters 参数
 *  @param callBlock  成功返回
 *  @param callerror  err返回
 */
- (void)getRequestWithURL:(NSString*)url parameters:(NSDictionary*)parameters callBlock:(GD_ResultBlockSuccess)callBlock callError:(GD_ResultBlockError)callerror;

@end
