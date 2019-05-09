//
//  UIView+Extern.h
//
//
//  Created by TAN on 2018/11/8.
//  Copyright © 2018 TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;   

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGPoint origin;

@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat maxY;

@property (nonatomic) CGFloat bottom;

@end
