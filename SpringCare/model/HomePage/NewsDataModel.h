//
//  NewsDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDataModel : NSObject

@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *news_title;

+ (NSArray*) getNews;
+ (NSArray*) getImageUrlArray;
+ (void) SetNewsWithArray:(NSArray*) list;

@end
