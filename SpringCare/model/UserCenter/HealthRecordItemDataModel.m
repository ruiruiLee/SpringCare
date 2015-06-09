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
    model.hp = [dic objectForKey:@"hp"];
    model.lp = [dic objectForKey:@"lp"];
    model.pulse = [dic objectForKey:@"pulse"];
    model.dateString = [dic objectForKey:@"t"];
    
    return model;
}

@end
