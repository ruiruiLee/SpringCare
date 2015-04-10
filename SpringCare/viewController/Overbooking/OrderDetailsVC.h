//
//  OrderDetailsVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface OrderDetailsVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
}

@end
