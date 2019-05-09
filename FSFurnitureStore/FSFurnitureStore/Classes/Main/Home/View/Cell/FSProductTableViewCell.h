//
//  FSProductTableViewCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeSubClass.h"

NS_ASSUME_NONNULL_BEGIN

@class FSProductTableViewCell;
@protocol FSProductCellDelegate <NSObject>
@optional
- (void)product:(FSProductTableViewCell *)cell didSelectAtModel:(FSHomeSubClass *)model;
@end

@interface FSProductTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *subClass;

@property (nonatomic, weak) id<FSProductCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
