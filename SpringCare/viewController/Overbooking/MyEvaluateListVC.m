//
//  MyEvaluateListVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyEvaluateListVC.h"
#import "EvaluateListCell.h"
//#import "IQKeyboardReturnKeyHandler.h"

@interface MyEvaluateListVC ()
{
    NSString *_currentCareId;
}

@property (nonatomic, strong) EvaluateListCell *prototypeCell;

@end

@implementation MyEvaluateListVC
@synthesize tableview = _tableview;
@synthesize DataList;
@synthesize prototypeCell;

- (id) initVCWithNurseId:(NSString *) nurseId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _currentCareId = nurseId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pages = 0;
    DataList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"评价";
    _careModel = [[CareEvaluateInfoModel alloc] init];
    _careModel.careId = _currentCareId;
    __weak MyEvaluateListVC *weakSelf = self;
    self.tableview.pullTableIsRefreshing = YES;
    [_careModel LoadCommentListWithPages:pages isOnlySplit:NO block:^(int code, id content) {
        if(code){
            [weakSelf.DataList removeAllObjects];
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf.tableview reloadData];
            
            [weakSelf reSetHeaderView];
        }
        
        [weakSelf refreshTable];
    }];
    
    [self initSubviews];
}

- (void) reSetHeaderView
{
//    lbTitle.text = @"累计评价36（好评80%）";
    NSString *text = [NSString stringWithFormat:@"累计评价%d（好评%@%@）", _careModel.commentsNumber, _careModel.commentsRate, @"%"];
    lbTitle.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    lbTitle.textColor = _COLOR(0x99, 0x99, 0x99);
    lbTitle.font = _FONT(15);
    [headerView addSubview:lbTitle];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-19-[lbTitle]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
    
    _tableview = [[PullTableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.pullDelegate = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.tableHeaderView = headerView;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[EvaluateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EvaluateDataModel *data = [DataList objectAtIndex:indexPath.row];
    [cell SetContentDataWith:data];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(prototypeCell == nil){
        prototypeCell = [[EvaluateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    EvaluateDataModel *data = [DataList objectAtIndex:indexPath.row];
    EvaluateListCell *cell = (EvaluateListCell *)self.prototypeCell;
    [cell SetContentDataWith:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    __weak MyEvaluateListVC *weakSelf = self;
    [_careModel LoadCommentListWithPages:0 isOnlySplit:NO block:^(int code, id content) {
        if(code){
            pages = 0;
            [weakSelf.DataList removeAllObjects];
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf.tableview reloadData];
        }
        [weakSelf reSetHeaderView];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    __weak MyEvaluateListVC *weakSelf = self;
    [_careModel LoadCommentListWithPages:pages + 1 isOnlySplit:YES block:^(int code, id content) {
        if(code){
            pages ++;
            [weakSelf.DataList addObjectsFromArray:content];
            [weakSelf.tableview reloadData];
        }
        [weakSelf reSetHeaderView];
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1];
    }];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    NSLog(@"refreshTable");
    self.tableview.pullLastRefreshDate = [NSDate date];
    self.tableview.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    NSLog(@"loadMoreDataToTable");
    self.tableview.pullTableIsLoadingMore = NO;
}


@end
