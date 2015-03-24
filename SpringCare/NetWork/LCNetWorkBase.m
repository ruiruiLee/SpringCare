//
//  LCNetWorkBase.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCNetWorkBase.h"
#import "define.h"
#import <AFNetworking.h>
#import "SBJson.h"
#import "ProjectDefine.h"

@implementation LCNetWorkBase

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (void)requestWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion
{
    NSString *path = SERVER_ADDRESS;
    if (method != nil && method.length > 0) {
        path = [SERVER_ADDRESS stringByAppendingString:method];
    }
    
    /**
     * 处理短时间内重复请求
     **/
//    if ([ProjectDefine searchRequestTag:path]) {
//        return;
//    }else{
//        [ProjectDefine addRequestTag:path];
//    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //https
//    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithData:(NSData *)responseObject];//[(NSData *)responseObject objectFromJSONData];
        
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, result);
        completion(1, result);
        if([[result objectForKey:@"resultCode"] integerValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
//        [ProjectDefine removeRequestTag:path];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //服务器请求超时不提示
        
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, error);
        if (error.code != -1001) {
            completion(0, error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
//        [ProjectDefine removeRequestTag:path];
    }];
}

+ (void)postWithParams:(NSString*)params Url:(NSString*)url Completion:(Completion)completion
{
    NSLog(@"%@", url);
    NSString *soapLength = [NSString stringWithFormat:@"%ld", (unsigned long)[params length]];
    
    /**
     * 处理短时间内重复请求
     **/
//    NSString *path = [NSString stringWithFormat:@"%@%@", url, params];
//    if ([ProjectDefine searchRequestTag:path]) {
//        return;
//    }else{
//        [ProjectDefine addRequestTag:path];
//    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    NSError *error = nil;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
//        [ProjectDefine removeRequestTag:path];
        NSLog(@"%@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
        
//        [ProjectDefine removeRequestTag:path];
        NSLog(@"%@", response);
    }];
    [manager.operationQueue addOperation:operation];
}

@end
