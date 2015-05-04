//
//  RootViewController.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/16.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"
#import "HomePageVC.h"
#import "NurseListMainVC.h"
#import "EscortTimeVC.h"

@interface RootViewController : UITabBarController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) HomePageVC *homeVC;
@property (strong, nonatomic) NurseListMainVC *nurseVC;
@property (strong, nonatomic) EscortTimeVC *messageListVC;
-(void) pushtoController:(NSInteger)curentPushtype;
@end

