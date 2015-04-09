//
//  PayTypeCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeItemCell : UITableViewCell
{
    UIImageView *_logoImage ;
    UILabel *_payName;
    UIButton *_btnSelect;
    UILabel *_line;
}

@property (nonatomic, strong) UIImageView *_logoImage ;
@property (nonatomic, strong) UILabel *_payName;
@property (nonatomic, strong) UIButton *_btnSelect;
@property (nonatomic, strong) UILabel *_line;;

@end

@interface PayTypeCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
}

@end
