//
//  FeedBackVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "FeedBackVC.h"
#import "define.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

#import "IQKeyboardReturnKeyHandler.h"

@interface FeedBackVC ()

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"意见反馈";
    self.ContentView.backgroundColor = TableBackGroundColor;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeySend;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    [self initSubViews];
}

- (void) initSubViews
{
    _lbExplation = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_lbExplation];
    _lbExplation.translatesAutoresizingMaskIntoConstraints = NO;
    _lbExplation.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbExplation.font = _FONT(14);
    _lbExplation.backgroundColor = [UIColor clearColor];
    _lbExplation.text = @"告诉“春风陪护”您的宝贵意见，我们改进会更快哦";
    
    _tvContent = [[UITextView alloc] initWithFrame:CGRectZero];
    _tvContent.delegate = self;
    [self.ContentView addSubview:_tvContent];
    _tvContent.translatesAutoresizingMaskIntoConstraints = NO;
    _tvContent.font = _FONT(14);
    _tvContent.returnKeyType = UIReturnKeySend;
    
    _btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_btnSubmit];
    [_btnSubmit setTitle:@"提交宝贵意见" forState:UIControlStateNormal];
    _btnSubmit.layer.cornerRadius = 8;
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    _btnSubmit.backgroundColor = Abled_Color;
    [_btnSubmit addTarget:self action:@selector(doBtnFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbExplation, _tvContent, _btnSubmit);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_lbExplation]-15-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_tvContent]-15-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnSubmit]-15-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbExplation(20)]-5-[_tvContent(120)]-20-[_btnSubmit(42)]->=0-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doBtnFeedBack:(UIButton *)sender
{
    [_tvContent resignFirstResponder];
    NSString *content = _tvContent.text;
    if(content == nil || [content length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入内容，谢谢你对我们的支持！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
    __weak FeedBackVC *_weakSelf = self;
    [agent syncFeedbackThreadsWithBlock:@"" contact:content block:^(NSArray *objects, NSError *error) {
        if(error == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"感谢你对我们产品的支持！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [_weakSelf.navigationController popViewControllerAnimated:YES];
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

@end
