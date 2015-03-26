//
//  NurseListInfoModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NurseListInfoModel : NSObject

@property (nonatomic, strong) NSString *nurseId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int comment;
@property (nonatomic, strong) NSString *simpleIntro;
@property (nonatomic, strong) NSString *detailIntro;

/**
 * 通过页数来获取数据
 *
 */
- (void) loadNurseDataWithPage:(int) pages;

+ (NSMutableArray*) nurseListModel;

@end
