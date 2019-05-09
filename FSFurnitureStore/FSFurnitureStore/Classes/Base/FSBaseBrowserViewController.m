//
//  FSBaseBrowserViewController.m
//  FSFurnitureStore
//
//  Created by YxTAN on 2018/10/17.
//  Copyright © 2018 TAN. All rights reserved.
//

#import "FSBaseBrowserViewController.h"
#import <WebKit/WebKit.h>

@interface FSBaseBrowserViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *emptyDataView;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation FSBaseBrowserViewController

- (UIButton *)emptyDataView {
    
    if (!_emptyDataView) {
        _emptyDataView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyDataView setTitleColor:[UIColor colorLightTextColor] forState:UIControlStateNormal];
        _emptyDataView.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
        [_emptyDataView setTitle:@"No product introduction" forState:UIControlStateNormal];
        _emptyDataView.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_emptyDataView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _emptyDataView.frame = self.view.bounds;
    }
    return _emptyDataView;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        CGFloat h = 3;
        CGFloat y = 0;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _progressView.alpha = 0.0;
        _progressView.progress = 0.0;
        _progressView.progressTintColor = [UIColor redColor];
        _progressView.backgroundColor = [UIColor colorWhiteColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor colorWhiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self initSubview];
    [self loadRequest:self.URLString];
}

- (void)initSubview {
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)loadRequest:(NSString *)URLString {
    if (!self.URLString.length) {
        [FSProgressHUD hideHUD];
        [self.view addSubview:self.emptyDataView];
        return;
    }
    
    if ([URLString containsString:@"http"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        [self.webView loadRequest:request];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }else {
        [self.webView loadHTMLString:URLString baseURL:nil];
    }
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.webView) {
        self.progressView.alpha = 1.0;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        // 隐藏进度条
        if (self.webView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.3
                                  delay:0.5
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.progressView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0 animated:YES];
                             }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [FSProgressHUD hideHUD];
    
    NSString *style = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%d%%'", 300]; //修改百分比即可
    [webView evaluateJavaScript:style completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [FSProgressHUD hideHUD];
}

#pragma mark - dealloc

- (void)dealloc {
    
    [NC removeObserver:self];
}

@end

