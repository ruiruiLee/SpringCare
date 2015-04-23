//
//  UserAttentionTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserAttentionModel.h"

@class UserAttentionVC;

@interface UserAttentionTableCell : UITableViewCell<UIActionSheetDelegate>
{
   // UIImageView *_photoImage;
    //UIButton *_btnphotoImg;
    UIImageView * ImgSex;
    UILabel *_lbRelation;
    UILabel *_lbName;
    UIButton *_btnRing;
    UILabel *_Address;
    UILabel *_line;
    NSString *phoneNum;
    UIImageView *_attentionLogo;
}

//@property (assign, nonatomic) id<ChangHeaderPhotoDelegate> delegate;
@property (nonatomic, retain) UIButton *btnphotoImg;
@property (nonatomic, retain) UserAttentionVC *parentController;
@property (nonatomic, retain) UserAttentionModel *model;
- (void) SetContentData:(UserAttentionModel*) data;

@end


