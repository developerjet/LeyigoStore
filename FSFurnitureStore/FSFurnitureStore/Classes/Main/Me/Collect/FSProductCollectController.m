//
//  FSProductCollectController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSProductCollectController.h"
#import "FSClassifyProductCell.h"

#import "FSProductDetailViewController.h"

static NSString *const kProductCollectCellIdentifier = @"kProductCollectCellIdentifier";

@interface FSProductCollectController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSProductCollectController

#pragma mark - Lazy

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Product Collect";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initTableView];
    [self initRefreshing];
}

- (void)initTableView {
    
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSClassifyProductCell" bundle:nil] forCellReuseIdentifier:kProductCollectCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initRefreshing {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestCollect];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestCollect {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"0" forKey:@"page"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kProduct_CollectList parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            NSArray *JSONArray = [responseObj[@"product"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSClassifyRoot mj_objectArrayWithKeyValuesArray:JSONArray]];
            [self.tableView reloadData];
        }else {
            [FSProgressHUD showHUDWithError:responseObj[@"message"] delay:1.0];
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
    
    FSClassifyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCollectCellIdentifier];
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
        detailVC.isCollect = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
