//
//  EditUserInfoVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface EditUserInfoVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    NSArray *_data;
}

- (void) setContentArray:(NSArray*)dataArray;

@end
