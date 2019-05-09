//
//  FSWaitingOrderViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSBaseConfigViewController.h"
#import "FSProductClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSWaitingOrderViewController : FSBaseConfigViewController

@property (nonatomic, strong) FSProductClass *model;

@property (nonatomic, assign) BOOL isShopCart;

@end

NS_ASSUME_NONNULL_END
