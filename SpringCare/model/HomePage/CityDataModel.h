//
//  CityDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDataModel : NSObject

@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *city_name;
//@property (nonatomic, assign) double latitude;
//@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *short_name;

+ (NSArray*) getCityData;

+ (void) SetCityDataWithArray:(NSArray*) list;

+ (CityDataModel*) modelWithName:(NSString*) name;

@end
