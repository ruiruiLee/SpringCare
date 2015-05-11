//
//  MainBaseVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/2.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MainBaseVC.h"
#import "SliderViewController.h"
#import "LoginVC.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>


@implementation MainBaseVC
@synthesize controlLeft;
@synthesize controlRight;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _NavigationBar = [[LCNavigationbar alloc] initWithFrame:CGRectZero];
    _NavigationBar.delegate = self;
    _NavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    _NavigationBar.btnLeft.hidden = YES;
    _NavigationBar.btnRight.hidden = YES;
    _NavigationBar.lbTitle.hidden = YES;
    
    _ContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_ContentView];
    _ContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_NavigationBar];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_ContentView, _NavigationBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_NavigationBar]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_ContentView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_ContentView]-0-|" options:0 metrics:nil views:views]];
    if(_IPHONE_OS_VERSION_UNDER_7_0){
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_NavigationBar(44)]->=0-|" options:0 metrics:nil views:views]];
        self.view.frame = CGRectMake(0, -20, ScreenWidth, self.view.frame.size.height);
    }else{
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_NavigationBar(64)]->=0-|" options:0 metrics:nil views:views]];
    }
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 49, 46)];
    [self.view addSubview:_btnLeft];
    _btnLeft.backgroundColor = [UIColor clearColor];
    _btnLeft.translatesAutoresizingMaskIntoConstraints = NO;
    
    controlLeft = [[UIControl alloc] initWithFrame:CGRectZero];
    [self.view addSubview:controlLeft];
    controlLeft.translatesAutoresizingMaskIntoConstraints = NO;
    [controlLeft addTarget:self action:@selector(LeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    if(![UserModel sharedUserInfo].isLogin){
        [_btnLeft setBackgroundImage:[UIImage imageNamed:@"nav-person"] forState:UIControlStateNormal];
//    }else{
//        [_btnLeft sd_setImageWithURL:[NSURL URLWithString:[UserModel sharedUserInfo].headerFile] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav-person"]];
//    }
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnRight];
//    [_btnRight addTarget:self action:@selector(RightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.translatesAutoresizingMaskIntoConstraints = NO;
    _btnRight.hidden = YES;
    
    controlRight = [[UIControl alloc] initWithFrame:CGRectZero];
    [self.view addSubview:controlRight];
    controlRight.translatesAutoresizingMaskIntoConstraints = NO;
    [controlRight addTarget:self action:@selector(RightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_lbTitle];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = _FONT(21);
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor whiteColor];
    
    NSDictionary *navviews = NSDictionaryOfVariableBindings(_btnLeft, _btnRight, _lbTitle, _NavigationBar, controlLeft, controlRight);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=80-[_lbTitle(140)]->=80-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTitle(28)]->=8-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[controlLeft(48)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[controlLeft(80)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controlLeft attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[controlRight(48)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[controlRight(80)]-0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controlRight attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnLeft(46)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_btnLeft(46)]->=0-[_lbTitle]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbTitle]->=0-[_btnRight(40)]-10-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnRight(40)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnLeft attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnRight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:_lbTitle.text];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:_lbTitle.text];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma LCNavigationbarDelegate
- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    //    [self.navigationController pushViewController:self animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    
}

- (void) LeftButtonClicked:(id)sender
{
    if(![UserModel sharedUserInfo].isLogin){
        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else
        [[SliderViewController sharedSliderController] leftItemClick];
}

- (void) RightButtonClicked:(id)sender
{
    
}

@end
