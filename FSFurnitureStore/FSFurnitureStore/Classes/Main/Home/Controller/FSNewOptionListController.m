//
//  FSNewOptionListController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSNewOptionListController.h"
#import "FSNewOptionBaseController.h"

@interface FSNewOptionListController ()

@end

@implementation FSNewOptionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"More";
    
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
    
    return self.subClass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SubClassCellWithIdentifier = @"SubClassCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubClassCellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SubClassCellWithIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.subClass.count > indexPath.row) {
        FSHomeSubClass *sub = self.subClass[indexPath.row];
        cell.textLabel.text = sub.title;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.subClass.count > indexPath.row) {
        FSNewOptionBaseController *optionVC = [[FSNewOptionBaseController alloc] init];
        optionVC.subClass = self.subClass[indexPath.row];
        [self.navigationController pushViewController:optionVC animated:YES];
    }
}

@end
