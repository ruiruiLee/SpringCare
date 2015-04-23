//
//  NewsDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewsDataModel.h"

static NSMutableArray *newsArray = nil;

@implementation NewsDataModel
@synthesize image_url;
@synthesize news_title;

+ (NSArray*) getNews
{
    if(!newsArray){
        newsArray = [[NSMutableArray alloc] init];
    }
    return newsArray;
}

+ (NSArray*) getImageUrlArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [newsArray count]; i++) {
        NewsDataModel *model = [newsArray objectAtIndex:i];
        [array addObject:model.image_url];
    }
    return array;
}

+ (NSArray*) getNewsUrlArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [newsArray count]; i++) {
        NewsDataModel *model = [newsArray objectAtIndex:i];
        [array addObject:model.news_url];
    }
    return array;
}

+ (void) SetNewsWithArray:(NSArray*) list
{
    if(!newsArray){
        newsArray = [[NSMutableArray alloc] init];
    }else{
        [newsArray removeAllObjects];
    }
    
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic = [list objectAtIndex:i];
        if([dic isKindOfClass:[NSDictionary class]]){
            NewsDataModel *model = [[NewsDataModel alloc] init];
            model.image_url = [dic objectForKey:@"image_url"];
            model.news_title = [dic objectForKey:@"news_title"];
            model.news_url = [dic objectForKey:@"url"];
            [newsArray addObject:model];
        }
    }
}

@end
