//
//  HealthRecordVC.m
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HealthRecordVC.h"
#import "HealthRecordTableCell.h"

@interface HealthRecordVC ()<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@end

@implementation HealthRecordVC
@synthesize tableview;

- (id) initWithLoverId:(NSString *)loverId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _model = [[HealthRecordModel alloc] init];
        _loverId = loverId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"历史纪录";
    
    tableview = [[PullTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.pullDelegate = self;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    
    if(_model){
        __weak HealthRecordVC *weakSelf = self;
        [_model LoadRecordListWithLoverId:_loverId block:^(int code, id content) {
            
            if([_model.recordList count] == 0)
            {
                [weakSelf.tableview displayEmpityImageView:ThemeImage(@"norecordbg")];
            }else
            {
                [weakSelf.tableview removeBackgroudImgView];
            }
            
            [weakSelf.tableview reloadData];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_model.recordList count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthRecordTableCell *cell = (HealthRecordTableCell *)[tableview dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[HealthRecordTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:indexPath.section];
    [cell SetContentWithModel:model];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _model.pages = 0;
    __weak HealthRecordVC *weakSelf = self;
    [_model LoadRecordListWithLoverId:_loverId block:^(int code, id content) {
        
        if([_model.recordList count] == 0)
        {
            [weakSelf.tableview displayEmpityImageView:ThemeImage(@"norecordbg")];
        }else
        {
            [weakSelf.tableview removeBackgroudImgView];
        }
        
        [weakSelf.tableview reloadData];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _model.pages ++;
    
    __weak HealthRecordVC *weakSelf = self;
    [_model LoadRecordListWithLoverId:_loverId block:^(int code, id content) {
        
        if([_model.recordList count] == 0)
        {
            [weakSelf.tableview displayEmpityImageView:ThemeImage(@"norecordbg")];
        }else
        {
            [weakSelf.tableview removeBackgroudImgView];
        }
        
        [weakSelf.tableview reloadData];
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
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

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section > 0){
        HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:section];
        HealthRecordItemDataModel *model1 = [_model.recordList objectAtIndex:section - 1];
        if(![Util isDateShowFirstDate:[model1.dateString substringToIndex:10] secondDate:[model.dateString substringToIndex:10]])
            return 40.f;
    }else
        return 40.f;
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = SeparatorLineColor;
    
    UILabel *lbDateString = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbDateString];
    lbDateString.translatesAutoresizingMaskIntoConstraints = NO;
    lbDateString.backgroundColor = [UIColor clearColor];
    lbDateString.font = _FONT(13);
    lbDateString.textColor = _COLOR(0x66, 0x66, 0x66);
    
    HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:section];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter1 dateFromString:model.dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *string = [formatter stringFromDate:date];
    lbDateString.text = string;
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbDateString]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbDateString)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbDateString]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbDateString)]];
    
    if(section > 0){
        HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:section];
        HealthRecordItemDataModel *model1 = [_model.recordList objectAtIndex:section - 1];
        if(![Util isDateShowFirstDate:[model1.dateString substringToIndex:10] secondDate:[model.dateString substringToIndex:10]])
        {
            
        }else{
            lbDateString.hidden = YES;
        }
    }else
    {
        
    }
    
    return view;
}

@end
