//
//  LoginVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/1.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LoginVC.h"
#import "define.h"
#import "NSStrUtil.h"
#import "UserModel.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

@implementation LoginVC

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _count = 60;
    }
    return self;
}

- (void)dealloc
{
    [_timerOutTimer invalidate];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.NavigationBar.Title = @"快速登录";
    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    
    [self initSubViews];
}

- (void) initSubViews
{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:scrollview];
    scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:line];
    line.backgroundColor = _COLOR(225, 225, 225);
    line.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:title];
    title.font = _FONT(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = _COLOR(0x66, 0x66, 0x66);
    title.text = @"验证手机，马上体验";
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.backgroundColor = [UIColor whiteColor];
    
    _tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfPhoneNum];
    _tfPhoneNum.font = _FONT(18);
    _tfPhoneNum.placeholder = @"手机号";
    _tfPhoneNum.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfPhoneNum.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    _tfPhoneNum.layer.cornerRadius = 5;
    _tfPhoneNum.layer.borderWidth = 1;
    _tfPhoneNum.layer.borderColor = _COLOR(225, 225, 225).CGColor;
    _tfPhoneNum.delegate = self;
    _tfPhoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [_tfPhoneNum becomeFirstResponder];
    
    _btnVerifyCode = [[UIButton alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_btnVerifyCode];
    _btnVerifyCode.backgroundColor = Disabled_Color;//[UIColor greenColor];//初始化为disabled
    _btnVerifyCode.enabled = NO;
    _btnVerifyCode.layer.cornerRadius = 5;
    [_btnVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _btnVerifyCode.titleLabel.font = _FONT(15);
    _btnVerifyCode.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnVerifyCode addTarget:self action:@selector(btnGainVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    _tfVerifyCode = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfVerifyCode];
    _tfVerifyCode.font = _FONT(18);
    _tfVerifyCode.placeholder = @"验证码";
    _tfVerifyCode.translatesAutoresizingMaskIntoConstraints = NO;
    _tfVerifyCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfVerifyCode.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tfVerifyCode.leftViewMode = UITextFieldViewModeAlways;
    _tfVerifyCode.layer.cornerRadius = 5;
    _tfVerifyCode.layer.borderWidth = 1;
    _tfVerifyCode.layer.borderColor = _COLOR(225, 225, 225).CGColor;
    _tfVerifyCode.delegate = self;
    _tfVerifyCode.keyboardType = UIKeyboardTypeNumberPad;
    
    _btnLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_btnLogin];
    _btnLogin.enabled = NO;
    _btnLogin.backgroundColor = [UIColor blueColor];
    _btnLogin.layer.cornerRadius = 5;
    [_btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
    _btnLogin.backgroundColor = Disabled_Color;
    _btnLogin.titleLabel.font = _FONT(18);
    _btnLogin.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnLogin addTarget:self action:@selector(btnLoginUseVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnAgreement = [[UIButton alloc] initWithFrame:CGRectZero];
    btnAgreement.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:btnAgreement];
    btnAgreement.titleLabel.font = _FONT(12);
    btnAgreement.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *agreement = @"点击-登录，即表示您同意《春风优护用户协议》";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:agreement];
    NSRange range = [agreement rangeOfString:@"《春风优护用户协议》"];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf0, 0x77, 0x2a) range:range];
    range = [agreement rangeOfString:@"点击-登录，即表示您同意"];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0x99, 0x99, 0x99) range:range];
    [btnAgreement setAttributedTitle:string forState:UIControlStateNormal];
//    [btnAgreement setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(line, title, _tfPhoneNum, _btnVerifyCode, _btnLogin, scrollview, _tfVerifyCode, btnAgreement);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *lineHFormat = [NSString stringWithFormat:@"H:|-0-[line(%f)]-0-|", screenWidth];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-52-[line(0.8)]->=10-|" options:0 metrics:nil views:views]];
    
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[title(200)]->=0-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[title(20)]->=0-|" options:0 metrics:nil views:views]];
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:line attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:line attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSString *phoneNUmHFormat = [NSString stringWithFormat:@"H:|-30-[_tfPhoneNum(%f)]-10-[_btnVerifyCode(%f)]-30-|", screenWidth - 160, 90.f];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:phoneNUmHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[title(20)]-35-[_tfPhoneNum(51)]->=10-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[title(20)]-35-[_btnVerifyCode(51)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *verifyCodeHFormat = [NSString stringWithFormat:@"H:|-30-[_tfVerifyCode(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verifyCodeHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_tfPhoneNum(51)]-20-[_tfVerifyCode(51)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *btnLoginHFormat = [NSString stringWithFormat:@"H:|-30-[_btnLogin(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:btnLoginHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_tfVerifyCode(51)]-20-[_btnLogin(51)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *attributeHFormat = [NSString stringWithFormat:@"H:|-30-[btnAgreement(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:attributeHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_btnLogin(51)]-10-[btnAgreement(20)]->=10-|" options:0 metrics:nil views:views]];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _tfPhoneNum){
        if(string == nil || [string length] == 0){
            _btnVerifyCode.enabled = NO;
            _btnVerifyCode.backgroundColor = Disabled_Color;
            _btnLogin.enabled = NO;
            _btnLogin.backgroundColor = Disabled_Color;
            [_btnVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            return YES;
        }
        else{
            if(range.location >= 11){
                return NO;
            }
            else{
                NSString *verifyCode = _tfVerifyCode.text;
                if(range.location == 10){
                    _btnVerifyCode.enabled = YES;
                    _btnVerifyCode.backgroundColor = Abled_Color;
                    
                    if([verifyCode length] == 6 && _timerOutTimer != nil && _count != 0){
                        _btnLogin.enabled = YES;
                        _btnLogin.backgroundColor = Abled_Color;
                    }
                }
                return YES;
            }
        }
    }else{
        if(string == nil || [string length] == 0){
            _btnLogin.enabled = NO;
            _btnLogin.backgroundColor = Disabled_Color;
            return YES;
        }
        else{
            if(range.location >= 6){
                return NO;
            }
            else{
                NSString *phone = _tfPhoneNum.text;
                BOOL isphone = [NSStrUtil isMobileNumber:phone];
                if(range.location == 5 && [string length] == 1 && isphone && _timerOutTimer != nil && _count != 0){
                    _btnLogin.enabled = YES;
                    _btnLogin.backgroundColor = Abled_Color;
                }
                return YES;
            }
        }
    }
    return YES;
}

#pragma action

- (void) btnGainVerifyCode:(id)sender
{
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
    NSString *phone = _tfPhoneNum.text;
    BOOL isMobile = [NSStrUtil isMobileNumber:phone];
    if(!isMobile){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"电话号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
            [self TimerOutTimer];
            if(succeeded){
                
                [self TimerOutTimer];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"电话号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

- (void) btnLoginUseVerifyCode:(id)sender
{
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
    
    NSString *verifyCode = _tfVerifyCode.text;
    NSString *phone = _tfPhoneNum.text;
    
    __weak LoginVC *weakSelf = self;
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:phone smsCode:verifyCode block:^(AVUser *user, NSError *error) {
        if(error == nil){
            UserModel *model = [UserModel sharedUserInfo];
            model.isLogin = YES;
            model.sessionToken = user.sessionToken;
            model.username = user.username;
            model.mobilePhoneNumber = user.mobilePhoneNumber;
            model.isNew = user.isNew;
            model.email = user.email;
            model.headerFile = ((AVFile*)[user objectForKey:@"header_image"]).url;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOGIN_SUCCESS object:nil];
            
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
}

#pragma timer
- (void)TimerOutTimer
{
    [_timerOutTimer invalidate];
    _count = 60;
    _timerOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerObserver) userInfo:nil repeats:YES];
}

- (void)TimerObserver
{
    _count --;
    [_btnVerifyCode setTitle:[NSString stringWithFormat:@"%ld秒", _count] forState:UIControlStateNormal];
    if(_count == 0){
        [_timerOutTimer invalidate];
        [_btnVerifyCode setTitle:@"重取验证码" forState:UIControlStateNormal];
        
        _btnLogin.enabled = NO;
        _btnLogin.backgroundColor = Disabled_Color;
        _tfVerifyCode.text = @"";
    }
}

@end
