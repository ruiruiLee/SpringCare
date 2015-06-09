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

@protocol UserAttentionTableCellDelegate <NSObject>

- (void)NotifyHealthRecordButtonClickedWithModel:(UserAttentionModel *)model;

@end

@interface UserAttentionTableCell : UITableViewCell<UIActionSheetDelegate>
{
    UIView *_backgroundView;
    
    UIImageView * ImgSex;
    UILabel *_lbRelation;
    UILabel *_lbName;
    UIButton *_btnRing;
    UILabel *_Address;
    NSString *phoneNum;
    UIImageView *_attentionLogo;
    
    UIView *_sview1;
    UIView *_sview2;
    
    UIButton *_btnHealthRecord;
}

@property (nonatomic, retain) UIButton *btnphotoImg;
@property (nonatomic, assign) UserAttentionVC *parentController;
@property (nonatomic, retain) UserAttentionModel *model;
@property (nonatomic, assign) id<UserAttentionTableCellDelegate> delegate;

- (void) SetContentData:(UserAttentionModel*) data;

@end


