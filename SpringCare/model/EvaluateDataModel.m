//
//  EvaluateDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateDataModel.h"


/************************************
 **
 **
 **   护工评论参数
 **
 **
 **
 *************************************/

@implementation CareEvaluateInfoModel

- (id) init{
    self = [super init];
    if(self){
        self.commentsNumber = INT_MAX;
        self.itemArray = [[NSMutableArray alloc] init];
    }
    
    return self;
    
}

+ (CareEvaluateInfoModel *) modelFromDictionary:(NSDictionary *)dic
{
    CareEvaluateInfoModel *model = [[CareEvaluateInfoModel alloc] init];
    
    model.careId = [dic objectForKey:@"careId"];
    model.commentsNumber = [[dic objectForKey:@"commentsNumber"] integerValue];
    model.commentsRate = [dic objectForKey:@"commentsRate"];
    
    return model;
}

- (void) LoadCommentListWithPages:(NSInteger) pages isOnlySplit:(BOOL) isOnlySplit block:(CompletionBlock) block
{
    if(self.commentsNumber <= pages)
        block(0, nil);
    
    if(pages == 0){
        [self.itemArray removeAllObjects];
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:self.careId forKey:@"careId"];
    
    if(isOnlySplit){
        [parmas setObject:[NSNumber numberWithInteger:pages * LIMIT_COUNT] forKey:@"offset"];
        [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
        [parmas setObject:@"true" forKey:@"isOnlySplit"];
    }else{
        [parmas setObject:[NSNumber numberWithInteger:0] forKey:@"offset"];
        [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
        [parmas setObject:@"false" forKey:@"isOnlySplit"];
    }
    
    __weak CareEvaluateInfoModel *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/care/comment/List" Params:parmas Completion:^(int code, id content) {
        if(code){
            if(isOnlySplit){
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (int i = 0; i < [[content objectForKey:@"rows"] count]; i++) {
                    EvaluateDataModel *model = [EvaluateDataModel modelFromDictionary:[[content objectForKey:@"rows"] objectAtIndex:i]];
                    [result addObject:model];
                }
                [weakSelf.itemArray addObjectsFromArray:result];
                weakSelf.commentsNumber = [[content objectForKey:@"total"] integerValue];
                if(block){
                    block(1, result);
                }
            }
            else{
                weakSelf.careId = [[content objectForKey:@"care"] objectForKey:@"careId"];
                weakSelf.commentsNumber = [[[content objectForKey:@"care"] objectForKey:@"commentsNumber"] integerValue];
                weakSelf.commentsRate = [[content objectForKey:@"care"] objectForKey:@"commentsNumber"];
                
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (int i = 0; i < [[content objectForKey:@"rows"] count]; i++) {
                    EvaluateDataModel *model = [EvaluateDataModel modelFromDictionary:[[content objectForKey:@"rows"] objectAtIndex:i]];
                    [result addObject:model];
                }
                [weakSelf.itemArray addObjectsFromArray:result];
                if(block){
                    block(1, result);
                }
            }
        }
        else{
            if(block){
                block(0, nil);
            }
        }
    }];
}

@end


/************************************
 **
 **
 **
 **     护工评论信息列表
 **
 **
 *************************************/

@implementation EvaluateDataModel

+ (EvaluateDataModel *) modelFromDictionary:(NSDictionary *)dic
{
    EvaluateDataModel *model = [[EvaluateDataModel alloc] init];
    
    model.content = [dic objectForKey:@"content"];
    model.score = [[dic objectForKey:@"score"] integerValue];
    model.createAt = [dic objectForKey:@"createAt"];
    model.commentUserName = [dic objectForKey:@"commentUserName"];
    
    return model;
}

@end
