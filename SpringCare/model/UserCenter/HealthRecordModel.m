//
//  HealthRecordModel.m
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HealthRecordModel.h"

@implementation HealthRecordModel
@synthesize pages;
@synthesize totals;

- (id)init
{
    self = [super init];
    if(self){
        self.recordList = [[NSMutableArray alloc] init];
        self.pages = 0;
        self.totals = INT_MAX;
    }
    
    return self;
}

-(void) setPages:(NSInteger)num
{
    pages = num;
    if(num == 0)
    {
        self.totals = INT_MAX;
    }
}

- (void) LoadRecordListWithLoverId:(NSString *)loverId block:(CompletionBlock)block
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:loverId forKey:@"loverId"];
    
    [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = pages * limit;
    if(offset >= [self.recordList count])
        offset = [self.recordList count];
    [parmas setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
    __weak HealthRecordModel *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/lover/health" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content objectForKey:@"code"] == nil){
                weakSelf.totals = [[content objectForKey:@"totals"] integerValue];
                NSArray *rows = [content objectForKey:@"rows"];
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (int i = 0; i < [rows count]; i++) {
                    HealthRecordItemDataModel *model = [HealthRecordItemDataModel modelFromDictionary:[rows objectAtIndex:i]];
                    [result addObject:model];
                }
                if(pages == 0)
                    [weakSelf.recordList removeAllObjects];
                [weakSelf.recordList addObjectsFromArray:result];
                if(block){
                    block( 1, result);
                }
                return ;
            }
        }
        
        if(block){
            block(0, nil);
        }
    }];
}

@end
