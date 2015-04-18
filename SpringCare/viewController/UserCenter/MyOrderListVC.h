//
//  MyOrderListVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCTabBar.h"
#import "PullTableView.h"
#import "define.h"

@interface MyOrderListVC : LCBaseVC<LCTabBarDelegate, UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    LCTabBar *_tabBar;
    
    NSArray *dataList;
    
    NSInteger pages;
    
    OrderListType orderType;
}

@property (nonatomic, strong) PullTableView *pullTableView;

@end
