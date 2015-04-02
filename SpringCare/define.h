//
//  define.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#ifndef LovelyCare_define_h
#define LovelyCare_define_h


#define SERVER_ADDRESS @"http://baidu.com"
//#define SERVER_ADDRESS @"http://baidu.com"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width


#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT_B(s) [UIFont boldSystemFontOfSize:(s)]

#define _IPHONE_OS_VERSION_UNDER_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define Nav_Title_Color [UIColor WhiteColor]

//陪护时光中用来确定内容的长度
#define Content_Width [UIScreen mainScreen].bounds.size.width - 80

//
#define Disabled_Color  [UIColor colorWithRed:(210)/255.0 green:(210)/255.0 blue:(210)/255.0 alpha:1]
#define Abled_Color  [UIColor colorWithRed:(30)/255.0 green:(156)/255.0 blue:(91)/255.0 alpha:1]


#endif
