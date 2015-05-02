//
//  EvaluateOrderVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateOrderVC.h"
#import "EvaluateOrderCell.h"

@interface EvaluateOrderVC ()<EvaluateOrderCellDelegate>

@end

@implementation EvaluateOrderVC
@synthesize dataList;

- (id) initWithModel:(MyOrderdataModel *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _orderModel = model;
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"评价订单";
    
    dataList = [[NSMutableArray alloc] initWithArray:_orderModel.nurseInfo];
    [self initSubViews];
}

//- (void)NotifyCommentChanged:(NSNotification *) notify
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[EvaluateOrderCell class] forCellReuseIdentifier:@"cell"];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NurseListInfoModel *model = [_orderModel.nurseInfo objectAtIndex:indexPath.row];
//    [cell SetContentWithModel:model orderId:_orderModel.oId];
//    [cell SetContentWithModel:_orderModel nuridx:(int)indexPath.row];
    [cell SetContentWithModel:_orderModel nursemodel:[_orderModel.nurseInfo objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void) NotifyEvaluateSuccessAndDelete:(NurseListInfoModel *)model
{
    [dataList removeObject:model];
    if (dataList.count==0) {
        if(_delegate && [_delegate respondsToSelector:@selector(NotifyReloadOrderInfo)]){
            [_delegate NotifyReloadOrderInfo];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
      [_tableview reloadData];
}

@end
