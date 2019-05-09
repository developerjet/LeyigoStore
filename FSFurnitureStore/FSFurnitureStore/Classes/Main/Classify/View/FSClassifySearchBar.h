//
//  FSCustomSearchBar.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSClassifySearchBar;
@protocol FSCustomSearchviewDelegate <NSObject>
@optional;
- (void)search:(FSClassifySearchBar *)search textFieldDidEndEditing:(NSString *)text;
@end

NS_ASSUME_NONNULL_BEGIN

@interface FSClassifySearchBar : UIView

+ (instancetype)createSearchViewWithFrame:(CGRect)frame
                                 delegate:(id<FSCustomSearchviewDelegate>)delegate;

@property (nonatomic, strong) id<FSCustomSearchviewDelegate> delegate;

@property (nonatomic, strong) NSString *placeholder;

@end

NS_ASSUME_NONNULL_END
