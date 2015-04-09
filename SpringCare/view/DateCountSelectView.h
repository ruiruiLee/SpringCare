//
//  DateCountSelectView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCountSelectView : UIView
{
    UIImageView *_imgBg;
    UIButton *_btnAdd;
    UIButton *_btnDel;
    UILabel *_lbCount;
}

@property (nonatomic, assign) NSInteger countNum;

@end
