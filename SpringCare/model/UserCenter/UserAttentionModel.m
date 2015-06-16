//
//  UserAttentionModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionModel.h"

#import "UserModel.h"
#import "UserRequestAcctionModel.h"
#import "define.h"

static NSMutableArray *myAttentionArray = nil;

@implementation UserAttentionModel
@synthesize userid;
@synthesize username;
@synthesize ringNum;
@synthesize photoUrl;
@synthesize relation;
@synthesize address;
@synthesize isCare;
@synthesize age;
@synthesize sex;
@synthesize height;
@synthesize relationId;

+ (NSMutableArray*) GetMyAttentionArray
{
    if(myAttentionArray == nil)
    {
        myAttentionArray = [[NSMutableArray alloc] init];
    }
    return myAttentionArray;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)RemoveObjectFromArray:(NSNotification *) notify
{
    [myAttentionArray removeAllObjects];
}

- (id) init
{
    self = [super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveObjectFromArray:) name:Notify_Register_Logout object:nil];
        
    }
    return self;
}

+ (UserAttentionModel*) modelFromDIctionary:(NSDictionary*)dic
{
    UserAttentionModel *model = [[UserAttentionModel alloc] init];
    model.userid = [dic objectForKey:@"id"];
    model.username = [dic objectForKey:@"name"];
    if(model.username == nil)
        model.username = @"";
    model.ringNum = [dic objectForKey:@"phone"];
    model.photoUrl = [dic objectForKey:@"headerImage"];
    model.relation = [dic objectForKey:@"nickname"];
    if(model.relation == nil)
        model.relation = @"";
    model.address = [dic objectForKey:@"addr"];
    if(model.address == nil)
        model.address = @"";
    model.isCare = [[dic objectForKey:@"isCare"] boolValue];
    model.sex = [dic objectForKey:@"sex"];
    if(![[dic objectForKey:@"height"] isKindOfClass:[NSNull class]])
        model.height = [[dic objectForKey:@"height"] integerValue];
    else
        model.height = 0;

    if([dic objectForKey:@"birthDay"] == nil)
        model.age = @"";
    else{
        model.age = [NSString stringWithFormat:@"%d", [Util GetAgeByBirthday:[[dic objectForKey:@"birthDay"] substringToIndex:10]]];
    }
    
    model.relationId = [dic objectForKey:@"relationId"];
    
    return model;
}


+ (void) loadLoverList:(NSString*)needRequest block:(block) block
{
    if(!myAttentionArray){
        myAttentionArray = [[NSMutableArray alloc] init];
        
    }
    [myAttentionArray removeAllObjects];
    NSDictionary *dic = @{@"registerId" :  [UserModel sharedUserInfo].userId, @"isLoadRequest" :needRequest};
    [LCNetWorkBase postWithMethod:@"api/lover/list" Params:dic Completion:^(int code, id content) {
        if(code){
            NSArray *lovers = [content objectForKey:@"lovers"];
            for (int  i = 0; i < [lovers count]; i++) {
                NSDictionary *dic = [lovers objectAtIndex:i];
                UserAttentionModel *model = [self modelFromDIctionary:dic];
                [myAttentionArray addObject:model];
            }
            if([content objectForKey:@"requests"]!=nil){
            NSArray *requests = [content objectForKey:@"requests"];
            [UserRequestAcctionModel SetRequestAcctionArrayWithArray:requests];
            }
            if(block){
                block(1);
            }
        }
    }];
}

- (void) deleteAttention:(block) block
{
    if(self.isCare){
        NSDictionary *dic = @{@"registerId":[UserModel sharedUserInfo].userId, @"loverId":userid};
        [LCNetWorkBase postWithMethod:@"api/oneLover/delete" Params:dic Completion:^(int code, id content) {
            if(code){
                [myAttentionArray removeObject:self];
                if(block)
                    block(1);
            }
        }];
    }else{
        NSDictionary *dic = @{@"registerId":[UserModel sharedUserInfo].userId, @"loverId":userid};
        [LCNetWorkBase postWithMethod:@"api/lover/delete" Params:dic Completion:^(int code, id content) {
            if(code){
                [myAttentionArray removeObject:self];
                if(block)
                    block(1);
            }
        }];
    }
}

@end
