//
//  NurseIntroTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/5.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeInfoView.h"
#import "NurseListInfoModel.h"

@interface NurseIntroTableCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbCommitCount;//评论条数
    UIImageView *_imgCert;//是否有证书
    UILabel *_lbNurseIntro;//籍贯等
    UILabel *_lbWorkIntro;//介绍
    UILabel *_lbPrice;//价格
    UIButton *_btnLocation;//位置
    GradeInfoView *_gradeView;
    
    UILabel *_line;
}

- (void) SetContentData:(NurseListInfoModel*) model;

@end
