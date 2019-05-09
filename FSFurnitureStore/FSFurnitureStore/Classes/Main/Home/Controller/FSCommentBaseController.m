//
//  FSCommentBaseController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSCommentBaseController.h"
#import "FSCommentTableViewCell.h"

#import "FSConfigInputView.h"

@interface FSCommentBaseController ()<FSConfigInputDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSCommentBaseController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Comment";
    
    [self initSubview];
    [self configRefresh];
}

- (void)initSubview {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight - kInputHeight;
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"kCommentCellIdentifier"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    FSConfigInputView *inputView = [[FSConfigInputView alloc] init];
    inputView.delegate = self;
    [inputView showInputAddedTo:self.view];
}

- (void)configRefresh {
    
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
    if (!self.curClass) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.curClass.idField forKey:@"id"];
    [params setObject:@"3406" forKey:@"appkey"];
    [params setObject:@"0" forKey:@"page"];
    
    [[FSRequestManager manager] POST:kHome_Comment_List parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray *JSONArray = [responseObj[@"array"] mj_JSONObject];
        [self.dataSource addObjectsFromArray:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:JSONArray]];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)beginComment:(NSString *)content {
    if (![FSLoginManager manager].token) {
        [FSProgressHUD showHUDWithError:@"Please log in first" delay:1.0];
        return;
    }
    
    if (!self.curClass.idField.length) {
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:content forKey:@"pinglun"];
    [p setObject:self.curClass.idField forKey:@"id"];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    [[FSRequestManager manager] POST:kHome_Comment parameters:p success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        FSHttpResult *result = [FSHttpResult mj_objectWithKeyValues:responseObj];
        
        if (result.returns == 1) {
            [self.tableView.mj_header beginRefreshing];
        }
        [FSProgressHUD showHUDWithText:result.message delay:1.0];
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCommentCellIdentifier"];
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
