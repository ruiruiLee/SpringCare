//
//  HomePageVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "HomePageVC.h"
#import "SliderViewController.h"
#import "AdDataModel.h"
#import "define.h"
#import <CoreText/CoreText.h>
//#import "sys/utsname.h"
#import "NSStrUtil.h"
//#import "LoginVC.h"

@implementation HomePageVC

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.lbTitle.text = @"春风陪护";
    [self.btnLeft setImage:[UIImage imageNamed:@"nav-person"] forState:UIControlStateNormal];
    self.NavigationBar.alpha = 0.9f;
    
    activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(320, 20, 74, 30)];
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activityBtn setTitle:@"附近" forState:UIControlStateNormal];
    [activityBtn setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    activityBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 58, 5, 0);
    [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activityBtn];
    activityBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(self.btnRight, activityBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[activityBtn(74)]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[activityBtn(30)]->=10-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.btnRight attribute:NSLayoutAttributeCenterY multiplier:1 constant:2]];
    
    [self initWithSubviews];
}

- (void) btnPressed:(UIButton*) sender
{
    CityListSelectVC *vc = [[CityListSelectVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void) initWithSubviews
{
    //广告
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 213)];
    AdDataModel * dataModel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    scrollView.imageNameArray = dataModel.imageNameArray;
    scrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self.view insertSubview:scrollView belowSubview:self.NavigationBar];
    _banner = scrollView;
    
    UIColor *dark = _COLOR(90, 90, 100);
    //介绍
    btnIntro = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnIntro];
    btnIntro.translatesAutoresizingMaskIntoConstraints = NO;
    [btnIntro setTitleColor:dark forState:UIControlStateNormal];
    [btnIntro setTitle:@"护理介绍" forState:UIControlStateNormal];
    btnIntro.titleLabel.font = _FONT(11);
    
    underLine = [[UILabel alloc] initWithFrame:CGRectZero];
    underLine.backgroundColor = dark;
    [btnIntro addSubview:underLine];
    underLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    line = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = dark;
    [self.ContentView addSubview:line];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    
    btnCommitment = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnCommitment];
    [btnCommitment setTitleColor:dark forState:UIControlStateNormal];
    btnCommitment.translatesAutoresizingMaskIntoConstraints = NO;
    [btnCommitment setTitleColor:dark forState:UIControlStateNormal];
    [btnCommitment setTitle:@"服务承若" forState:UIControlStateNormal];
    btnCommitment.titleLabel.font = _FONT(11);
    
    underLineCommit = [[UILabel alloc] initWithFrame:CGRectZero];
    underLineCommit.backgroundColor = dark;
    [btnCommitment addSubview:underLineCommit];
    underLineCommit.translatesAutoresizingMaskIntoConstraints = NO;
    
    btnHospital = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnHospital];
    btnHospital.translatesAutoresizingMaskIntoConstraints = NO;
    [btnHospital setBackgroundImage:[UIImage imageNamed:@"hospital"] forState:UIControlStateNormal];
    
    btnHome = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnHome];
    btnHome.translatesAutoresizingMaskIntoConstraints = NO;
    [btnHome setBackgroundImage:[UIImage imageNamed:@"jiating"] forState:UIControlStateNormal];
    
    btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnRing];
    btnRing.translatesAutoresizingMaskIntoConstraints = NO;
    btnRing.backgroundColor = dark;
    btnRing.layer.cornerRadius = 8;
    
    imgRing = [[UIImageView alloc] initWithFrame:CGRectZero];
    [btnRing addSubview:imgRing];
    imgRing.translatesAutoresizingMaskIntoConstraints = NO;
    [imgRing setImage:[UIImage imageNamed:@"call"]];
    
    lbPhone = [[UILabel alloc] initWithFrame:CGRectZero];
    lbPhone.backgroundColor = [UIColor clearColor];
    [btnRing addSubview:lbPhone];
    lbPhone.translatesAutoresizingMaskIntoConstraints = NO;
    lbPhone.textAlignment = NSTextAlignmentCenter;
    lbPhone.textColor = [UIColor whiteColor];
    lbPhone.font = _FONT(20);
    lbPhone.text = @"400 888 888";
    
    imgIden = [[UIImageView alloc] initWithFrame:CGRectZero];
    [btnRing addSubview:imgIden];
    imgIden.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(btnIntro, line, btnCommitment, btnHospital, btnHome, btnRing, imgRing, lbPhone, imgIden, underLine, underLineCommit);
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        [self InitConstraintsForiPhone4S:views];
    }
    else if (type == EnumValueTypeiPhone5){
        [self InitConstraintsForiPhone5:views];
    }
    else if (type == EnumValueTypeiPhone6){
        [self InitConstraintsForiPhone6:views];
    }
    else if (type == EnumValueTypeiPhone6P){
        [self InitConstraintsForiPhone6P:views];
    }else{
        [self InitConstraintsForiPhone5:views];
    }
}

- (void) InitConstraintsForiPhone4S:(NSDictionary*) views
{
    _banner.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 174);
    CGFloat oh = _banner.frame.size.height;
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(20)]->=10-|", oh + 16 ];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(9)]->=10-|", oh + 22 ];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(20)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-32-[btnHospital(94)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-34-[btnHome(94)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(94)]-24-[btnRing(50)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(220)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(94)]-38-[btnHome(94)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-66]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(60)]-0-[line(1.2)]-0-[btnCommitment(60)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imgRing(35)]-5-[lbPhone]-5-[imgIden(25)]-15-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgIden attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
    CGFloat oh = _banner.frame.size.height;
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(20)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(9)]->=10-|", oh + 22];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(20)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-39-[btnHospital(114)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-39-[btnHome(114)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(114)]-32-[btnHome(114)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(114)]-42-[btnRing(50)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(220)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(60)]-0-[line(1.2)]-0-[btnCommitment(60)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-72]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imgRing(35)]-5-[lbPhone]-5-[imgIden(25)]-15-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgIden attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    CGFloat oh = _banner.frame.size.height;
    
    btnIntro.titleLabel.font = _FONT(14);
    btnCommitment.titleLabel.font = _FONT(14);
    lbPhone.font = _FONT(22);
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(24)]->=10-|", oh + 26];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(11)]->=10-|", oh + 33];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(24)]->=10-|", oh + 26];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(24)]-59-[btnHospital(124)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(24)]-59-[btnHome(124)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(124)]-42-[btnHome(124)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(124)]-62-[btnRing(60)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(260)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(76)]-0-[line(1.2)]-0-[btnCommitment(76)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-83]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imgRing(35)]-5-[lbPhone]-5-[imgIden(25)]-20-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgIden attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    CGFloat oh = _banner.frame.size.height;
    
    btnIntro.titleLabel.font = _FONT(15);
    btnCommitment.titleLabel.font = _FONT(15);
    lbPhone.font = _FONT(23);
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(30)]->=10-|", oh + 26];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(14)]->=10-|", oh + 35];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(30)]->=10-|", oh + 26];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(30)]-69-[btnHospital(144)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(30)]-69-[btnHome(144)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(144)]-42-[btnHome(144)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(144)]-72-[btnRing(64)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(280)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(80)]-0-[line(1.2)]-0-[btnCommitment(80)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-93]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[imgRing(35)]-5-[lbPhone]-5-[imgIden(25)]-25-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgIden attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) LeftButtonClicked:(id)sender
{
    [[SliderViewController sharedSliderController] leftItemClick];
}

//- (NSString*)deviceString
//{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    return platform;
//}

#pragma CityListSelectVCDelegate

- (void) NotifyCitySelectedWithData:(NSDictionary*) data
{
    NSString *city = @"成都";
    [activityBtn setTitle:city forState:UIControlStateNormal];
}

@end
