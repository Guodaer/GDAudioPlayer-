//
//  AudioPlayDetailView.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Audio_PlayButtonTag 10000           //播放按钮
#define Audio_NextButtonTag 10001           //下一首
#define Audio_ForwardButtonTag 10002        //上一首


@protocol  AudioPlayDetailDelegate <NSObject>

@optional
- (void)audioViewdismiss:(UIButton *)button;

@end

@interface AudioPlayDetailView : UIView

@property (nonatomic, assign) id<AudioPlayDetailDelegate>gd_delegate;

//退出播放器
- (void)invalidateLrc;

@end
