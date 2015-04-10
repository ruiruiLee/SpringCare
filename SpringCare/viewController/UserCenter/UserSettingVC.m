//
//  UserSettingVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserSettingVC.h"
#import "UserSettingTableCell.h"
#import "define.h"

@interface UserSettingVC ()

@end

@implementation UserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"设置";
    
    [self initSubViews];
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else if (section == 1)
        return 2;
    else
        return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserSettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UserSettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if(indexPath.section == 0)
    {
        cell._lbTitle.text = @"版本更新";
        cell._lbContent.text = @"1.0";
        cell._lbContent.hidden = NO;
        cell._imgFold.hidden = YES;
    }else if (indexPath.section == 1)
    {
        if(indexPath.row == 0){
            cell._lbTitle.text = @"告诉朋友";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
        else{
            cell._lbTitle.text = @"给我好评";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0){
            cell._lbTitle.text = @"关于我们";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
        else{
            cell._lbTitle.text = @"用户陪护协议";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.5f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

@end