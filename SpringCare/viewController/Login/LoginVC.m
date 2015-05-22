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
#import "WebContentVC.h"

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

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    //    [self.navigationController pushViewController:self animated:YES];
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.NavigationBar.Title = @"快速登录";
    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    [self initSubViews];
//    [_tfPhoneNum becomeFirstResponder];
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.001];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void) showKeyBoard
{
    [_tfPhoneNum becomeFirstResponder];
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
//    [_tfPhoneNum becomeFirstResponder];
    
    _btnVerifyCode = [[UIButton alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_btnVerifyCode];
    _btnVerifyCode.clipsToBounds = YES;
    UIImage *image =[Util imageWithColor:Disabled_Color size:CGSizeMake(5, 5)];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
    [_btnVerifyCode setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
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
    _tfVerifyCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    _btnLogin.layer.cornerRadius = 5;
    _btnLogin.clipsToBounds = YES;
    [_btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
//    _btnLogin.backgroundColor = Disabled_Color;
    _btnLogin.titleLabel.font = _FONT(18);
    _btnLogin.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnLogin addTarget:self action:@selector(btnLoginUseVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLogin setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
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
    [btnAgreement addTarget:self action:@selector(doBtnAgreementClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[title(20)]-37-[_tfPhoneNum(42)]->=10-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[title(20)]-37-[_btnVerifyCode(42)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *verifyCodeHFormat = [NSString stringWithFormat:@"H:|-30-[_tfVerifyCode(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verifyCodeHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_tfPhoneNum(42)]-20-[_tfVerifyCode(42)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *btnLoginHFormat = [NSString stringWithFormat:@"H:|-30-[_btnLogin(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:btnLoginHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_tfVerifyCode(42)]-20-[_btnLogin(42)]->=10-|" options:0 metrics:nil views:views]];
    
    NSString *attributeHFormat = [NSString stringWithFormat:@"H:|-30-[btnAgreement(%f)]-30-|", screenWidth - 60];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:attributeHFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_btnLogin(42)]-10-[btnAgreement(20)]->=10-|" options:0 metrics:nil views:views]];
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
    
    if (textField == _tfPhoneNum) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        NSString *textfront = nil;
        NSString *textend=nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            textfront = [textField.text substringToIndex:range.location];
            textend=[textField.text substringFromIndex:range.location];
            text = [NSString stringWithFormat:@"%@%@%@",textfront,string,textend];
            
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if ([NSStrUtil isMobileNumber:text]) {
            _btnVerifyCode.enabled = YES;
            [_btnVerifyCode setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
            _btnLogin.enabled = YES;
            [_btnLogin setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];


        }else{
            
            _btnLogin.enabled = NO;
            [_btnLogin setBackgroundImage:[Util imageWithColor:Disabled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
            _btnVerifyCode.enabled = NO;
            [_btnVerifyCode setBackgroundImage:[Util imageWithColor:Disabled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];

        }
    }
    return YES;
    
}

#pragma action

- (void) btnGainVerifyCode:(id)sender
{
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
    _btnVerifyCode.enabled = NO;
    [_btnVerifyCode setBackgroundImage:[Util imageWithColor:Disabled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    NSString *phone = _tfPhoneNum.text;
    __weak LoginVC *weakSelf = self;
    [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
        //[self TimerOutTimer];
        if(succeeded){
            [weakSelf TimerOutTimer];
//            _btnLogin.enabled = YES;
//            [_btnLogin setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
            [Util showAlertMessage:@"验证码已发送!" ];
        }else{
            [Util showAlertMessage:@"服务器错误，稍后再试!" ];
        }
    }];
}

- (void) btnLoginUseVerifyCode:(id)sender
{
    [_tfPhoneNum resignFirstResponder];
    [_tfVerifyCode resignFirstResponder];
    
    NSString *verifyCode = _tfVerifyCode.text;
    NSString *phone = _tfPhoneNum.text;
    if ([phone isEqual:@"13880417776"]) {
        [AVUser logInWithUsernameInBackground:phone password:verifyCode block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                [[UserModel sharedUserInfo] modifyInfo];
                AVInstallation *currentInstallation = [AVInstallation currentInstallation];
                [currentInstallation addUniqueObject:[UserModel sharedUserInfo].userId forKey:@"channels"];
                [currentInstallation saveInBackground];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
            }
        }];
    }
    else{
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:phone smsCode:verifyCode block:^(AVUser *user, NSError *error) {
        if(error == nil){
            [[UserModel sharedUserInfo] modifyInfo];
             AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation addUniqueObject:[UserModel sharedUserInfo].userId forKey:@"channels"];
            [currentInstallation saveInBackground];

            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{

             [Util showAlertMessage:@"请输入正确的验证码！" ];
        }
    }];
    }
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
    [_btnVerifyCode setTitle:[NSString stringWithFormat:@"%d秒", _count] forState:UIControlStateNormal];
    if(_count == 0){
        [_timerOutTimer invalidate];
        [_btnVerifyCode setTitle:@"重取验证码" forState:UIControlStateNormal];
         [_btnVerifyCode setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
        _btnVerifyCode.enabled = YES;
//        _btnLogin.enabled = NO;
//        [_btnLogin setBackgroundImage:[Util imageWithColor:Disabled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
        _tfVerifyCode.text = @"";
    }
}


//键盘监控事件
- (void) keyboardWillShow:(NSNotification *) notify
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        [UIView animateWithDuration:0.25 animations:^{
            scrollview.contentOffset = CGPointMake(0, 94);
        }];
    }
    else if (type == EnumValueTypeiPhone5){
        [UIView animateWithDuration:0.25 animations:^{
            scrollview.contentOffset = CGPointMake(0, 32);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)notify
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        [UIView animateWithDuration:0.25 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
        }];
    }
    else if (type == EnumValueTypeiPhone5){
        [UIView animateWithDuration:0.25 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
        }];
    }
}

-(void) doBtnAgreementClicked:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Agreement];
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"用户陪护协议" url:url];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
