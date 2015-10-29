//
//  AttentionSelectTableViewCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAttentionModel.h"

@interface AttentionSelectTableViewCell : UITableViewCell
{
    UIImageView *_photoImage;
    UILabel *_lbName;
    UIImageView *_selectStatus;
    UILabel *_lbLine;
    
    UIImageView *_imgAttentionLogo;
}

@property (nonatomic, strong) UIImageView *_selectStatus;
@property (nonatomic, strong) UIImageView *_imgAttentionLogo;

- (void) setContentWithModel:(UserAttentionModel*) model;

@end
