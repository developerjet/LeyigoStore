//
//  FSHomeViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSHomeViewController.h"

#import "FSHomeBannerHeader.h"
#import "FSSectionHeaderView.h"

#import "FSPartnerTableViewCell.h"
#import "FSCenterAdTableViewCell.h"
#import "FSOptionTableViewCell.h"
#import "FSProductTableViewCell.h"

#import "FSHomeSubClass.h"
#import "FSHomeJsonClass.h"

#import "FSNewOptionBaseController.h"
#import "FSNewOptionListController.h"

#import "FSStoreDetailBaseController.h"
#import "FSProductDetailViewController.h"

static NSString *const kPartnerCellIdentifier = @"kPartnerCellIdentifier";
static NSString *const kCenterAdCellIdentifier = @"kCenterAdCellIdentifier";
static NSString *const kOptionCellIdentifier = @"kOptionCellIdentifier";
static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";

static NSString *const kTitleHeaderReuseIdentifier = @"kTitleHeaderReuseIdentifier";

@interface FSHomeViewController ()
<FSHomeBannerHeaderDelegate,
FSPartnerCellDelegate,
FSOptionCellDelegate,
FSProductCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) FSHomeBannerHeader *headerView;

@property (nonatomic, strong) NSMutableArray <FSHomeSubClass *>*itemSource;

@property (nonatomic, strong) NSMutableArray <FSHomeSubClass *>*bannerSource;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation FSHomeViewController

- (NSArray *)titles {
    
    if (!_titles) {
        
        _titles = @[@"Merchant", @"", @"Categories", @"", @"Product"];
    }
    return _titles;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<FSHomeSubClass *> *)bannerSource {
    
    if (!_bannerSource) {
        
        _bannerSource = [NSMutableArray array];
    }
    return _bannerSource;
}

- (NSMutableArray <FSHomeSubClass *>*)itemSource {
    
    if (!_itemSource) {
        
        _itemSource = [NSMutableArray array];
    }
    return _itemSource;
}

- (FSHomeBannerHeader *)headerView {
    
    if (!_headerView) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.75);
        _headerView = [[FSHomeBannerHeader alloc] initWithFrame:rect];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Home";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initTableView];
    [self initRefreshing];
}

- (void)initTableView
{
    CGFloat h = SCREEN_HEIGHT - kNavHeight - kTabBarHeight;
    
    self.groupedTable.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, h);
    self.groupedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.groupedTable registerClass:[FSPartnerTableViewCell class] forCellReuseIdentifier:kPartnerCellIdentifier];
    [self.groupedTable registerNib:[UINib nibWithNibName:@"FSCenterAdTableViewCell" bundle:nil] forCellReuseIdentifier:kCenterAdCellIdentifier];
    [self.groupedTable registerClass:[FSOptionTableViewCell class] forCellReuseIdentifier:kOptionCellIdentifier];
    [self.groupedTable registerClass:[FSProductTableViewCell class] forCellReuseIdentifier:kProductCellIdentifier];
    [self.groupedTable registerClass:[FSSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kTitleHeaderReuseIdentifier];
    self.groupedTable.backgroundColor = [UIColor clearColor];
    self.groupedTable.tableHeaderView = self.headerView;
    [self.view addSubview:self.groupedTable];
}

- (void)initRefreshing {
    
    WeakSelf;
    self.groupedTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHomeData];
    }];
    [self.groupedTable.mj_header beginRefreshing];
}

#pragma mark - Request

- (void)requestHomeData {
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@appkey=3406", kHome_List];
    [[FSRequestManager manager] POST:requestURL parameters:nil success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            self.headerView.hidden = YES;
            return;
        }
        [self clearSource];
        
        self.headerView.hidden = NO;
        NSArray *JSONObject = [FSHomeJsonClass mj_objectArrayWithKeyValuesArray:responseObj[@"json"]];
        
        [JSONObject enumerateObjectsUsingBlock:^(FSHomeJsonClass *object, NSUInteger idx, BOOL * _Nonnull stop) {
            if (object.subClass) {
                if ([object.type isEqualToString:@"partner"]) {
                    [self.dataSource insertObject:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass] atIndex:0];
                }
                if ([object.type isEqualToString:@"scroll_center"]) {
                    [self.dataSource insertObject:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass] atIndex:1];
                }
                if ([object.type isEqualToString:@"option"]) {
                    [self.dataSource insertObject:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass] atIndex:2];
                }
                if ([object.type isEqualToString:@"scroll_bottom"]) {
                    [self.dataSource insertObject:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass] atIndex:3];
                }
                if ([object.type isEqualToString:@"product"]) {
                    [self.dataSource insertObject:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass] atIndex:4];
                }
                
                if ([object.type isEqualToString:@"scroll_ad"]) {
                    [self.bannerSource addObjectsFromArray:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass]];
                    self.headerView.images = self.bannerSource;
                }
                if ([object.type isEqualToString:@"new_option"]) {
                    [self.itemSource addObjectsFromArray:[FSHomeSubClass mj_objectArrayWithKeyValuesArray:object.subClass]];
                    self.headerView.items = self.itemSource;
                }
            }
        }];
        
        if (self.dataSource.count) {
            [self.groupedTable reloadData];
        }
                                 
    } failure:^(NSError * _Nonnull error) {
        self.headerView.hidden = YES;
        [self endRefreshing];
    }];
}

- (void)clearSource {
    
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    
    if (self.bannerSource.count) {
        [self.bannerSource removeAllObjects];
    }
    
    if (self.itemSource.count) {
        [self.itemSource removeAllObjects];
    }
    
}


#pragma mark - <FSPartnerCellDelegate>

- (void)cell:(FSPartnerTableViewCell *)cell DidSelectAtModel:(FSHomeSubClass *)model {
    
    if (model) {
        FSStoreDetailBaseController *storeVC = [[FSStoreDetailBaseController alloc] init];
        FSStorePartner *partner = [FSStorePartner new];
        partner.idField = model.idField;
        partner.name = model.name;
        partner.logo = model.bz_1;
        storeVC.model = partner;
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}

#pragma mark - <FSOptionTableViewCell>

- (void)option:(FSOptionTableViewCell *)cell didSelectAtModel:(FSHomeSubClass *)model {
    
    FSProductDetailViewController *productVC = [[FSProductDetailViewController alloc] init];
    FSClassifyRoot *root = [FSClassifyRoot new];
    root.idField = model.idField;
    root.price = @"￥0.00";
    root.name = model.name;
    root.img = model.img;
    productVC.model = root;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - <FSProductCellDelegate>

- (void)product:(FSProductTableViewCell *)cell didSelectAtModel:(FSHomeSubClass *)model {
    
    FSProductDetailViewController *productVC = [[FSProductDetailViewController alloc] init];
    FSClassifyRoot *root = [FSClassifyRoot new];
    root.price = @"￥0.00";
    root.idField = model.idField;
    root.name = model.name;
    root.img = model.img;
    productVC.model = root;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - <FSHomeBannerHeaderDelegate>

- (void)header:(FSHomeBannerHeader *)header DidSelectAtSubClass:(FSHomeSubClass *)subClass {
    
    if ([subClass.title isEqualToString:@"更多"]) {
        FSNewOptionListController *listVC = [[FSNewOptionListController alloc] init];
        listVC.subClass = self.itemSource;
        [self.navigationController pushViewController:listVC animated:YES];
    }else {
        FSNewOptionBaseController *optionVC = [[FSNewOptionBaseController alloc] init];
        optionVC.subClass = subClass;
        [self.navigationController pushViewController:optionVC animated:YES];
    }
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            FSPartnerTableViewCell *partnerCell = [tableView dequeueReusableCellWithIdentifier:kPartnerCellIdentifier];
            partnerCell.subClass = self.dataSource[indexPath.section];
            partnerCell.delegate = self;
            return partnerCell;
        }
            break;
        case 1:
        {
            FSCenterAdTableViewCell *centerAdCell = [tableView dequeueReusableCellWithIdentifier:kCenterAdCellIdentifier];
            centerAdCell.model = self.dataSource[indexPath.section][0];
            return centerAdCell;
        }
            break;
        case 2:
        {
            FSOptionTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:kOptionCellIdentifier];
            optionCell.subClass = self.dataSource[indexPath.section];
            optionCell.delegate = self;
            return optionCell;
        }
            break;
        case 3:
        {
            FSCenterAdTableViewCell *centerAdCell = [tableView dequeueReusableCellWithIdentifier:kCenterAdCellIdentifier];
            centerAdCell.model = self.dataSource[indexPath.section][0];
            return centerAdCell;
        }
            break;
        case 4:
        {
            FSProductTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier];
            productCell.subClass = self.dataSource[indexPath.section];
            productCell.delegate = self;
            return productCell;
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.dataSource.count > section) {
        FSSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTitleHeaderReuseIdentifier];
        header.title = self.titles[section];
        return header;
    }else {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 200;
    }else if (indexPath.section == 1 || indexPath.section == 3) {
        return 100;
    }else if (indexPath.section == 4) {
        return 320;
    }else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 2 || section == 4) {
        return 40;
    }else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

@end
