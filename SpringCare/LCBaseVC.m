//
//  LCBaseVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCBaseVC.h"
#import <AVOSCloud/AVOSCloud.h>
@implementation LCBaseVC
@synthesize NavTitle;

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
    [self.view addSubview:_NavigationBar];
    _NavigationBar.delegate = self;
    _NavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    if(NavTitle != nil)
        _NavigationBar.Title = NavTitle;
    
    _ContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_ContentView];
    _ContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _ContentView.clipsToBounds = YES;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_ContentView, _NavigationBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_NavigationBar]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_ContentView]-0-|" options:0 metrics:nil views:views]];
    if(_IPHONE_OS_VERSION_UNDER_7_0){
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_NavigationBar(44)]-0-[_ContentView]-0-|" options:0 metrics:nil views:views]];
    }else{
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_NavigationBar(64)]-0-[_ContentView]-0-|" options:0 metrics:nil views:views]];
    }
    //  _NavigationBar.Title = @"对方很高";
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:_NavigationBar.Title];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:_NavigationBar.Title ];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) setNavTitle:(NSString *)title
{
    NavTitle = title;
    if(self.NavigationBar != nil){
        self.NavigationBar.Title = title;
    }
}

- (void) keyboardWillShow:(NSNotification *) notify
{
    
}

- (void) keyboardWillHide:(NSNotification *)notify
{
    
}

@end
