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
#import "NurseListInfoModel.h"
#import "CouponsSelectView.h"

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

@protocol PlaceOrderEditCellDelegate <NSObject>

- (void) NotifyToSelectAddr;
- (void) NotifyTOSelectCoupons;
- (void) NotifyValueChanged:(NSInteger )value;

@end

@interface PlaceOrderEditCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ZHPickViewDelegate, BusinessTypeViewDelegate, DateCountSelectViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
    
    BusinessTypeView *businessType;//24或12小时;
    DateCountSelectView *dateSelectView;//多少天
    UILabel *lbUnitPrice;//单价
    UILabel *lbAmountPrice;//总价
    
    ZHPickView *_pickview;
    
    NurseListInfoModel *_nurseData;
    
    CouponsSelectView *_couponsView;
    
    NSArray *Constraints;
    UIImageView *logo;
    UILabel *lbPaytype;
    UILabel *line1;
}

@property (nonatomic, assign) id<PlaceOrderEditCellDelegate> delegate;
@property (nonatomic, strong) UITableView *_tableview;
@property (nonatomic, strong) BusinessTypeView *businessType;
@property (nonatomic, strong) DateCountSelectView *dateSelectView;
@property (nonatomic, strong) CouponsSelectView *couponsView;
@property (nonatomic, strong) UILabel *lbUnits;

- (void) setNurseListInfo:(NurseListInfoModel*) model;

@end
