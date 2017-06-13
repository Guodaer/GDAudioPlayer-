//
//  GetMusicUrlManager.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "GetMusicUrlManager.h"
#import "MusicModel.h"
#import "PlayManager.h"
@implementation GetMusicUrlManager

+ (instancetype)shareInstance {
    static GetMusicUrlManager *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

#pragma mark - 请求得到音乐流的地址
- (void)getlistenMusicURL:(NSString *)mid Singer:(NSString*)singer Album:(NSString*)album {
    
    [[GD_DownloadCenter manager] postRequestWithURL:Get_mdlurl parameters:@{@"pver":@"1",@"Mid":mid} callBlock:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        GetMusicFileUrlModel *model = [[GetMusicFileUrlModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        [[PlayManager defaultManager] prepareToPlayMusicWithURl:model.mfile mname:model.mname Singer:singer Album:album Mid:mid];
    } callError:^(id Error) {
        GDLog(@"Error");
    }];
    
}

@end
