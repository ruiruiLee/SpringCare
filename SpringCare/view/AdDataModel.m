//
//  AdDataModel.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdDataModel.h"

@implementation AdDataModel

- (instancetype)initWithImageName
{
    self = [super init];
    if (self)
    {
//        _imageNameArray = [NSArray arrayWithContentsOfFile:PATH][0];
        _imageNameArray = [[NSArray alloc] init];
    }
    return self;
}



+ (id)adDataModelWithImageName
{
    return [[self alloc]initWithImageName];
}


@end

