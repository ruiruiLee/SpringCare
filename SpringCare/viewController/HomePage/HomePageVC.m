//
//  HomePageVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "HomePageVC.h"
//#import "AdDataModel.h"
#import "define.h"
#import <CoreText/CoreText.h>
#import "NSStrUtil.h"
#import "WebContentVC.h"
#import "NurseListVC.h"
#import "HomeCareListVC.h"

#import "NewsDataModel.h"
#import "CityDataModel.h"
#import "AppDelegate.h"

@implementation HomePageVC
//@synthesize scrollView = scrollView;

- (void) dealloc
{
    [cfAppDelegate removeObserver:self forKeyPath:@"currentCityModel"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        isLoaded = NO;
    }
    return self;
}

- (void) NotifyCurrentCityGained:(NSNotification *)notify
{
    if(isLoaded)
        return;
    isLoaded = YES;
    CLLocation *newLocation = [notify.userInfo objectForKey:@"location"];
    double _lat = newLocation.coordinate.latitude;
    double _lon = newLocation.coordinate.longitude;
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:[NSNumber numberWithDouble:_lon] forKey:@"longitude"];
    [parmas setObject:[NSNumber numberWithDouble:_lat] forKey:@"latitude"];
    
    [self loadData:parmas];
}

- (void) loadData:(NSDictionary *)dic
{
    __weak HomePageVC *weakSelf = self;
    [LCNetWorkBase requestWithMethod:@"api/index" Params:dic Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                [cfAppDelegate setHospital_product_id:[content objectForKey:@"hospitalProductId"]] ;
                [cfAppDelegate setDefaultProductId:[content objectForKey:@"defaultProductId"] ];
                [NewsDataModel SetNewsWithArray:[content objectForKey:@"posterList"]];
                _banner.NewsmodelArray =  [NewsDataModel getNews];
                [CityDataModel SetCityDataWithArray:[content objectForKey:@"cityList"]];
                [weakSelf selectDefaultCity];
                NSArray *wordList = [content objectForKey:@"wordList"];
                for (int i = 0; i < [wordList count]; i++) {
                    NSDictionary *dic = [wordList objectAtIndex:i];
                    if([[dic objectForKey:@"newsTitle"] isEqualToString:@"护理介绍"])
                        introduceUrl = [dic objectForKey:@"url"];
                    else if ([[dic objectForKey:@"newsTitle"] isEqualToString:@"护理承诺"])
                        promiseUrl = [dic objectForKey:@"url"];
                }
                [LcationInstance startUpdateLocation];
            }
        }
    }];
}

- (void) selectDefaultCity
{
    NSArray *array = [CityDataModel getCityData];
    if([Util GetStoreCityId] == nil){
        for (int i = 0; i < [array count]; i++) {
            CityDataModel *model = [array objectAtIndex:i];
            if(model.isNear)
            {
                [cfAppDelegate setCurrentCityModel:model];
                [Util StoreCityId:model.city_id];
            }
        }
    }
    else{
        for (int i = 0; i < [array count]; i++) {
            CityDataModel *model = [array objectAtIndex:i];
            if([model.city_id isEqualToString:[Util GetStoreCityId]])
            {
                [cfAppDelegate setCurrentCityModel:model];
                [Util StoreCityId:model.city_id];
            }
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentCityModel"])
    {
        [activityBtn setTitle:[cfAppDelegate currentCityModel].city_name forState:UIControlStateNormal];
    }else{
        if(self.view.frame.size.height == 391){
            self.view.frame = CGRectMake(0, -20, ScreenWidth, 411);
        }else if (self.view.frame.size.height == 479)
            self.view.frame = CGRectMake(0, -20, ScreenWidth, 499);
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [cfAppDelegate addObserver:self forKeyPath:@"currentCityModel" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyCurrentCityGained:) name:NOTIFY_LOCATION_GAINED object:nil];
    
    if([Util GetStoreCityId] != nil){
        [self loadData:nil];
        isLoaded = YES;
    }
    
    self.lbTitle.text = @"春风陪护";
    self.NavigationBar.alpha = 0.7f;
    
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
    NurseListVC *vc = [[NurseListVC alloc] initWithProductId:[cfAppDelegate hospital_product_id]];
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

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, oldY)];
}

- (void) initWithSubviews
{
    //广告
    float scale = ScreenWidth/375.0;
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 251 * scale);
    if(type == EnumValueTypeiPhone4S)
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 251 * scale - 40);
    
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.size.height - 20);
    _banner = [[AdScrollView alloc]initWithFrame:rect];
    _banner.parentController=self;
    _banner.PageControlShowStyle = UIPageControlShowStyleCenter;
    _banner.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _banner.pageControl.currentPageIndicatorTintColor = Abled_Color;
    [self.view insertSubview:_banner belowSubview:self.NavigationBar];
    
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
//    btnRing.backgroundColor = _COLOR(0x66, 0x66, 0x66);
    UIImage *image = [Util imageWithColor:_COLOR(0x66, 0x66, 0x66) size:CGSizeMake(5, 5)];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
    [btnRing setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    btnRing.clipsToBounds = YES;
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
    imgIden.image = [UIImage imageNamed:@"nav-right"];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(btnIntro, line, btnCommitment, btnHospital, btnHome, btnRing, imgRing, lbPhone, imgIden, underLine, underLineCommit);
    
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
    CGFloat oh = _banner.frame.size.height;
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(20)]->=10-|", oh + 16 ];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(9)]->=10-|", oh + 22 ];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(20)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-34-[btnHospital(100)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(20)]-34-[btnHome(100)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(100)]-24-[btnRing(50)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(220)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(100)]-30-[btnHome(100)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-66]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(60)]-0-[line(1.2)]-0-[btnCommitment(60)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imgRing(34)]-5-[lbPhone]-5-[imgIden(11)]-15-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(34)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(32.5)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(14)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:lbPhone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [btnRing addConstraint:[NSLayoutConstraint constraintWithItem:imgIden attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnRing attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHome attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btnHospital attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}


- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
    btnIntro.titleLabel.font = _FONT(12);
    btnCommitment.titleLabel.font = _FONT(12);
    lbPhone.font = _FONT(21);
    btnRing.layer.cornerRadius = 8;
    
    CGFloat oh = _banner.frame.size.height;
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(17)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(7.5)]->=10-|", oh + 22];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(17)]->=10-|", oh + 16];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(17)]-39-[btnHospital(112)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnIntro(17)]-39-[btnHome(112)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(112)]-30-[btnHome(112)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(112)]-42-[btnRing(46)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnRing(220)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(61)]-0-[line(1.2)]-0-[btnCommitment(61)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.7)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.7)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-70]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imgRing(34)]-5-[lbPhone]-5-[imgIden(11)]-15-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(34)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(30)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(14)]->=0-|" options:0 metrics:nil views:views]];
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
    lbPhone.font = _FONT(25);
    btnRing.layer.cornerRadius = 10;
    
    NSString *format = [NSString stringWithFormat:@"V:|-%f-[btnIntro(26)]->=10-|", oh + 26 - 7 + 1.9];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    NSString *lineHformat = [NSString stringWithFormat:@"V:|-%f-[line(12)]->=10-|", oh + 33 - 7 + 1.9];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHformat options:0 metrics:nil views:views]];
    
    NSString *commentHformat = [NSString stringWithFormat:@"V:|-%f-[btnCommitment(26)]->=10-|", oh + 26 -7 + 1.9];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHformat options:0 metrics:nil views:views]];
    
    NSString *hospitalHFormat = [NSString stringWithFormat:@"V:|-%f-[btnHospital(149)]->=0-|", oh + 87 + 8.7];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hospitalHFormat options:0 metrics:nil views:views]];
    NSString *homeHFormat = [NSString stringWithFormat:@"V:|-%f-[btnHome(149)]->=0-|", oh + 87 + 8.7];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:homeHFormat options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnHospital(149)]-36-[btnHome(149)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnHospital(149)]-52-[btnRing]-98-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-59.5-[btnRing]-59.5-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[btnIntro(77)]-0-[line(1.2)]-0-[btnCommitment(77)]->=0-|" options:0 metrics:nil views:views]];
    
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[underLine]-9-|" options:0 metrics:nil views:views]];
    [btnIntro addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLine(0.8)]-2-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[underLineCommit]-9-|" options:0 metrics:nil views:views]];
    [btnCommitment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[underLineCommit(0.8)]-2-|" options:0 metrics:nil views:views]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnHospital attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-83]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[imgRing(45)]-5-[lbPhone]-5-[imgIden(11)]-22-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgRing(45)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbPhone(45)]->=0-|" options:0 metrics:nil views:views]];
    [btnRing addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgIden(14)]->=0-|" options:0 metrics:nil views:views]];
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
    [vc loadInfoFromUrl:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Introduce]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnCommitment:(UIButton*)sender
{
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"服务承诺" url:@""];
    vc.hidesBottomBarWhenPushed = YES;
    [vc loadInfoFromUrl:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Promiss]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
