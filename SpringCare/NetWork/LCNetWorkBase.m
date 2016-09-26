//
//  LCNetWorkBase.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCNetWorkBase.h"
#import "ProjectDefine.h"
#import "SBJson.h"

@implementation LCNetWorkBase
@synthesize manager;

+ (id)sharedLCNetWorkBase
{
    static LCNetWorkBase *instance = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[LCNetWorkBase alloc] init];});
    return instance;
}

- (id)init
{
    self = [super init];
    if(self){
        [ProjectDefine shareProjectDefine];
    }
    
    return self;
}

- (void)requestWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion
{
    NSString *path = SERVER_ADDRESS;
    if (method != nil && method.length > 0) {
        path = [SERVER_ADDRESS stringByAppendingString:method];
    }
    
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
//        if (completion!=nil) {
//            completion(0, nil);
//        }
        return;
    }
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    manager = [AFHTTPSessionManager manager];
    
    [manager GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = responseObject;//[_parser objectWithData:(NSData *)responseObject];

        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, result);
        completion(1, result);
        [ProjectDefine removeRequestTag:Tag];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, error);
        [ProjectDefine removeRequestTag:Tag];
        if (error.code != -1001) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        if (completion!=nil) {
            completion(0, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //https
////    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    

}

- (void)postWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion
{
    NSString *path = SERVER_ADDRESS;
    if (method != nil && method.length > 0) {
        path = [SERVER_ADDRESS stringByAppendingString:method];
    }
    
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
//        if (completion!=nil) {
//            completion(0, nil);
//        }
        return;
    }
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    manager = [AFHTTPSessionManager manager];
    
    [manager POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [ProjectDefine removeRequestTag:Tag];
//        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = responseObject;

        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, result);
        if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"code"] != nil){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            if (completion!=nil) {
                completion(0, result);
            }

        }else{
            if (completion!=nil) {
                completion(1, result);
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [ProjectDefine removeRequestTag:Tag];
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, error);
        if (error.code != -1001) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
         if (completion!=nil) {
              completion(0, error);
         }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}




- (void)GetWithParams:(NSDictionary *)params Url:(NSString*)url Completion:(Completion)completion{
    manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"%@", responseObject);
        if (completion!=nil) {
            completion(1, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (completion!=nil) {
                completion(0, error.localizedDescription);
            }
    }];

}
- (void)postWithParams:(NSString*)params Url:(NSString*)url Completion:(Completion)completion
{
    NSLog(@"%@", url);
    NSString *soapLength = [NSString stringWithFormat:@"%ld", (unsigned long)[params length]];
    /**
     * 处理短时间内重复请求
     **/
//    manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
//    NSError *error = nil;
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        [formData appendPartWithFormData:[params dataUsingEncoding:NSUTF8StringEncoding] name:@"aaa"];
//        
//        int j = 0;
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *response = responseObject;
//        NSLog(@"%@", response);
//        if (completion!=nil) {
//            completion(1, response);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@", error);
//        if (completion!=nil) {
//            completion(0, error.localizedDescription);
//        }
//    }];
    
//    NSURLSessionTask *operation = [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *response = responseObject;
//        NSLog(@"%@", response);
//        if (completion!=nil) {
//            completion(1, response);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@", error);
//        if (completion!=nil) {
//            completion(0, error.localizedDescription);
//        }
//    }];
    
//    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
//    manager1.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    manager1.securityPolicy.allowInvalidCertificates = YES;
//    [manager1.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager1.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
//    NSError *error = nil;
//    NSMutableURLRequest *request = [manager1.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    AFHTTPRequestOperation *operation = [manager1 HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", response);
//        if (completion!=nil) {
//            completion(1, response);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", response);
//        if (completion!=nil) {
//            completion(0, response);
//        }
//    }];
//    [manager1.operationQueue addOperation:operation];
}

@end
