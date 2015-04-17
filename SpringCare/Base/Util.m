//
//  Util.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString*) getFullImageUrlPath:(NSString*) path
{
    return @"";
}

+ (NSString*) getStringFromDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

+ (NSDate*) getDateFromString:(NSString*) string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

+ (NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+ (NSString*) StringFromDate:(NSDate*)Date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *string = [formatter stringFromDate:Date];
    return string;
}

+ (int) getAgeWithBirthday:(NSString*) birthday
{
    int birth = [[birthday substringToIndex:4] intValue];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    int year = (int)[comps year];
    
    return (year - birth);
}

//图像等比例压缩 .充满空隙

+(UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize
{
    if (!image)
    {
        return nil;
    }
    if (image.size.width<tosize.width && image.size.height<tosize.height)
    {
        return image;
    }
    CGFloat wscale = image.size.width/tosize.width;
    CGFloat hscale = image.size.height/tosize.height;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UserSex) GetSexByName:(NSString*) string
{
    if(string == nil)
        return EnumUnknown;
    if([string isEqualToString:@"男"])
        return EnumMale;
    else if ([string isEqualToString:@"女"])
        return EnumFemale;
    else
        return EnumUnknown;
}

@end
