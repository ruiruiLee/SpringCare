//
//  MyOrderListVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyOrderListVC.h"
#import "define.h"
#import "MyOrderTableCell.h"
#import "MyOrderOnDoingTableCell.h"

@interface MyOrderListVC ()

@end

@implementation MyOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataList = [OrderListModel GetOrderList];
    
    self.NavigationBar.Title = @"我的订单";
    
    [self initSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubView
{
    _tabBar = [[LCTabBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [self.ContentView addSubview:_tabBar];
//    _tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *titleArray = @[@"全部订单", @"待评价"];
    [_tabBar SetItemTitleArray:titleArray];
    _tabBar.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.ContentView addSubview:_tableView];
    _tableView.backgroundColor = TableBackGroundColor;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tabBar, _tableView);
    
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tabBar]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabBar(40)]-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return [dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 134.f;
    else
        return 109.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        MyOrderOnDoingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if(!cell){
            cell = [[MyOrderOnDoingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        }
        OrderListModel *model = [dataList objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
    else{
        MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        OrderListModel *model = [dataList objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (void) NotifyItemClickedWithIdx:(NSInteger) idx
{
    if(idx == 0){
        //全部订单
    }
    else{
        //待评价
    }
}

@end
