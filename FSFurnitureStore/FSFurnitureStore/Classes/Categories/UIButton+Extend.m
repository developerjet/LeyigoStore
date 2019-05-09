//
//  UIButton+Extend.m
//  UIButton
//
//  Created by tj on 2018/7/9.
//

#import "UIButton+Extend.h"
#import <objc/runtime.h>

static const void *associatedKey = @"associatedKey";
static const void *acceptEventIntervalKey = @"eventIntervalKey";
static const void *acceptEventIntervalTimeKey = @"acceptEventIntervalTimeKey";

@implementation UIButton (Extend)

#pragma mark - - Configuration title

- (void)setTitle:(NSString *)title {
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSelectedTitle:(NSString *)selectedTitle {

    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (void)setHighlightedTitle:(NSString *)highlightedTitle {
    
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

#pragma mark - - Configuration image

- (void)setImage:(NSString *)image {
    
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setSelectedImage:(NSString *)selectedImage {
    
    [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}

- (void)setHighlightedImage:(NSString *)highlightedImage {
    
    [self setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
}


#pragma mark - - Configuration backgroundImage

- (void)setBackgroundImage:(NSString *)backgroundImage {
    
    [self setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
}


- (void)setSelectedBgImage:(NSString *)selectedBgImage {
    
    [self setBackgroundImage:[UIImage imageNamed:selectedBgImage] forState:UIControlStateSelected];
}


- (void)setHighlightedBgImage:(NSString *)highlightedBgImage {
    
    [self setBackgroundImage:[UIImage imageNamed:highlightedBgImage] forState:UIControlStateHighlighted];
}

#pragma mark - - Configuration titleColor

- (void)setTitleColor:(UIColor *)titleColor {
    
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor {
    
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

#pragma mark - - Configuration fontSize

- (void)setSize:(CGFloat)size {
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
}


#pragma mark - - Configuration Touch Event

- (void)setAddAction:(DidTouchUpInsideEventBlock)addAction {
    
    objc_setAssociatedObject(self, associatedKey, addAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self removeTarget:self action:@selector(buttonDidEvent) forControlEvents:UIControlEventTouchUpInside];
    if (addAction) {
        [self addTarget:self action:@selector(buttonDidEvent) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (DidTouchUpInsideEventBlock)addAction {
    
    return objc_getAssociatedObject(self, associatedKey);
}


#pragma mark - - Configuration Touch NSTimeInterval

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    
    objc_setAssociatedObject(self, acceptEventIntervalKey, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSTimeInterval)acceptEventInterval {
    
    return [objc_getAssociatedObject(self, acceptEventIntervalKey) doubleValue];
}

- (void)setAcceptEventIntervalTime:(NSTimeInterval)acceptEventIntervalTime {
    
    objc_setAssociatedObject(self, acceptEventIntervalTimeKey, @(acceptEventIntervalTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventIntervalTime {
    
    return [objc_getAssociatedObject(self, acceptEventIntervalTimeKey) doubleValue];
}

#pragma mark - Method Change

+ (void)load {
    
    //获取这两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL systemSEL = @selector(sendAction:to:forEvent:);
    
    Method currentMethod = class_getInstanceMethod(self, @selector(custom_sendAction:to:forEvent:));
    SEL currentSEL = @selector(custom_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, systemSEL, method_getImplementation(currentMethod), method_getTypeEncoding(currentMethod));
    
    //如果方法已经存在
    if (didAddMethod) {
        class_replaceMethod(self, currentSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else {
        method_exchangeImplementations(systemMethod, currentMethod);
    }
}


/**
 对点击事件作处理
 */
- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (NSDate.date.timeIntervalSince1970 - self.acceptEventIntervalTime < self.acceptEventInterval) {
        return;
    }
    
    if (self.acceptEventInterval > 0) {
        self.acceptEventIntervalTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self custom_sendAction:action to:target forEvent:event];
}


- (void)buttonDidEvent {
    
    if (self.addAction) {
        self.addAction();
    }
}

@end
