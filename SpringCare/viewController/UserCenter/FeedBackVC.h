//
//  FeedBackVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface FeedBackVC : LCBaseVC<UITextViewDelegate>
{
    UIScrollView *scrollview;
    UITextView *_tvContent;
    UILabel *_lbExplation;
    UIButton *_btnSubmit;
}

@property (nonatomic, strong)UIScrollView *scrollview;

@end
