//
//  UIButton+Extend.h
//  UIButton
//
//  Created by tj on 2018/7/9.
//

#import <UIKit/UIKit.h>

typedef void(^DidTouchUpInsideEventBlock)(void);

@interface UIButton (Extend)

/// 文字设置
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedTitle;
@property (nonatomic, copy) NSString *highlightedTitle;

/// 按钮图片
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *selectedImage;
@property (nonatomic, copy) NSString *highlightedImage;

/// 背景图片
@property (nonatomic, copy) NSString *backgroundImage;
@property (nonatomic, copy) NSString *selectedBgImage;
@property (nonatomic, copy) NSString *highlightedBgImage;

/// 文字颜色
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *highlightedTitleColor;

/// 字体大小设置
@property (nonatomic, assign) CGFloat size;

/// 点击事件
@property (nonatomic, copy) DidTouchUpInsideEventBlock addAction;

/// 设置每次点击间隔时间
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
@property (nonatomic, assign) NSTimeInterval acceptEventIntervalTime;

@end
