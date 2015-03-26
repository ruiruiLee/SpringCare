//
//  NurseListInfoModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseListInfoModel.h"

static NSMutableArray *nurseList = nil;

@implementation NurseListInfoModel

@synthesize nurseId;
@synthesize name;
@synthesize address;
@synthesize simpleIntro;
@synthesize detailIntro;
@synthesize mobile;
@synthesize comment;

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
        self.nurseId = @"1001";
        self.name = @"abcd";
        self.address = @"abcd";
        self.simpleIntro = @"abcd";
        self.detailIntro = @"abcd";
        self.mobile = @"abcd";
        self.comment = 1;
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
    model.nurseId = [dic objectForKey:@"id"];
    model.name = [dic objectForKey:@"name"];
    model.address = [dic objectForKey:@"address"];
    model.simpleIntro = [dic objectForKey:@""];
    model.detailIntro = [dic objectForKey:@""];
    model.mobile = [dic objectForKey:@""];
    model.comment = [[dic objectForKey:@""] integerValue];
    
    return model;
}

- (void) loadNurseDataWithPage:(int) pages
{
    [NurseListInfoModel nurseListModel];
    for (int i = 0; i < 15; i++) {
        NurseListInfoModel *model = [[NurseListInfoModel alloc] init];
        [nurseList addObject:model];
    }
}

@end
