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

@interface MyOrderListVC : LCBaseVC<LCTabBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    LCTabBar *_tabBar;
    
    UITableView *_tableView;
    
    NSArray *dataList;
}

@end
