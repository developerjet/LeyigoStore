//
//  FSAllBaseViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/23.
//  Copyright © 2018 FTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "JXCategoryView.h"

#import <UShareUI/UShareUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSBaseConfigViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate,
JXCategoryViewDelegate>

/**
 基类列表
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 基类分组列表
 */
@property (nonatomic, strong) UITableView *groupedTable;

/**
 基类UICollectionView
 */
@property (nonatomic, strong) UICollectionView *collectView;

/**
 用户token
 */
@property (nonatomic, strong) NSString *token;

/**
 停止当前列表刷新
 */
- (void)endRefreshing;

/**
 去登录
 */
- (void)goToLogin;

@end

NS_ASSUME_NONNULL_END
