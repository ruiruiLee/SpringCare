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
            self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];
            self.career = [muser objectForKey:@"career"];
            //self.intro = [muser objectForKey:@"intro"];
            self.chineseName = [muser objectForKey:@"chineseName"];
            self.locationPoint =[muser objectForKey:@"locationPoint"];
            self.userRecommendId = [(AVObject*)[muser objectForKey:@"user_recommend_re"] objectId];
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
    self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];
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
    
    
    self.userRecommendId = [(AVObject*)[muser objectForKey:@"user_recommend_re"] objectId];
}
-(BOOL)isLogin{
    if ( [AVUser currentUser]==nil) {
         return false;
    }
    else{
        return true;
    }
}

-(void)saveRecommendPhone:(NSString *)phone block:(void(^)(int code))block
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    if(self.userId != nil)
        [parmas setObject:self.userId forKey:@"registerId"];
    [parmas setObject:phone forKey:@"phone"];
    
    [LCNetWorkBase postWithMethod:@"api/recommend/save" Params:parmas Completion:^(int code, id content) {
        if(code == 1){
            if([content objectForKey:@"code"] != nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[content objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                if(block)
                    block(1);
            }
        }
    }];
}

-(void) setUserRecommendId:(NSString *)userRecommendId
{
    if(userRecommendId == nil)
        return;
    if([userRecommendId isEqualToString:_userRecommendId])
        return;
    
    _userRecommendId = userRecommendId;
    
    AVUser *muser = [AVUser currentUser];
    AVQuery *query = [AVQuery queryWithClassName:[(AVObject*)[muser objectForKey:@"user_recommend_re"] className]];
    AVObject *Recommend = [query getObjectWithId:_userRecommendId];
    
    self.userRecommendPhone = [Recommend objectForKey:@"phone"];
}

@end
