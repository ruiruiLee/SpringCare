//
//  EscortTimeVC.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "EscortTimeTableCell.h"
#import "MainBaseVC.h"
#import "AttentionSelectView.h"
#import "feedbackView.h"

@interface EscortTimeVC : MainBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, AttentionSelectViewDelegate>
{
    UITableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnInfo;//信息
    AttentionSelectView *_selectView;
    UIView *_bgView;
    
    NSString *_currentAttentionId;//用来处理当前的陪护时光是谁的
    
    //
    EscortTimeDataModel *_replyContentModel;//
    NSString *_reReplyPId;//被回复人id
}

@end
