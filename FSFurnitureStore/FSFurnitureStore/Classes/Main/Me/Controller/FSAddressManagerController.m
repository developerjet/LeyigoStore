//
//  FSLogisticsManagerController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSAddressManagerController.h"
#import "FSAddressManagerCell.h"

#import "FSAddressAddViewController.h"

static NSString *const kAddressManagerCellIdentifier = @"kAddressManagerCellIdentifier";

@interface FSAddressManagerController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *selectSource;

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation FSAddressManagerController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectSource {
    
    if (!_selectSource) {
        
        _selectSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectSource;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        CGFloat h = 60;
        CGFloat y = SCREEN_HEIGHT - h;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor colorThemeColor];
        _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _deleteButton.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
        [_deleteButton addTarget:self action:@selector(deleteAddress) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.title = @"Delete";
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Logistics Manager";
    self.view.backgroundColor = [UIColor colorWhiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"ic_add_address" target:self action:@selector(addNewAddress)];
    [NC addObserver:self selector:@selector(requestAddress) name:NC_ADD_ADDRESS object:nil];
    
    [self initTableView];
    [self initTabRefresh];
}

- (void)initTableView {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight - self.deleteButton.height;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSAddressManagerCell" bundle:nil] forCellReuseIdentifier:kAddressManagerCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.deleteButton];
}

- (void)initTabRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestAddress];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Request

- (void)requestAddress {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kAddress_List parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        if ([responseObj[@"returns"] integerValue] == 1) {
            NSArray *JSONArray = [responseObj[@"address"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSShopCartList mj_objectArrayWithKeyValuesArray:JSONArray]];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)deleteAddress {
    
    NSString *idField = [self.selectSource componentsJoinedByString:@","];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:idField forKey:@"id"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kAddress_Delete parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            [FSProgressHUD hideHUD];
            [self.tableView.mj_header beginRefreshing];
        }else {
            [FSProgressHUD showHUDWithError:responseObj[@"message"] delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)addNewAddress {

    FSAddressAddViewController *addAddress = [[FSAddressAddViewController alloc] init];
    [self.navigationController pushViewController:addAddress animated:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSAddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressManagerCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataSource.count > indexPath.row) {
        FSShopCartList *model = self.dataSource[indexPath.row];
        model.isSelect = !model.isSelect;
        if (model.isSelect) {
            [self.selectSource addObject:model.idField];
        }else {
            [self.selectSource removeObject:model.idField];
        }
        
        self.deleteButton.hidden = self.selectSource.count ? NO : YES;
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
