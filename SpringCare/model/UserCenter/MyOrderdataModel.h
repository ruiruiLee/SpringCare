//
//  MyOrderdataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/17.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "NurseListInfoModel.h"
#import "UserAttentionModel.h"

@interface ProductInfodataModel : NSObject

@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *name;

@end

@interface RegistrUserInfoModel : NSObject

@property (nonatomic, strong) NSString *uId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *chineseName;

@end


@interface MyOrderdataModel : NSObject

@property (nonatomic, assign) BOOL isLoadDetail;
@property (nonatomic, strong) NSString *oId;
@property (nonatomic, assign) DateType dateType;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) CGFloat orderCount;
@property (nonatomic, strong) NSString *orderCountStr;
@property (nonatomic, assign) NSInteger unitPrice;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) CommentStatus commentStatus;
@property (nonatomic, assign) PayStatus payStatus;
@property (nonatomic, strong) ProductInfodataModel *product;
@property (nonatomic, strong) NSArray *nurseInfo;//NurseListInfoModel *nurseInfo;
//detail

@property (nonatomic, strong) UserAttentionModel *lover;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) RegistrUserInfoModel *registerUser;
@property (nonatomic, strong) NSDate *createdDate;

@property (nonatomic, assign) NSInteger realyTotalPrice;//实际支付金额
@property (nonatomic, assign) NSInteger couponsAmount;//优惠券金额

@property (nonatomic, strong) NSString *priceName;

+ (NSArray *) GetNoAssessmentOrderList;
+ (NSArray *) GetMyOrderList;

/**
 *  获取订单数据, pages为0时刷新
 *
 */
+ (void) loadOrderlistWithPages:(NSInteger) pages type:(OrderListType) orderType isOnlyIndexSplit:(BOOL) isOnlyIndexSplit block:(CompletionBlock) block;

/**
 *  获取护工详情
 *
 */
- (void) LoadDetailOrderInfo:(block) block;

@end
