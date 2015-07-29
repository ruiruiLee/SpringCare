//
//  define.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#ifndef LovelyCare_define_h
#define LovelyCare_define_h

#import "Util.h"
#import "NSStrUtil.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "LCNetWorkBase.h"


#define NOTIFY_PICKVIEW_HIDDEN @"NOTIFY_PICKVIEW_HIDDEN"
#define Notify_Resign_First_Responder @"Notify_Resign_First_Responder"
#define Notify_Register_Logout @"Notify_Register_Logout"



#define Service_Methord @"buspromotion/detailInfo/"

#define Care_Introduce @"55288db3e4b0da2c5df90b29"//护理介绍
#define Care_Promiss @"55288e01e4b0da2c5df90e9f"//护理承若
#define About_Us @"5544ad2ee4b03fd8342e9c19"//关于我们
#define Care_Agreement @"5544af16e4b03fd8342eb2d3"//用户协议
#define CouponExplain @"55696adce4b0349d3326183a"//使用说明


#define LCNetWorkBase [LCNetWorkBase sharedLCNetWorkBase]


#define cfAppDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define  numberOfLineLimit 5

#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//#FF2A66
#define RGBwithHex(hex) _COLOR(((float)((hex & 0xFF0000) >> 16)),((float)((hex & 0xFF00) >> 8)),((float)(hex & 0xFF)))



// 订单列表页面没有数据的时候 加载的图片
#define noOrderBackbroundImg ThemeImage(@"noOrderBackground")
#define noCareBackbroundImg ThemeImage(@"noCare")
// 陪护时光无数据时加载的页面。
#define TimeBackbroundImg ThemeImage(@"default_bg")

#define LcationInstance [LocationManagerObserver sharedInstance]

//#define CityID @"552cf514e4b02ec896e6cdbf"
#define CityName @"成都市"

//下载更新
#define apkUrl @"http://itunes.apple.com/lookup"
//#define KEY_APPLE_ID @"702715314"
#define KEY_APPLE_ID @"992339154"

// 支付
#define kUrlScheme      @"wx039f05e7e07b0fca"
//#define kUrl            @"http://spring.avosapps.com/api/order/pay/getToken"
#define kUrl            @"api/order/pay/getToken"


//语音存放地址
#define SpeechMaxTime 60.0f

#define chat_VoiceCache_path [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"]

#define chat_VoiceCache_file(_fileName) [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"] stringByAppendingPathComponent:_fileName]

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]

//首页海报图片压缩比例大小
//#define imgCoverSize CGSizeMake(750, 508)
#define imgHeaderSize CGSizeMake(200, 200)


#define FormatImage(imageUrl,imageWidth,imageHeight) [NSString stringWithFormat:@"%@?imageView/2/w/%d/h/%d", imageUrl,imageWidth,imageHeight]
#define FormatImage_1(imageUrl,imageWidth,imageHeight) [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", imageUrl,imageWidth,imageHeight]

//首页海报以及产品图片压缩比例大小
#define PostersImage(imageUrl) FormatImage(imageUrl,500,300)
#define PostersImage4s(imageUrl) FormatImage(imageUrl,500,300)
#define ProductImage(imageUrl) FormatImage(imageUrl,400,200)

//应用里头像处理尺寸
#define HeadImage(imageUrl) FormatImage(imageUrl,150,150)

#define TimesImage(imageUrl) FormatImage(imageUrl,200,200)

#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT_B(s) [UIFont boldSystemFontOfSize:(s)]

#define _IPHONE_OS_VERSION_UNDER_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define Nav_Title_Color [UIColor WhiteColor]

//陪护时光中用来确定内容的长度
#define Content_Width [UIScreen mainScreen].bounds.size.width - 100

//
#define Disabled_Color  _COLOR(0x8f, 0x8f, 0x97)
#define Abled_Color  [UIColor colorWithRed:(0x27)/255.0 green:(0xa6)/255.0 blue:(0x69)/255.0 alpha:1]

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define Place_Holder_Image  nil//[UIImage imageNamed:@""]

#define Photo_Place_Holder_Image  nil

#define SeparatorLineColor  _COLOR(0xd7, 0xd7, 0xd7)
#define TableBackGroundColor    _COLOR(0xf8, 0xf8, 0xf8)
#define TableSectionBackgroundColor _COLORa(241, 241, 241,0.9) //_COLORa(0xf3, 0xf5, 0xf7,0.9)

#define TIME_LIMIT 5
#define LIMIT_COUNT 20

typedef void(^block)(int code);
typedef void(^CompletionBlock)(int code, id content);

#endif
