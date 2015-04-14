//
//  PlaceOrderForProductVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
@class NurseListInfoModel;

@interface PlaceOrderForProductVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
}

- (id) initWithModel:(NurseListInfoModel*) model;

@end
