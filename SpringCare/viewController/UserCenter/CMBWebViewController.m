//
//  CMBWebViewController.m
//  SpringCare
//
//  Created by LiuZach on 16/9/29.
//  Copyright © 2016年 cmkj. All rights reserved.
//

#import "CMBWebViewController.h"
#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>

@interface CMBWebViewController ()<UIWebViewDelegate>
{
    NSURLRequest *_requestUrl;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CMBWebViewController
@synthesize webView;

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (BOOL)needBackItem
{
    return YES;
}

- (void)loadUrl:(NSString*)outerURL
{
    NSURL *url = [NSURL URLWithString: outerURL];
    // NSURL *url = [NSURL URLWithString: @"http://99.12.73.80:802/MobileHtml/debitcard/m_netpay/test/sign.aspx"];
    _requestUrl = [NSURLRequest requestWithURL:url];
}

- (void)loadURLRequest:(NSURLRequest*)requesturl
{
    _requestUrl = requesturl;

}

- (void)reloadWebView
{
    
    [webView loadRequest: _requestUrl];
    
}
- (void)viewDidLoad
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [super viewDidLoad];
    
    self.NavigationBar.Title = @"付款";
    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    
    webView = [[UIWebView alloc] init];
//    webView.frame = self.view.frame;
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:webView];
    webView.delegate = self; // self.wvDelegateColletion;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(webView);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-|" options:0 metrics:nil views:views]];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
//    [self reloadWebView];
    
    [self.NavigationBar addSubview:_progressView];
    [self.NavigationBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    [self.NavigationBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_progressView(2)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    //    [self pb_setDesiredNavigaionBarType:self]
    
    [_progressView removeFromSuperview];
    _progressView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

static BOOL FROM = FALSE;
- (BOOL)webView:(UIWebView *)_webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {
        CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
        [secKeyboard showKeyboardWithRequest:request];
        secKeyboard.webView = _webView;
        
        UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:myTap]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
        myTap.delegate = self;
        myTap.cancelsTouchesInView = NO;
        return NO;
    }
    
    NSString *uri = request.URL.absoluteString;
    if(self.MerchantRetUrl != nil && [uri rangeOfString:self.MerchantRetUrl].length > 0 && [uri rangeOfString:self.MerchantRetUrl].location == 0){
        [self NavLeftButtonClickEvent:nil];
        return YES;
    }
    
    //
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Load webView error:%@", [error localizedDescription]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (FROM) {
        
        return;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
    //_secKeyboard.webView = _webView;
}





#pragma mark - dealloc
- (void)dealloc
{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
}

@end
