//
//  FSClassifyViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSClassifyViewController.h"
#import "FSClassifyColectCell.h"
#import "FSClassifySearchBar.h"
#import "FSClassifyRoot.h"

#import "FSProductSearchController.h"
#import "FSClassProductListController.h"
#import "FSClassProductResultController.h"

#define SPACE  10

static NSString *const kClassifyCellIdentifier = @"kClassifyCellIdentifier";

@interface FSClassifyViewController()<FSCustomSearchviewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSClassifyViewController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Classify";
    
    [self initClassifyView];
    [self initClassRefresh];
}

- (void)initClassifyView
{
    CGRect frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, 60);
    FSClassifySearchBar *searchView = [FSClassifySearchBar createSearchViewWithFrame:frame delegate:self];
    searchView.placeholder = @"Please fill in the search";
    [self.view addSubview:searchView];
    
    CGFloat y = searchView.maxY;
    CGFloat h = SCREEN_HEIGHT - y - kTabBarHeight;
    self.collectView.frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    [self.collectView registerNib:[UINib nibWithNibName:@"FSClassifyColectCell" bundle:nil] forCellWithReuseIdentifier:kClassifyCellIdentifier];
    [self.view addSubview:self.collectView];
}

- (void)initClassRefresh {
    
    WeakSelf;
    self.collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestClassify];
    }];
    [self.collectView.mj_header beginRefreshing];
}

#pragma mark - Request

- (void)requestClassify {
    
    NSString *startURL = [NSString stringWithFormat:@"%@appkey=3406", kClassify_List];
    [[FSRequestManager manager] startGET:startURL parameters:nil progress:nil success:^(id  _Nonnull response) {
        [self endRefreshing];
        if (response) {
            NSArray *JSONObject = [response mj_JSONObject];
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:[FSClassifyRoot mj_objectArrayWithKeyValuesArray:JSONObject]];
            [self.collectView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <FSCustomSearchviewDelegate>

- (void)search:(FSClassifySearchBar *)search textFieldDidEndEditing:(NSString *)text {
    
    FSProductSearchController *searchVC = [[FSProductSearchController alloc] init];
    searchVC.keyword = text;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSClassifyColectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClassifyCellIdentifier forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        FSClassifyRoot *model = self.dataSource[indexPath.row];
        if (model.subclass.count) {
            FSClassProductListController *listVC = [[FSClassProductListController alloc] init];
            listVC.subclass = [FSClassifyRoot mj_objectArrayWithKeyValuesArray:model.subclass];
            listVC.title = model.name;
            [self.navigationController pushViewController:listVC animated:YES];
        }else {
            FSClassProductResultController *productVC = [[FSClassProductResultController alloc] init];
            productVC.model = model;
            [self.navigationController pushViewController:productVC animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = (SCREEN_WIDTH- 4*SPACE) / 3;
    return CGSizeMake(itemWidth-5, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(SPACE, SPACE, SPACE, SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return SPACE;
}

@end
