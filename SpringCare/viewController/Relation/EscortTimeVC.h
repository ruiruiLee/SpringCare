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
#import "PullTableView.h"

@interface EscortTimeVC : MainBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, AttentionSelectViewDelegate, PullTableViewDelegate>
{
    PullTableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnInfo;//信息
    AttentionSelectView *_selectView;
    UIView *_bgView;
    
    NSString *_currentLoverId;//用来处理当前的陪护时光是谁的
    
    //
    EscortTimeDataModel *_replyContentModel;//
    NSString *_reReplyPId;//被回复人id
    NSString *_reReplyName;//被回复人名字
    //UIImageView *_defaultImgView;
    
    NSInteger pages;
    NSInteger totalPages;
    
    NSMutableArray *_dataList;
    NSArray *AttentionArray;
    UIView *headerView;
    NSString* previousDate;
    
    CGFloat _offset;
}

@property (nonatomic, strong) PullTableView *tableView;
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView;
@end
