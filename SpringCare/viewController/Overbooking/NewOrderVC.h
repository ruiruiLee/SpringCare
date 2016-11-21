//
//  NewOrderVC.h
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceOrderEditCell.h"
#import "HBImageViewList.h"
#import "WorkAddressSelectVC.h"
#import "CouponsVC.h"
#import "FamilyProductModel.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"

typedef enum : NSUInteger {
    enumOrderTypeForNurse,
    EnumOrderTypeForProduct,
} EnumOrderType;

@interface NewOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PlaceOrderEditCellDelegate, WorkAddressSelectVCDelegate, CouponsVCDelegate>

{
    UITableView *_tableview;
    UILabel *lbActualPay;
    
    HBImageViewList *_imageList;
    
    UserAttentionModel *_loverModel;
    PriceDataModel *currentPriceModel;
}

@property (nonatomic, strong) CouponsDataModel *selectCoupons;
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSString *payValue;
@property (strong, nonatomic) UserAttentionModel *loverModel;
@property (strong, nonatomic) UIButton *btnSubmit;

/**
 创建headerview
 */
- (UIView *)createTableHeaderView;

- (void) btnSubmitOrder:(id) sender;

- (NSMutableAttributedString *)AttributedStringFromString:(NSString*)string subString:(NSString *)subString;

- (CGFloat) GetOrderTotalValue:(CGFloat) price count:(CGFloat) count couponvalue:(CGFloat) couponvalue;

- (void) submitWithloverId:(NSString*)loverId;

@end
