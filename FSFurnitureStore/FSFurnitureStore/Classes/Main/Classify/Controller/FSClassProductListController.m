//
//  FSClassProductListController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSClassProductListController.h"
#import "FSClassifyRoot.h"

#import "FSClassProductResultController.h"

@interface FSClassProductListController ()


@end

@implementation FSClassProductListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}

- (void)initTableView {
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight;
    
    self.tableView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.subclass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ProductClassCellWithIdentifier = @"ProductClassCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductClassCellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProductClassCellWithIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.subclass.count > indexPath.row) {
        FSClassifyRoot *root = self.subclass[indexPath.row];
        cell.textLabel.text = root.name;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.subclass.count > indexPath.row) {
        FSClassProductResultController *productVC = [FSClassProductResultController new];
        FSClassifyRoot *model = self.subclass[indexPath.row];
        productVC.model = model;
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

@end
