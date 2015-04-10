//
//  PayForOrderVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface PayForOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    
    UIView *_nurseInfoBg;//护士信息
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbPrice;//价格
    UIImageView *_imgDayTime;
    UIImageView *_imgNight;
    UILabel *_lbDetailTime;
    
    UIView *_totalPriceBg;//总价
    UILabel *_lbTotalPrice;//
    UILabel *_lbTotalPriceValue;
    
    UIImageView *_payLogo;
    UILabel *_lbPaytype;
}

@end
