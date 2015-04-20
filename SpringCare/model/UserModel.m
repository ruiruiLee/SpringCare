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
    if (self = [super init]) {
        if ( ![[AVUser currentUser]isEqual: nil]) {
            AVUser *user = [AVUser currentUser];
            self.userId= user.objectId;
            self.mobilePhoneNumber= user.mobilePhoneNumber;
            self.sessionToken = user.sessionToken;
            self.username = user.username;
            self.mobilePhoneNumber = user.mobilePhoneNumber;
            self.isNew = user.isNew;
            self.email = user.email;
            //self.headerFile = ((AVFile*)[user objectForKey:@"header_image"]).url;
            //self.chineseName = [user objectForKey:@"chinese_name"];
         }
    }
    
    return self;
}
-(BOOL)isLogin{
    if ( [AVUser currentUser]==nil) {
         return false;
    }
    else{
        if (self.registerId==nil) {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self getDetailUserInfo];
             });
        }
        return true;
    }
}

- (void) getDetailUserInfo
{
    NSDictionary *dic = @{@"id" : self.userId};
    [LCNetWorkBase postWithMethod:@"api/register/detail" Params:dic Completion:^(int code, id content) {
        if(code){
            self.registerId = [content objectForKey:@"registerId"];
            self.sex = [content objectForKey:@"sex"];
            self.addr = [content objectForKey:@"addr"];
            self.birthDay = [content objectForKey:@"birthDay"];  //日期
            self.career = [content objectForKey:@"career"];
            self.intro = [content objectForKey:@"intro"];
            self.chineseName = [content objectForKey:@"chineseName"];
            self.headerFile = [content objectForKey:@"headerImage"];
        }
    }];
}

@end
