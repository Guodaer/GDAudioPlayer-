//
//  AppDelegate.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/11.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AppDelegate.h"
#import "GDTabbarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication];
    GDTabbarController *tabbar = [[GDTabbarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    // 1.拿到AVAudioSession单例对象
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 2.设置类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 3.激活
    [session setActive:YES error:nil];
    [self createManager];
    return YES;
}
- (void)createManager {
//    //创建数据库根目录
//    NSString *path = [NSString stringWithFormat:@"%@/Library/db",NSHomeDirectory()];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    BOOL yes;
//    if (![manager fileExistsAtPath:path isDirectory:&yes]) {
//        BOOL b=[manager createDirectoryAtPath:path withIntermediateDirectories:yes attributes:nil error:nil];
//        GDLog(@"dbpath = %d",b);
//    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 接收远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    //判断是否为远程事件
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
                [[PlayManager defaultManager] gd_play];
                break;
            case UIEventSubtypeRemoteControlPause:
                UD_SetValue([NSNumber numberWithInteger:HandPause], Hand_pause);
                [[PlayManager defaultManager] gd_pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                [[PlayManager defaultManager] next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                [[PlayManager defaultManager] previous];
                break;
            default:
                break;
        }
    }
}
@end
