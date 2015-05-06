//
//  FamilyProductModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "FamilyProductModel.h"
#import "define.h"

static NSMutableArray *familyProductArray = nil;

@implementation FamilyProductModel
@synthesize pId;
@synthesize image_url;
@synthesize isDirectOrder;
@synthesize productDesc;
@synthesize productName;
@synthesize price;
@synthesize priceDiscount;

+ (NSArray*) getProductArray
{
    if(familyProductArray == nil){
        familyProductArray = [[NSMutableArray alloc] init];
    }
    return familyProductArray;
}

+ (void) setFamilyProduct:(NSArray*)array
{
    if(familyProductArray == nil){
        familyProductArray = [[NSMutableArray alloc] init];
    }
    [familyProductArray removeAllObjects];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        FamilyProductModel *model = [[FamilyProductModel alloc] init];
        model.pId = [dic objectForKey:@"id"];
        model.image_url = [dic objectForKey:@"imageUrl"];
        model.isDirectOrder = [[dic objectForKey:@"isDirectOrder"] boolValue];
        model.productName = [dic objectForKey:@"productName"];
        model.productDesc = [dic objectForKey:@"productDesc"];
        if([[dic objectForKey:@"price"] isKindOfClass:[NSNull class]])
            model.price = 0;
        else
            model.price = [[dic objectForKey:@"price"] integerValue];
        if([[dic objectForKey:@"priceDiscount"] isKindOfClass:[NSNull class]])
            model.priceDiscount = 0;
        else
            model.priceDiscount = [[dic objectForKey:@"priceDiscount"] integerValue];
        
        [familyProductArray addObject:model];
    }
}

- (id) init
{
    self = [super init];
    if(self){
    }
    return self;
}

- (void) loadetailDataWithproductId:(NSString*)productId block:(void(^)(id content))block
{
    NSDictionary *prama = @{@"registerId":[UserModel sharedUserInfo].userId, @"productId":productId};
    [LCNetWorkBase postWithMethod:@"api/order/open" Params:prama Completion:^(int code, id content) {
        if(code){
                block(content);
        }
    }];
}

@end
