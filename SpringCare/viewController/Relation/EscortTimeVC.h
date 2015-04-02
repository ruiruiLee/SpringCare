//
//  EscortTimeVC.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "EscortTimeTableCell.h"

@interface EscortTimeVC : UIViewController<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate>
{
    UITableView *tableView;
    EscortTimeDataModel *model;
    
}

@end
