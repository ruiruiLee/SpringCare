//
//  EscortTimeDataModel.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface FileDataModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, strong) NSString *seconds;

@end

@interface EscortTimeReplyDataModel : NSObject

@property (nonatomic, assign) float height;

@property (nonatomic, strong) NSString *replyUserHeaderImage;
@property (nonatomic, strong) NSString *replyUserName;
@property (nonatomic, strong) NSString *guId;
@property (nonatomic, strong) NSString *replyDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyUserId;
@property (nonatomic, strong) NSString *orgUserHeaderImage;
@property (nonatomic, strong) NSString *orgUserName;
@property (nonatomic, strong) NSString *orgUserId;


@end

@interface EscortTimeDataModel : NSObject
{
    
}

@property (nonatomic, strong) NSString *itemId;//陪护时光id
@property (nonatomic, strong) NSString *careId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSArray *replyInfos;


@property (nonatomic, strong) NSArray *imgPathArray;
@property (nonatomic, strong) FileDataModel *VoliceDataModel;

@property (nonatomic, assign) BOOL showTime;   //显示时间

@property (nonatomic, assign) NSInteger numberOfLinesTotal;
@property (nonatomic, assign) BOOL isShut;//是否展开， 0未展开； 1展开

+ (NSArray*) GetEscortTimeData;

+ (void) LoadCareTimeListWithLoverId:(NSString *)loverId pages:(NSInteger) num block:(CompletionBlock) block;

@end
