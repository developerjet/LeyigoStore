//
//  FSNavHideViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/23.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSNavDisplayViewController.h"

@interface FSNavDisplayViewController ()

@end

@implementation FSNavDisplayViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWhiteColor];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [FSProgressHUD hideHUD];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points，（状态栏不隐藏）
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

#pragma mark - Lazy

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGFloat y = [kCurrentWindow yx_navigationHeight];
        CGFloat tabBarHeight = [kCurrentWindow yx_tabbarHeight];
        CGFloat h = SCREEN_HEIGHT - y - tabBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight   = 250;
        _tableView.emptyDataSetSource   = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.mj_header.automaticallyChangeAlpha = YES;
    }
    return _tableView;
}

- (UITableView *)groupedTable {
    
    if (!_groupedTable) {
        CGFloat y = [kCurrentWindow yx_navigationHeight];
        CGFloat tabBarHeight = [kCurrentWindow yx_tabbarHeight];
        CGFloat h = SCREEN_HEIGHT - y - tabBarHeight;
        _groupedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        _groupedTable.delegate   = self;
        _groupedTable.dataSource = self;
        _groupedTable.estimatedRowHeight   = 250;
        _groupedTable.emptyDataSetSource   = self;
        _groupedTable.emptyDataSetDelegate = self;
        _groupedTable.backgroundColor = [UIColor clearColor];
        _groupedTable.showsHorizontalScrollIndicator = NO;
        _groupedTable.mj_header.automaticallyChangeAlpha = YES;
    }
    return _groupedTable;
}

- (UICollectionView *)collectView {
    
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // setup
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectView;
}


#pragma mark - Private Methods

- (void)endRefreshing {
    [FSProgressHUD hideHUD];
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if ([self.groupedTable.mj_header isRefreshing]) {
        [self.groupedTable.mj_header endRefreshing];
    }
    if ([self.groupedTable.mj_footer isRefreshing]) {
        [self.groupedTable.mj_footer endRefreshing];
    }
    
    if ([self.collectView.mj_header isRefreshing]) {
        [self.collectView.mj_header endRefreshing];
    }
    if ([self.collectView.mj_footer isRefreshing]) {
        [self.collectView.mj_footer endRefreshing];
    }
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"No data yet, please try again";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor colorLightTextColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    [self refreshingAgain];
}

- (void)refreshingAgain
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header beginRefreshing];
        }
        
        if (![self.groupedTable.mj_header isRefreshing]) {
            [self.groupedTable.mj_header beginRefreshing];
        }
        
        if (![self.collectView.mj_header isRefreshing]) {
            [self.collectView.mj_header beginRefreshing];
        }
    });
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
