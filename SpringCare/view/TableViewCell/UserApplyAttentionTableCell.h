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
    
    UserRequestAcctionModel *requestModel;
}

@property (nonatomic, strong) UIButton *_btnAccept;
@property (nonatomic, strong) UserRequestAcctionModel *requestModel;

- (void) SetContentData:(UserRequestAcctionModel*) data;

@end
