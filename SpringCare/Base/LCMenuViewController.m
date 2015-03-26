//
//  LCMenuViewController.m
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCMenuViewController.h"
#import "define.h"
#import "MenuTableViewCell.h"
#import "SliderViewController.h"

@implementation LCMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    tableview.tableFooterView = footerView;
//    footerView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth/400.0 * (ScreenWidth/2.0 - 60))/2.0 - 60, 40, 120, 34)];
    
//    CGAffineTransform transT = CGAffineTransformMakeTranslation(Left_SContent_Offset, 0);//设置偏移
//    CGAffineTransform scaleT = CGAffineTransformMakeScale(scale, scale);//设置缩放，分别为x方向，y方向
//    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
//    CGPoint center = self.view.center;
//    CGPoint new = CGPointApplyAffineTransform(center, conT);
//    CGSize size = CGSizeApplyAffineTransform(self.view.frame.size, conT);
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)/2 - 60, 40, 120, 34)];
    [footerView addSubview:btnCancel];
    btnCancel.layer.cornerRadius = 17;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = _COLOR(222, 222, 222).CGColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view, tableview);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views]];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableview dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imgIcon.image = [UIImage imageNamed:@"main_1"];
    cell.lbContent.text = @"史蒂夫和南";
    cell.imgUnflod.image = [UIImage imageNamed:@"main_1"];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
