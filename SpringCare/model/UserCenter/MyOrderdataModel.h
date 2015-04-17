//
//  MyOrderdataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/17.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface MyOrderdataModel : NSObject

+ (NSArray *) GetNoAssessmentOrderList;
+ (NSArray *) GetMyOrderList;

/**
 *  获取订单数据, pages为0时刷新
 *
 */
+ (void) loadOrderlistWithPages:(NSInteger) pages block:(block) block;

@end
