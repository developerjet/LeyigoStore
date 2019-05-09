//
//  FSOptionDetailViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSOptionDetailViewController.h"

#import "FSCommentBaseController.h"

@interface FSOptionDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) FSNewOptionClass *curClass;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceTopHeight;

@end

@implementation FSOptionDetailViewController

- (FSNewOptionClass *)curClass {
    
    if (!_curClass) {
        
        _curClass = [[FSNewOptionClass alloc] init];
    }
    return _curClass;
}

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _spaceTopHeight.constant = iPhoneX ? 88 : 64;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = self.model.name;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self beginRequest];
}

- (void)beginRequest {
    NSMutableDictionary *prt = [NSMutableDictionary dictionary];
    [prt setObject:@"3406" forKey:@"appkey"];
    [prt setObject:self.model.idField forKey:@"id"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    [[FSRequestManager manager] POST:kHome_Option_List parameters:prt success:^(id  _Nullable responseObj) {
        [FSProgressHUD hideHUD];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSDictionary *values = [responseObj mj_JSONObject];
        self.curClass = [FSNewOptionClass mj_objectWithKeyValues:values];

        [self loadHTMLString];
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)loadHTMLString {
    self.titleLabel.text = self.curClass.name;
    self.dateLabel.text = self.curClass.time;
    
    [self.webView loadHTMLString:self.curClass.content baseURL:nil];
    [self.webView request];
}

#pragma mark - DidEvent

- (IBAction)commentDidEvent:(id)sender
{
    FSCommentBaseController *commentVC = [[FSCommentBaseController alloc] init];
    commentVC.curClass = self.curClass;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [FSProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [FSProgressHUD hideHUD];
}

@end
