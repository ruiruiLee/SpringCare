//
//  OrderInfoSelectView.h
//  SpringCare
//
//  Created by LiuZach on 15/7/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoSelectView : UIView
{
    UIButton *_logoImageView;
    UILabel *_lbTitle;
    UIImageView *_unfoldStaus;
    UILabel *_line;
}

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *logoImageView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) id value;

@end
