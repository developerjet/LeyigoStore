//
//  FSOptionTableViewCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeSubClass.h"

NS_ASSUME_NONNULL_BEGIN
@class FSOptionTableViewCell;

@protocol FSOptionCellDelegate <NSObject>
@optional
- (void)option:(FSOptionTableViewCell *)cell didSelectAtModel:(FSHomeSubClass *)model;
@end

@interface FSOptionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *subClass;

@property (nonatomic, weak) id<FSOptionCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
