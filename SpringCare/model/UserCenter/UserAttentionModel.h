//
//  UserAttentionModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface UserAttentionModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *ringNum;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL isCare;//是否关注对象

+ (NSMutableArray*) GetMyAttentionArray;

- (void) loadLoverList:(block) block;

/**
 删除
 */
- (void) deleteAttention:(block) block;

@end
