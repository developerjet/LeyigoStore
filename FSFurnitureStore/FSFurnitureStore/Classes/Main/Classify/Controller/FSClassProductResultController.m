//
//  FSClassSearchResultController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSClassProductResultController.h"
#import "FSClassifyProductCell.h"

#import "FSProductDetailViewController.h"

static NSString *const kProductCellReuseIdentifier = @"kProductCellReuseIdentifier";

@interface FSClassProductResultController ()<UISearchBarDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger sortIndex;

@end

@implementation FSClassProductResultController

#pragma mark - Lazy

- (NSArray<NSString *> *)titles {
    
    if (!_titles) {
        
        _titles = @[@"New", @"Sales", @"Popularity", @"Price"];
    }
    return _titles;
}

- (JXCategoryTitleView *)categoryView {
    
    if (!_categoryView) {
        CGFloat h = 40;
        CGFloat y = kNavHeight;
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _categoryView.delegate = self;
        _categoryView.titles = self.titles;
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleColor = [UIColor colorLightTextColor];
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

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sortIndex = 0;
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self configSubView];
    [self initRefreshing];
}

- (void)configSubView {
    
    [self.view addSubview:self.categoryView];
    
    CGFloat y = self.categoryView.maxY;
    CGFloat h = SCREEN_HEIGHT - y;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSClassifyProductCell" bundle:nil] forCellReuseIdentifier:kProductCellReuseIdentifier];
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
                                 @"tid": self.model.idField,
                                 @"sort": @(self.sortIndex),
                                 @"page": @"0"};
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kClassify_Product parameters:parameters success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray *JSONArray = [responseObj[@"product"] mj_JSONObject];
        
        [self.dataSource addObjectsFromArray:[FSClassifyRoot mj_objectArrayWithKeyValuesArray:JSONArray]];
        [self.tableView reloadData];
    
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <JXCategoryViewDelegate>

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.sortIndex = index; //及时改变索引值
    
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
    
    FSClassifyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCellReuseIdentifier];
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
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}


@end
