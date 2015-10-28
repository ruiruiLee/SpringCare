//
//  HealthRecordItemDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HealthRecordItemDataModel.h"

@implementation HealthRecordItemDataModel

+ (HealthRecordItemDataModel *)modelFromDictionary:(NSDictionary *)dic
{
    HealthRecordItemDataModel *model = [[HealthRecordItemDataModel alloc] init];
    model.hp = [[dic objectForKey:@"hp"] stringValue];
    model.lp = [[dic objectForKey:@"lp"] stringValue];
    model.pulse = [[dic objectForKey:@"pulse"] stringValue];
    model.dateString = [dic objectForKey:@"t"];
    
    return model;
}

+ (HealthRecordItemDataModel *)modelDateFromDictionary:(NSDictionary *)dic
{
    HealthRecordItemDataModel *model = [[HealthRecordItemDataModel alloc] init];
    model.hp = [[dic objectForKey:@"Hp"] stringValue];
    model.lp = [[dic objectForKey:@"Lp"] stringValue];
    model.pulse = [[dic objectForKey:@"Pulse"] stringValue];
    model.dt = [dic objectForKey:@"dt"];
    
    return model;
}

@end
