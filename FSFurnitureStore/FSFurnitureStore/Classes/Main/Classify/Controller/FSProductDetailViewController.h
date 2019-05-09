//
//  FSProductDetailViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSBaseConfigViewController.h"
#import "FSClassifyRoot.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSProductDetailViewController : FSBaseConfigViewController

@property (nonatomic, strong) FSClassifyRoot *model;

@property (nonatomic, assign) BOOL isCollect;

@end

NS_ASSUME_NONNULL_END
