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
{
    int loadCount;
}

@property (nonatomic, strong) MyOrderTableCell *prototypeCell;

@end

@implementation MyOrderListVC
@synthesize pullTableView;
@synthesize dataOnDoingList = dataOnDoingList;
@synthesize dataOtherList = dataOtherList;
@synthesize isComment;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pages = 0;
    
    isComment = NO;
    
    self.NavigationBar.Title = @"我的订单";
    
    dataOtherList = [[NSMutableArray alloc] init];
    
    [self initSubView];
   // [self loadDataList];
   }

-(void)loadDataList{
    __weak MyOrderListVC *weakSelf = self;
    
    loadCount = 2;
    
    [MyOrderdataModel loadOrderlistWithPages:0 type:EnumOrderService isOnlyIndexSplit:NO block:^(int code, id content) {
        if(code){
            dataOnDoingList = content; // 正在进行中的订单
            [weakSelf.pullTableView removeBackgroudImgView];
            loadCount -- ;
            if(loadCount == 0){
                [weakSelf.pullTableView reloadData];
                if (dataOnDoingList.count==0 && dataOtherList.count==0) {
                    [weakSelf.pullTableView displayEmpityImageView:noOrderBackbroundImg];
                }
            }
            [weakSelf refreshTable];
        }else{
            [weakSelf refreshTable];
        }
    }];
    
    [MyOrderdataModel loadOrderlistWithPages:0 type:EnumOrderOther isOnlyIndexSplit:NO block:^(int code, id content) {
        if(code){
            [dataOtherList removeAllObjects];
            [dataOtherList addObjectsFromArray:content]; // 全部订单
            [weakSelf.pullTableView removeBackgroudImgView];
            loadCount -- ;
            if(loadCount == 0){
                [weakSelf.pullTableView reloadData];
                
                if (dataOnDoingList.count==0 && dataOtherList.count==0) {
                    [weakSelf.pullTableView displayEmpityImageView:noOrderBackbroundImg];
                }
            }
            [weakSelf refreshTable];
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
    //if(isComment){
    [self pullTableViewDidTriggerRefresh:nil];
    //}
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


#pragma EvaluateOrderDelegate
//- (void) NotifyReloadOrderInfo{
//    [self pullTableViewDidTriggerRefresh:nil];
//}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!isComment){
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
    if(!isComment){
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
        return [dataListForCom count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.prototypeCell == nil){
        self.prototypeCell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        self.prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyOrderdataModel *model = nil;//[[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(!isComment){
        if(indexPath.section == 0){
            if([dataOnDoingList count] == 0){
                if([dataOtherList count] > indexPath.row)
                    model = [dataOtherList objectAtIndex:indexPath.row];
            }
            else{
                model = [dataOnDoingList objectAtIndex:indexPath.row];
            }
        }else
            if([dataOtherList count] > indexPath.row)
                model = [dataOtherList objectAtIndex:indexPath.row];
    }else
        model = [dataListForCom objectAtIndex:indexPath.row];
    MyOrderTableCell *cell = (MyOrderTableCell *)self.prototypeCell;
    [cell SetContentData:model];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isComment){
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
            if([dataOtherList count] > indexPath.row){
                MyOrderdataModel *model = [dataOtherList objectAtIndex:indexPath.row];
                [cell SetContentData:model];
            }
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
    if(isComment){
        model = [dataListForCom objectAtIndex:indexPath.row];
    }
    else{
        if(indexPath.section == 0){
            if([dataOnDoingList count] == 0){
                if([dataOtherList count] > indexPath.row)
                    model = [dataOtherList objectAtIndex:indexPath.row];
            }
            else{
                if([dataOnDoingList count] > indexPath.row)
                    model = [dataOnDoingList objectAtIndex:indexPath.row];
            }
        }else{
            if([dataOtherList count] > indexPath.row)
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
    if(!isComment){
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
    if(!isComment && section == 0 && [dataOnDoingList count] > 0)
        return 40;
    return 15.f;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    pages = 0;
    if(isComment){
        __weak MyOrderListVC *weakSelf = self;
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderPrepareForAssessment isOnlyIndexSplit:NO block:^(int code, id content) {
            if(code){
                dataListForCom = [NSArray arrayWithArray:[MyOrderdataModel GetNoAssessmentOrderList]]; //评论中的订单
                
                if(dataListForCom.count>0){
                    [weakSelf.pullTableView removeBackgroudImgView];
                    [weakSelf.pullTableView reloadData];
                    [weakSelf refreshTable];
                }else{
                     [weakSelf refreshTable];
                     [weakSelf.pullTableView displayEmpityImageView:noOrderBackbroundImg];
                }
            }else{
                [weakSelf refreshTable];
            }
        }];
    }else{
        
        [self loadDataList];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    pages ++;
    if(isComment){
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
    }else{
        __weak MyOrderListVC *weakSelf = self;
        [MyOrderdataModel loadOrderlistWithPages:pages type:EnumOrderOther isOnlyIndexSplit:NO block:^(int code, id content) {
            if(code){
                [dataOtherList addObjectsFromArray:content];
                [weakSelf.pullTableView reloadData];
                [weakSelf loadMoreDataToTable];
                
                if (dataOnDoingList.count==0 && dataOtherList.count==0) {
                    [weakSelf.pullTableView displayEmpityImageView:noOrderBackbroundImg];
                }
            }else{
                [weakSelf loadMoreDataToTable];
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
        isComment = NO;
        [self.pullTableView removeBackgroudImgView];
        if (dataOtherList.count==0&& dataOnDoingList.count==0) {
            [self.pullTableView displayEmpityImageView:noOrderBackbroundImg];
        }else{
            [self.pullTableView removeBackgroudImgView];
        }

    }
    else{
        //待评价
        isComment = YES;
        if(dataListForCom == nil){
            //self.pullTableView.pullTableIsRefreshing = YES;
            [self pullTableViewDidTriggerRefresh:nil];
        }
        else{
            if (dataListForCom.count==0) {
                [self.pullTableView displayEmpityImageView:noOrderBackbroundImg];
            }else{
                 [self.pullTableView removeBackgroudImgView];
            }

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
    vc.delegate=(id)self;
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
     vc.delegate=(id)self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma delegate

- (void) NotifyOrderCancelAndRefreshTableView:(OrderDetailsVC *)orderDetailVC
{
    self.pullTableView.pullTableIsRefreshing = YES;
    [self pullTableViewDidTriggerRefresh:nil];
}

@end
