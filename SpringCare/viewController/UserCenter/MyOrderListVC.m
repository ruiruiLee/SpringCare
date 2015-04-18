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
#import "MyOrderdataModel.h"
#import "OrderDetailsVC.h"
#import "PayForOrderVC.h"

@interface MyOrderListVC ()

@end

@implementation MyOrderListVC
@synthesize pullTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pages = 0;
    
    orderType = EnumOrderAll;
    
    self.NavigationBar.Title = @"我的订单";
    
    [self initSubView];
    
    dataList = [MyOrderdataModel GetMyOrderList];
//    if([dataList count] == 2){
//        pages = [self GetPagesWithDataArray:[dataList objectAtIndex:1]];
//    }
    
//    if(pages == 0){
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll block:^(int code) {
            if(code){
                dataList = [MyOrderdataModel GetMyOrderList];
                [pullTableView reloadData];
                [self refreshTable];
            }else{
                [self refreshTable];
            }
        }];
//    }
}

- (NSInteger) GetPagesWithDataArray:(NSArray *) array
{
    NSInteger count  = [array count] / LIMIT_COUNT;
    if([array count] % LIMIT_COUNT > 0)
        count ++;
    return count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubView
{
    _tabBar = [[LCTabBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [self.ContentView addSubview:_tabBar];
    NSArray *titleArray = @[@"全部订单", @"待评价"];
    [_tabBar SetItemTitleArray:titleArray];
    _tabBar.delegate = self;
    
    pullTableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    pullTableView.delegate = self;
    pullTableView.dataSource = self;
    [self.ContentView addSubview:pullTableView];
    pullTableView.backgroundColor = TableBackGroundColor;
    pullTableView.translatesAutoresizingMaskIntoConstraints = NO;
    pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pullTableView.pullDelegate = self;
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = TableBackGroundColor;
    self.pullTableView.backgroundColor = TableBackGroundColor;
    self.pullTableView.pullTextColor = [UIColor blackColor];
    [pullTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tabBar, pullTableView);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabBar(40)]-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(EnumOrderAll == orderType)
        return [dataList count];
    else
        return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(EnumOrderAll == orderType){
        if(section == 0)
            return [[dataList objectAtIndex:0] count];
        else
            return [[dataList objectAtIndex:1] count];
    }
    else
        return [dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(EnumOrderAll == orderType){
        if(indexPath.section == 0)
            return 134.f;
    }
    
    return 109.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(EnumOrderAll == orderType){
        if(indexPath.section == 0){
            MyOrderOnDoingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            if(!cell){
                cell = [[MyOrderOnDoingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            }
            MyOrderdataModel *model = [[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [cell SetContentData:model];
            return cell;
        }
        else{
            MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(!cell){
                cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            MyOrderdataModel *model = [[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [cell SetContentData:model];
            return cell;
        }
    }else{
        MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        MyOrderdataModel *model = [dataList objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailsVC *vc = [[OrderDetailsVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
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

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    pages = 0;
    if(EnumOrderPrepareForAssessment == orderType){
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderPrepareForAssessment block:^(int code) {
            if(code){
                dataList = [MyOrderdataModel GetNoAssessmentOrderList];
                [pullTableView reloadData];
                [self refreshTable];
            }else{
                [self refreshTable];
            }
        }];
    }else{
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll block:^(int code) {
            if(code){
                dataList = [MyOrderdataModel GetMyOrderList];
                [pullTableView reloadData];
                [self refreshTable];
            }else{
                [self refreshTable];
            }
        }];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    pages ++;
    if(EnumOrderPrepareForAssessment == orderType){
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
    }else{
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll block:^(int code) {
            if(code){
                dataList = [MyOrderdataModel GetMyOrderList];
                [pullTableView reloadData];
                [self refreshTable];
            }else{
                [self refreshTable];
            }
        }];
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    NSLog(@"refreshTable");
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    NSLog(@"loadMoreDataToTable");
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma LCTabBarDelegate

- (void) NotifyItemClickedWithIdx:(NSInteger) idx
{
    if(idx == 0){
        //全部订单
        orderType = EnumOrderAll;
        dataList = [MyOrderdataModel GetMyOrderList];
        if([dataList count] == 2){
            pages = [self GetPagesWithDataArray:[dataList objectAtIndex:1]];
        }
    }
    else{
        //待评价
        orderType = EnumOrderPrepareForAssessment;
        dataList = [MyOrderdataModel GetNoAssessmentOrderList];
        pages = [self GetPagesWithDataArray:dataList];
    }
    
    [pullTableView reloadData];
}

@end
