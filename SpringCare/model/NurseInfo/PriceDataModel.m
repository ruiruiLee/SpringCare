//
//  PriceDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/6/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PriceDataModel.h"

@implementation PriceDataModel

+ (PriceDataModel *)modelFromDictionary:(NSDictionary *)dic
{
    PriceDataModel *model = [[PriceDataModel alloc] init];
    model.amount = [[dic objectForKey:@"amount"] integerValue];
    model.typeName = [dic objectForKey:@"typeName"];
    model.name = [dic objectForKey:@"name"];
    model.type = [[dic objectForKey:@"type"] integerValue];
    
    return model;
}

@end
