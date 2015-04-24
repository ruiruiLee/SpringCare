//
//  EvaluateDataModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"



@interface CareEvaluateInfoModel : NSObject

@property (nonatomic, strong) NSString *careId;
@property (nonatomic, assign) NSInteger commentsNumber;
@property (nonatomic, strong) NSString *commentsRate;
@property (nonatomic, strong) NSMutableArray *itemArray;

- (void) LoadCommentListWithPages:(NSInteger) pages isOnlySplit:(BOOL) isOnlySplit block:(CompletionBlock) block;

@end

@interface EvaluateDataModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commentUserName;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, assign) NSInteger score;

+ (EvaluateDataModel *) modelFromDictionary:(NSDictionary *)dic;

@end
