//
//  CityListSelectVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface CityListSelectVC : LCBaseVC<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableview;
}

@end
