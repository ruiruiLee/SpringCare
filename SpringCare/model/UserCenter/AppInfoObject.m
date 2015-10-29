//
//  AppInfoObject.m
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "AppInfoObject.h"
#import "define.h"


@implementation AppInfoObject

- (void) LoadAppInfo
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    [LCNetWorkBase postWithMethod:@"api/system/app" Params:parmas Completion:^(int code, id content) {
        if(code){
            
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSArray *array = [content objectForKey:@"rows"];
            if(array != nil && [array isKindOfClass:[NSArray class]]){
                for (int  i = 0; i < [array count]; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    AppInfo *info = [AppInfo modelWithDictionary:dic];
                    [result addObject:info];
                }
                
                self.appArray = result;
            }
        }
    }];
}

@end
