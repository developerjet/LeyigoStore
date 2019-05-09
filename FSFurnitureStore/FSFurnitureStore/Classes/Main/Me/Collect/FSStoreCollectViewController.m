//
//  FSStoreCollectViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreCollectViewController.h"
#import "FSStoreCollectCell.h"

#import "FSStoreDetailBaseController.h"

static NSString *const kStoreCollectCellIdentifier = @"kStoreCollectCellIdentifier";

@interface FSStoreCollectViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSStoreCollectViewController

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
    // Do any additional setup after loading the view.
    self.title = @"Store Collect";
    self.view.backgroundColor = [UIColor colorWhiteColor];
    
    [self initTableView];
    [self initRefreshing];
}

- (void)initTableView {
    
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSStoreCollectCell" bundle:nil] forCellReuseIdentifier:kStoreCollectCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)initRefreshing {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestCurList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Request

- (void)requestCurList {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"0" forKey:@"page"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kStore_CollectList parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            NSArray *JSONArray = [responseObj[@"partner"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSStorePartner mj_objectArrayWithKeyValuesArray:JSONArray]];
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
    
    FSStoreCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreCollectCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (self.dataSource.count > indexPath.row) {
        FSStoreDetailBaseController *detailcVC = [[FSStoreDetailBaseController alloc] init];
        FSStorePartner *model = self.dataSource[indexPath.row];
        detailcVC.isCollect = NO;
        detailcVC.model = model;
        [self.navigationController pushViewController:detailcVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
