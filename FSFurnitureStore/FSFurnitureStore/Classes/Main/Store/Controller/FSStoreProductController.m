//
//  FSStoreProductController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreProductController.h"
#import "FSClassifyProductCell.h"

#import "FSProductDetailViewController.h"

#import "FSAppDelegate.h"

static NSString *const kStoreProductCellIdentifier = @"kStoreProductCellIdentifier";

@interface FSStoreProductController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSStoreProductController

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
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initTableView];
    [self initRefreshing];
}

- (void)initTableView {
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight - 170);
    self.tableView.frame = rect;
    [self.tableView registerNib:[UINib nibWithNibName:@"FSClassifyProductCell" bundle:nil] forCellReuseIdentifier:kStoreProductCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initRefreshing {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestProduct];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Request

- (void)requestProduct {
    
    NSDictionary *parameters = @{@"appkey": @"3406",
                                 @"pid": self.model.idField};
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kClassify_Product parameters:parameters success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            NSArray *JSONArray = [responseObj[@"product"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSClassifyRoot mj_objectArrayWithKeyValuesArray:JSONArray]];
        }else {
            [FSProgressHUD showHUDWithError:responseObj[@"message"] delay:1.0];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSClassifyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreProductCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSProductDetailViewController *detailVC = [FSProductDetailViewController new];
        detailVC.model = self.dataSource[indexPath.row];
        detailVC.isCollect = YES;
        [kAppDelegate.currentNav pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor colorLightTextColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

@end
