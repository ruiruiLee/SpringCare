//
//  QuickmarkVC.m
//  SpringCare
//
//  Created by LiuZach on 15/5/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "QuickmarkVC.h"
#import "PopView.h"
#import <ShareSDK/ShareSDK.h>

@interface QuickmarkVC () <PopViewDelegate>
{
    PopView *popview;
}

@end

@implementation QuickmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"扫描下载";
    [self.NavigationBar.btnRight setTitle:@"分享" forState:UIControlStateNormal];
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.layer.cornerRadius = 8;
    self.NavigationBar.btnRight.backgroundColor = [UIColor whiteColor];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(16);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = ThemeImage(@"Quickmark");
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-80]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    if(!popview){
        popview = [[PopView alloc] initWithImageArray:@[@"wechatshare", @"momentshare", @"messageshare"] nameArray:@[@"微信好友", @"朋友圈", @"手机短信"]];
        [self.view.window addSubview:popview];
        popview.delegate = self;
    }
    
    [popview show];
}

- (void) HandleItemSelect:(PopView *)view withTag:(NSInteger)tag
{
    switch (tag) {
        case 1:{
            [self shareWithType:SSDKPlatformSubTypeWechatTimeline];
        }
            break;
            
        case 0:{
            [self shareWithType:SSDKPlatformSubTypeWechatSession];
        }
            break;
            
        case 2:{
            [self shareWithType:SSDKPlatformTypeSMS];
        }
            break;
        default:
            break;
    }
}

- (void) shareWithType:(SSDKPlatformType) type
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:@[[UIImage imageNamed:@"icontitle"]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

@end
