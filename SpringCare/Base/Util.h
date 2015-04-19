//
//  Util.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "define.h"

typedef enum : NSUInteger {
    EnumMale = 1,
    EnumFemale = 0,
    EnumUnknown = 2,
} UserSex;

typedef enum : NSUInteger {
    EnumDateTypeUnknown,
    EnumTypeHalfDay,
    EnumTypeOneDay,
    EnumTypeOneWeek,
    EnumTypeOneMounth,
} DateType;

typedef enum : NSUInteger {
    EnumOrderStatusTypeNew,
    EnumOrderStatusTypeConfirm,
    EnumOrderStatusTypeServing,
    EnumOrderStatusTypeFinish,
    EnumOrderStatusTypeCancel,
    EnumOrderStatusTypeUnknown,
} OrderStatus;

typedef enum : NSUInteger {
    EnumTypeCommented,
    EnumTypeNoComment,
} CommentStatus;

typedef enum : NSUInteger {
    EnumTypePayed,
    EnumTypeNopay,
} PayStatus;

typedef enum : NSUInteger {
    EnumOrderAll,
    EnumOrderPrepareForAssessment,
} OrderListType;

typedef enum : NSUInteger {
    EnumServiceTimeNight,
    EnumServiceTimeDay,
    EnumServiceTimeOneDay,
} ServiceTimeType;

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

/**
 *@Method openCamera:
 *@Brief 打开照相机
 *@Param |currentViewController| 当前的viewcontroller
 **/
+ (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion;

/**
 *@Method openPhotoLibrary:
 *@Brief 打开相册
 *@Param |currentViewController| 当前的viewcontroller
 **/
+ (void)openPhotoLibrary:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion;

+ (NSString*) StringFromDate:(NSDate*)Date;

+ (int) getAgeWithBirthday:(NSString*) birthday;

+ (UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize;

+ (UserSex) GetSexByName:(NSString*) string;

+ (NSString *) GetOrderServiceTime:(NSDate *) begin enddate:(NSDate *) end datetype:(DateType) datetype;

+ (ServiceTimeType) GetServiceTimeType:(NSDate *) begin;

+ (NSDate*) convertDateFromDateString:(NSString*)uiDate;

+ (NSString*) ChangeToUTCTime:(NSString*) time;

+ (NSString *) headerImagePathWith:(UserSex ) sex;

+ (NSInteger) GetAgeByBirthday:(NSString *) day;

@end
