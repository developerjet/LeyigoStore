//
//  FSStoreContactController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreContactController.h"
#import "FSStoreContactCell.h"

static NSString *const kStoreContactCellIdentifier = @"kStoreContactCellIdentifier";

@interface FSStoreContactController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSStoreContactController

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initDataSource];
    [self initTableView];
}

- (void)initTableView {

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight - 170);
    [self.tableView registerNib:[UINib nibWithNibName:@"FSStoreContactCell" bundle:nil] forCellReuseIdentifier:kStoreContactCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    if (self.model.name.length) {
        [self.dataSource addObject:[FSBaseModel initImage:@"ic_company" title:self.model.name]];
    }else if (self.model.operate.length) {
        [self.dataSource addObject:[FSBaseModel initImage:@"ic_contact" title:self.model.operate]];
    }else if (self.model.tel.length) {
        [self.dataSource addObject:[FSBaseModel initImage:@"ic_phone" title:self.model.tel]];
    }else if (self.model.address.length) {
        [self.dataSource addObject:[FSBaseModel initImage:@"ic_address" title:self.model.address]];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSStoreContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreContactCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        if (indexPath.row == 2) {
            if (self.model.tel.length) {            
                NSMutableString * URLString = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.model.tel];
                UIWebView * callWebView = [[UIWebView alloc] init];
                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
                [self.view addSubview:callWebView];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


@end
