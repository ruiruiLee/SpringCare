//
//  OrderListModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderListModel.h"

static NSMutableArray *ordrList = nil;

@implementation OrderListModel

+ (NSArray*) GetOrderList
{
    if(!ordrList){
        ordrList = [[NSMutableArray alloc] init];
    }
    return ordrList;
}

@end
