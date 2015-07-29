//
//  PlaceOrderEditCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessTypeView.h"
#import "ZHPickView.h"
#import "NurseListInfoModel.h"
#import "CouponsSelectView.h"
#import "OrderInfoSelectView.h"
#import "LCPickView.h"

@protocol PlaceOrderEditCellDelegate <NSObject>

- (void) NotifyToSelectAddr;
- (void) NotifyTOSelectCoupons;
- (void) NotifyValueChanged:(NSInteger )value;
- (void) NotifyCurrentSelectPriceModel:(PriceDataModel *)model;

@end

@interface PlaceOrderEditCell : UITableViewCell<ZHPickViewDelegate, BusinessTypeViewDelegate, LCPickViewDelegate>
{
    BusinessTypeView *businessType;//24或12小时;
    UILabel *lbUnitPrice;//单价
    UILabel *lbCount;
    
    ZHPickView *_pickview;
    LCPickView *_endPickView;
    
    CouponsSelectView *_couponsView;
    
    NSArray *Constraints;
    UIImageView *logo;
    UILabel *lbPaytype;
    UILabel *line1;
    UILabel *line2;
    
    //产品价格介绍
    UIView *pricebg;
    UIImageView *warnImageView;
    UILabel *lbshdx;//适合对象
    UILabel *lbfwsc;//服务时长
    
    PriceDataModel *currentPriceModel;
    NSArray *OrderPriceList;
}

@property (nonatomic, assign) id<PlaceOrderEditCellDelegate> delegate;
@property (nonatomic, strong) BusinessTypeView *businessType;
@property (nonatomic, strong) CouponsSelectView *couponsView;
@property (nonatomic, strong) UILabel *lbUnits;

@property (nonatomic, strong) OrderInfoSelectView *beginDate;
@property (nonatomic, strong) OrderInfoSelectView *endDate;
@property (nonatomic, strong) OrderInfoSelectView *address;
@property (nonatomic, assign) CGFloat totalDays;

- (void) SetPriceList:(NSArray *)priceList;


@end
