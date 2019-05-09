//
//  FSStoreViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSStoreViewController.h"
#import "FSStoreTableViewCell.h"
#import "FSStorePartner.h"

#import "FSProductDetailViewController.h"
#import "FSStoreDetailBaseController.h"

static NSString *const kStoreCellIdentifier = @"kStoreCellIdentifier";

@interface FSStoreViewController()<FSStoreTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSStoreViewController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Store";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initTableview];
    [self initTabRefresh];
}

- (void)initTableview {
    
    CGFloat y = kNavHeight;
    CGFloat h = SCREEN_HEIGHT - y - kTabBarHeight;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kStoreCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initTabRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestStore];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestStore {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"0" forKey:@"page"];
    [p setObject:@"0" forKey:@"pid"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kStore_List parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            NSDictionary *JSONObject = [responseObj[@"partner"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSStorePartner mj_objectArrayWithKeyValuesArray:JSONObject]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <FSStoreTableCellDelegate>

- (void)cell:(FSStoreTableViewCell *)cell didSelectItemAtModel:(FSStoreSubclas *)model {
    
    if (model) {
        FSClassifyRoot *root = [FSClassifyRoot new];
        FSProductDetailViewController *detailVC = [FSProductDetailViewController new];
        root.img = model.photoX;
        root.name = model.name;
        root.idField = model.idField;
        root.price = model.price;
        detailVC.model = root;
        detailVC.isCollect = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellIdentifier];
    cell.delegate = self;
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSStorePartner *model = self.dataSource[indexPath.row];
        model.idField = @"1"; 
        FSStoreDetailBaseController *detailVC = [FSStoreDetailBaseController new];
        detailVC.isCollect = YES;
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSStorePartner *model = self.dataSource[indexPath.row];
        if (model.subclass.count) {
            return 210;
        }else {
            return 110;
        }
    }else {
        return 0.01;
    }
}

@end
