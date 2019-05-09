//
//  FSSettlementViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSSettlementViewController.h"
#import "FSShoppingCartInfoCell.h"

#import "FSBaseTabBarViewController.h"

#import "FSProductDetailViewController.h"
#import "FSAddressAddViewController.h"
#import "FSMeInfoViewController.h"

static NSString *const kOrderCellWithIdentifier = @"kOrderCellWithIdentifier";

@interface FSSettlementViewController ()

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (weak, nonatomic) IBOutlet UITableView *curTabView;

@property (nonatomic, strong) NSMutableArray *addressResult;

@property (nonatomic, copy) NSString * addressID;

@end

@implementation FSSettlementViewController

- (NSMutableArray *)addressResult {
    
    if (!_addressResult) {
        
        _addressResult = [NSMutableArray array];
    }
    return _addressResult;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Confirm Order";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [NC addObserver:self selector:@selector(requestAddress) name:NC_ADD_ADDRESS object:nil];
    
    [self initSubview];
    [self requestAddress];
}

- (void)initSubview {
    self.view.backgroundColor = [UIColor colorWhiteColor];
    
    self.bottomButton.layer.cornerRadius = 5.0;
    self.bottomButton.layer.masksToBounds = YES;
    
    self.orderButton.layer.cornerRadius = 17;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.orderButton addTarget:self action:@selector(addNewOrder) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalMoneyLab.text = @"￥0.0";
    self.totalPriceLab.text = @"￥0.0";
    
    [self initTabView];
}

- (void)initTabView {
    
    self.curTabView.delegate = self;
    self.curTabView.dataSource = self;
    self.curTabView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.curTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.curTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.curTabView registerNib:[UINib nibWithNibName:@"FSShoppingCartInfoCell" bundle:nil] forCellReuseIdentifier:kOrderCellWithIdentifier];
}

#pragma mark - Request

- (void)addNewOrder {
    if (!self.dataSource.count) {
        [FSProgressHUD showHUDWithError:@"Please select product" delay:1.0];
        return;
    }
    if (!self.addressID) {
        [FSProgressHUD showHUDWithError:@"Please add address" delay:1.0];
        return;
    }
    
    NSMutableArray *idArray = [NSMutableArray new];
    for (FSShopCartList *model in self.dataSource) {
        [idArray addObject:model.idField];
    }
    
    NSString *idField = [idArray componentsJoinedByString:@","];
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.addressID forKey:@"address"];
    [p setObject:idField forKey:@"inventory"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"0" forKey:@"ipost_id"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kOrder_add parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            [FSProgressHUD showHUDWithSuccess:@"Success" delay:2.0];
            [self popToController];
        }else {
            [FSProgressHUD showHUDWithError:@"Operation failed" delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}


- (void)requestAddress {
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kAddress_List parameters:p success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            NSArray *JSONArray = [responseObj[@"address"] mj_JSONObject];
            if (JSONArray.count) {
                [self.addressResult addObjectsFromArray:[FSShopCartList mj_objectArrayWithKeyValuesArray:JSONArray]];
                [self reloadAddressInfo:[self.addressResult firstObject]];
            }
        }else {
            [FSProgressHUD showHUDWithLongText:@"Please add address" delay:1.0];
            [self addToAddress];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)addToAddress {
    
    FSAddressAddViewController *addAddress = [[FSAddressAddViewController alloc] init];
    [self.navigationController pushViewController:addAddress animated:YES];
}

- (void)reloadAddressInfo:(FSShopCartList *)model {
    if (!model) return;
    
    self.addressID = model.idField;
    
    self.telLabel.text = model.tel;
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
}

- (void)popToController {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FSProductDetailViewController class]]) {
            FSProductDetailViewController *vc1 = (FSProductDetailViewController *)controller;
            [self.navigationController popToViewController:vc1 animated:YES];
        }if ([controller isKindOfClass:[FSMeInfoViewController class]]) {
            FSMeInfoViewController *vc2 = (FSMeInfoViewController *)controller;
            [self.navigationController popToViewController:vc2 animated:YES];
        }
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSShoppingCartInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCellWithIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.hideAdd = YES;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}


#pragma mark - Action

- (IBAction)arrowDidEvent:(id)sender {
    
    if (!self.addressID) {
        [self addToAddress];
    }
}
@end
