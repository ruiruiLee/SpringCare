//
//  AppInfo.m
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+ (AppInfo*) modelWithDictionary:(NSDictionary*) dic
{
    AppInfo *model = [[AppInfo alloc] init];
    
    model.imgUrl = [dic objectForKey:@"imgUrl"];
    model.title = [dic objectForKey:@"title"];
    model.url = [dic objectForKey:@"iosUrl"];
    
    return model;
}

@end
