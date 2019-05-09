//
//  FSAddressAddViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/6.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSAddressAddViewController.h"
#import "FSLogInRegisterCell.h"

static NSString *const kAddressAddCellIdentifier = @"kAddressAddCellIdentifier";

@interface FSAddressAddViewController ()<FSLogInRegisterCellDelegate>

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) FSLogRegistConfig *request;

@end

@implementation FSAddressAddViewController

#pragma mark - Lazy

- (FSLogRegistConfig *)request {
    
    if (!_request) {
        _request = [[FSLogRegistConfig alloc] init];
        _request.appkey = @"3406";
        _request.sheng = @"868";
        _request.city = @"869";
        _request.quyu = @"870";
    }
    return _request;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _bottomView = [[UIView alloc] initWithFrame:rect];
        UIButton *logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logInButton.frame = CGRectMake(30, (rect.size.height-44)/2, rect.size.width-60, 44);
        logInButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        logInButton.backgroundColor = [UIColor colorThemeColor];
        logInButton.layer.cornerRadius = 22;
        logInButton.layer.masksToBounds = YES;
        logInButton.title = @"Confirm";
        [logInButton addTarget:self action:@selector(confirmAdd) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:logInButton];
    }
    return _bottomView;
}


- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = @[[FSLogRegistConfig initTitle:@"Recipient:"
                                         placeholder:@"Please enter the recipient's name"],
                        [FSLogRegistConfig initTitle:@"Phone Number:"
                                         placeholder:@"11 mobile phone numbers"],
                        [FSLogRegistConfig initTitle:@"Location:"
                                         placeholder:@"Please input your location"],
                        [FSLogRegistConfig initTitle:@"Detailed address:"
                                         placeholder:@"Please enter detailed address"],
                        [FSLogRegistConfig initTitle:@"Postal Code:"
                                         placeholder:@"Please enter postalcode"]];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Update information";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initTableView];
}

- (void)initTableView {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSLogInRegisterCell" bundle:nil] forCellReuseIdentifier:kAddressAddCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.bottomView;
    [self.view addSubview:self.tableView];
}

- (void)confirmAdd {
    [self.view endEditing:YES];
    if (![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithError:@"Please log in first" delay:1.0];
        return;
    }
    
    if (![NSString isValidateHomePhoneNum:self.request.tel]) {
        [FSProgressHUD showHUDWithError:@"Phone number format error" delay:1.0];
        return;
    }
    if (!self.request.name.length) {
        [FSProgressHUD showHUDWithError:@"The recipient cannot be empty" delay:1.0];
        return;
    }
    if (self.request.name.length > 20) {
        [FSProgressHUD showHUDWithError:@"Recipient is too long" delay:1.0];
        return;
    }
    if (![NSString isValidateHomePhoneNum:self.request.tel]) {
        [FSProgressHUD showHUDWithError:@"Phone number format error" delay:1.0];
        return;
    }
    if (!self.request.address) {
        [FSProgressHUD showHUDWithError:@"The address must not be empty." delay:1.0];
        return;
    }
    if (!self.request.code) {
        [FSProgressHUD showHUDWithError:@"The location must not be empty." delay:1.0];
        return;
    }
    
    
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    [parmes setObject:[FSLoginManager manager].token forKey:@"token"];
    [parmes setObject:self.request.appkey forKey:@"appkey"];
    [parmes setObject:self.request.address forKey:@"address"];
    [parmes setObject:self.request.name forKey:@"name"];
    [parmes setObject:self.request.code forKey:@"code"];
    [parmes setObject:self.request.tel forKey:@"tel"];
    [parmes setObject:self.request.sheng forKey:@"sheng"];
    [parmes setObject:self.request.city forKey:@"city"];
    [parmes setObject:self.request.quyu forKey:@"quyu"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kAddress_Add parameters:parmes progress:nil success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        NSDictionary *JSONObject = [responseObj mj_JSONObject];
        
        FSLogRegistConfig *result = [FSLogRegistConfig mj_objectWithKeyValues:JSONObject];
        if (result.returns == 1) {
            [FSProgressHUD showHUDWithSuccess:@"Success" delay:2.0];
            [NC postNotificationName:NC_ADD_ADDRESS object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [FSProgressHUD showHUDWithSuccess:result.message delay:2.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - <FSLogInRegisterCellDelegate>

- (void)cell:(FSLogInRegisterCell *)cell textFieldDidEndEditing:(NSString *)text {
    NSInteger row = [[self.tableView indexPathForCell:cell] item];
    
    switch (row) {
        case 0:
            self.request.name = text;
            break;
        case 1:
            self.request.tel = text;
            break;
        case 3:
            self.request.address = text;
            break;
        case 4:
            self.request.code = text;
            break;
        default:
            break;
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSLogInRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressAddCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

@end
