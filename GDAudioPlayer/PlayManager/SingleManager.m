//
//  SingleManager.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/14.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "SingleManager.h"

@interface SingleManager ()
{
    UIActivityIndicatorView *progressIndicator;
    UIView *IndicatorView;
}
@end

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
#pragma mark - 加载转圈指示
- (void)loadIndicatiorView{
    progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    IndicatorView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    IndicatorView.backgroundColor = XUIColor(0x000000, 0.85);
    IndicatorView.layer.cornerRadius = 10;
    progressIndicator.center = CGPointMake(50, 50);
    [IndicatorView addSubview:progressIndicator];
    IndicatorView.alpha = 0;
    IndicatorView.transform = CGAffineTransformMakeScale(0, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:IndicatorView];
}
- (void)IndicatiorStartAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        IndicatorView.alpha = 1;
        IndicatorView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    [progressIndicator startAnimating];
}
- (void)IndicatiorStopAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        IndicatorView.alpha = 0;
        IndicatorView.transform = CGAffineTransformMakeScale(0, 0);
    }];
    [progressIndicator stopAnimating];
}
@end
