//
//  MyOrderOnDoingTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderdataModel.h"

@class MyOrderOnDoingTableCell;

@protocol MyOrderOnDoingTableCellDelegate <NSObject>

- (void) NotifyToPayWithModel:(MyOrderdataModel *) oreder onDoingcell:(MyOrderOnDoingTableCell *) cell;
- (void) NotifyToCommentWithModel:(MyOrderdataModel *) order onDoingcell:(MyOrderOnDoingTableCell *) cell;

@end

@interface MyOrderOnDoingTableCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbPrice;//价格
    UILabel *_lbCountPrice;//总价
    UILabel *_line;
    UIButton *_btnPay;//去付款
    UIButton *_btnStatus;//订单状态
    UIImageView *_imgLogo;
    UIImageView *_imgDayTime;
    UIImageView *_imgNight;
    UILabel *_lbDetailTime;
    
    UILabel *_topLine;
    UILabel *_headerText;
    
    MyOrderdataModel *orderModel;
}

@property (nonatomic, assign) id<MyOrderOnDoingTableCellDelegate> delegate;

- (void) SetContentData:(MyOrderdataModel*) data;

@end
