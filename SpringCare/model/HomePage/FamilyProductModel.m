//
//  FamilyProductModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "FamilyProductModel.h"

static NSMutableArray *familyProductArray = nil;

@implementation FamilyProductModel
@synthesize pId;
@synthesize image_url;
@synthesize isDirectOrder;
@synthesize productDesc;
@synthesize productName;

+ (NSArray*) getProductArray
{
    if(familyProductArray == nil){
        familyProductArray = [[NSMutableArray alloc] init];
    }
    return familyProductArray;
}

+ (void) setFamilyProduct:(NSArray*)array
{
    if(familyProductArray == nil){
        familyProductArray = [[NSMutableArray alloc] init];
    }
    [familyProductArray removeAllObjects];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        FamilyProductModel *model = [[FamilyProductModel alloc] init];
        model.pId = [dic objectForKey:@"id"];
        model.image_url = [dic objectForKey:@"image_url"];
        model.isDirectOrder = [[dic objectForKey:@"isDirectOrder"] boolValue];
        model.productName = [dic objectForKey:@"productName"];
        model.productDesc = [dic objectForKey:@"productDesc"];
        
        [familyProductArray addObject:model];
    }
}

@end
