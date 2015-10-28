//
//  LCNetWorkBase.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/*
 正式
 */
//#define SERVER_ADDRESS @"http://spring.avosapps.com/"

/*
 测试
 */
//#define SERVER_ADDRESS @"http://dev.spring.avosapps.com/"
#define SERVER_ADDRESS @"http://dev.springcare.avosapps.com/"

typedef void(^Completion) (int code, id content);

@interface LCNetWorkBase : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

+ (id)sharedLCNetWorkBase;

- (void)requestWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion;

- (void)postWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion;

- (void)postWithParams:(NSString*)params Url:(NSString*)url Completion:(Completion)completion;

- (void)GetWithParams:(NSDictionary *)params Url:(NSString*)url Completion:(Completion)completion;

@end
