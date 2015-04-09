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
@synthesize ID;
@synthesize type;
@synthesize price;
@synthesize countPrice;
@synthesize fromto;
@synthesize name;

+ (NSArray*) GetOrderList
{
    if(!ordrList){
        ordrList = [[NSMutableArray alloc] init];
        
        for (int  i = 0; i < 10; i++) {
            OrderListModel *model = [[OrderListModel alloc] init];
            [ordrList addObject:model];
        }
    }
    return ordrList;
}

- (id) init
{
    self = [super init];
    if(self){
        ID = @"";
        type = 0;
        price = @"1453";
        countPrice = @"234523";
        fromto = @"2015.03.25-03.27 (20:-次日08:00)";
        name = @"而且我";
    }
    return self;
}

@end
