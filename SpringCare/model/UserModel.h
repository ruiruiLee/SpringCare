//
//  UserModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"
 #import <AVOSCloud/AVOSCloud.h>
@interface UserModel : NSObject
{
}


@property (nonatomic, strong) NSString *mobilePhoneNumber;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *username;
//@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *headerFile;
@property (nonatomic, strong) NSString *userId;//用户id

//详情
//@property (nonatomic, strong) NSString *registerId;//注册用户扩展表id
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSDate *birthDay;
@property (nonatomic, strong) NSString *career;
//@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *chineseName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) AVGeoPoint *locationPoint;
//@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentDetailAdrress;
+(UserModel *)sharedUserInfo;

-(BOOL)isLogin;
-(void)modifyInfo;
-(void)modifyLocation:(NSString*)detailAddress;
@end
