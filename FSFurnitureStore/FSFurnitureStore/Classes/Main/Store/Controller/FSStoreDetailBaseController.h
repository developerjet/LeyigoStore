//
//  FSStoreDetailViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/30.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSBaseConfigViewController.h"
#import "FSStorePartner.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSStoreDetailBaseController : FSBaseConfigViewController

@property (nonatomic, assign) BOOL isCollect;

@property (nonatomic, strong) FSStorePartner *model;

@property (nonatomic, assign) BOOL isNeedCategoryListContainerView;

@end

NS_ASSUME_NONNULL_END
