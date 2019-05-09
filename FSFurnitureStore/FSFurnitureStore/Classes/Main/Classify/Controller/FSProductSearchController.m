//
//  FSProductSearchController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSProductSearchController.h"
#import "FSClassifyProductCell.h"

#import "FSProductDetailViewController.h"


static NSString *const kProductSeachCellIdentifier = @"kProductSeachCellIdentifier";

@interface FSProductSearchController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSProductSearchController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        CGRect frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, 50);
        _searchBar = [[UISearchBar alloc] initWithFrame:frame];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeholder = @"Search for your furniture";
        _searchBar.delegate = self;
        _searchBar.scopeBarBackgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    return _searchBar;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Search";
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self initSubview];
    [self beginRefresh];
}

- (void)initSubview {
    
    [self.view addSubview:self.searchBar];
    
    CGFloat y = self.searchBar.maxY;
    CGFloat h = SCREEN_HEIGHT - y;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSClassifyProductCell" bundle:nil] forCellReuseIdentifier:kProductSeachCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)beginRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf searchProduct];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchProduct {
    
    NSDictionary *parameters = @{@"appkey": @"3406",
                                 @"keyword": _keyword};
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kClassify_Product parameters:parameters success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray *JSONArray = [responseObj[@"product"] mj_JSONObject];
        
        [self.dataSource addObjectsFromArray:[FSClassifyRoot mj_objectArrayWithKeyValuesArray:JSONArray]];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if ([searchBar isEqual:self.searchBar]) {
        if (searchBar.text.length) {
            self.keyword = searchBar.text;
            [self.tableView.mj_header beginRefreshing];
        }else {
            [FSProgressHUD showHUDWithError:@"Please fill in the search" delay:1.0];
        }
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSClassifyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductSeachCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (self.dataSource.count > indexPath.row) {
        FSProductDetailViewController *detailVC = [FSProductDetailViewController new];
        detailVC.model = self.dataSource[indexPath.row];
        detailVC.isCollect = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}


@end
