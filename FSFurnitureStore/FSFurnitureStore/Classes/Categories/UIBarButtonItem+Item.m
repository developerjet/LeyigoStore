//
//  UIBarButtonItem+Item.m
//  Create TAN
//
//  Created by TAN on 16/5/29.
//  Copyright © 2016年 CODER_TJ. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *customView = [[UIView alloc] initWithFrame:button.bounds];
    [customView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (instancetype)itemWithImage:(NSString *)image hightImage:(NSString *)hightImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *customView = [[UIView alloc] initWithFrame:button.bounds];
    [customView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (instancetype)itemWithImage:(NSString *)image selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button sizeToFit];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *contentView = [[UIView alloc] initWithFrame:button.bounds];
    [contentView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIView *customView = [[UIView alloc] initWithFrame:button.bounds];
    [customView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}


+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:button.bounds];
    [customView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}


@end
