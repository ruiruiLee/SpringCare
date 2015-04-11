//
//  PlaceOrderEditForProductCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateCountSelectView.h"
#import "UnitsTypeView.h"
#import "ZHPickView.h"

@interface PlaceOrderEditForProductCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ZHPickViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
    
    UnitsTypeView *businessTypeView;//24或12小时
    DateCountSelectView *dateSelectView;//多少天
    UILabel *lbUnitPrice;//单价
    UILabel *lbAmountPrice;//总价
    
    ZHPickView *_pickview;
}

@end
