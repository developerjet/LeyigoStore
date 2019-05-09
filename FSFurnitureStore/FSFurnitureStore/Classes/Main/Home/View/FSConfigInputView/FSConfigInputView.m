//
//  FSConfigInputView.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSConfigInputView.h"

@interface FSConfigInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation FSConfigInputView

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        CGFloat y = SCREEN_HEIGHT - kInputHeight;
        self.frame = CGRectMake(0, y, SCREEN_WIDTH, kInputHeight);
        
        [self addTextSubView];
        [self addNotification];
    }
    return self;
}

- (void)addTextSubView
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorBoardLineColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UITextField *textField = [[UITextField alloc] init];
    textField.leftView = leftView;
    textField.borderStyle = UITextBorderStyleNone;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @"Please enter your comment";
    textField.textColor = [UIColor colorDarkTextColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 5.0;
    textField.layer.masksToBounds = YES;
    textField.delegate = self;
    [self addSubview:textField];
    self.textField = textField;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.layer.cornerRadius = 16;
    sendButton.layer.masksToBounds = YES;
    sendButton.backgroundColor = [UIColor colorThemeColor];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    sendButton.title = @"Send";
    [self addSubview:sendButton];
    self.sendButton = sendButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 15;
    
    self.lineView.frame = CGRectMake(0, 0, self.width, 1);
    
    CGFloat w1 = 70;
    CGFloat x1 = self.width - w1 - space;
    CGFloat h1 = 32;
    CGFloat y1 = (self.height - h1) / 2;
    self.sendButton.frame = CGRectMake(x1, y1, w1, h1);
    [self.sendButton addTarget:self action:@selector(resignFirst) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat h2 = 40;
    CGFloat x2 = space;
    CGFloat y2 = (self.height - h2) / 2;
    CGFloat w2 = self.width - w1 - space * 3;
    self.textField.frame = CGRectMake(x2, y2, w2, h2);
}

- (void)resignFirst {
    [self.textField resignFirstResponder];
    
    if (self.textField.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(input:textFieldDidEndEditing:)]) {
            [self.delegate input:self textFieldDidEndEditing:self.textField.text];
        }
        // 清空内容
        self.textField.text = @"";
    }else {
        [FSProgressHUD showHUDWithLongText:@"Please enter content" delay:1.0];
    }
}

- (void)showInputAddedTo:(UIView *)view {
    if (view) {
        [view addSubview:self];
    }
}

- (void)hide {
    if (self) {
        [self removeFromSuperview];
    }
}

- (void)addNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(onKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self
               selector:@selector(onKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
}

- (void)onKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    NSLog(@"\n开始位置%@\n结束位置%@",NSStringFromCGRect([userInfoDic[UIKeyboardFrameBeginUserInfoKey] CGRectValue]),
          NSStringFromCGRect([userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue]));
    NSLog(@"弹出的动画时间间隔%lf",[userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    NSLog(@"弹出的时间曲线%ld",[userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]);
    
    // ============================================================
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardRect            = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight         = MIN(CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
    
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
        
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    NSLog(@"\n%@\n%@",NSStringFromCGRect([userInfoDic[UIKeyboardFrameBeginUserInfoKey] CGRectValue]),
          NSStringFromCGRect([userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue]));
    NSLog(@"收回的动画时间间隔%lf",[userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    NSLog(@"收回的时间曲线%ld",[userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]);
    
    NSTimeInterval duration = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options \
                     animations:^{
                         self.self.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

#pragma mark - delloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
