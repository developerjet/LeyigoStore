//
//  UIBarButtonItem+Item.h
//  Create TAN
//
//  Created by TAN on 16/5/29.
//  Copyright © 2016年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

/** 普通状态 */
+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action;

/** 高亮状态 */
+ (instancetype)itemWithImage:(NSString *)image hightImage:(NSString *)hightImage target:(id)target action:(SEL)action;

/** 选中状态 */
+ (instancetype)itemWithImage:(NSString *)image selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action;

/** 普通状态+文字设置 */
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

/** 选中状态+文字设置 */
+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action;

@end
