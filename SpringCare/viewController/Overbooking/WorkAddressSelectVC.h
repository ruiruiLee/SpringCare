//
//  WorkAddressSelectVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "EditUserInfoVC.h"

@interface WorkAddressSelectVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EditUserInfoVCDelegate>
{
    UITableView *_tableview;
    
    NSArray *_dataList;
}

@end
