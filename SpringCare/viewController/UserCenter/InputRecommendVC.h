//
//  InputRecommendVC.h
//  SpringCare
//
//  Created by LiuZach on 15/5/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface InputRecommendVC : LCBaseVC
{
    UIScrollView *scrollview;
    UITextField *_tfContent;
    UILabel *_lbExplation;
    UIButton *_btnSubmit;
}

@property (nonatomic, strong)UIScrollView *scrollview;

@end
