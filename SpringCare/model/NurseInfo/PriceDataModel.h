//
//  PriceDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/6/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceDataModel : NSObject

@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger amount;

+ (PriceDataModel *)modelFromDictionary:(NSDictionary *)dic;

@end
