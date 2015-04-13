//
//  Util.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 * 获取图片文件资源，
 * 带图片的 长, 宽
 **/
+ (NSString*) getFullImageUrlPath:(NSString*) path;

/**
 * 获取时间的显示字符,精确到分
 */
+ (NSString*) getStringFromDate:(NSDate*) date;

+ (NSDate*) getDateFromString:(NSString*) string;

/**
 * 获取时间的显示字符,精确到小时
 */
+ (NSDate*) convertDateFromString:(NSString*)uiDate;

+ (NSString*) StringFromDate:(NSDate*)Date;

@end
