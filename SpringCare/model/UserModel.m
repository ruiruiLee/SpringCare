//
//  UserModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
//@synthesize isNew;
@synthesize username;
//@synthesize sessionToken;
//@synthesize email;
@synthesize mobilePhoneNumber;
@synthesize headerFile;
@synthesize userId;

@synthesize sex;
@synthesize addr;
@synthesize birthDay;
@synthesize career;
//@synthesize intro;
@synthesize chineseName;

+(UserModel *)sharedUserInfo
{
    static dispatch_once_t onceToken;
    static UserModel *user = nil;
    dispatch_once(&onceToken, ^{
        user = [[UserModel alloc] init];
    });
    return user;
}

- (id)init
{
    if (self = [super init]) {
        AVUser *muser = [AVUser currentUser];
        if ( muser!=nil) {
            self.userId= muser.objectId;
            self.mobilePhoneNumber= muser.mobilePhoneNumber;
            //self.sessionToken = muser.sessionToken;
            self.username = muser.username;
            self.isNew = muser.isNew;
            //self.email = muser.email;
            self.sex = [[muser objectForKey:@"sex"] boolValue]?@"男":@"女";
            self.addr = [muser objectForKey:@"addr"];
            self.birthDay = [muser objectForKey:@"birthDay"];  //日期
            self.career = [muser objectForKey:@"career"];
            //self.intro = [muser objectForKey:@"intro"];
            self.chineseName = [muser objectForKey:@"chineseName"];
            self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];
            self.locationPoint =[muser objectForKey:@"locationPoint"];
        }
    }
    return self;
}
-(NSString*) displayName{
    if (self.chineseName.length==0) {
        
        return self.mobilePhoneNumber;
    }
    else{
        return self.chineseName;
    }
}
-(void)modifyLocation:(NSString*)detailAddress{
     self.locationPoint =[[AVUser currentUser] objectForKey:@"locationPoint"];
    if (detailAddress) {
            self.currentDetailAdrress= detailAddress;
    }
}
-(void)modifyInfo{
    AVUser *muser = [AVUser currentUser];
    self.userId= muser.objectId;
    self.mobilePhoneNumber= muser.mobilePhoneNumber;
    //self.sessionToken = muser.sessionToken;
    self.username = muser.username;
    self.isNew = muser.isNew;
    //self.email = muser.email;
    self.sex = [[muser objectForKey:@"sex"] boolValue]?@"男":@"女";
    self.addr = [muser objectForKey:@"addr"];
    self.birthDay = [muser objectForKey:@"birthDay"];  //日期
    self.career = [muser objectForKey:@"career"];
    //self.intro = [muser objectForKey:@"intro"];
    self.chineseName = [muser objectForKey:@"chineseName"];
    self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];

}
-(BOOL)isLogin{
    if ( [AVUser currentUser]==nil) {
         return false;
    }
    else{
        return true;
    }
}


@end
