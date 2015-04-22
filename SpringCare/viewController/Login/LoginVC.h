//
//  LoginVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/1.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "IQKeyboardReturnKeyHandler.h"

@interface LoginVC : LCBaseVC <UITextFieldDelegate>
{
    UIScrollView *scrollview;
    
    UITextField *_tfPhoneNum;
    UITextField *_tfVerifyCode;
    
    UIButton *_btnVerifyCode;
    UIButton *_btnLogin;
    
    NSTimer *_timerOutTimer;
    
    NSInteger _count;
}

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end
