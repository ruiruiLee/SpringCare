//
//  WebContentVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WebContentVC.h"

@interface WebContentVC ()

@end

@implementation WebContentVC

- (id) initWithTitle:(NSString*)title url:(NSString*)url
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        titleString = title;
        urlPath = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = titleString;
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:_webview];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webview)]];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(urlPath != nil){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        [_webview loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.NavigationBar addSubview:_progressView];
    [self.NavigationBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    [self.NavigationBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_progressView(2)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadInfoFromUrl:(NSString*) url
{
    urlPath = url;
    if(urlPath != nil){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        [_webview loadRequest:request];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
