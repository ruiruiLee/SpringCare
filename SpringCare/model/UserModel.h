//
//  UserModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface UserModel : NSObject
{
}


@property (nonatomic, strong) NSString *mobilePhoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *headerFile;
@property (nonatomic, strong) NSString *userId;//用户id

//详情
@property (nonatomic, strong) NSString *registerId;//注册用户扩展表id
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthDay;
@property (nonatomic, strong) NSString *career;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *chineseName;

+(UserModel *)sharedUserInfo;

-(BOOL)isLogin;
- (void) getDetailUserInfo;

@end
