//
//  HomePageVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "HomePageVC.h"
#import "SliderViewController.h"

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
    
    self.ContentView.backgroundColor = [UIColor redColor];
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[SliderViewController sharedSliderController] leftItemClick];
}

@end
