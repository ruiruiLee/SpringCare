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
#import "Util.h"
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
    model.replyUserPhone = [dic objectForKey:@"replyUserPhone"];
    model.guId = [dic objectForKey:@"id"];
    model.replyDate = [dic objectForKey:@"replyDate"];
    model.replyUserId = [dic objectForKey:@"replyUserId"];
    model.orgUserHeaderImage = [dic objectForKey:@"orgUserHeaderImage"];
    model.orgUserName = [dic objectForKey:@"orgUserName"];
    model.orgUserPhone = [dic objectForKey:@"orgUserPhone"];
    model.orgUserId = [dic objectForKey:@"orgUserId"];
    
    NSString *content = [dic objectForKey:@"content"];
    NSMutableString *str = [[NSMutableString alloc] init];
    if(model.replyUserName!= nil){
        if ([model.replyUserName isEqualToString:[UserModel sharedUserInfo].displayName]) {
            [str appendString:@"我"];
        }
        else
          [str appendString:model.replyUserName];
    }
    
    if(model.orgUserName != nil){
        if ([model.orgUserName isEqualToString:[UserModel sharedUserInfo].displayName]) {
           [str appendString:[NSString stringWithFormat:@"@%@",@"我"]];
        }
        else
            [str appendString:[NSString stringWithFormat:@"@%@", model.orgUserName]];
    }
    [str appendString:[NSString stringWithFormat:@":%@", content]];

    model.content = content;
    
    return model;
}

+ (EscortTimeReplyDataModel *) ReplysFromDictionary:(NSDictionary *)dic{
     EscortTimeReplyDataModel *model = [[EscortTimeReplyDataModel alloc] init];
    model.replyUserName = [dic objectForKey:@"replyUserName"];
    model.replyUserPhone = [dic objectForKey:@"replyUserPhone"];
     model.replyUserId = [dic objectForKey:@"replyUserId"];
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

+ (NSMutableAttributedString *)getFullStringWithModel:(EscortTimeReplyDataModel *)model
{
    UIColor *nameColor = _COLOR(106, 164, 225);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    if(model.replyUserName!= nil){
        if ([model.replyUserName isEqualToString:[UserModel sharedUserInfo].mobilePhoneNumber]||
            [model.replyUserName isEqualToString:[UserModel sharedUserInfo].chineseName]) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我"];
            [att addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, 1)];
            [str appendAttributedString:att];
        }
        else{
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.replyUserName];
            [att addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, [model.replyUserName length])];
            [str appendAttributedString:att];
        }
    }
    
    if(model.orgUserName != nil){
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"回复"];
        //    [str appendString:[NSString stringWithFormat:@":%@", content]];
        [str appendAttributedString:att];
        
        if ([model.orgUserName isEqualToString:[UserModel sharedUserInfo].displayName]) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我"];
            [att addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, 1)];
            [str appendAttributedString:att];
            //           [str appendString:[NSString stringWithFormat:@"@%@",@"我"]];
        }
        else{
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.orgUserName];
            [att addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, [model.orgUserName length])];
            [str appendAttributedString:att];
            //            [str appendString:[NSString stringWithFormat:@"@%@", model.orgUserName]];
        }
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@":"];
    //    [str appendString:[NSString stringWithFormat:@":%@", content]];
    [str appendAttributedString:att];
    
    return str;
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
    model.createAt = [dic objectForKey:@"createdAt"];
    NSArray *array = [Util convertTimeFromStringDate:model.createAt];
    model.createTime =  array[1];
    model.createDate =   array[0];//[Util convertTimetoBroadFormat:array[0]];
    model.replyInfos = [EscortTimeReplyDataModel ArrayFromDictionaryArray:[dic objectForKey:@"replys"]];
    
    NSArray *files = [dic objectForKey:@"files"];
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [files count]; i++) {
        FileDataModel *file = [FileDataModel ObjectFromDictionary:[files objectAtIndex:i]];
        if(file.fileType == 1){
            ObjImageDataInfo *info = [[ObjImageDataInfo alloc] init];
            info.urlBigPath = file.url;
            info.urlSmallPath = TimesImage(file.url);
            [photoArray addObject:info];
        }else if (file.fileType == 2)
            model.VoliceDataModel = file;
            
    }
    
    model.imgPathArray = photoArray;
    
    return model;
}


+ (void) LoadCareTimeListWithLoverId:(NSString *)loverId previousDate:(NSString*)previousDate pages:(NSInteger) num block:(CompletionBlock) block
{

    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    if(loverId){
        [mdic setObject:loverId forKey:@"loverId"];
    }
    NSInteger offset = num * LIMIT_COUNT;
    [mdic setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [mdic setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    [mdic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    
    NSString __block * pdate = previousDate;
    [LCNetWorkBase postWithMethod:@"api/careTime/list" Params:mdic Completion:^(int code, id content) {
        if(code){
            NSMutableArray *result = [[NSMutableArray alloc] init];
                totalCount = [[content objectForKey:@"total"] integerValue];
            if (totalCount>0) {
                NSArray *array = [content objectForKey:@"rows"];
               // NSString* previousDate=nil;
                for (int i = 0; i < [array count]; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    EscortTimeDataModel *model = [EscortTimeDataModel ObjectFromDictionary:dic];
                    model.showTime = ![pdate isEqualToString:model.createDate];
                    pdate = model.createDate;
                    [escortTimeData addObject:model];
                    [result addObject:model];
                }
              }
                block(1, result);
        }
    }];
}

@end
