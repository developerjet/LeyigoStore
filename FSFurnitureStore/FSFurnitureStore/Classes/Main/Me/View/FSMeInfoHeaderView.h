//
//  FSMeInfoHeaderView.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FSMeInfoDidType_Arrow,
    FSMeInfoDidType_Photo,
} FSMeInfoDidType;

NS_ASSUME_NONNULL_BEGIN
@class FSMeInfoHeaderView;
@protocol FSMeInfoHeaderDelegate <NSObject>
@optional
- (void)header:(FSMeInfoHeaderView *)header didUserInfoType:(FSMeInfoDidType)type model:(FSLogRegistConfig *)model;
@end

@interface FSMeInfoHeaderView : UIView

@property (nonatomic, strong) FSLogRegistConfig *model;

@property (nonatomic, weak) id<FSMeInfoHeaderDelegate> delegate;

@property (nonatomic, strong) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
