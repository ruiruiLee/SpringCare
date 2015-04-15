//
//  UserModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize isLogin;
@synthesize isNew;
@synthesize username;
@synthesize sessionToken;
@synthesize email;
@synthesize mobilePhoneNumber;
@synthesize headerFile;

+(UserModel *)sharedUserInfo
{
    static dispatch_once_t onceToken;
    static UserModel *user = nil;
    dispatch_once(&onceToken, ^{
        user = [[UserModel alloc]init];
    });
    return user;
}

- (id)init
{
    self = [super init];
    if(self){
        isLogin = NO;
    }
    return self;
}

@end
