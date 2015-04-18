//
//  EvaluateOrderVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "MyOrderdataModel.h"

@interface EvaluateOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    MyOrderdataModel *_orderModel;
}

- (id) initWithModel:(MyOrderdataModel *)model;

@end
