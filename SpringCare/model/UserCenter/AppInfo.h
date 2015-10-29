//
//  AppInfo.h
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

+ (AppInfo*) modelWithDictionary:(NSDictionary*) dic;

@end
