//
//  NurseListInfoModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseListInfoModel.h"
#import "AppDelegate.h"
#import "UserModel.h"

static NSMutableArray *nurseList = nil;
//static EnumNursePriceType modelType = EnumTypeUnKonwn;
//static NSMutableDictionary *pramaNurseDic = nil;
static NSInteger nurseTotal = 0;

@implementation DefaultLoverModel
@synthesize loverId;
@synthesize addr;

+ (DefaultLoverModel*) modelFromDictionary:(NSDictionary*) dic
{
    DefaultLoverModel *model = [[DefaultLoverModel alloc]init];
    model.loverId = [dic objectForKey:@"id"];
    model.addr = [dic objectForKey:@"addr"];
    
    return model;
}

@end

/***********
 ** PriceModel
 ***********/

@implementation PriceModel


+ (PriceModel*) modelFromDictionary:(NSDictionary*) dic
{
    PriceModel *model = [[PriceModel alloc] init];
    
    model.halfDay = [[dic objectForKey:@"halfDay"] integerValue];
    
    model.fullDay = [[dic objectForKey:@"fullDay"] integerValue];
    
    return model;
}

@end


/***********
** NurseListInfoModel
***********/

@implementation NurseListInfoModel
@synthesize name;
@synthesize detailIntro;
@synthesize nid;
@synthesize age;
@synthesize distance;
@synthesize birthPlace;
@synthesize sex;
@synthesize intro;
@synthesize headerImage;
@synthesize careAge;
@synthesize commentsNumber;
@synthesize commentsRate;


//详细部分
@synthesize isLoadDetail;

//+ (NSDictionary*) PramaNurseDic
//{
//    return pramaNurseDic;
//}

+ (NSMutableArray*)nurseListModel
{
    if(nurseList == nil){
        nurseList = [[NSMutableArray alloc] init];
    }
    return nurseList;
}

- (id)init
{
    self = [super init];
    if(self){
        isLoadDetail = NO;
    }
    return self;
}

- (NSDictionary*)dictionaryFromData:(NurseListInfoModel*) model
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    return result;
}

+ (NurseListInfoModel*)objectFromDictionary:(NSDictionary*) dic
{
    NurseListInfoModel *model = [[NurseListInfoModel alloc] init];
    if([dic objectForKey:@"Distance"] == nil || [[dic objectForKey:@"Distance"] isKindOfClass:[NSNull class]])
        model.Distance = 0;
    else
        model.Distance = [[dic objectForKey:@"Distance"] integerValue];
    model.name = [dic objectForKey:@"name"];
    if([dic objectForKey:@"age"] == nil || [[dic objectForKey:@"age"] isKindOfClass:[NSNull class]])
        model.age = 0;
    else
        model.age = [[dic objectForKey:@"age"] integerValue];
    model.birthPlace = [dic objectForKey:@"birthPlace"];
    model.careAge = [dic objectForKey:@"careAge"];
    model.detailIntro = [dic objectForKey:@"detailIntro"];
    model.headerImage = [dic objectForKey:@"headerImage"];
    model.nid = [dic objectForKey:@"id"];
    model.intro = [dic objectForKey:@"intro"];
    if(model.intro == nil)
        model.intro = @"";
    model.sex = [dic objectForKey:@"sex"];
    if([dic objectForKey:@"commentsNumber"] == nil || [[dic objectForKey:@"sex"] isKindOfClass:[NSNull class]])
        model.commentsNumber = 0;
    else
        model.commentsNumber = [[dic objectForKey:@"commentsNumber"] integerValue];
    if([dic objectForKey:@"commentsRate"] == nil || [[dic objectForKey:@"commentsRate"] isKindOfClass:[NSNull class]])
        model.commentsRate = 0;
    else
        model.commentsRate = [[dic objectForKey:@"commentsRate"] integerValue];
    
    model.pricemodel = [PriceModel modelFromDictionary:[dic objectForKey:@"prices"]];
    
    model.price = [[dic objectForKey:@"price"] integerValue];
    model.priceDiscount = [[dic objectForKey:@"priceDiscount"] integerValue];
    model.priceName = [dic objectForKey:@"priceName"];
    model.priceType = [[dic objectForKey:@"priceType"] integerValue];
    
    return model;
}

- (NurseListInfoModel*) modelWithNurseId:(NSString*) string
{
    for (int i = 0; i< [nurseList count]; i++) {
        NurseListInfoModel *model = [nurseList objectAtIndex:i];
        if([model.nid isEqualToString:string]){
            return model;
        }
    }
    return nil;
}

- (void) loadNurseDataWithPage:(int) pages type:(EnumNursePriceType) type key:(NSString*)key ordr:(NSString*) order sortFiled:(NSString*)sortFiled productId:(NSString*) productId block:(block) block
{
    if(pages == 0){
        [nurseList removeAllObjects];
    }

    NSInteger offset = pages * LIMIT_COUNT;
    if(offset >= [nurseList count])
        offset = [nurseList count];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    if ([cfAppDelegate currentCityModel]!=nil) {
        [dic setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];
    }
    if(LcationInstance.lat>0&&LcationInstance.lon>0){
        [dic setObject:[NSNumber numberWithDouble:LcationInstance.lon ] forKey:@"longitude"];
        [dic setObject:[NSNumber numberWithDouble:LcationInstance.lat ]forKey:@"latitude"];
    }
    if(productId != nil){
        productID =productId;
    }
    else{
         productID =[cfAppDelegate defaultProductId];
    }
     [dic setObject:productID forKey:@"productId"];
    [dic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
   
    [LCNetWorkBase postWithMethod:@"api/care/list" Params:dic Completion:^(int code, id content) {
        if(code){
    
                NSArray *results = [content objectForKey:@"rows"];
                nurseTotal = [[content objectForKey:@"total"] integerValue];
                if([results isKindOfClass:[NSArray class]]){
                    if(nurseList == nil){
                        nurseList = [[NSMutableArray alloc] init];
                    }
                    for (int i = 0; i <[results count]; i++) {
                        NSDictionary *dic = [results objectAtIndex:i];
                        if([[dic allKeys] count] > 0){
                            NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:dic];
                            [nurseList addObject:model];
                        }
                    }
                if(block){
                    block(code);
                }
            }
        }
    }];
}

- (void) loadNurseDataWithPage:(int) pages prama:(NSDictionary*)prama block:(CompletionBlock) block
{
    if(pages == 0){
        [nurseList removeAllObjects];
    }
     NSMutableDictionary *pramaNurseDic = [[NSMutableDictionary alloc] init];
    [pramaNurseDic setObject:productID forKey:@"productId"];
    [pramaNurseDic setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(offset >= [nurseList count])
        offset = [nurseList count];
    [pramaNurseDic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    if ([cfAppDelegate currentCityModel]!=nil) {
        [pramaNurseDic setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];
    }
    if(LcationInstance.lat>0&&LcationInstance.lon>0){
         [pramaNurseDic setObject:[NSNumber numberWithDouble:LcationInstance.lon ] forKey:@"longitude"];
         [pramaNurseDic setObject:[NSNumber numberWithDouble:LcationInstance.lat ]forKey:@"latitude"];
    }
    [pramaNurseDic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    NSArray *array = [prama allKeys];
    for (int  i = 0; i < [array count]; i++) {
        [pramaNurseDic setObject:[prama objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
    }
    
    [LCNetWorkBase postWithMethod:@"api/care/list" Params:pramaNurseDic Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSArray *results = [content objectForKey:@"rows"];
                nurseTotal = [[content objectForKey:@"total"] integerValue];
                
                NSMutableArray *result = [[NSMutableArray alloc] init];
                
                if([results isKindOfClass:[NSArray class]]){
                    for (int i = 0; i <[results count]; i++) {
                        NSDictionary *dic = [results objectAtIndex:i];
                        if([[dic allKeys] count] > 0){
                            NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:dic];
                            [nurseList addObject:model];
                            [result addObject:model];
                        }
                    }
                }
                if(block){
                    block(code, result);
                }
            }
        }
    }];
}

//- (void) loadetailDataWithproductId:(NSString*)productId block:(block) block
- (void) loadetailDataWithproductId:(NSString*)productId block:(void(^)(id content))block
{
//    [self LoadBaseInfoWithBlock:nil];
    
    NSDictionary *prama = @{@"registerId":[UserModel sharedUserInfo].userId, @"careId":self.nid, @"productId":productId};
    [LCNetWorkBase postWithMethod:@"api/order/open" Params:prama Completion:^(int code, id content) {
        if(code){
            block(content);
        }
    }];
}

- (void) LoadBaseInfoWithBlock:(block) block
{
    NSDictionary *prama = @{@"careId":self.nid};
    __weak NurseListInfoModel *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/care/BaseInfo" Params:prama Completion:^(int code, id content) {
        if(code == 1){
            if([content isKindOfClass:[NSDictionary class]]){
                if([content objectForKey:@"code"] == nil){
                    weakSelf.certList = [content objectForKey:@"certList"];
                }
            }
        }
        if(block){
            block(code);
        }
    }];
}

@end
