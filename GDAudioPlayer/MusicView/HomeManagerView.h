//
//  HomeManagerView.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMangerViewDelegate <NSObject>

- (void)HomeManagerDelegateSelected:(UIButton *)sender;

@end

@interface HomeManagerView : UIView

@property (nonatomic, assign) id<HomeMangerViewDelegate> gd_delegate;


@end
