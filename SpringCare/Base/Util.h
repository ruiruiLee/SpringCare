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
    EnumTypeTimes,
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
    EnumOrderService,
    EnumOrderOther,
    EnumOrderPrepareForAssessment,
} OrderListType;

typedef enum : NSUInteger {
    EnumServiceTimeNight,
    EnumServiceTimeDay,
    EnumServiceTimeOneDay,
} ServiceTimeType;

typedef enum
{
    PushFromBcakground=0,   //在后台内存未回收时进入
    PushFromTerminate  //从中止了的应用程序进入
}PushType;

typedef enum : NSUInteger {
    EnumCouponTypeNotUse = 0,
    EnumCouponTypeUsed,
    EnumCouponTypeDisable,
    EnumCouponTypeExpire,
    EnumCouponTypeUnknown,
} EnumCouponType;

@interface Util : NSObject

/**
 * 获取图片文件资源，
 * 带图片的 长, 宽
 **/
+ (NSString*) getFullImageUrlPath:(NSString*) path;


+ (NSString*) convertDinstance:(float)distance;
/**
 * 获取时间的显示字符,精确到小时
 */
+ (NSDate*) getDateFromString:(NSString*) string;
+ (NSString*) StringFromDate:(NSDate*) date;
+ (NSDate*) convertDateFromString:(NSString*)string;
+ (NSArray*) convertTimeFromStringDate:(NSString*) stringdate;
+ (NSString*) convertStringFromDate:(NSDate*) date;
+ (NSString*) convertShotStrFromDate:(NSDate*) date;
+ (NSString*) orderTimeFromDate:(NSDate*) date;  //订单展示时间形式
+ (NSString *) reductionTimeFromOrderTime:(NSString *)orderTime;//逆转回来，和上面是一对
+ (NSInteger) GetAgeByBirthday:(NSString *) day;
+(NSString *) convertTimetoBroadFormat:(NSString*)inputDate;
+ (NSInteger)GetDayFromdate:(NSString *)inputDate;
+ (NSInteger)GetMonthFromdate:(NSString *)inputDate;

/*
 format yyyy-MM-dd HH:mm
 */
+ (NSInteger)GetHourFromdate:(NSDate *)inputDate;


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


+ (int) getAgeWithBirthday:(NSDate*) birthDate;

+ (UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize;

+ (UserSex) GetSexByName:(NSString*) string;

+ (NSString *) GetOrderServiceTime:(NSDate *) begin enddate:(NSDate *) end datetype:(DateType) datetype;

+ (ServiceTimeType) GetServiceTimeType:(NSDate *) begin;

+ (NSDate*) convertDateFromDateString:(NSString*)uiDate;

+ (NSString*) ChangeToUTCTime:(NSString*) time;

+ (NSString *) headerImagePathWith:(UserSex ) sex;

+ (BOOL) isOneDay:(NSDate *) begin end:(NSDate *) end;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)GetBtnBackgroundImage;

+ (BOOL) isDateShowFirstDate:(NSString *)date1 secondDate:(NSString *)date2;
+ (void)showAlertMessage:(NSString*)msg;
+ (void)PayForOrders:(NSDictionary*) dict Controller:(UIViewController*)weakSelf;
+ (NSString *)getCurrentVersion;
+ (void)updateVersion :(void(^)(NSArray *info))handleResponse;

+ (EnumCouponType) GetCouponsUseStatus:(NSInteger) status;

+ (void) StoreCity:(NSString *)city;
+ (void) DeleteCity;
+ (NSString *) GetStoreCity;

+ (NSString *) getSubStrings:(NSString *)string;

+ (CGFloat) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd;

@end
