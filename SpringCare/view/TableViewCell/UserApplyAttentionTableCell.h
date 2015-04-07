//
//  UserApplyAttentionTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRequestAcctionModel.h"

@interface UserApplyAttentionTableCell : UITableViewCell
{
    UIImageView *_photoImage;
    UILabel *_lbUserName;
    UILabel *_lbActionName;
    UIButton *_btnAccept;
    UIImageView *_imgExplaction;
    UILabel *_lbExplaction;
    UILabel *_line;
}

- (void) SetContentData:(UserRequestAcctionModel*) data;

@end
