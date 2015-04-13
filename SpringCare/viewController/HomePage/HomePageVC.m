//
//  HomePageVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "HomePageVC.h"
#import "AdDataModel.h"
#import "define.h"
#import <CoreText/CoreText.h>
#import "NSStrUtil.h"
#import "PlaceOrderVC.h"
#import "PlaceOrderForProductVC.h"
#import "WebContentVC.h"
#import "NurseListVC.h"
#import "HomeCareListVC.h"
#import "LCNetWorkBase.h"

#import "NewsDataModel.h"
#import "CityDataModel.h"

static NSString *hospital_product_id = nil;

@implementation HomePageVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
    }
    return self;
}

- (void) loadData
{
    [LCNetWorkBase requestWithMethod:@"api/index" Params:nil Completion:^(int code, id content) {
        if(code == 1){
            NSLog(@"%@", content);
            if([content isKindOfClass:[NSDictionary class]]){
                hospital_product_id = [content objectForKey:@"hospital_product_id"];
                [NewsDataModel SetNewsWithArray:[content objectForKey:@"posterList"]];
                scrollView.imageNameArray = [NewsDataModel getImageUrlArray];
                [CityDataModel SetCityDataWithArray:[content objectForKey:@"cityList"]];
                NSArray *wordList = [content objectForKey:@"wordList"];
                for (int i = 0; i < [wordList count]; i++) {
                    NSDictionary *dic = [wordList objectAtIndex:i];
                    if([[dic objectForKey:@"news_title"] isEqualToString:@"护理介绍"])
                        introduceUrl = [dic objectForKey:@"url"];
                    else if ([[dic objectForKey:@"news_title"] isEqualToString:@"护理承诺"])
                        promiseUrl = [dic objectForKey:@"url"];
                }
            }
        }
    }];
}

- (void) NotifyCurrentCityGained:(NSNotification*) notify
{
    NSString *city = [notify.userInfo objectForKey:@"city"];
    [activityBtn setTitle:city forState:UIControlStateNormal];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyCurrentCityGained:) name:NOTIFY_LOCATION_GAINED object:nil];
    
    [self loadData];
    
    self.lbTitle.text = @"春风陪护";
    self.NavigationBar.alpha = 0.9f;
    
    activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(320, 20, 94, 30)];
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activityBtn setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [activityBtn setTitle:@"正在定位.." forState:UIControlStateNormal];
    activityBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 78, 5, 0);
    activityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
    activityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activityBtn];
    activityBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(self.btnRight, activityBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[activityBtn(94)]-13-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[activityBtn(30)]->=10-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.btnRight attribute:NSLayoutAttributeCenterY multiplier:1 constant:2]];

    [self initWithSubviews];
}

- (void) doBtnProductList:(UIButton*)sender
{
    HomeCareListVC *vc = [[HomeCareListVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnInNurseList:(UIButton*)sender
{
    NurseListVC *vc = [[NurseListVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 187 + 64)];
//    AdDataModel * dataModel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
//    scrollView.imageNameArray = dataModel.imageNameArray;
    
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
    [btnIntro setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [btnIntro setTitle:@"护理介绍" forState:UIControlStateNormal];
    btnIntro.titleLabel.font = _FONT_B(12);
    [btnIntro addTarget:self action:@selector(doBtnIntro:) forControlEvents:UIControlEventTouchUpInside];
    
    underLine = [[UILabel alloc] initWithFrame:CGRectZero];
    underLine.backgroundColor = _COLOR(0x66, 0x66, 0x6);
    [btnIntro addSubview:underLine];
    underLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    line = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = _COLOR(0x66, 0x66, 0x66);
    [self.ContentView addSubview:line];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    
    btnCommitment = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnCommitment];
    [btnCommitment setTitleColor:dark forState:UIControlStateNormal];
    btnCommitment.translatesAutoresizingMaskIntoConstraints = NO;
    [btnCommitment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCommitment setTitle:@"服务承诺" forState:UIControlStateNormal];
    btnCommitment.titleLabel.font = _FONT_B(12);
    [btnCommitment addTarget:self action:@selector(doBtnCommitment:) forControlEvents:UIControlEventTouchUpInside];
    
    underLineCommit = [[UILabel alloc] initWithFrame:CGRectZero];
    underLineCommit.backgroundColor = _COLOR(0x66, 0x66, 0x66);
    [btnCommitment addSubview:underLineCommit];
    underLineCommit.translatesAutoresizingMaskIntoConstraints = NO;
    
    btnHospital = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnHospital];
    btnHospital.translatesAutoresizingMaskIntoConstraints = NO;
    [btnHospital setBackgroundImage:[UIImage imageNamed:@"hospital"] forState:UIControlStateNormal];
    [btnHospital addTarget:self action:@selector(doBtnInNurseList:) forControlEvents:UIControlEventTouchUpInside];
    
    btnHome = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnHome];
    btnHome.translatesAutoresizingMaskIntoConstraints = NO;
    [btnHome setBackgroundImage:[UIImage imageNamed:@"jiating"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(doBtnProductList:) forControlEvents:UIControlEventTouchUpInside];
    
    btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnRing];
    btnRing.translatesAutoresizingMaskIntoConstraints = NO;
    btnRing.backgroundColor = _COLOR(0x66, 0x66, 0x66);
    btnRing.layer.cornerRadius = 8;
    [btnRing addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
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
    lbPhone.text = @"400-626-8787";
    
    imgIden = [[UIImageView alloc] initWithFrame:CGRectZero];
    [btnRing addSubview:imgIden];
    imgIden.translatesAutoresizingMaskIntoConstraints = NO;
    imgIden.image = [UIImage imageNamed:@"shut"];
    
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
    
    btnIntro.titleLabel.font = _FONT(13);
    btnCommitment.titleLabel.font = _FONT(13);
    lbPhone.font = _FONT(23);
    btnRing.layer.cornerRadius = 10;
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(24)]->=10-|", oh + 26 - 7];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(11)]->=10-|", oh + 33 - 7];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(24)]->=10-|", oh + 26 -7];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    NSString *hospitalHFormat = [NSString stringWithFormat:@"V:|-%f-[btnHospital(135.5)]->=0-|", oh + 87];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hospitalHFormat options:0 metrics:nil views:views]];
    NSString *homeHFormat = [NSString stringWithFormat:@"V:|-%f-[btnHome(135.5)]->=0-|", oh + 87];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:homeHFormat options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(135.5)]-36-[btnHome(135.5)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(135.5)]-47-[btnRing]-89-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-59.5-[btnRing]-59.5-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(70)]-0-[line(1.2)]-0-[btnCommitment(70)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.8)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.8)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-83]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[imgRing(41)]-5-[lbPhone]-5-[imgIden(11)]-22-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(41)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(41)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(14)]->=0-|" options:0 metrics:nil views:views]];
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

- (void)btnRingClicked{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:lbPhone.text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView setTag:12];
    [alertView show];
}

#pragma alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 12) {
     if (buttonIndex==0) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",lbPhone.text]];
        [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

#pragma CityListSelectVCDelegate

- (void) NotifyCitySelectedWithData:(NSString*) data
{
    NSString *city = data;
    [activityBtn setTitle:city forState:UIControlStateNormal];
}

- (void) doBtnIntro:(UIButton*)sender
{
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"护理介绍" url:@""];
    vc.hidesBottomBarWhenPushed = YES;
    [vc loadInfoFromUrl:introduceUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnCommitment:(UIButton*)sender
{
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"服务承诺" url:@""];
    vc.hidesBottomBarWhenPushed = YES;
    [vc loadInfoFromUrl:promiseUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
