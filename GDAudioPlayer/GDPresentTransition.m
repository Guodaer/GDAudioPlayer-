//
//  GDPresentTransition.m
//  GDTranslation
//
//  Created by xiaoyu on 16/7/6.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "GDPresentTransition.h"

@interface GDPresentTransition ()
{
    GDPresentOneTransitionType _type;
}

@end
@implementation GDPresentTransition
+ (instancetype)shareInstance{
    static GDPresentTransition *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc] init];
    });
    return manager;
    
}
//+ (instancetype)transitionWithTransitionType:(GDPresentOneTransitionType)type {
//
//    return self;
//}
- (instancetype)initWithTransitionType:(GDPresentOneTransitionType)type{
    _type = type;
    return self;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_type) {
        case GDPresentOneTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case GDPresentOneTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}
//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
#if 1
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc2、fromVC就是vc1
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
      //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和vc2的view都加入ContainerView中
//    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    toVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.frame.size.height);
    
    [UIView animateWithDuration:0.25 animations:^{
//        toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
        toVC.view.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            NSLog(@"presentTrans---error");
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
            //然后移除截图视图，因为下次触发present会重新截图
//            [tempView removeFromSuperview];
        }
    }];
#endif
#if 0
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    //画两个圆路径
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREENWIDTH/2-12.5,SCREENHEIGHT/2-12.5, 25, 25)];
    //    CGFloat x = MAX(SCREENWIDTH-start_x, containerView.frame.size.width - SCREENWIDTH-start_x);
    //    CGFloat y = MAX(start_y, containerView.frame.size.height - start_y);
    
    CGFloat radius = sqrtf(pow(SCREENWIDTH/2, 2) + pow(SCREENHEIGHT/2, 2));//求平方根  pox 幂函数
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
#endif
#if 0
    //开始动画吧，使用产生弹簧效果的动画API
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        //首先我们让vc2向上移动
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -containerView.frame.size.height);
    } completion:^(BOOL finished) {
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
            //然后移除截图视图，因为下次触发present会重新截图
            [tempView removeFromSuperview];
        }
    }];
#endif
}
//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意这个关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //动画吧
   
    UIView *containerView = [transitionContext containerView];
    for (UIView *view in containerView.subviews) {
        [view removeFromSuperview];
    }
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
//    [containerView bringSubviewToFront:fromVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
//        fromVC.transform = CGAffineTransformIdentity;
        fromVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.frame.size.height);
//        toVC.view.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了标记失败
            [transitionContext completeTransition:NO];
            GDLog(@"1111111");
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
//            containerView.backgroundColor = [UIColor redColor];
        }
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    switch (_type) {
        case GDPresentOneTransitionTypePresent:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
        }
            break;
        case GDPresentOneTransitionTypeDismiss:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
    }
}@end
