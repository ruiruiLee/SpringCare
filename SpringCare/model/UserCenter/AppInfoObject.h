//
//  AppInfoObject.h
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"



@interface AppInfoObject : NSObject

@property (nonatomic, strong) NSArray *appArray;


- (void) LoadAppInfo;

@end
