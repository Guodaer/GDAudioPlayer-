//
//  GDTensionView.m
//  GDTensionView
//
//  Created by xiaoyu on 16/1/25.
//  Copyright © 2016年 Guoda. All rights reserved.
//

#import "GDTensionView.h"

#import "UIImageView+WebCache.h"

@interface GDTensionView ()

//本地图片
@property (nonatomic, strong) UIImageView *localImageView;

@property (nonatomic, strong) UIImageView *netImageView;
//初始宽度
@property (nonatomic, assign) CGFloat orginWidth;
//初始高度
@property (nonatomic, assign) CGFloat orginHeight;

@property (nonatomic, assign) NSInteger isLocal;


@end

@implementation GDTensionView

/**
 *  加载本地图片
 *
 *  @param frame
 *  @param imageName
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame WithImages:(NSString *)imageName {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageName];
        self.localImageView = imageView;
        self.orginWidth = imageView.frame.size.width;
        self.orginHeight = imageView.frame.size.height;
        self.isLocal = localImage;
        [self addSubview:imageView];
    }
    return self;
}
/**
 *  加载网络图片
 *
 *  @param frame
 *  @param imageUrl
 *  @param placeholder
 *
 *  @return
 */
#if 0
"http://ws.xzhushou.cn/focusimg/201508201549023.jpg"
"http://ws.xzhushou.cn/focusimg/52.jpg"
"http://ws.xzhushou.cn/focusimg/51.jpg"
"http://ws.xzhushou.cn/focusimg/50.jpg"
#endif
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSURL *)imageUrl PlaceholderImage:(UIImage *)placeholder {

    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        imageView.image = [UIImage imageNamed:imageName];
        [imageView sd_setImageWithURL:imageUrl placeholderImage:placeholder];
        self.netImageView = imageView;
        self.orginWidth = imageView.frame.size.width;
        self.orginHeight = imageView.frame.size.height;
        self.isLocal = netImage;
        [self addSubview:imageView];
        
    }
    return self;
    
}

- (void)imageViewStretchingWithOffSet:(CGFloat)offset {

    CGFloat whPercent = self.orginWidth/self.orginHeight;//原始比例
    
    CGFloat height = self.orginHeight - offset;//拉伸后的高度
    
    CGFloat width = self.orginWidth - offset * whPercent;//拉伸后的宽度
    
    if (offset < -1) {
        if (self.isLocal == localImage) {
            self.localImageView.frame = CGRectMake(offset/3*2, offset, width, height);
        }
        if (self.isLocal == netImage) {
            self.netImageView.frame = CGRectMake(offset/3*2, offset, width, height);
        }
    }
    else {
        if (self.isLocal == localImage) {
            self.localImageView.frame = CGRectMake(0, 0, self.orginWidth, self.orginHeight);

        }
        if (self.isLocal == netImage) {
            self.netImageView.frame = CGRectMake(0, 0, self.orginWidth, self.orginHeight);
        }
    
    }
    
}





@end
