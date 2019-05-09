//
//  FSConfigInputView.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInputHeight 60

NS_ASSUME_NONNULL_BEGIN

@class FSConfigInputView;

@protocol FSConfigInputDelegate <NSObject>
@optional;
- (void)input:(FSConfigInputView *)input textFieldDidEndEditing:(NSString *)text;
@end


typedef void(^DidEndEditingBlock)(NSString *text);

@interface FSConfigInputView : UIView

- (void)showInputAddedTo:(UIView *)view;
- (void)hide;

/// 获取输入的内容
@property (nonatomic, strong) DidEndEditingBlock editingBlock;
/// 设置代理
@property (nonatomic, weak) id<FSConfigInputDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
