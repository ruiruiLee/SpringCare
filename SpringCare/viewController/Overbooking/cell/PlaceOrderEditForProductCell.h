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
#import "FamilyProductModel.h"
#import "CouponsSelectView.h"

@protocol PlaceOrderEditForProductCellDelegate <NSObject>

- (void) NotifyToSelectAddr;
- (void) NotifyTOSelectCoupons;
- (void) NotifyValueChanged:(NSInteger )value;

@end

@interface PlaceOrderEditForProductCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ZHPickViewDelegate, UnitsTypeViewDelegate, DateCountSelectViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
    UILabel *sepline;
    
    UnitsTypeView *businessType;//24或12小时
    DateCountSelectView *dateSelectView;//多少天
    UILabel *lbUnitPrice;//单价
    UILabel *lbAmountPrice;//总价
    UILabel *lbNumber;
    UILabel *lbOrderUnit;
    
    ZHPickView *_pickview;
    
    FamilyProductModel *_nurseData;
    CouponsSelectView *_couponsView;
    
    NSArray *hConstraints;
}

@property (nonatomic, assign) id<PlaceOrderEditForProductCellDelegate> delegate;
@property (nonatomic, strong) UITableView *_tableview;
@property (nonatomic, strong) UnitsTypeView *businessType;
@property (nonatomic, strong) DateCountSelectView *dateSelectView;
@property (nonatomic, strong) CouponsSelectView *couponsView;
@property (nonatomic, strong) UILabel *lbUnits;

- (void) setNurseListInfo:(FamilyProductModel*) model;

@end
