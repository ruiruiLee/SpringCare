//
//  UserAttentionTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAttentionModel.h"

@interface UserAttentionTableCell : UITableViewCell
{
    UIImageView *_photoImage;
    UILabel *_lbRelation;
    UILabel *_lbName;
    UIButton *_btnRing;
    UILabel *_Address;
    UILabel *_line;
}

- (void) SetContentData:(UserAttentionModel*) data;

@end