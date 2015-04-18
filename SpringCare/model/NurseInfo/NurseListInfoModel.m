//
//  NurseListInfoModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseListInfoModel.h"
#import "AppDelegate.h"
#import "LCNetWorkBase.h"
#import "CityDataModel.h"
#import "UserModel.h"

static NSMutableArray *nurseList = nil;
static EnumNursePriceType modelType = EnumTypeUnKonwn;
static NSMutableDictionary *pramaNurseDic = nil;

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

@implementation NurseListInfoModel
@synthesize name;
@synthesize detailIntro;
@synthesize nid;
@synthesize age;
@synthesize distance;
@synthesize birthPlace;
@synthesize sex;
@synthesize priceDiscount;
@synthesize price;
@synthesize intro;
@synthesize headerImage;
@synthesize careAge;
@synthesize commentsNumber;
@synthesize commentsRate;
@synthesize addr;

//详细部分
@synthesize isLoadDetail;

+ (NSDictionary*) PramaNurseDic
{
    return pramaNurseDic;
}

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
    model.Distance = [[dic objectForKey:@"Distance"] integerValue];
    model.name = [dic objectForKey:@"name"];
    model.age = [[dic objectForKey:@"age"] integerValue];
    model.birthPlace = [dic objectForKey:@"birthPlace"];
    model.careAge = [dic objectForKey:@"careAge"];
    model.detailIntro = [dic objectForKey:@"detailIntro"];
    model.headerImage = [dic objectForKey:@"headerImage"];
    model.nid = [dic objectForKey:@"id"];
    model.intro = [dic objectForKey:@"intro"];
    model.price = [[dic objectForKey:@"price"] integerValue];
    model.priceDiscount = [[dic objectForKey:@"priceDiscount"] integerValue];
    model.sex = [dic objectForKey:@"sex"];
    model.commentsNumber = [[dic objectForKey:@"commentsNumber"] integerValue];
    model.commentsRate = [[dic objectForKey:@"commentsRate"] integerValue];
    
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
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    double lon = delegate._observer.lon;
    double lat = delegate._observer.lat;
    NSString *cityId = delegate.currentCityModel.city_id;
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(offset >= [nurseList count])
        offset = [nurseList count];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [dic setObject:[NSNumber numberWithDouble:lon] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithDouble:lat] forKey:@"latitude"];
    if(sortFiled != nil)
        [dic setObject:sortFiled forKey:@"sortFiled"];
    if(productId != nil)
        [dic setObject:productId forKey:@"productId"];
    if(order == nil)
        order = @"asc";
    [dic setObject:order forKey:@"order"];
    if(!(key == nil || [key length] == 0))
        [dic setObject:key forKey:@"key"];
    if(cityId != nil)
        [dic setObject:cityId forKey:@"cityId"];
    [dic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
    pramaNurseDic = dic;
    
    [LCNetWorkBase postWithMethod:@"api/care/list" Params:dic Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSArray *results = [content objectForKey:@"results"];
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
                }
                if(block){
                    block(code);
                }
            }
        }
    }];
}

- (void) loadNurseDataWithPage:(int) pages prama:(NSDictionary*)prama block:(block) block
{
    if(pages == 0){
        [nurseList removeAllObjects];
    }
    
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(offset >= [nurseList count])
        offset = [nurseList count];
    [pramaNurseDic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
    NSArray *array = [prama allKeys];
    for (int  i = 0; i < [array count]; i++) {
        [pramaNurseDic setObject:[prama objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
    }
    [LCNetWorkBase postWithMethod:@"api/care/list" Params:pramaNurseDic Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSArray *results = [content objectForKey:@"results"];
                if([results isKindOfClass:[NSArray class]]){
                    for (int i = 0; i <[results count]; i++) {
                        NSDictionary *dic = [results objectAtIndex:i];
                        if([[dic allKeys] count] > 0){
                            NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:dic];
                            [nurseList addObject:model];
                        }
                    }
                }
                if(block){
                    block(code);
                }
            }
        }
    }];
}

- (void) loadetailDataWithproductId:(NSString*)productId block:(block) block
{
//    NurseListInfoModel *model = [self modelWithNurseId:self.nid];
//    if(model == nil)
//    {
//        block(0);
//    }
//    else{
        NSDictionary *prama = @{@"currentUserId":[UserModel sharedUserInfo].userId, @"careId":self.nid, @"productId":productId};
        [LCNetWorkBase postWithMethod:@"api/order/open" Params:prama Completion:^(int code, id content) {
            if(code){
                NSDictionary *dic = [content objectForKey:@"care"];
                self.addr = [dic objectForKey:@"addr"];
                self.isLoadDetail = YES;
                
                NSArray *array = [dic objectForKey:@"defaultLover"];
//                model.defaultLoverArray = [];
                NSMutableArray *marray = [[NSMutableArray alloc] init];
                for (int i= 0; i< [array count]; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    DefaultLoverModel *lmmodel = [DefaultLoverModel modelFromDictionary:dic];
                    [marray addObject:lmmodel];
                }
                self.defaultLoverArray = marray;
                self.detailIntro = [dic objectForKey:@"detailIntro"];
            }
        }];
//    }
}

@end
