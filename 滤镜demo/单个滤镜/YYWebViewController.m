//
//  YYWebViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYWebViewController.h"
@import WebKit;

@interface YYWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation YYWebViewController {
    WKWebView *_webView;
    UIActivityIndicatorView *_indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    [self.view addSubview:_webView];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.color = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
    _indicator.hidesWhenStopped = YES;
    [self.view addSubview:_indicator];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _webView.frame = self.view.bounds;
    _indicator.center = self.view.center;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [_indicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_indicator stopAnimating];
}

@end
