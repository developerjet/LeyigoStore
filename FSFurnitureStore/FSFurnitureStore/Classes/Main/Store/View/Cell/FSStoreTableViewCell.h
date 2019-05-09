//
//  FSStoreTableViewCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStorePartner.h"

@class FSStoreTableViewCell;
@protocol FSStoreTableCellDelegate <NSObject>
@optional
- (void)cell:(FSStoreTableViewCell *)cell didSelectItemAtModel:(FSStoreSubclas *)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface FSStoreTableViewCell : UITableViewCell

@property (nonatomic, strong) FSStorePartner *model;

@property (nonatomic, strong) id<FSStoreTableCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
