//
//  PlaceOrderVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface PlaceOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    
    UIImageView *_photoImage;
    UILabel *_lbName;
    UIButton *_btnCert;
    UIButton *_btnInfo;
    UILabel *_detailInfo;
    UIButton *_btnUnfold;
    
    NSArray *headerViewHeightConstraint;
}

@end
