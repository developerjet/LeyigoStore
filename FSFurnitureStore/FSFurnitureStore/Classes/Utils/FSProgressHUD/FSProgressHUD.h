//
//  XDProgressHUD.h
//  OnlyBrother_ Seller
//
//  Created by CODER_TJ on 16/10/23.
//  Copyright © 2016年 CODER_TJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSProgressHUD : NSObject

+ (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay;

+ (void)showHUDWithLongText:(NSString *)text delay:(NSTimeInterval)delay;

+ (void)showHUDWithIndeterminateAndText:(NSString *)text delay:(NSTimeInterval)delay;

+ (void)showHUDWithIndeterminate:(NSString *)text;

/**
 失败信息提示

 @param error 具体信息
 @param delay 显示时间
 */
+ (void)showHUDWithError:(NSString *)error delay:(NSTimeInterval)delay;


/**
 失败信息提示

 @param succes 具体信息
 @param delay 显示时间
 */
+ (void)showHUDWithSuccess:(NSString *)succes delay:(NSTimeInterval)delay;

/** 展示自定义GIF动画 */
+ (void)showGifWithtext:(NSString *)text;

/** 隐藏HUD */
+ (void)hideHUD;

@end
