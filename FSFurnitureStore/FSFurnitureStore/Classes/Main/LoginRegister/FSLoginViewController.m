//
//  FSLoginViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSLogInRegisterCell.h"

#import "FSRegisterViewController.h"

static NSString *const kLoginCellReuseIdentifier = @"kLoginCellReuseIdentifier";

@interface FSLoginViewController ()<UIWebViewDelegate, FSLogInRegisterCellDelegate>

@property (nonatomic, strong) FSLogRegistConfig *request;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FSLoginViewController

#pragma mark - Lazy

- (FSLogRegistConfig *)request {
    
    if (!_request) {
        _request = [[FSLogRegistConfig alloc] init];
        _request.name = [FSLoginManager manager].account;
        _request.password = [FSLoginManager manager].password;
        _request.appkey = @"3406";
    }
    return _request;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[[FSLogRegistConfig initTitle:@"Account:"
                                                text:[FSLoginManager manager].account
                                         placeholder:@"Please input Account"
                                     secureTextEntry:NO],
                        [FSLogRegistConfig initTitle:@"Password:"
                                                text:[FSLoginManager manager].password
                                         placeholder:@"Please input Password"
                                     secureTextEntry:YES]];
    }
    return _dataSource;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _bottomView = [[UIView alloc] initWithFrame:rect];
        // login button
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(30, (rect.size.height-44)/2, rect.size.width-60, 44);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        loginButton.backgroundColor = [UIColor colorThemeColor];
        loginButton.layer.cornerRadius = 22;
        loginButton.layer.masksToBounds = YES;
        loginButton.title = @"Login";
        [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:loginButton];
    }
    return _bottomView;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"User Login";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Register" image:nil target:self action:@selector(goRegister)];
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initLoginView];
}

- (void)fileLastUsers {
    
}

- (void)initLoginView {
    
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FSLogInRegisterCell" bundle:nil] forCellReuseIdentifier:kLoginCellReuseIdentifier];
    self.tableView.tableFooterView = self.bottomView;
    [self.view addSubview:self.tableView];
}


- (void)goRegister {
    
    FSRegisterViewController *registerVC = [[FSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - Login Request

- (void)loginButtonPressed {
    [self.view endEditing:YES];
    
    if (!self.request.name.length ||
        self.request.name.length <7 ||
        self.request.name.length > 13) {
        [FSProgressHUD showHUDWithError:@"Account format error" delay:1.0];
        return;
    }
    if (![NSString isValidPassword:self.request.password]) {
        [FSProgressHUD showHUDWithError:@"Password format error" delay:1.0];
        return;
    }
    
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    [parmes setObject:self.request.name forKey:@"name"];
    [parmes setObject:self.request.appkey forKey:@"appkey"];
    [parmes setObject:[self.request.password md5] forKey:@"password"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Login..."];
    [[FSRequestManager manager] POST:kUser_Login parameters:parmes progress:nil success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        NSDictionary *JSONObject = [responseObj mj_JSONObject];
        FSLogRegistConfig *result = [FSLogRegistConfig mj_objectWithKeyValues:JSONObject];
        
        if (result.returns == 1) {
            [self saveLoginResult:result];
            [FSProgressHUD showHUDWithSuccess:@"Login success" delay:1.5];
            [NC postNotificationName:NC_LOGIN_SUCCESS object:nil];
        }else {
            [FSProgressHUD showHUDWithSuccess:result.message delay:1.5];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD showHUDWithSuccess:@"Login failure" delay:1.5];
    }];
}

- (void)saveLoginResult:(FSLogRegistConfig *)result {
    if (!result.token.length) {
        return;
    }
    
    [UD setObject:result.token forKey:UD_USER_TOKEN];
    [UD setObject:self.request.name forKey:UD_USER_ACCOUNT];
    [UD setObject:self.request.password forKey:UD_USER_PASSWORD];
    [UD synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
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
        default:
            break;
    }
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSLogInRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoginCellReuseIdentifier];
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
