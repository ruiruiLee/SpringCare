//
//  FamilyProductModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyProductModel : NSObject

@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *productDesc;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) BOOL isDirectOrder;

+ (NSArray*) getProductArray;

+ (void) setFamilyProduct:(NSArray*)array;

@end
