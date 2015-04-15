//
//  UserModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) NSString *mobilePhoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *headerFile;
@property (nonatomic, strong) NSString *userId;

+(UserModel *)sharedUserInfo;

@end
