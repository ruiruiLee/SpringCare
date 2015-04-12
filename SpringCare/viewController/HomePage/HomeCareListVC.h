//
//  HomeCareListVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "ProductInfoCell.h"

@interface HomeCareListVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
}

@property (nonatomic, strong) ProductInfoCell *producttypeCell;

@end
