//
//  FSOrderListViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/2.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSOrderListViewController.h"
#import "FSOrderContentInfoCell.h"

static NSString *const kOrderContentCellIdentifier = @"kOrderContentCellIdentifier";

@interface FSOrderListViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, strong) NSMutableArray *selectSource;

@property (nonatomic, strong) NSArray <NSString *>*statusArray;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, assign) NSUInteger statusIndex;

@end

@implementation FSOrderListViewController

#pragma mark - Lazy

- (NSArray<NSString *> *)titles {
    
    if (!_titles) {
        
        _titles = @[@"全部", @"未付款", @"待发货", @"交易完成", @"待收货"];
    }
    return _titles;
}

- (NSArray<NSString *> *)statusArray {
    
    if (!_statusArray) {
        
        _statusArray = @[@"", @"0", @"1", @"2", @"4"];
    }
    return _statusArray;
}

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

- (JXCategoryTitleView *)categoryView {
    
    if (!_categoryView) {
        CGFloat h = 40;
        CGFloat y = kNavHeight;
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _categoryView.delegate = self;
        _categoryView.titles = self.titles;
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleColor = [UIColor colorDarkTextColor];
        _categoryView.titleSelectedColor = [UIColor colorThemeColor];
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:17];
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, _categoryView.height-0.5, SCREEN_WIDTH, 0.5)];
        // lineView
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        lineView.indicatorLineViewColor = [UIColor colorThemeColor];
        _categoryView.indicators = @[lineView];
        _categoryView.titleColorGradientEnabled = YES;
        separatorLine.backgroundColor = [UIColor colorBoardLineColor];
        [_categoryView addSubview:separatorLine];
    }
    return _categoryView;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Order";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Delete" image:nil target:self action:@selector(deleteOrder)];
    
    [self initSubview];
    [self initRefresh];
}

- (void)initSubview {
    self.statusIndex = 0;
    
    [self.view addSubview:self.categoryView];
    
    CGFloat y = self.categoryView.maxY;
    CGFloat h = SCREEN_HEIGHT - y;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FSOrderContentInfoCell" bundle:nil] forCellReuseIdentifier:kOrderContentCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)initRefresh {
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestOrders];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Request

- (void)requestOrders {
    // status=0 未付款，status=1 待发货，status=2 交易完成，status=4 待收货，
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.statusArray[self.statusIndex] forKey:@"status"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kOrder_List parameters:p success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            NSArray *JSONArray = [responseObj[@"order"] mj_JSONObject];
            [self.dataSource addObjectsFromArray:[FSOrderInfoList mj_objectArrayWithKeyValuesArray:JSONArray]];
            [self.tableView reloadData];
        }else {
            [FSProgressHUD showHUDWithError:responseObj[@"message"] delay:1.0];
        }

    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)deleteOrder {
    if (!self.selectSource.count) {
        [FSProgressHUD showHUDWithError:@"Please select an order" delay:1.0];
        return;
    }
    
    NSString *ids = [self.selectSource componentsJoinedByString:@","];
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:ids forKey:@"id"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kOrser_Delete parameters:p success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            [self.tableView.mj_header beginRefreshing];
        }else {
            [FSProgressHUD showHUDWithError:responseObj[@"message"] delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - <JXCategoryViewDelegate>

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.statusIndex = index; //及时改变索引值
    
    [self.tableView setContentOffset:CGPointMake(0,0)  animated:NO];
    [self.tableView.mj_header beginRefreshing];
}

- (NSUInteger)preferredListViewCount {
    
    return self.titles.count;
}

- (Class)preferredCategoryViewClass {
    
    return [JXCategoryTitleView class];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSOrderContentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderContentCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSOrderInfoList *model = self.dataSource[indexPath.row];
        model.isSelect = !model.isSelect;
        if (model.isSelect) {
            [self.selectSource addObject:model.idField];
        }else {
            [self.selectSource removeObject:model.idField];
        }
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 190;
}


@end
