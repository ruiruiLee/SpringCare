//
//  CMBWebViewController.h
//  SpringCare
//
//  Created by LiuZach on 16/9/29.
//  Copyright © 2016年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface CMBWebViewController : LCBaseVC<UIGestureRecognizerDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong) NSString *MerchantRetUrl;

- (void)loadUrl:(NSString*)outerURL;
- (void)loadURLRequest:(NSURLRequest*)requesturl;

@end
