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
#import "EvaluateOrderVC.h"

@interface MyOrderListVC ()<MyOrderOnDoingTableCellDelegate, MyOrderTableCellDelegate, OrderDetailsVCDelegate>

@end

@implementation MyOrderListVC
@synthesize pullTableView;
@synthesize dataOnDoingList = dataOnDoingList;
@synthesize dataOtherList = dataOtherList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pages = 0;
    
    orderType = EnumOrderAll;
    
    self.NavigationBar.Title = @"我的订单";
    
    dataOtherList = [[NSMutableArray alloc] init];
    
    [self initSubView];
    
    __weak MyOrderListVC *weakSelf = self;
    [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll isOnlyIndexSplit:NO block:^(int code, id content) {
        if(code){
            NSArray *dataList = [MyOrderdataModel GetMyOrderList];
            dataOnDoingList = [dataList objectAtIndex:0];
            [dataOtherList addObjectsFromArray:[dataList objectAtIndex:1]];
                     // else{
            [weakSelf.pullTableView reloadData];
            [weakSelf refreshTable];
           // }
        }else{
            [weakSelf refreshTable];
        }
    }];
}

- (NSInteger) GetPagesWithDataArray:(NSArray *) array
{
    NSInteger count  = [array count] / LIMIT_COUNT;
    if([array count] % LIMIT_COUNT > 0)
        count ++;
    return count;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [pullTableView reloadData];
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
    pullTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    if(EnumOrderAll == orderType){
        if([dataOnDoingList count] == 0)
            return 1;
        else
            return 2;
    }
    else
        return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(EnumOrderAll == orderType){
        if(section == 0){
            if([dataOnDoingList count] > 0)
                return [dataOnDoingList count];
            else
                return [dataOtherList count];
        }
        else
            return [dataOtherList count];
    }
    else{
        if(dataListForCom.count==0){
            UIImage *img = ThemeImage(@"orderend");
            UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(pullTableView.frame.size.width/2-img.size.width/2, pullTableView.frame.size.height/2-img.size.height-64, img.size.width, img.size.height)];
           // [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderend"]];
            imageView.image=img;
            [self.pullTableView addSubview:imageView];
        }
        else{
            //[self.pullTableView setBackgroundView:nil];

        }
        return [dataListForCom count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(EnumOrderAll == orderType){
        if(indexPath.section == 0){
            MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            if(!cell){
                cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                cell.backgroundColor=[UIColor clearColor];//关键语句
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
            }
            MyOrderdataModel *model = nil;//[[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if([dataOnDoingList count] == 0)
                model = [dataOtherList objectAtIndex:indexPath.row];
            else
                model = [dataOnDoingList objectAtIndex:indexPath.row];
            [cell SetContentData:model];
            cell.delegate = self;
            return cell;
        }
        else{
            MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(!cell){
                cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;

            }
            MyOrderdataModel *model = [dataOtherList objectAtIndex:indexPath.row];
            [cell SetContentData:model];
            cell.delegate = self;
            return cell;
        }
    }else{
        MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.delegate = self;
        MyOrderdataModel *model = [dataListForCom objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyOrderdataModel *model = nil;
    if(EnumOrderPrepareForAssessment == orderType){
        model = [dataListForCom objectAtIndex:indexPath.row];
    }
    else{
        if(indexPath.section == 0){
            if([dataOnDoingList count] == 0)
                model = [dataOtherList objectAtIndex:indexPath.row];
            else
                model = [dataOnDoingList objectAtIndex:indexPath.row];
        }else{
            model = [dataOtherList objectAtIndex:indexPath.row];
        }
    }
//    [model addObserver:self forKeyPath:@"orderStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    OrderDetailsVC *vc = [[OrderDetailsVC alloc] initWithOrderModel:model];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    if(EnumOrderAll == orderType){
        if(section == 0 && [dataOnDoingList count] > 0){
            UIView *headerview = [[UIView alloc] initWithFrame:CGRectZero];
            [view addSubview:headerview];
            headerview.translatesAutoresizingMaskIntoConstraints = NO;
            headerview.backgroundColor = TableBackGroundColor;
            
            UILabel *_headerText = [[UILabel alloc] initWithFrame:CGRectZero];//24
            [headerview addSubview:_headerText];
            _headerText.translatesAutoresizingMaskIntoConstraints = NO;
            _headerText.font = _FONT(14);
            _headerText.textColor = _COLOR(0xe4, 0x39, 0x3c);
            _headerText.text = @"正在服务中的订单";
            _headerText.backgroundColor = TableBackGroundColor;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
            [view addSubview:line];
            line.backgroundColor = SeparatorLineColor;
            line.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSDictionary *views = NSDictionaryOfVariableBindings(headerview, _headerText, line);
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerview]-0-|" options:0 metrics:nil views:views]];
            [headerview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_headerText]-0-|" options:0 metrics:nil views:views]];
            [headerview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerText]-0-|" options:0 metrics:nil views:views]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:views]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[headerview(24)]-0-[line(1)]-0-|" options:0 metrics:nil views:views]];
            
        }else{
            view.backgroundColor = TableSectionBackgroundColor;
        }
    }
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(EnumOrderAll == orderType && section == 0 && [dataOnDoingList count] > 0)
        return 40;
    return 15.f;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    pages = 0;
    if(EnumOrderPrepareForAssessment == orderType){
        __weak MyOrderListVC *weakSelf = self;
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderPrepareForAssessment isOnlyIndexSplit:NO block:^(int code, id content) {
            if(code){
                dataListForCom = [MyOrderdataModel GetNoAssessmentOrderList];
                
                [weakSelf.pullTableView reloadData];
                [weakSelf refreshTable];
            }else{
                [weakSelf refreshTable];
            }
        }];
    }else{
        __weak MyOrderListVC *weakSelf = self;
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll isOnlyIndexSplit:NO block:^(int code, id content) {
            if(code){
                NSArray *dataList = [MyOrderdataModel GetMyOrderList];
                
                dataOnDoingList = [dataList objectAtIndex:0];
                [dataOtherList removeAllObjects];
                [dataOtherList addObjectsFromArray:[dataList objectAtIndex:1]];
                [weakSelf.pullTableView reloadData];
                [weakSelf refreshTable];
            }else{
                [weakSelf refreshTable];
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
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderAll isOnlyIndexSplit:YES block:^(int code, id content) {
            if(code){
                [dataOtherList addObjectsFromArray:content];
                [pullTableView reloadData];
                [self loadMoreDataToTable];
            }else{
                [self loadMoreDataToTable];
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
    }
    else{
        //待评价
        orderType = EnumOrderPrepareForAssessment;
        if(dataListForCom == nil){
            self.pullTableView.pullTableIsRefreshing = YES;
            [self pullTableViewDidTriggerRefresh:nil];
        }
    }
    
    [pullTableView reloadData];
}

#pragma delegate

- (void) NotifyToPayWithModel:(MyOrderdataModel *) oreder cell:(MyOrderTableCell *) cell
{
    PayForOrderVC *vc = [[PayForOrderVC alloc] initWithModel:oreder];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToCommentWithModel:(MyOrderdataModel *) order cell:(MyOrderTableCell *) cell
{
    EvaluateOrderVC *vc = [[EvaluateOrderVC alloc] initWithModel:order];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToPayWithModel:(MyOrderdataModel *) oreder onDoingcell:(MyOrderOnDoingTableCell *) cell
{
    PayForOrderVC *vc = [[PayForOrderVC alloc] initWithModel:oreder];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToCommentWithModel:(MyOrderdataModel *) order onDoingcell:(MyOrderOnDoingTableCell *) cell
{
    EvaluateOrderVC *vc = [[EvaluateOrderVC alloc] initWithModel:order];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma delegate

- (void) NotifyOrderCancelAndRefreshTableView:(OrderDetailsVC *)orderDetailVC
{
    self.pullTableView.pullTableIsRefreshing = YES;
    [self pullTableViewDidTriggerRefresh:nil];
}

@end
