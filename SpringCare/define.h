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

#define NOTIFY_LOCATION_GAINED  @"NOTIFY_LOCATION_GAINED"
#define NOTIFY_PICKVIEW_HIDDEN @"NOTIFY_PICKVIEW_HIDDEN"
#define Notify_Comment_Changed @"Notify_Comment_Changed"






#define LCNetWorkBase [LCNetWorkBase sharedLCNetWorkBase]
#define KEY_APPLE_ID @"702715314"

#define cfAppDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define  numberOfLineLimit 5

#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//#FF2A66
#define RGBwithHex(hex) _COLOR(((float)((hex & 0xFF0000) >> 16)),((float)((hex & 0xFF00) >> 8)),((float)(hex & 0xFF)))

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]

// 订单列表页面没有数据的时候 加载的图片
#define orderBackbroundImg ThemeImage(@"orderend")

#define LcationInstance [LocationManagerObserver sharedInstance]

#define CityID @"552cf514e4b02ec896e6cdbf"
#define CityName @"成都市"

// 支付
#define kUrlScheme      @"springcarepayschemes"
#define kUrl            @"YOUR-URL"


//语音存放地址
#define SpeechMaxTime 60.0f

#define chat_VoiceCache_path [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"]

#define chat_VoiceCache_file(_fileName) [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"] stringByAppendingPathComponent:_fileName]

//首页海报图片压缩比例大小
#define imgCoverSize CGSizeMake(750, 508)
#define imgHeaderSize CGSizeMake(200, 200)

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
#define TableSectionBackgroundColor _COLORa(241, 241, 241,0.8) //_COLORa(0xf3, 0xf5, 0xf7,0.9)

#define TIME_LIMIT 5
#define LIMIT_COUNT 20

typedef void(^block)(int code);
typedef void(^CompletionBlock)(int code, id content);

#endif
