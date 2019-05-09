//
//  FSStoreConcentController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreConcentController.h"

@interface FSStoreConcentController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIScrollView *subScollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIWebView *webView;

@end


@implementation FSStoreConcentController

#pragma mark - Lazy

- (UIScrollView *)subScollView {
    
    if (!_subScollView) {
        _subScollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _subScollView.contentSize = CGSizeMake(self.view.width, self.view.height * 2);
        _subScollView.backgroundColor = [UIColor colorWhiteColor];
        _subScollView.scrollEnabled = YES;
        _subScollView.delegate = self;
    }
    return _subScollView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        CGRect rect = CGRectMake(10, 15, SCREEN_WIDTH - 20, 140);
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.image = [UIImage imageNamed:@"icon_loading_image"];
    }
    return _imageView;
}

- (UIWebView *)webView {
    
    if (!_webView) {
        CGFloat x = 10;
        CGFloat w = self.view.width - x * 2;
        CGFloat y = self.imageView.maxY + 15;
        CGFloat h = self.view.height - y;
        CGRect rect = CGRectMake(x, y, w, h);
        _webView = [[UIWebView alloc] initWithFrame:rect];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWhiteColor];
    
    [self initSubView];
    [self requestConcent];
}

- (void)initSubView {
    
    [self.subScollView addSubview:self.imageView];
    [self.subScollView addSubview:self.webView];
    [self.view addSubview:self.subScollView];
}


#pragma mark - Request

- (void)requestConcent {
    if (!self.model) {
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.model.idField forKey:@"id"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    [[FSRequestManager manager] POST:kStore_Detail parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            FSStorePartner *partner = [FSStorePartner mj_objectWithKeyValues:responseObj];
            [self loadHTMLString:partner];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)loadHTMLString:(FSStorePartner *)partner {
    if (!partner || !partner.concent) {
        return;
    }
    
    NSDictionary *images = [[partner.img firstObject] mj_JSONObject];
    [self.webView loadHTMLString:partner.concent baseURL:nil];
    [self.imageView setImage:images[@"img"] placeholder:@"icon_loading_image"];
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *style = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%d%%'", 300]; //修改百分比即可
    [webView stringByEvaluatingJavaScriptFromString:style];
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
    //(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
