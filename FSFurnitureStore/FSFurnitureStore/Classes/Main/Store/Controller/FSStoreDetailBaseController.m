//
//  FSStoreDetailViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/30.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreDetailBaseController.h"
#import "FSStoreConcentController.h"
#import "FSStoreProductController.h"
#import "FSStoreContactController.h"

#import "FSStoreInfoHeader.h"

@interface FSStoreDetailBaseController ()

@property (nonatomic, strong) JXCategoryListVCContainerView *listVCContainerView;

@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) FSStoreInfoHeader *headerView;

@property (nonatomic, strong) NSMutableArray *listVCArray;

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, assign) NSInteger categoryIndex;

@property (nonatomic, strong) NSArray *subClassArray;

@property (nonatomic, strong) UIButton *starButton;

@end

@implementation FSStoreDetailBaseController

#pragma mark - Lazy

- (NSArray<NSString *> *)titles {
    
    if (!_titles) {
        
        _titles = @[@"Introduction", @"Product", @"Contact"];
    }
    return _titles;
}

- (NSMutableArray *)listVCArray {
    
    if (!_listVCArray) {
        
        _listVCArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listVCArray;
}

- (FSStoreInfoHeader *)headerView {
    
    if (!_headerView) {
        CGRect rect = CGRectMake(0, kNavHeight, SCREEN_WIDTH, 120);
        _headerView = [[FSStoreInfoHeader alloc] initWithFrame:rect];
        _headerView.model = self.model;
    }
    return _headerView;
}


- (NSArray *)subClassArray {
    
    if (!_subClassArray) {
        
        _subClassArray = @[@"FSStoreConcentController",
                           @"FSStoreProductController",
                           @"FSStoreContactController"];
    }
    return _subClassArray;
}


- (UIButton *)starButton {
    
    if (!_starButton) {
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setImage:[UIImage imageNamed:@"ic_star_normal"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"ic_star_selected"] forState:UIControlStateSelected];
        [_starButton addTarget:self action:@selector(storeToAdd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Detail";
    self.starButton.hidden = self.isCollect ? NO : YES;
    
    [self initSubView];
}

- (void)initSubView {
    
    self.isNeedCategoryListContainerView = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.starButton];
    
    [self.view addSubview:self.headerView];
    [self initCategoryView];
}

- (void)initCategoryView {
    _categoryIndex = 0;
    
    CGFloat categoryH = 50;
    CGFloat categoryY = self.headerView.maxY;
    CGFloat height = SCREEN_HEIGHT - categoryY - categoryH;
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, categoryY, SCREEN_WIDTH, categoryH);
    self.categoryView.delegate = self;
    self.categoryView.titles = self.titles;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorThemeColor];
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    self.lineView = lineView;
    
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomScale = 1.15;
    self.categoryView.titleColor = [UIColor colorWithWhite:0.2 alpha:0.9f];
    self.categoryView.titleSelectedColor = [UIColor colorThemeColor];
    
    //UIView
    UIView *categoryLine = [[UIView alloc] initWithFrame:CGRectMake(0, categoryH-0.5, SCREEN_WIDTH, 0.5)];
    categoryLine.backgroundColor = [UIColor colorBoardLineColor];
    [self.categoryView addSubview:categoryLine];
    
    categoryLine.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    categoryLine.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    categoryLine.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    categoryLine.layer.shadowRadius = 3;//阴影半径，默认3
    
    
    CGFloat subViewY = self.categoryView.maxY;
    
    NSUInteger count = self.subClassArray.count;
    for (int i = 0; i < count; i++) {
        UIViewController *listVC = [[NSClassFromString(self.subClassArray[i]) alloc] init];
        if ([listVC isKindOfClass:[FSStoreConcentController class]]) {
            FSStoreConcentController *vc1 = [[FSStoreConcentController alloc] init];
            vc1.model = self.model;
            vc1.view.frame = CGRectMake(i*SCREEN_WIDTH, subViewY, SCREEN_WIDTH, height);
            [self.listVCArray addObject:vc1];
        }else if ([listVC isKindOfClass:[FSStoreProductController class]]) {
            FSStoreProductController *vc2 = [[FSStoreProductController alloc] init];
            vc2.model = self.model;
            vc2.view.frame = CGRectMake(i*SCREEN_WIDTH, subViewY, SCREEN_WIDTH, height);
            [self.listVCArray addObject:vc2];
        }else {
            FSStoreContactController *vc3 = [[FSStoreContactController alloc] init];
            vc3.model = self.model;
            vc3.view.frame = CGRectMake(i*SCREEN_WIDTH, subViewY, SCREEN_WIDTH, height);
            [self.listVCArray addObject:vc3];
        }
    }
    
    if (self.isNeedCategoryListContainerView) {
        self.listVCContainerView = [[JXCategoryListVCContainerView alloc] initWithFrame:CGRectMake(0, subViewY, SCREEN_WIDTH, height)];
        self.listVCContainerView.defaultSelectedIndex = 0;
        self.categoryView.defaultSelectedIndex = 0;
        self.listVCContainerView.listVCArray = self.listVCArray;
        [self.view addSubview:self.listVCContainerView];
        self.categoryView.contentScrollView = self.listVCContainerView.scrollView;
    }
}


#pragma mark - Request

- (void)storeToAdd {
    if (![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithLongText:@"please login" delay:1.0];
        [self goToLogin];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.model.idField forKey:@"id"];
    [p setObject:@"partner" forKey:@"action"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"add" forKey:@"type"];
    
    [[FSRequestManager manager] POST:kStore_Collect parameters:p success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            self.starButton.selected = YES;
        }
        [FSProgressHUD showHUDWithLongText:responseObj[@"message"] delay:1.0];
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - <JXCategoryViewDelegate>

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (!self.isNeedCategoryListContainerView) {
    }
}

//点击某个index
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (self.isNeedCategoryListContainerView) {
        [self.listVCContainerView didClickSelectedItemAtIndex:index];
    }
}

//滚动到某个index
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    if (self.isNeedCategoryListContainerView) {
        [self.listVCContainerView didScrollSelectedItemAtIndex:index];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    if (self.isNeedCategoryListContainerView) {
        [self.listVCContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio];
    }
}


@end
