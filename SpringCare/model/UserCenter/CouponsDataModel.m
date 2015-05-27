//
//  CouponsDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/5/27.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponsDataModel.h"

@implementation CouponsDataModel

+ (CouponsDataModel *)modelFromDictionary:(NSDictionary *) dic
{
    CouponsDataModel *model = [[CouponsDataModel alloc] init];
    
    model.couponsId = [dic objectForKey:@"id"];
    model.name = [dic objectForKey:@"name"];
    model.beginDate = [dic objectForKey:@"beginDate"];
    model.endDate = [dic objectForKey:@"endDate"];
    model.useDate = [dic objectForKey:@"useDate"];
    model.type = [Util GetCouponsUseStatus:[[dic objectForKey:@"status"] integerValue]];
    model.amount = [[dic objectForKey:@"amount"] integerValue];
    
    return model;
}

@end
