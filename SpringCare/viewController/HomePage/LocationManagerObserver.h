//
//  LocationManagerObserver.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManagerObserver : NSObject<CLLocationManagerDelegate>

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy) NSString* currentCity ;
- (void) startUpdateLocation;
+ (LocationManagerObserver *)sharedInstance;
//+ (NSString*) getCurrentCityName;

@end
