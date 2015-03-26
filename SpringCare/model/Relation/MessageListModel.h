//
//  MessageListModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

- (void) LoadMessagesWithPageNum:(int)pageNum;

+ (NSArray*) MessageList;

@end
