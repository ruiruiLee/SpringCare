//
//  UserRequestAcctionModel.h
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRequestAcctionModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isAccept;
@property (nonatomic, strong) NSString *phone;

+ (NSArray*) GetRequestAcctionArray;

+ (void) SetRequestAcctionArrayWithArray:(NSArray*) array;

@end
