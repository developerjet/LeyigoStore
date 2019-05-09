//
//  FSProductCommentController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/6.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSProductCommentController.h"
#import "FSCommentTableViewCell.h"
#import "FSConfigInputView.h"

static NSString *const kProductCommentCellIdentifier = @"kProductCommentCellIdentifier";

@interface FSProductCommentController ()<FSConfigInputDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSProductCommentController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Product Comment";
    
    [self initSubview];
    [self initRefresh];
}

- (void)initSubview {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight - kInputHeight;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kProductCommentCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    FSConfigInputView *inputView = [[FSConfigInputView alloc] init];
    inputView.delegate = self;
    [inputView showInputAddedTo:self.view];
}

- (void)initRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestComment];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - FSConfigInputDelegate

- (void)input:(FSConfigInputView *)input textFieldDidEndEditing:(NSString *)text {
    
    if (text && text.length > 0) {
        
        [self beginComment:text];
    }
}

#pragma mark - Request

- (void)requestComment {
    if (!self.model.idField.length) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.model.idField forKey:@"id"];
    [params setObject:@"3406" forKey:@"appkey"];
    [params setObject:@"0" forKey:@"page"];
    
    [[FSRequestManager manager] POST:kProduct_Comment_List parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        FSHttpResult *result = [FSHttpResult mj_objectWithKeyValues:responseObj];
        if (result.returns == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            NSArray *JSONArray = [responseObj[@"array"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:JSONArray]];
        }else {
            [FSProgressHUD showHUDWithError:result.message delay:1.0];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)beginComment:(NSString *)pinglun {
    if (![FSLoginManager manager].token) {
        [FSProgressHUD showHUDWithError:@"Please log in first" delay:1.0];
        return;
    }
    
    if (!self.model.idField.length) {
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.model.idField forKey:@"id"];
    [p setObject:pinglun forKey:@"pinglun"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"9" forKey:@"num"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    [[FSRequestManager manager] POST:kProduct_Comment parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        FSHttpResult *result = [FSHttpResult mj_objectWithKeyValues:responseObj];
        if (result.returns == 1) {
            [FSProgressHUD showHUDWithSuccess:@"Success" delay:1.0];
            [self.tableView.mj_header beginRefreshing];
        }else {
            [FSProgressHUD showHUDWithError:result.message delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCommentCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
