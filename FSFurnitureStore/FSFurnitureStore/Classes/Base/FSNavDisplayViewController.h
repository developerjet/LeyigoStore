//
//  FSNavHideViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/23.
//  Copyright © 2018 FTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSNavDisplayViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate,
JXCategoryViewDelegate>

/**
 基类普通列表
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
 停止当前列表刷新
 */
- (void)endRefreshing;

@end

NS_ASSUME_NONNULL_END
