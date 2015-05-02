//
//  EvaluateOrderVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "MyOrderdataModel.h"

@protocol EvaluateOrderDelegate <NSObject>

@optional
- (void) NotifyReloadOrderInfo;
@end

@interface EvaluateOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    MyOrderdataModel *_orderModel;
}

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) id<EvaluateOrderDelegate> delegate;

- (id) initWithModel:(MyOrderdataModel *)model;

@end
