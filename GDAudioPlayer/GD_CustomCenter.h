//
//  GD_CustomCenter.h
//  XUIPhone
//
//  Created by xiaoyu on 15/11/24.
//  Copyright © 2015年 guoda. All rights reserved.
//

#ifndef GD_CustomCenter_h
#define GD_CustomCenter_h
#import "AppDelegate.h"

typedef enum : NSUInteger {
    MenuLoopType_ALL,
    MenuLoopType_RANDOM,
    MenuLoopType_SEQUENCE,
    MenuLoopType_SINGLE,
} MenuLoopType;
typedef enum: NSInteger{
    HandPause,
    HandStart
}HandlePause;
/**3
 *  屏幕的大小
 */
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  设置图片
 *
 *  @param X 图片名称
 *
 *  @return UIImage类型的
 */
#define XUIImage(X) [UIImage imageNamed:X]

/**
 *  加在本地图片
 *
 *  @param x 图片名称
 *
 *  @return UIImage
 */
#define XUILocalImage(x) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:x ofType:@"png"]]
/**
 *  颜色0x------
 *
 *  @param rgbValue
 *
 *  @return UIColor
 */
#define XUIColor(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]

//#define SystemColor 0x3B5286
/**
 *  默认颜色
 *
 *  @param alpha 透明度
 *
 *  @return 默认颜色
 */
#define rgbValue 0x3b5286
#define SystemColor(alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]

/**
 *  判断设备型号
 */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREENWIDTH, SCREENHEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6p (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#ifdef DEBUG
#define GDLog( s, ... ) NSLog( @"^_^[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define GDLog( s, ... )
#endif

/**
 *  沙盒路径-缓存/Library/XZSP
 */
#define Local_Home_File_Path ([NSString stringWithFormat:@"%@/Library/XZSP",NSHomeDirectory()])
/**Caches
 *  沙盒路径-表
 */
#define Local_Home_DB_Path ([NSString stringWithFormat:@"%@/Library/db",NSHomeDirectory()])

//角度转弧度
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

/**
 *  判断系统版本是否大于9.0
 */
#define iOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))

#define iOS_VERSION_8_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_8_0

/**
 *  NSUserdefault
 *
 *  @param key key
 *
 *  @return value
 */
#define UserDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
/**
 *  Description
 */
#define UD_SetValue(object,key) {NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];\
[ud setObject:object forKey:key];\
[ud synchronize];}

/**
 *    通知
 *
 *  @return
 */
#define Notification_Menu_Present @"notificationMenupresent"

#define Notification_AudioPlayDetail_Present @"Notification_AudioPlayDetail_Present"

#define Notification_PLAY_Start @"Notification_PLAY_Start"

#define Notification_PLAY_Pause @"Notification_PLAY_Pause"

#define Notification_PLAY_NowMusicMessage @"Notification_PLAY_NowMusicMessage"
/**
 *  数据存储
 */
#define Menu_LoopModel @"menuloopModel" //循环模式

#define CurrentPlay_Music @"Current_PlayMusic" //当前播放的 {mid,msinger,malbum,mname}

#define Hand_pause @"handpause"//手动停止

/**
 *  接口
 *
 *  @return
 */
#define Home_Server_HttpAddress @"http://123.57.25.103/XUIWeb/"//外网测试

#define GET_ma_list [NSString stringWithFormat:@"%@%@",Home_Server_HttpAddress,@"getmalist"]

#define GET_musiclist [NSString stringWithFormat:@"%@%@",Home_Server_HttpAddress,@"getmusiclist"]

#define Get_mdlurl [NSString stringWithFormat:@"%@%@",Home_Server_HttpAddress,@"getmdlurl"]

#endif /* GD_CustomCenter_h */
