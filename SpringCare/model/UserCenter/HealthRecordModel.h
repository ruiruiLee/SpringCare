//
//  HealthRecordModel.h
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecordItemDataModel.h"
#import "define.h"

typedef enum : NSUInteger {
    EnumDataTypeWeek,
    EnumDataTypeMonth,
    EnumDataTypeOther,
} EnumDataType;

@interface HealthRecordModel : NSObject

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger totals;
@property (nonatomic, strong) NSMutableArray *recordList;

- (void) LoadRecordListWithLoverId:(NSString *)loverId block:(CompletionBlock)block;

- (void) LoadRecordListWithSata:(NSString *)loverId begin:(NSString *)begin type:(EnumDataType) type block:(CompletionBlock)block;

@end
