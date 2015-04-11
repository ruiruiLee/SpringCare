//
//  PlaceOrderEditCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateCountSelectView.h"
#import "BusinessTypeView.h"
#import "ZHPickView.h"

@interface PlaceOrderEditItemCell : UITableViewCell
{
    UIButton *_logoImageView;
    UILabel *_lbTitle;
    UIImageView *_unfoldStaus;
    UILabel *_line;
}

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *logoImageView;

@end

@interface PlaceOrderEditCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ZHPickViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
    
    BusinessTypeView *businessTypeView;//24或12小时
    DateCountSelectView *dateSelectView;//多少天
    UILabel *lbUnitPrice;//单价
    UILabel *lbAmountPrice;//总价
    
    ZHPickView *_pickview;
}

@end
