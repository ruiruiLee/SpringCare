//
//  CouponsDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/5/27.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface CouponsDataModel : NSObject

@property (nonatomic, strong) NSString *couponsId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *useDate;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) EnumCouponType type;

+ (CouponsDataModel *)modelFromDictionary:(NSDictionary *) dic;

@end
