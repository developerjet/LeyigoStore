//
//  FSMeShoppingCartController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSMeShoppingCartController.h"
#import "FSShoppingCartInfoCell.h"
#import "FSSectionHeaderView.h"
#import "FSShopCartClass.h"

#import "FSSettlementViewController.h"

static NSString *const kShopCartCellIdentifier = @"kShopCartCellIdentifier";
static NSString *const kShopCartHeaderIdentifier = @"kShopCartHeaderIdentifier";

@interface FSMeShoppingCartController ()<FSShoppingCartCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *selectSource;

@property (nonatomic, strong) NSMutableArray *orderResults;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation FSMeShoppingCartController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectSource {
    
    if (!_selectSource) {
        
        _selectSource = [NSMutableArray array];
    }
    return _selectSource;
}

- (NSMutableArray *)orderResults {
    
    if (!_orderResults) {
        
        _orderResults = [NSMutableArray array];
    }
    return _orderResults;
}

#pragma mark - Life Cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shopping Cart";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initShopCartView];
    [self initShopRefresh];
}

- (void)initShopRefresh {
    
    WeakSelf;
    self.groupedTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestShopCart];
    }];
    
    [self.groupedTable.mj_header beginRefreshing];
}

- (void)initShopCartView {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Delete" image:nil target:self action:@selector(updateShopCart)];
    
    CGFloat y = kNavHeight;
    CGFloat h = (SCREEN_HEIGHT - y - _bottomHeight.constant);
    self.groupedTable.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.groupedTable registerNib:[UINib nibWithNibName:@"FSShoppingCartInfoCell" bundle:nil] forCellReuseIdentifier:kShopCartCellIdentifier];
    [self.groupedTable registerClass:[FSSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kShopCartHeaderIdentifier];
    self.groupedTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.groupedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.groupedTable];
}

#pragma mark - Request

- (void)requestShopCart {
    if (!self.token) {
        [FSProgressHUD showHUDWithError:@"Please log in first" delay:1.0];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kShopCart_List parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            
            if ([[responseObj[@"array"] firstObject] count]) {
                NSDictionary *JSONObject = [responseObj[@"array"] firstObject][@"partner"];
                FSShopCartClass *cartClass = [FSShopCartClass mj_objectWithKeyValues:JSONObject];
                [self.dataSource addObject:cartClass];
            }
            [self.groupedTable reloadData];
            
        }else {
            
            [FSProgressHUD showHUDWithError:@"Login verification failed" delay:2.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)updateShopCart {
    if (!self.selectSource.count) {
        [FSProgressHUD showHUDWithError:@"Please select product" delay:1.0];
        return;
    }
    

    NSString *newIdField = [self.selectSource componentsJoinedByString:@","];

    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.token forKey:@"token"];
    [p setObject:newIdField forKey:@"id"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"del" forKey:@"type"];
    
    [FSProgressHUD showHUDWithIndeterminate:@""];
    [[FSRequestManager manager] POST:kShopCart_Update parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            [self.groupedTable.mj_header beginRefreshing];
        }else {
            [FSProgressHUD showHUDWithError:@"Operation failed" delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

// 开始下单
- (void)requestOrder {
    if (!self.selectSource.count) {
        [FSProgressHUD showHUDWithError:@"Please select product" delay:1.0];
        return;
    }
    
    NSString *idField = [self.selectSource componentsJoinedByString:@","];
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:idField forKey:@"inventory"];
    [p setObject:self.token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kShopCaset_Order parameters:p success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.orderResults.count) {
                [self.orderResults removeAllObjects];
            }
            NSArray *JSONArray = [responseObj[@"array"] mj_JSONObject];
            [self.orderResults addObjectsFromArray:[FSShopCartList mj_objectArrayWithKeyValuesArray:JSONArray]];
            [self confirmOrder];
        }else {
            [FSProgressHUD showHUDWithError:@"Operation failed" delay:1.0];
        }

    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)confirmOrder {
    
    FSSettlementViewController *settleVC = [[FSSettlementViewController alloc] init];
    settleVC.dataSource = self.orderResults;
    [self.navigationController pushViewController:settleVC animated:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource.count > section) {
        FSShopCartClass *cartClass = self.dataSource[section];
        if (cartClass.list.count) {
            return cartClass.list.count;
        }else {
            return 0;
        }
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSShoppingCartInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCartCellIdentifier];
    if (self.dataSource.count > indexPath.section) {
        FSShopCartClass *cartClass = self.dataSource[indexPath.section];
        if (cartClass.list.count > indexPath.row) {
            cell.model = cartClass.list[indexPath.row];
            cell.delegate = self;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FSSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kShopCartHeaderIdentifier];
    
    if (self.dataSource.count > section) {
        FSShopCartClass *cartClass = self.dataSource[section];
        header.titleColor = [UIColor colorWithHexString:@"EE2C2C"];
        header.title = cartClass.name;
        return header;
    }else {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.section) {
        FSShopCartClass *cartClass = self.dataSource[indexPath.section];
        if (cartClass.list.count > indexPath.row) {
            FSShopCartList *model = cartClass.list[indexPath.row];
            model.isSelect = !model.isSelect;
            if (model.isSelect) {
                [self.selectSource addObject:model.idField];
            }else {
                [self.selectSource removeObject:model.idField];
            }
            
            self.countLabel.text = [NSString stringWithFormat:@"%ld", self.selectSource.count];
            [self.groupedTable reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}


#pragma mark - Click

- (IBAction)confirmOrder:(id)sender {
    if (!self.selectSource.count) {
        [FSProgressHUD showHUDWithError:@"Please select product" delay:1.0];
        return;
    }
    
    [self requestOrder];
}

@end
