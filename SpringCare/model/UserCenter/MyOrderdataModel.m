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

@implementation ProductInfodataModel

+ (ProductInfodataModel *) modelWithDictionary:(NSDictionary *) dic
{
    ProductInfodataModel *model = [[ProductInfodataModel alloc] init];
    model.pId = [dic objectForKey:@"id"];
    model.name = [dic objectForKey:@"name"];
    return model;
}

@end

@implementation RegistrUserInfoModel

+ (RegistrUserInfoModel *) modelWithDictionary:(NSDictionary *) dic
{
    RegistrUserInfoModel *model = [[RegistrUserInfoModel alloc] init];
    model.uId = [dic objectForKey:@"id"];
    model.phone = [dic objectForKey:@"phone"];
    model.chineseName = [dic objectForKey:@"chineseName"];
    return model;
}

@end

@implementation MyOrderdataModel

- (id) init
{
    self = [super init];
    if(self){
        self.isLoadDetail = NO;
    }
    return self;
}

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

+ (MyOrderdataModel *) modelWithDictionary:(NSDictionary*) dic
{
    MyOrderdataModel *model = [[MyOrderdataModel alloc] init];
    model.oId = [dic objectForKey:@"id"];
    model.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
    model.orgUnitPrice = [[dic objectForKey:@"orgUnitPrice"] integerValue];
    model.unitPrice = [[dic objectForKey:@"unitPrice"] integerValue];
    model.totalPrice = [[dic objectForKey:@"totalPrice"] integerValue];
    model.product = [ProductInfodataModel modelWithDictionary:[dic objectForKey:@"product"]];
    NSArray *cares = [dic objectForKey:@"cares"];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [cares count]; i++) {
        NSDictionary *dic = [cares objectAtIndex:i];
        NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:dic];
        [marray addObject:model];
    }
    if([marray count] > 0)
        model.nurseInfo = marray;
    model.payStatus = ([[dic objectForKey:@"payStatus"] intValue] == 0) ? EnumTypeNopay : EnumTypePayed;
    model.commentStatus = ([[dic objectForKey:@"payStatus"] intValue] == 0) ? EnumTypeCommented : EnumTypeNoComment;
    model.commentCount = [[dic objectForKey:@"payStatus"] integerValue];
    int dateType = [[dic objectForKey:@"dateType"] intValue];
    if(dateType == 1)
        model.dateType = EnumTypeHalfDay;
    else if (dateType == 2)
        model.dateType = EnumTypeOneDay;
    else if (dateType == 3)
        model.dateType = EnumTypeOneWeek;
    else if (dateType == 4)
        model.dateType = EnumTypeOneMounth;
    else
        model.dateType = EnumDateTypeUnknown;
    
    int orderStatus = [[dic objectForKey:@"orderStatus"] intValue];
    if(orderStatus == 1)
        model.orderStatus = EnumOrderStatusTypeNew;
    else if (orderStatus == 2)
        model.orderStatus = EnumOrderStatusTypeConfirm;
    else if (orderStatus == 3)
        model.orderStatus = EnumOrderStatusTypeServing;
    else if (orderStatus == 4)
        model.orderStatus = EnumOrderStatusTypeFinish;
    else if (orderStatus == 99)
        model.orderStatus = EnumOrderStatusTypeCancel;
    else
        model.orderStatus = EnumOrderStatusTypeUnknown;
    
    model.beginDate = [Util convertDateFromDateString:[dic objectForKey:@"beginDate"]];
    model.endDate = [Util convertDateFromDateString:[dic objectForKey:@"endDate"]];
    
    return model;
}

+ (void) loadOrderlistWithPages:(NSInteger) pages type:(OrderListType) orderType isOnlyIndexSplit:(BOOL) isOnlyIndexSplit block:(block) block
{
    if(pages == 0){
        if(orderType == EnumOrderAll){
            [MyOrderdataModel GetMyOrderList];
            [myOrderList removeAllObjects];
        }
        else{
            [MyOrderdataModel GetNoAssessmentOrderList];
            [noAssessmentOrderList removeAllObjects];
        }
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[UserModel sharedUserInfo].userId forKey:@"currentUserId"];
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(orderType == EnumOrderAll){
        [params setObject:@"index" forKey:@"searchType"];
        if([myOrderList count] < 2){
            offset = 0;
        }else{
            if(offset >= [[myOrderList objectAtIndex:1] count])
                offset = [[myOrderList objectAtIndex:1] count];
        }
    }else{
        [params setObject:@"waitComment" forKey:@"searchType"];
        if(offset >= [noAssessmentOrderList count])
            offset = [noAssessmentOrderList count];
    }
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    if(isOnlyIndexSplit)
        [params setObject:@"true" forKey:@"offset"];
    
    [LCNetWorkBase postWithMethod:@"api/order/register/list" Params:params Completion:^(int code, id content) {
        if(code){
            if(orderType == EnumOrderAll){
                if([content isKindOfClass:[NSDictionary class]]){
                    NSArray *serverOrders = [content objectForKey:@"serverOrders"];
                    NSArray *otherOrders = [content objectForKey:@"otherOrders"];
                    if([myOrderList count] < 2){
                        NSMutableArray *subArrayService = [[NSMutableArray alloc] init];
                        for (int i = 0; i < [serverOrders count]; i++) {
                            NSDictionary *dic = [serverOrders objectAtIndex:i];
                            MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                            [subArrayService addObject:model];
                        }
                        [myOrderList addObject:subArrayService];
                        NSMutableArray *subArrayOther = [[NSMutableArray alloc] init];
                        for (int i = 0; i < [otherOrders count]; i++) {
                            NSDictionary *dic = [otherOrders objectAtIndex:i];
                            MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                            [subArrayOther addObject:model];
                        }
                        [myOrderList addObject:subArrayOther];
                    }else{
                        NSMutableArray *subArrayService = [myOrderList objectAtIndex:0];
                        for (int i = 0; i < [serverOrders count]; i++) {
                            NSDictionary *dic = [serverOrders objectAtIndex:i];
                            MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                            [subArrayService addObject:model];
                        }

                        NSMutableArray *subArrayOther = [myOrderList objectAtIndex:1];
                        for (int i = 0; i < [otherOrders count]; i++) {
                            NSDictionary *dic = [otherOrders objectAtIndex:i];
                            MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                            [subArrayOther addObject:model];
                        }
                    }
                }
            }
            else{
                
                if([content isKindOfClass:[NSDictionary class]]){
                    NSArray *otherOrders = [content objectForKey:@"otherOrders"];
                    for (int i = 0; i < [otherOrders count]; i++) {
                        NSDictionary *dic = [otherOrders objectAtIndex:i];
                        MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                        [noAssessmentOrderList addObject:model];
                    }
                }
                else if ([content isKindOfClass:[NSArray class]]){
                    for (int i = 0; i < [content count]; i++) {
                        NSDictionary *dic = [content objectAtIndex:i];
                        MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                        [noAssessmentOrderList addObject:model];
                    }
                }
            }
            
            if(block){
                block (1);
            }
        }else
        {
            if(block){
                block (0);
            }
        }
    }];
}

- (void) LoadDetailOrderInfo:(block) block
{
    [LCNetWorkBase postWithMethod:@"api/order/detail" Params:@{@"id" : self.oId} Completion:^(int code, id content) {
        if(code){
            self.isLoadDetail = YES;
            self.serialNumber = [content objectForKey:@"serialNumber"];
            self.lover = [UserAttentionModel modelFromDIctionary:[content objectForKey:@"lover"]];
            self.registerUser = [RegistrUserInfoModel modelWithDictionary:[content objectForKey:@"register"]];
            self.createdDate = [Util convertDateFromDateString:[content objectForKey:@"createdDate"]];
            
            if(block){
                block(1);
            }
        }
    }];
}

@end
