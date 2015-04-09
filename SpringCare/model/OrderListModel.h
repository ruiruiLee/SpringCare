//
//  OrderListModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *countPrice;
@property (nonatomic, assign) int type; //0全天 1白天 2 晚上
@property (nonatomic, strong) NSString *fromto;
@property (nonatomic, strong) NSString *name;

+ (NSArray*) GetOrderList;

@end
