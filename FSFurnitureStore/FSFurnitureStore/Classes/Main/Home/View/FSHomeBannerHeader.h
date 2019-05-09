//
//  FSHomeBannerHeader.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeSubClass.h"

NS_ASSUME_NONNULL_BEGIN

@class FSHomeBannerHeader;
@protocol FSHomeBannerHeaderDelegate <NSObject>
@optional
- (void)header:(FSHomeBannerHeader *)header DidSelectAtSubClass:(FSHomeSubClass *)subClass;

@end

@interface FSHomeBannerHeader : UIView

@property (nonatomic, strong) NSMutableArray <FSHomeSubClass *>*items;

@property (nonatomic, strong) NSMutableArray <FSHomeSubClass *>*images;

@property (nonatomic, weak) id<FSHomeBannerHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
