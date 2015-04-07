//
//  UserAttentionModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAttentionModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *ringNum;
@property (nonatomic, strong) NSString *address;

+ (NSArray*) GetMyAttentionArray;

@end
