//
//  FSLogInBottomView.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSRegisterBottomView;
@protocol FSRegisterBottomDelegate <NSObject>
@optional
- (void)view:(FSRegisterBottomView *)view didRegsiterTag:(NSInteger)tag state:(BOOL)state;
@end

@interface FSRegisterBottomView : UIView

@property (nonatomic, weak) id<FSRegisterBottomDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
