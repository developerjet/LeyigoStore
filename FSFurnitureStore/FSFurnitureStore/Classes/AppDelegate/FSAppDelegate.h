//
//  AppDelegate.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/23.
//  Copyright © 2018 FTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
// UMCommon
#import <UMCommon/UMCommon.h>
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>

// JPush
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface FSAppDelegate : UIResponder <UIApplicationDelegate, JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *currentNav;

@end

