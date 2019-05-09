//
//  FSShopCartInfoCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSShopCartList.h"

NS_ASSUME_NONNULL_BEGIN

@class FSShoppingCartInfoCell;
@protocol FSShoppingCartCellDelegate <NSObject>
@optional
- (void)cell:(FSShoppingCartInfoCell *)cell didAddCountAtModel:(FSShopCartList *)model;
@end

@interface FSShoppingCartInfoCell : UITableViewCell

@property (nonatomic, weak) id<FSShoppingCartCellDelegate> delegate;

@property (nonatomic, strong) FSShopCartList *model;

@property (nonatomic, assign) BOOL hideAdd;

@end

NS_ASSUME_NONNULL_END
