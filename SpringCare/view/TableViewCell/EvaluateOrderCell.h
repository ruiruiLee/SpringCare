//
//  EvaluateOrderCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
#import "MyOrderdataModel.h"

@protocol EvaluateOrderCellDelegate <NSObject>

- (void) NotifyEvaluateSuccessAndDelete:(NurseListInfoModel*) model;

@end

@interface EvaluateOrderCell : UITableViewCell<UITextViewDelegate>
{
    UIView *_headerView;
    UIImageView *_photoImage;
    UILabel *_lbName;
    UIButton *_btnInfo;
    
    PlaceholderTextView *_tvContent;
    UIButton *_btnGood;
    UIButton *_btnBetter;
    UIButton *_btnBest;
    
    UIButton *_btnSubmit;
    UILabel *_line;
    
    MyOrderdataModel *_OrderModel;
//    int _nurseIdx;
    NurseListInfoModel *_nurseModel;
}

@property (nonatomic, assign) id<EvaluateOrderCellDelegate> delegate;

- (void) SetContentWithModel:(MyOrderdataModel *) model nursemodel:(NurseListInfoModel *) nursemodel;

@end
