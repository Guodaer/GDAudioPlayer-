//
//  GDSlider.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/19.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "GDSlider.h"

@implementation GDSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createGDSlider];
    }
    return self;
}
- (void)createGDSlider{
//    [self setMinimumTrackImage:XUIImage(@"APD_audio_slider_track") forState:UIControlStateNormal];
    [self setMaximumTrackImage:XUIImage(@"APD_audio_slider_track_bg") forState:UIControlStateNormal];
    [self setMinimumTrackTintColor:[UIColor yellowColor]];
    [self setThumbImage:XUIImage(@"APD_audio_slider_thumb") forState:UIControlStateNormal];
    [self setThumbImage:XUIImage(@"APD_audio_slider_thumb") forState:UIControlStateHighlighted];
}
@end
