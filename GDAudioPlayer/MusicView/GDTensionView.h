//
//  GDTensionView.h
//  GDTensionView
//
//  Created by xiaoyu on 16/1/25.
//  Copyright © 2016年 Guoda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    localImage,
    netImage
    
}ISLocalImage;

@interface GDTensionView : UIView


/**
 *  初始化
 *
 *  @param frame      frame
 *  @param imageName  图片名字
 *
 *  @return
 */
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSString *)imageName;

/**
 *  加载的网络图片拉伸
 *
 *  @param frame       frame
 *  @param imageUrl
 *  @param placeholder placeholder description
 *
 *  @return return value description
 */
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSURL *)imageUrl PlaceholderImage:(UIImage *)placeholder;

/**
 *  放大方法
 *
 *  @param offset 滚动的offset
 */
- (void)imageViewStretchingWithOffSet:(CGFloat)offset;


@end
