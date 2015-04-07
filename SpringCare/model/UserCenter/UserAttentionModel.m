//
//  UserAttentionModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionModel.h"

static NSMutableArray *myAttentionArray = nil;

@implementation UserAttentionModel
@synthesize userid;
@synthesize username;
@synthesize ringNum;
@synthesize photoUrl;
@synthesize relation;
@synthesize address;

+ (NSArray*) GetMyAttentionArray
{
    if(myAttentionArray == nil)
    {
        myAttentionArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            UserAttentionModel *model = [[UserAttentionModel alloc] init];
            [myAttentionArray addObject:model];
        }
    }
    return myAttentionArray;
}

- (id) init
{
    self = [super init];
    if(self){
        userid = @"11111";
        username = @"罗纳尔多";
        ringNum = @"13608083607";
        photoUrl = @"";
        relation = @"朋友";
        address = @"程度时锦江区三圣花乡新福美林,程度时锦江区三圣花乡新福美林";
    }
    return self;
}

@end
