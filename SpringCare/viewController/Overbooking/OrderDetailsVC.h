//
//  OrderDetailsVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "OrderStepView.h"

@interface OrderPriceCell : UITableViewCell
{
    UILabel *_lbPrice;
    UILabel *_lbTotalPrice;
    UILabel *_lbStatus;
}

@end

@interface OrderInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbPrice;//价格
    UILabel *_lbDetailTime;
    UIButton *_btnInfo;//护工信息
    UILabel *_lbIntro;//护工介绍
    
    UILabel *_lbType;
    UILabel *_line;
}

@end

@interface BeCareInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbAge;
    UIButton *_btnMobile;
    UIButton *_btnAddress;
    UILabel *_LbRelation;
    UIImageView *_imgSex;
}

@end

@interface OrderDetailsVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    OrderStepView *_stepView;
    UILabel *lbOrderNum;//订单号
    UILabel *lbOrderTime;//下单时间
}

@end
