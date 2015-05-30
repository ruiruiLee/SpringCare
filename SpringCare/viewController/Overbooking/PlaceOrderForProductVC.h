//
//  PlaceOrderForProductVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceOrderEditForProductCell.h"
@class FamilyProductModel;

@interface PlaceOrderForProductVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PlaceOrderEditForProductCellDelegate>
{
    UITableView *_tableview;
    
    UILabel *_lbTitle;
    UILabel *_lbExplain;
    
    UILabel *lbActualPay;
}
@property (strong, nonatomic) NSString *payValue;
@property (strong, nonatomic) UITableView *_tableview;
- (id) initWithModel:(FamilyProductModel*) model;

@end
