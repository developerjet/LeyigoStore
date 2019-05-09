//
//  FSPartnerTableViewCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeSubClass.h"

NS_ASSUME_NONNULL_BEGIN

@class FSPartnerTableViewCell;
@protocol FSPartnerCellDelegate <NSObject>
@optional
- (void)cell:(FSPartnerTableViewCell *)cell DidSelectAtModel:(FSHomeSubClass *)model;
@end

@interface FSPartnerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *subClass;

@property (nonatomic, weak) id<FSPartnerCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
