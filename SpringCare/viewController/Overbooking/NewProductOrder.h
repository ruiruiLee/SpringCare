//
//  NewProductOrder.h
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewOrderVC.h"

@interface NewProductOrder : NewOrderVC
{
    UILabel *_lbTitle;
    UILabel *_lbExplain;
    UIImageView *_bglogo;
}

- (id) initWIthFamilyProductModel:(FamilyProductModel *)model;

@end
