//
//  AdDataModel.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdDataModel : NSObject

@property (retain,nonatomic,readonly) NSArray * imageNameArray;

- (instancetype)initWithImageName;

+ (id)adDataModelWithImageName;

@end


