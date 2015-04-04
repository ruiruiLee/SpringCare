//
//  HomePageVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCBaseVC.h"
#import "AdScrollView.h"
#import "MainBaseVC.h"


@interface HomePageVC : MainBaseVC
{
    AdScrollView *_banner;
    
    UIButton *btnIntro;
    UILabel *underLine;
    UILabel *line;
    UIButton *btnCommitment;
    UILabel *underLineCommit;
    UIButton *btnHospital;
    UIButton *btnHome;
    UIButton *btnRing;
    UIImageView *imgRing;
    UILabel *lbPhone;
    UIImageView *imgIden;
    
}

@property(nonatomic,strong) NSArray *cityArr;
@property(nonatomic,strong) NSArray *areaArr;
@property(nonatomic,strong) NSArray *currentAreaArr;

@end
