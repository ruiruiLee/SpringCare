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

//#import "EvaluateOrderVC.h"

@interface MyOrderListVC : LCBaseVC<LCTabBarDelegate, UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    LCTabBar *_tabBar;
    
    NSArray *dataListForCom;//待评价数据
    NSArray *dataOnDoingList;//正在进行中的订单
    NSMutableArray *dataOtherList;//其他订单
    
    NSInteger pages;
}

@property (nonatomic, assign) BOOL isComment;//是否待评价;
@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSArray *dataOnDoingList;
@property (nonatomic, strong) NSMutableArray *dataOtherList;

@end
