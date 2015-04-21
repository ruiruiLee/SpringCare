//
//  EscortTimeDataModel.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeDataModel.h"
#import "ObjImageDataInfo.h"
#import "define.h"

static NSMutableArray *escortTimeData = nil;
static NSInteger totalCount = 0;

@implementation FileDataModel

+ (FileDataModel *) ObjectFromDictionary:(NSDictionary *) dic
{
    FileDataModel *model = [[FileDataModel alloc] init];
    
    model.url = [dic objectForKey:@"url"];
    model.fileType = [[dic objectForKey:@"fileType"] integerValue];
    model.seconds = [dic objectForKey:@"seconds"];
    
    return model;
}

@end


@implementation EscortTimeReplyDataModel
@synthesize height;

+ (EscortTimeReplyDataModel *) ObjectFromDictionary:(NSDictionary *)dic
{
    EscortTimeReplyDataModel *model = [[EscortTimeReplyDataModel alloc] init];
    model.replyUserHeaderImage = [dic objectForKey:@"replyUserHeaderImage"];
    model.replyUserName = [dic objectForKey:@"replyUserName"];
    model.guId = [dic objectForKey:@"guId"];
    model.replyDate = [dic objectForKey:@"replyDate"];
    model.content = [dic objectForKey:@"content"];
    model.replyUserId = [dic objectForKey:@"replyUserId"];
    model.orgUserHeaderImage = [dic objectForKey:@"orgUserHeaderImage"];
    model.orgUserName = [dic objectForKey:@"orgUserName"];
    model.orgUserId = [dic objectForKey:@"orgUserId"];
    
    return model;
}

+ (NSArray *) ArrayFromDictionaryArray:(NSArray *) array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[EscortTimeReplyDataModel ObjectFromDictionary:dic]];
    }
    
    return result;
}

@end

@implementation EscortTimeDataModel

+ (NSArray*) GetEscortTimeData
{
    if (!escortTimeData)
    {
        escortTimeData = [[NSMutableArray alloc] init];
    }
    return escortTimeData;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.isShut = NO;
    }
    return self;
}

+ (EscortTimeDataModel *) ObjectFromDictionary:(NSDictionary *)dic
{
    EscortTimeDataModel *model = [[EscortTimeDataModel alloc] init];
    
    model.itemId = [dic objectForKey:@"id"];
    model.careId = [dic objectForKey:@"careId"];
    model.content = [dic objectForKey:@"content"];
    model.createAt = [dic objectForKey:@"createAt"];
    model.replyInfos = [EscortTimeReplyDataModel ArrayFromDictionaryArray:[dic objectForKey:@"replyInfos"]];
    
    NSArray *files = [dic objectForKey:@"files"];
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [files count]; i++) {
        FileDataModel *file = [FileDataModel ObjectFromDictionary:[files objectAtIndex:i]];
        if(file.fileType == 99){
            ObjImageDataInfo *info = [[ObjImageDataInfo alloc] init];
            info.urlPath = file.url;
            [photoArray addObject:info];
        }else if (file.fileType == 2)
            model.VoliceDataModel = file;
            
    }
    
    model.imgPathArray = photoArray;
    
    return model;
}

+ (void) LoadCareTimeListWithLoverId:(NSString *)loverId pages:(NSInteger) num block:(block) block
{
    if(num == 0){
        [EscortTimeDataModel GetEscortTimeData];
        [escortTimeData removeAllObjects];
    }
    
    NSInteger limit = LIMIT_COUNT;
    NSInteger offset = limit * num;
    if(offset > [escortTimeData count]){
        offset = [escortTimeData count];
    }
    
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    if(loverId){
        [mdic setObject:loverId forKey:@"loverId"];
    }
    [mdic setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [mdic setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    [mdic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
    [LCNetWorkBase postWithMethod:@"api/careTime/list" Params:mdic Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                totalCount = [[content objectForKey:@"total"] integerValue];
                NSArray *array = [content objectForKey:@"rows"];
                for (int i = 0; i < [array count]; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    EscortTimeDataModel *model = [EscortTimeDataModel ObjectFromDictionary:dic];
                    [escortTimeData addObject:model];
                }
            }
            if(block)
                block(1);
        }
    }];
}

@end
