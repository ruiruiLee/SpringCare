//
//  RootViewController.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/16.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"

@interface RootViewController : LCBaseVC <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

