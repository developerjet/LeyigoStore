//
//  FSAppDelegate+Utils.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAppDelegate (Utils)

/**
 初始化工程系统设置
 */
- (void)appInitialization;
    
/**
 友盟分享注册
 */
- (void)registerUMPlatforms;

/**
 注册jpush
 */
- (void)jpushConfiguration:(NSDictionary *)launchOptions;
    
/**
 注册deviceToken
 */
- (void)jpushDidRegisterDeviceToken:(NSData *)deviceToken;
    
@end

NS_ASSUME_NONNULL_END
