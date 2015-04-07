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

+ (NSArray*) GetRequestAcctionArray
{
    if(requestAcctionArray == nil)
    {
        requestAcctionArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            UserRequestAcctionModel *model = [[UserRequestAcctionModel alloc] init];
            [requestAcctionArray addObject:model];
        }
    }
    return requestAcctionArray;
}

- (id) init
{
    self = [super init];
    if(self){
        userid = @"11111";
        username = @"罗纳尔多";
        photoUrl = @"";
        isAccept = NO;
    }
    return self;
}

@end
