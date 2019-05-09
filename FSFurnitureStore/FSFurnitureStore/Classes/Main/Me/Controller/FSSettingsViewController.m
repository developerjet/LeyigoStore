//
//  FSSettingsViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSSettingsViewController.h"
#import "FSSettingsTableViewCell.h"

#import "FSAboutMeViewController.h"

@interface FSSettingsViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, copy) void(^clearDidBlock)(void);

@end

@implementation FSSettingsViewController


#pragma mark - Lazy

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[[FSBaseModel initTitle:@"About App" subtitle:@""],
                        [FSBaseModel initTitle:@"Clear cache" subtitle:[FSCacheManager shared].cacheSize]];
    }
    return _dataSource;
}

- (UIButton *)logoutButton {
    
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.hidden = YES;
        _logoutButton.title = @"Logout";
        _logoutButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _logoutButton.backgroundColor = [UIColor colorWhiteColor];
        _logoutButton.titleColor = [UIColor redColor];
        [_logoutButton addTarget:self action:@selector(beginLogout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    self.logoutButton.hidden = [FSLoginManager manager].token.length ? NO : YES;
    
    [self initTableView];
}

- (void)initTableView {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    self.tableView.tableFooterView = self.logoutButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"FSSettingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"kSettingsCellWithIdentifier"];
    [self.view addSubview:self.tableView];   
}

#pragma mark - Request

- (void)beginLogout {
    if (![FSLoginManager manager].token) {
        [FSProgressHUD showHUDWithError:@"Not login" delay:1.0];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"zx" forKey:@"type"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Logout..."];
    [[FSRequestManager manager] POST:kUser_Login parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"return"] isEqualToString:@"ok"]) {
            [FSProgressHUD showHUDWithSuccess:@"Logout ssuccess" delay:1.0];
            [NC postNotificationName:NC_LOGOUT_SUCCESS object:nil];
            
            [self popToController];
        }else {
            [FSProgressHUD showHUDWithError:@"Operation failed" delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)popToController {
    [FSLoginManager manager].token = @"";
    [UD setObject:@"" forKey:UD_USER_TOKEN];
    [UD setObject:@"" forKey:UD_USER_PASSWORD];
    [UD synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSettingsCellWithIdentifier"];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1) {
            self.clearDidBlock = ^{
                cell.subtitleLabel.text = @"0.0KB";
            };
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        FSAboutMeViewController *aboutMe = [[FSAboutMeViewController alloc] init];
        [self.navigationController pushViewController:aboutMe animated:YES];
    }else {
        [self clearCaches];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}


- (void)clearCaches {
    [FSProgressHUD showHUDWithIndeterminate:@""];
    
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FSProgressHUD hideHUD];
        [[FSCacheManager shared] clearCache];
        if (weakSelf.clearDidBlock) {
            weakSelf.clearDidBlock();
        }
    });
}

@end
