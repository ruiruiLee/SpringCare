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
#import "MainBaseVC.h"

@interface EscortTimeVC : MainBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate>
{
    UITableView *tableView;
    EscortTimeDataModel *model;
    
    
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnInfo;//信息
}

@end
