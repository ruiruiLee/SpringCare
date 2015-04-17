//
//  MyOrderdataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/17.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyOrderdataModel.h"

static NSMutableArray *myOrderList = nil;
static NSMutableArray *noAssessmentOrderList = nil;

@implementation MyOrderdataModel

+ (NSArray *) GetMyOrderList
{
    if(!myOrderList){
        myOrderList = [[NSMutableArray alloc] init];
    }
    return myOrderList;
}

+ (NSArray *) GetNoAssessmentOrderList
{
    if(!noAssessmentOrderList){
        noAssessmentOrderList = [[NSMutableArray alloc] init];
    }
    return noAssessmentOrderList;
}

@end
