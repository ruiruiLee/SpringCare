//
//  HealthRecordItemDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthRecordItemDataModel : NSObject

@property (nonatomic, strong) NSString *pulse;
@property (nonatomic, strong) NSString *hp;
@property (nonatomic, strong) NSString *lp;
@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, strong) NSString *dt;

+ (HealthRecordItemDataModel *)modelFromDictionary:(NSDictionary *)dic;
+ (HealthRecordItemDataModel *)modelDateFromDictionary:(NSDictionary *)dic;

@end
