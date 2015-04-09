//
//  EditUserInfoVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "EditUserTableviewCell.h"
#import "EditCellTypeData.h"

@interface EditUserInfoVC ()

@end

@implementation EditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"编辑我的资料";
    
    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[EditUserTableviewCell class] forCellReuseIdentifier:@"cell"];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditUserTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    if(!cell)
//    {
//        cell = [[EditUserTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
    
    EditCellTypeData *typedata = [_data objectAtIndex:indexPath.row];
    [cell SetcontentData:typedata info:nil];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell.tfEdit.isEnabled)
        [cell.tfEdit becomeFirstResponder];
}

- (void) setContentArray:(NSArray*)dataArray
{
    _data = dataArray;
    [_tableview reloadData];
}

@end
