//
//  MyOrderListVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCTabBar.h"
#import "OrderListModel.h"
#import "PullTableView.h"

@interface MyOrderListVC : LCBaseVC<LCTabBarDelegate, UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    LCTabBar *_tabBar;
    
    NSArray *dataList;
    
    NSInteger pages;
}

@property (nonatomic, strong) PullTableView *pullTableView;

@end
