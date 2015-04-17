//
//  PayTypeForProductCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTypeCell.h"

@interface PayTypeForProductCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
}

@property (nonatomic, assign) PayType paytype;

@end
