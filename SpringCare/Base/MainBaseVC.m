//
//  MainBaseVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/2.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MainBaseVC.h"

@implementation MainBaseVC

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
    }else{
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_NavigationBar(64)]->=0-|" options:0 metrics:nil views:views]];
    }
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 32, 32)];
    [self.view addSubview:_btnLeft];
    _btnLeft.backgroundColor = [UIColor clearColor];
    [_btnLeft addTarget:self action:@selector(LeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnLeft.translatesAutoresizingMaskIntoConstraints = NO;
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(HandleRightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_lbTitle];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = _FONT_B(20);
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor whiteColor];
    
    NSDictionary *navviews = NSDictionaryOfVariableBindings(_btnLeft, _btnRight, _lbTitle, _NavigationBar);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=60-[_lbTitle(200)]->=60-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTitle(28)]->=8-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_btnLeft(50)]->=0-[_lbTitle]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbTitle]->=0-[_btnRight(50)]-10-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnLeft attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnRight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
    
}

- (void) RightButtonClicked:(id)sender
{
    
}

@end
