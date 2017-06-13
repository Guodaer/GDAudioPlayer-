//
//  GDPresentTransition.h
//  GDTranslation
//
//  Created by xiaoyu on 16/7/6.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GDPresentOneTransitionType) {
    GDPresentOneTransitionTypePresent = 0,//管理present动画
    GDPresentOneTransitionTypeDismiss//管理dismiss动画
};

@interface GDPresentTransition : NSObject<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
+ (instancetype)shareInstance;
//根据定义的枚举初始化的两个方法
//+ (instancetype)transitionWithTransitionType:(GDPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(GDPresentOneTransitionType)type;

@end
