//
//  UserRequestAcctionModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserRequestAcctionModel.h"

static NSMutableArray *requestAcctionArray = nil;

@implementation UserRequestAcctionModel
@synthesize userid;
@synthesize username;
@synthesize isAccept;
@synthesize photoUrl;
@synthesize phone;

+ (NSArray*) GetRequestAcctionArray
{
    if(requestAcctionArray == nil)
    {
        requestAcctionArray = [[NSMutableArray alloc] init];
    }
    return requestAcctionArray;
}

- (id) init
{
    self = [super init];
    if(self){
    }
    return self;
}

+ (UserRequestAcctionModel*) modelFromDictionary:(NSDictionary*) dic
{
    UserRequestAcctionModel *model = [[UserRequestAcctionModel alloc] init];
    model.userid = [dic objectForKey:@"id"];
    model.username = [dic objectForKey:@"chinese_name"];
    model.isAccept = [[dic objectForKey:@"is_agree"] boolValue];
    model.photoUrl = [dic objectForKey:@"header_image"];
    model.phone = [dic objectForKey:@"phone"];
    
    return model;
}

+ (void) SetRequestAcctionArrayWithArray:(NSArray*) array
{
    if(requestAcctionArray == nil){
        requestAcctionArray = [[NSMutableArray alloc] init];
    }
    [requestAcctionArray removeAllObjects];
    
    for(int i = 0; i< [array count]; i++){
        NSDictionary *dic = [array objectAtIndex:i];
        UserRequestAcctionModel *model = [UserRequestAcctionModel modelFromDictionary:dic];
        [requestAcctionArray addObject:model];
    }
}

@end
