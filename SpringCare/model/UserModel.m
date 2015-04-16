//
//  UserModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserModel.h"
#import "LCNetWorkBase.h"
 #import <AVOSCloud/AVOSCloud.h>
@implementation UserModel
@synthesize isNew;
@synthesize username;
@synthesize sessionToken;
@synthesize email;
@synthesize mobilePhoneNumber;
@synthesize headerFile;
@synthesize userId;

//
@synthesize registerId;
@synthesize sex;
@synthesize addr;
@synthesize birthDay;
@synthesize career;
@synthesize intro;
@synthesize chineseName;

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
    return self;
}

-(BOOL)isLogin{
   
    if ( [AVUser currentUser]==nil) {
        return false;
    }
    else
        return true;
}
- (void) setUserId:(NSString *)_userId
{
    userId = _userId;
    [self getDetailUserInfo];
}

- (void) getDetailUserInfo
{
    NSDictionary *dic = @{@"id" : self.userId};
    [LCNetWorkBase postWithMethod:@"api/register/detail" Params:dic Completion:^(int code, id content) {
        if(code){
            self.registerId = [content objectForKey:@"registerId"];
            self.sex = [content objectForKey:@"sex"];
            self.addr = [content objectForKey:@"addr"];
            self.birthDay = [content objectForKey:@"birthDay"];
            self.career = [content objectForKey:@"career"];
            self.intro = [content objectForKey:@"intro"];
            self.chineseName = [content objectForKey:@"chineseName"];
            self.mobilePhoneNumber = [content objectForKey:@"phone"];
        }
    }];
}

@end
