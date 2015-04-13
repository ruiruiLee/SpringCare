//
//  LocationManagerObserver.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString *currentCity = nil;

@interface LocationManagerObserver : NSObject<CLLocationManagerDelegate>

@end
