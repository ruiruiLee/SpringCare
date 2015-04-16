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

@implementation MainBaseVC

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

- (void) NotifyLoginSuccess:(NSNotification*) notify
{
    int type = [[notify.userInfo objectForKey:@"type"] intValue];
    switch (type) {
        case 1:
        {
            UserAttentionVC *vc = [[UserAttentionVC alloc] initWithNibName:nil bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 2:
        {
            MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 3:
        {
            FeedBackVC *vc = [[FeedBackVC alloc] initWithNibName:nil bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 4:
        {
            UserSettingVC *vc = [[UserSettingVC alloc] initWithNibName:nil bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 5:
        {
            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            EditCellTypeData *data1 = [[EditCellTypeData alloc] init];
            data1.cellTitleName = @"电话（账户）";
            data1.cellType = EnumTypeAccount;
            [mArray addObject:data1];
            
            EditCellTypeData *data2 = [[EditCellTypeData alloc] init];
            data2.cellTitleName = @"姓名";
            data2.cellType = EnumTypeUserName;
            [mArray addObject:data2];
            
            EditCellTypeData *data3 = [[EditCellTypeData alloc] init];
            data3.cellTitleName = @"性别";
            data3.cellType = EnumTypeSex;
            [mArray addObject:data3];
            
            EditCellTypeData *data4 = [[EditCellTypeData alloc] init];
            data4.cellTitleName = @"年龄";
            data4.cellType = EnumTypeAge;
            [mArray addObject:data4];
            
            EditCellTypeData *data5 = [[EditCellTypeData alloc] init];
            data5.cellTitleName = @"地址";
            data5.cellType = EnumTypeAddress;
            [mArray addObject:data5];
            
            
            EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
            vc.NavigationBar.Title = @"编辑我的资料";
            [vc setContentArray:mArray andmodel:[UserModel sharedUserInfo]];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyLoginSuccess:) name:NOTIFY_MENU_CHANGED object:nil];
    
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
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 49, 46)];
    [self.view addSubview:_btnLeft];
    _btnLeft.backgroundColor = [UIColor clearColor];
    [_btnLeft addTarget:self action:@selector(LeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnLeft.translatesAutoresizingMaskIntoConstraints = NO;
    if(![UserModel sharedUserInfo].isLogin){
        [_btnLeft setBackgroundImage:[UIImage imageNamed:@"nav-person"] forState:UIControlStateNormal];
    }else{
        [_btnLeft sd_setImageWithURL:[NSURL URLWithString:[UserModel sharedUserInfo].headerFile] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav-person"]];
    }
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(RightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.translatesAutoresizingMaskIntoConstraints = NO;
    _btnRight.hidden = YES;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_lbTitle];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = _FONT(21);
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor whiteColor];
    
    NSDictionary *navviews = NSDictionaryOfVariableBindings(_btnLeft, _btnRight, _lbTitle, _NavigationBar);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=80-[_lbTitle(200)]->=80-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTitle(28)]->=8-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_NavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnLeft(46)]->=0-|" options:0 metrics:nil views:navviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_btnLeft(46)]->=0-[_lbTitle]->=0-|" options:0 metrics:nil views:navviews]];
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
//    if(![UserModel sharedUserInfo].isLogin){
//        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self.navigationController presentViewController:nav animated:YES completion:^{
//            
//        }];
//    }
//    else
        [[SliderViewController sharedSliderController] leftItemClick];
}

- (void) RightButtonClicked:(id)sender
{
    
}

@end
