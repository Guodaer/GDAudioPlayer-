//
//  HomeManagerView.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "HomeManagerView.h"

@implementation HomeManagerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 80, 40);
    [button setTitle:@"已下载" forState:UIControlStateNormal];
    [self addSubview:button];
    [button addTarget:self action:@selector(homeManagerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

}
- (void)homeManagerBtnClick:(UIButton *)sender {
    if ([_gd_delegate respondsToSelector:@selector(HomeManagerDelegateSelected:)]) {
        [_gd_delegate HomeManagerDelegateSelected:sender];
    }
}
@end
