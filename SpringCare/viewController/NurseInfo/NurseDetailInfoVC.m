//
//  NurseDetailInfoVC.m
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseDetailInfoVC.h"

@implementation NurseDetailInfoVC

- (id)initWithModel:(NurseListInfoModel*)model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _nurseInfo = model;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.NavigationBar.Title = _nurseInfo.name;
    
    _nurseInfo.name = @"1234";
}

@end
