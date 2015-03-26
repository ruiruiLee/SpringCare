//
//  MessageListModel.m
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MessageListModel.h"

static NSMutableArray *messageList = nil;

@implementation MessageListModel

+ (NSArray*)MessageList
{
    if(messageList == nil){
        messageList = [[NSMutableArray alloc] init];
    }
    return messageList;
}

- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void) LoadMessagesWithPageNum:(int)pageNum
{
    for (int i = 0; i < 15; i++) {
        MessageListModel *model = [[MessageListModel alloc] init];
        [messageList addObject:model];
    }
}

@end
