//
//  AppDelegate.m
//  AutoAnswer
//
//  Created by 金峰 on 2018/1/16.
//  Copyright © 2018年 金峰. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()
{
    UNUserNotificationCenter *_userNotificationCenter;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    // 推送
    [self registNotification];
    
    
    // 注册后台播放音乐
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    return YES;
}

- (void)registNotification {
    if (@available(iOS 10.0, *)) {
        _userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
//        _userNotificationCenter.delegate = self;
        [_userNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    } else if (@available(iOS 8.0, *)) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
#pragma clang diagnostic pop
}


// app在前台时也能收到推送
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
//}



@end
