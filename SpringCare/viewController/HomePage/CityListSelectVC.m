//
//  CityListSelectVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CityListSelectVC.h"
#import "define.h"
#import "CityListCell.h"

@implementation CityListSelectVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.NavigationBar.Title = @"城市列表";
    
    [self InitSubviews];
}

- (void) InitSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] init];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[CityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.lbTitle.text = @"成都市";
    return cell;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = _COLOR(222, 222, 222);
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbTitle];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = _FONT(15);
    lbTitle.textColor = _COLOR(73, 73, 73);
    lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[lbTitle]-20-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
    if(section == 0){
        lbTitle.text = @"当前定位城市";
    }
    else{
        lbTitle.text = @"选择热门城市";
    }
    return view;
}

#pragma UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) BeginLocation
{
    
}

@end
