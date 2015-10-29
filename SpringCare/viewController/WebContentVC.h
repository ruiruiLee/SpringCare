//
//  WebContentVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"


#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface WebContentVC : LCBaseVC<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    UIWebView *_webview;
    
    NSString *urlPath;
    NSString *titleString;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

- (id) initWithTitle:(NSString*)title url:(NSString*)url;

- (void) loadInfoFromUrl:(NSString*) url;

@end
