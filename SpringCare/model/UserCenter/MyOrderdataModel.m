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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)RemoveObjectFromArray:(NSNotification *) notify
{
    [myOrderList removeAllObjects];
    [noAssessmentOrderList removeAllObjects];
}

- (id) init
{
    self = [super init];
    if(self){
        self.isLoadDetail = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveObjectFromArray:) name:Notify_Register_Logout object:nil];
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
    model.orderCount = [[dic objectForKey:@"orderCount"] floatValue];
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
    model.commentStatus = ([[dic objectForKey:@"commentStatus"] intValue] == 0) ? EnumTypeNoComment : EnumTypeCommented;
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
    
    model.realyTotalPrice = [[dic objectForKey:@"realyTotalPrice"] integerValue];
    model.couponsAmount = [[dic objectForKey:@"couponsAmount"] integerValue];
    
    model.priceName = [dic objectForKey:@"priceName"];
    
    return model;
}

+ (void) loadOrderlistWithPages:(NSInteger) pages type:(OrderListType) orderType isOnlyIndexSplit:(BOOL) isOnlyIndexSplit block:(CompletionBlock) block
{
    if(pages == 0){
        if(orderType == EnumOrderOther){
            [MyOrderdataModel GetMyOrderList];
            
            [myOrderList removeAllObjects];
        }
        else{
         [MyOrderdataModel GetNoAssessmentOrderList];
            [noAssessmentOrderList removeAllObjects];
        }
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(orderType == EnumOrderOther){    // 所有订单
        [params setObject:@"other" forKey:@"searchType"];
        if(offset > myOrderList.count)
            offset = myOrderList.count;
        [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
        [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    }
    else if (orderType == EnumOrderService){    //进行中的订单
        [params setObject:@"service" forKey:@"searchType"];
    }
    else{
        [params setObject:@"waitComment" forKey:@"searchType"];  //评论中的订单
    }
    if(pages > 0){
        [params setObject:@"true" forKey:@"isOnlyIndexSplit"];
    }
    else{
        [params setObject:@"false" forKey:@"isOnlyIndexSplit"];
    }
    
    [LCNetWorkBase postWithMethod:@"api/order/register/list" Params:params Completion:^(int code, id content) {
        if(code){
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSArray *Orders = [content objectForKey:@"rows"];
            if (orderType == EnumOrderService){    // 服务中的订单
                for (int i = 0; i < [Orders count]; i++) {
                    NSDictionary *dic = [Orders objectAtIndex:i];
                    MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                    [myOrderList addObject:model];
                    [result addObject:model];
                }
            }
            else if(orderType == EnumOrderOther){   //全部订单除去待评论的
                        for (int i = 0; i < [Orders count]; i++){
                        NSDictionary *dic = [Orders objectAtIndex:i];
                        MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                       // if (model.commentStatus == EnumTypeCommented) {
                                [myOrderList addObject:model];
                                [result addObject:model];
                       //  }
                    }
                }

            else
             {// 等待评论的订单
                    for (int i = 0; i < [Orders count]; i++) {
                        NSDictionary *dic = [Orders objectAtIndex:i];
                        MyOrderdataModel *model = [MyOrderdataModel modelWithDictionary:dic];
                        [noAssessmentOrderList addObject:model];
                        [result addObject:model];
                    }
            }
            
            if(block)
                block (1, result);
        }
        else{
            if(block)
                block (0, nil);
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
