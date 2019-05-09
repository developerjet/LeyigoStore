//
//  FSRegisterViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSRegisterViewController.h"
#import "FSLogInRegisterCell.h"

#import "FSRegisterBottomView.h"


static NSString *const kRegisterCellIdentifier = @"kRegisterCellIdentifier";

@interface FSRegisterViewController ()<FSLogInRegisterCellDelegate, FSRegisterBottomDelegate>

@property (nonatomic, copy) void(^typeDidBlock)(NSUInteger index);

@property (nonatomic, strong) FSRegisterBottomView *bottomView;

@property (nonatomic, strong) FSLogRegistConfig *request;

@property (nonatomic, assign) NSInteger typeIndex;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) BOOL isAgree;

@end

@implementation FSRegisterViewController

#pragma mark - Lazy

- (FSLogRegistConfig *)request {
    
    if (!_request) {
        _request = [[FSLogRegistConfig alloc] init];
        _request.appkey = @"3406";
    }
    return _request;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = @[[FSLogRegistConfig initTitle:@"Account" placeholder:@"6-12 bits, letters and numbers" secureTextEntry:NO],
                        [FSLogRegistConfig initTitle:@"Password" placeholder:@"6-8 bits, letters and numbers" secureTextEntry:YES],
                        [FSLogRegistConfig initTitle:@"Phone" placeholder:@"phone number" secureTextEntry:NO],
                        [FSLogRegistConfig initTitle:@"Organize" placeholder:@"Nickname" secureTextEntry:NO],
                        [FSLogRegistConfig initTitle:@"Type" placeholder:@"Ordinary users" secureTextEntry:NO]];
    }
    return _dataSource;
}

- (FSRegisterBottomView *)bottomView {
    
    if (!_bottomView) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        _bottomView = [[FSRegisterBottomView alloc] initWithFrame:rect];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Register";
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self initRegisterView];
}

- (void)initRegisterView {
    self.typeIndex = 0;
    self.isAgree = NO;
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSLogInRegisterCell" bundle:nil] forCellReuseIdentifier:kRegisterCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.bottomView;
    [self.view addSubview:self.tableView];
}

#pragma mark - Request

- (void)beginRegister {
    [self.view endEditing:YES];
    
    if (![NSString isValidAccount:self.request.name]) {
        [FSProgressHUD showHUDWithError:@"Account format error" delay:1.0];
        return;
    }
    if (![NSString isValidPassword:self.request.password]) {
        [FSProgressHUD showHUDWithError:@"Password format error" delay:1.0];
        return;
    }
    if (![NSString isValidateHomePhoneNum:self.request.tel]) {
        [FSProgressHUD showHUDWithError:@"Phone number format error" delay:1.0];
        return;
    }
    if (self.request.uname.length < 0 || self.request.uname.length >= 20) {
        [FSProgressHUD showHUDWithError:@"Format error" delay:1.0];
        return;
    }
    if (!self.isAgree) {
        [FSProgressHUD showHUDWithError:@"Confirm your consent to register" delay:1.0];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.request.appkey forKey:@"appkey"];
    [p setObject:self.request.name forKey:@"name"];
    [p setObject:self.request.password forKey:@"password"];
    [p setObject:self.request.tel forKey:@"tel"];
    [p setObject:self.request.uname forKey:@"uname"];
    [p setObject:@(self.typeIndex) forKey:@"type"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Register...."];
    [[FSRequestManager manager] POST:kUsre_Register parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        NSDictionary *JSONObject = [responseObj mj_JSONObject];
        FSLogRegistConfig *result = [FSLogRegistConfig mj_objectWithKeyValues:JSONObject];
        
        if (result.returns == 1) {
            [self saveRegisterResult];
        }
        [FSProgressHUD showHUDWithError:result.message delay:2.0];
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)saveRegisterResult {
    [UD setObject:self.request.name forKey:UD_USER_ACCOUNT];
    [UD setObject:self.request.password forKey:UD_USER_PASSWORD];
    [UD synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - <FSRegisterBottomDelegate>

- (void)view:(FSRegisterBottomView *)view didRegsiterTag:(NSInteger)tag state:(BOOL)state {
    
    if (tag == 1001) {
        self.isAgree = state;
    }else {
        [self beginRegister];
    }
}

#pragma mark - <FSLogInRegisterCellDelegate>

- (void)cell:(FSLogInRegisterCell *)cell textFieldDidEndEditing:(NSString *)text {
    NSInteger row = [[self.tableView indexPathForCell:cell] item];
    
    switch (row) {
        case 0:
            self.request.name = text;
            break;
        case 1:
            self.request.password = text;
            break;
        case 2:
            self.request.tel = text;
            break;
        case 3:
            self.request.uname = text;
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
    
    FSLogInRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:kRegisterCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.delegate = self;
        if (indexPath.row == self.dataSource.count-1) {
            cell.showHUD = YES;
            self.typeDidBlock = ^(NSUInteger index) {
                if (index == 0) {
                    cell.textField.placeholder = @"Ordinary users";
                }else {
                    cell.textField.placeholder = @"Merchant member";
                }
            };
        }
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        if (indexPath.row == self.dataSource.count - 1) {
            [self showTypeAlert];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)showTypeAlert {
    
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeTitle(@"Selection category")
    .LeeAction(@"Ordinary users", ^{
        weakSelf.typeIndex = 0;
        if (self.typeDidBlock) {
            self.typeDidBlock(weakSelf.typeIndex);
        }
    })
    .LeeAction(@"Merchant member", ^{
        weakSelf.typeIndex = 1;
        if (self.typeDidBlock) {
            self.typeDidBlock(weakSelf.typeIndex);
        }
    })
    .LeeCancelAction(@"Cancel", ^{
        // 点击事件Block
    })
    .LeeShow();
}


@end
