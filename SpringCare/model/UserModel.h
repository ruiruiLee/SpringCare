//
//  UserModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "define.h"

@interface UserModel : NSObject


@property (nonatomic, copy) NSString *mobilePhoneNumber;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, copy) NSString *headerFile;
@property (nonatomic, copy) NSString *userId;//用户id

//详情
//@property (nonatomic, strong) NSString *registerId;//注册用户扩展表id
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSDate *birthDay;
@property (nonatomic, copy) NSString *career;
//@property (nonatomic, strong) NSString *intro;
@property (nonatomic, copy) NSString *chineseName;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) AVGeoPoint *locationPoint;
//@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, copy) NSString *currentDetailAdrress;

@property (nonatomic, copy) NSString *userRecommendId;//邀请码关联对象
@property (nonatomic, copy) NSString *userRecommendPhone;//邀请码关联对象

+(UserModel *)sharedUserInfo;

-(BOOL)isLogin;
-(void)modifyInfo;
-(void)modifyLocation:(NSString*)detailAddress;
-(void)saveRecommendPhone:(NSString *)phone block:(void(^)(int code))block;

@end
