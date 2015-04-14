//
//  NurseListInfoModel.h
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

typedef enum : NSUInteger {
    EnumTypeUnKonwn,
    EnumTypeHospital,
    EnumTypeProduct,
} EnumNursePriceType;

@interface NurseListInfoModel : NSObject

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *birthPlace;
@property (nonatomic, strong) NSString *careAge;
@property (nonatomic, strong) NSString *detailIntro;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger priceDistcount;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) NSInteger commentsRate;
@property (nonatomic, assign) NSInteger commentsNumber;

//

+ (NSMutableArray*) nurseListModel;

+ (NSDictionary*) PramaNurseDic;

/**
 * 通过页数来获取数据
 *
 */

- (void) loadNurseDataWithPage:(int) pages type:(EnumNursePriceType) type key:(NSString*)key ordr:(NSString*) order sortFiled:(NSString*)sortFiled productId:(NSString*) productId block:(block) block;

- (void) loadNurseDataWithPage:(int) pages prama:(NSDictionary*)prama block:(block) block;


@end
