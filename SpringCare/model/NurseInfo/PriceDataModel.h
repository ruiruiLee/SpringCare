//
//  PriceDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/6/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceDataModel : NSObject

@property (nonatomic, strong) NSString *typeName;//单位名称
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, assign) NSInteger type;//5是月，6是小时，这两个都是选择数量；其他选择结束时间
@property (nonatomic, assign) NSInteger amount;//单价
@property (nonatomic, strong) NSString *fwsj;//服务时长
@property (nonatomic, strong) NSString *shrq;//适合对象
@property (nonatomic, assign) BOOL isDefault;

+ (PriceDataModel *)modelFromDictionary:(NSDictionary *)dic;

@end
