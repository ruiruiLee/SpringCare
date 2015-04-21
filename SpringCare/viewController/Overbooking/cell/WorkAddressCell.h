//
//  WorkAddressCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAttentionModel.h"

@interface WorkAddressCell : UITableViewCell
{
    UIImageView *_photoImage;
    UIImageView * ImgSex;
    UILabel *_lbRelation;
    UILabel *_lbName;
    UILabel *_lbAddress;
    UIButton *_btnSelect;
    UILabel *_line;
}

@property (nonatomic, strong) UIButton *_btnSelect;

- (void) setContentWithModel:(UserAttentionModel*) model;

@end
