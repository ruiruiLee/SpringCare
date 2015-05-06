//
//  InputRecommendVC.m
//  SpringCare
//
//  Created by LiuZach on 15/5/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "InputRecommendVC.h"
#import "NSStrUtil.h"

@interface InputRecommendVC ()

@end

@implementation InputRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"推荐码";
    self.ContentView.backgroundColor = TableBackGroundColor;
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    [_tfContent resignFirstResponder];
}

- (void) initSubViews
{
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:scrollview];
    scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollview addGestureRecognizer:singleRecognizer];
    
    _lbExplation = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_lbExplation];
    _lbExplation.translatesAutoresizingMaskIntoConstraints = NO;
    _lbExplation.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbExplation.font = _FONT(13);
    _lbExplation.backgroundColor = [UIColor clearColor];
    _lbExplation.text = @"请输入邀请人手机号";
    
    _tfContent = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfContent];
    _tfContent.translatesAutoresizingMaskIntoConstraints = NO;
    _tfContent.font = _FONT(14);
    _tfContent.returnKeyType = UIReturnKeySend;
    _tfContent.keyboardType = UIKeyboardTypeNumberPad;
    _tfContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfContent.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _tfContent.leftViewMode = UITextFieldViewModeAlways;
    _tfContent.layer.cornerRadius = 8;
    _tfContent.layer.borderWidth = 1;
    _tfContent.layer.borderColor = TableSectionBackgroundColor.CGColor;
    _tfContent.placeholder = @"邀请人手机号";
    _tfContent.backgroundColor = [UIColor whiteColor];
    
    _btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_btnSubmit];
    [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    _btnSubmit.layer.cornerRadius = 8;
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    //    _btnSubmit.backgroundColor = Abled_Color;
    [_btnSubmit addTarget:self action:@selector(doBtnFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    _btnSubmit.clipsToBounds = YES;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbExplation, _tfContent, _btnSubmit, scrollview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbExplation]-20-|" options:0 metrics:nil views:views]];
    NSString *format = [NSString stringWithFormat:@"H:|-15-[_tfContent(%f)]-15-|", ScreenWidth - 30];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnSubmit]-15-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbExplation(20)]-15-[_tfContent(44)]-20-[_btnSubmit(42)]->=0-|" options:0 metrics:nil views:views]];
}

- (void) doBtnFeedBack:(UIButton *)sender
{
    [_tfContent resignFirstResponder];
    NSString *content = _tfContent.text;
    if(![NSStrUtil isMobileNumber:content]){
        [Util showAlertMessage:@"手机号码不正确，请重新输入！" ];
        return;
    }
    
    __weak InputRecommendVC *_weakSelf = self;
    [[UserModel sharedUserInfo] saveRecommendPhone:content block:^(int code) {
        if(code == 1){
            
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self doBtnFeedBack:_btnSubmit];
        return NO;
    }
    
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [_tfContent resignFirstResponder];
}

@end
