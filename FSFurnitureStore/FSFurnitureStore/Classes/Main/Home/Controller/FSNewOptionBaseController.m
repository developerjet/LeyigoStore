//
//  FSNewOptionBaseController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSNewOptionBaseController.h"
#import "FSNewOptionContentCell.h"

#import "FSOptionDetailViewController.h"

@interface FSNewOptionBaseController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSNewOptionBaseController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.subClass.title;
    
    [self initTableView];
    [self configRefresh];
}

- (void)initTableView
{
    CGFloat y = kNavHeight;
    CGFloat h = SCREEN_HEIGHT - y;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSNewOptionContentCell" bundle:nil]
         forCellReuseIdentifier:@"kNewOptionContentIdentifier"];
    self.tableView.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)configRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOption];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestOption {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:self.subClass.idField forKey:@"pid"];
    [p setObject:@"0" forKey:@"page"];
    
    [[FSRequestManager manager] POST:kHome_Option_List parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray *newObject = [FSNewOptionClass mj_objectArrayWithKeyValuesArray:[responseObj[@"array"] mj_JSONObject]];
        [self.dataSource addObjectsFromArray:newObject];
        
        if (self.dataSource.count) {
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSNewOptionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kNewOptionContentIdentifier"];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSOptionDetailViewController *detailVC = [[FSOptionDetailViewController alloc] init];
        FSNewOptionClass *model = self.dataSource[indexPath.row];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

@end
