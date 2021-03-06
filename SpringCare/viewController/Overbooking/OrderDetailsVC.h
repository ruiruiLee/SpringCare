//
//  OrderDetailsVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "OrderStepView.h"
#import "MyOrderdataModel.h"
#import "EvaluateOrderVC.h"
#import "CouponLogoView.h"
#import "LCPickView.h"

@protocol OrderPriceCellDelegate <NSObject>

- (void) NotifyButtonClickedWithFlag:(UIButton*) sender;//0 去付款， 1 去评论

@end

@interface OrderPriceCell : UITableViewCell
{
    UILabel *_lbPrice;
    UILabel *_lbTotalPrice;
    UILabel *_lbRealPrice;
//    UILabel *_lbCouponsPrice;
    CouponLogoView *_couponLogo;
    UIButton *_btnStatus;
    UIImageView *_imgLogo;
    
    NSArray *constraints;
}

@property (nonatomic , assign) id<OrderPriceCellDelegate> delegate;

- (void) setContentData:(MyOrderdataModel *) model;

@end

@interface OrderInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbPrice;//价格
    UILabel *_lbDetailTime;
    UIButton *_btnInfo;//护工信息
    UIImageView *_logo;
    UILabel *_lbIntro;//护工介绍
    
    UILabel *_lbType;
    UILabel *_line;
    
    NSArray *constraintArray;
    NSArray *nurseConstraintArray;
}

- (void) setContentData:(MyOrderdataModel *) model;

@end

@interface BeCareInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbAge;
    UILabel * _lbHeight;
    UIButton *_btnMobile;
    UILabel *_btnAddress;
    UILabel *_LbRelation;
    UIImageView *_imgSex;
    UIImageView *_imgvAddr;
    
    UIView *seview1;
    UIView *seview2;
}

- (void) setContentData:(MyOrderdataModel *) model;

@end




@class OrderDetailsVC;

@protocol OrderDetailsVCDelegate <NSObject>

- (void) NotifyOrderCancelAndRefreshTableView:(OrderDetailsVC *) orderDetailVC;

@end

@interface OrderDetailsVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, OrderPriceCellDelegate,EvaluateOrderDelegate, LCPickViewDelegate>
{
    UITableView *_tableview;
    OrderStepView *_stepView;
    UILabel *lbOrderNum;//订单号
    UILabel *lbOrderTime;//下单时间
    
    MyOrderdataModel *_orderModel;
    MyOrderdataModel *storeModel;
    
    OrderInfoCell *ordercell;
    
    BOOL isReSetEndday;
    
    LCPickView *_endPickView;
}

@property (nonatomic, strong)MyOrderdataModel *_orderModel;
@property (nonatomic, strong)OrderStepView *_stepView;
@property (nonatomic, assign) id<OrderDetailsVCDelegate> delegate;
@property (nonatomic, strong) UITableView *_tableview;

- (id) initWithOrderModel:(MyOrderdataModel *) model;

@end
