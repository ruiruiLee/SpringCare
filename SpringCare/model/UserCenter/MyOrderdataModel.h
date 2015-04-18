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

@interface ProductInfodataModel : NSObject

@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *name;

@end

@interface MyOrderdataModel : NSObject

@property (nonatomic, strong) NSString *oId;
@property (nonatomic, assign) DateType dateType;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger orderCount;
@property (nonatomic, assign) NSInteger orgUnitPrice;
@property (nonatomic, assign) NSInteger unitPrice;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) CommentStatus commentStatus;
@property (nonatomic, assign) PayStatus payStatus;
@property (nonatomic, strong) ProductInfodataModel *product;
@property (nonatomic, strong) NSArray *nurseInfo;//NurseListInfoModel *nurseInfo;

+ (NSArray *) GetNoAssessmentOrderList;
+ (NSArray *) GetMyOrderList;

/**
 *  获取订单数据, pages为0时刷新
 *
 */
+ (void) loadOrderlistWithPages:(NSInteger) pages type:(OrderListType) orderType block:(block) block;

@end
