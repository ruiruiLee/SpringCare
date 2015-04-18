//
//  NurseListMainVC.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "NurseListMainVC.h"
#import "PlaceOrderVC.h"
#import "NurseIntroTableCell.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "LoginVC.h"

@implementation NurseListMainVC
@synthesize pullTableView;
@synthesize DataList;
@synthesize prototypeCell;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _SearchConditionStr = @"";
        _model = [[NurseListInfoModel alloc] init];
        
        pages = 0;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.lbTitle.text = @"陪护师";
//    [self.btnLeft setBackgroundImage:[UIImage imageNamed:@"nav-person"] forState:UIControlStateNormal];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    searchBar.backgroundImage = [self imageWithColor:_COLOR(0xf3, 0xf5, 0xf7) size:CGSizeMake(ScreenWidth, 44)];
    
    [self.view addSubview:searchBar];
    
    pullTableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:pullTableView];
    pullTableView.rowHeight = UITableViewAutomaticDimension;//启用预估行高度
    pullTableView.estimatedRowHeight = 100.0f;
    pullTableView.dataSource = self;
    pullTableView.delegate = self;
    pullTableView.pullDelegate = self;
    
    self.prices = @[@"价格区间",@"200元-300元",@"300元-500元",@"500元以上"];
    self.ages = @[@"年龄区间",@"20岁-30岁",@"30岁-40岁",@"40岁以上"];
    self.goodes = @[@"距离最近",@"护龄最长",@"好评优先",@"评论最多"];
        //数据先初始化
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    menu.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = TableBackGroundColor;
    self.pullTableView.backgroundColor = TableBackGroundColor;
    self.pullTableView.pullTextColor = [UIColor blackColor];
    [pullTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = self.NavigationBar;
    NSDictionary *views = NSDictionaryOfVariableBindings(pullTableView, self.ContentView, view, searchBar, menu);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(64)]-0-[searchBar(44)]-0-[menu(40)]-0-[pullTableView]-49-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menu]-0-|" options:0 metrics:nil views:views]];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    pullTableView.tableFooterView = footer;
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [_model loadNurseDataWithPage:(int)pages type:EnumTypeHospital key:nil ordr:nil sortFiled:nil productId:delegate.defaultProductId block:^(int code) {
        self.DataList = [NurseListInfoModel nurseListModel];
        [pullTableView reloadData];
        [self refreshTable];
    }];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
    }
}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setDataList:(NSMutableArray *)list
{
    DataList = list;
    [pullTableView reloadData];
}

- (void) appendDataWithArray:(NSArray*)array
{
    [DataList addObjectsFromArray:array];
    [pullTableView reloadData];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NurseIntroTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[NurseIntroTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
//    cell.textLabel.text = ((NurseListInfoModel*)[DataList objectAtIndex:indexPath.row]).name;
    NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
    [cell SetContentData:model];
    
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
        prototypeCell = [[NurseIntroTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NurseListInfoModel *data = [DataList objectAtIndex:indexPath.row];
    NurseIntroTableCell *cell = (NurseIntroTableCell *)self.prototypeCell;

    [cell SetContentData:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![[UserModel sharedUserInfo] isLogin]){
        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self.navigationController pushViewController:nav animated:YES];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else{
        NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
        PlaceOrderVC *vc = [[PlaceOrderVC alloc] initWithModel:model andproductId:[[NurseListInfoModel PramaNurseDic] objectForKey:@"productId"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    pages = 0;
    [_model loadNurseDataWithPage:(int)pages prama:nil block:^(int code) {
        self.DataList = [NurseListInfoModel nurseListModel];
        [self refreshTable];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    pages ++;
    
    [_model loadNurseDataWithPage:(int)pages prama:nil block:^(int code) {
        self.DataList = [NurseListInfoModel nurseListModel];
        [self loadMoreDataToTable];
    }];
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

#pragma KVO/KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [pullTableView reloadData];
    
}

#pragma mark - UISearchDisplayController delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
    NSString *searchStr = searchText;
    if(searchStr == nil || [searchStr isKindOfClass:[NSNull class]])
        searchStr = @"";
    if([_SearchConditionStr isEqual:searchStr])
        return;
    
    //    [pullTableView reloadData];
    self.pullTableView.pullTableIsRefreshing = YES;
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    NSString *searchStr = _searchBar.text;
    if(searchStr == nil || [searchStr isKindOfClass:[NSNull class]])
        searchStr = @"";
    if([_SearchConditionStr isEqual:searchStr])
        return;
    
    _SearchConditionStr = searchStr;
    

    pages = 0;
    [_model loadNurseDataWithPage:(int)pages prama:@{@"searchStr": searchStr} block:^(int code) {
        self.DataList = [NurseListInfoModel nurseListModel];
        [pullTableView reloadData];
        [self refreshTable];
    }];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
    }
    
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    switch (column) {
        case 0:
            return self.prices.count;
        case 1:
            return self.ages.count;
        case 2:
            return self.goodes.count;
        default:
            return 0;
    }

}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:
            return self.prices[indexPath.row];
        case 1:
            return self.ages[indexPath.row];
        case 2:
            return self.goodes[indexPath.row];
        default:
            return nil;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    NSString *sortFiled = nil;
    switch (indexPath.column) {
        case 0:{
            sortFiled = @"price";
        }
            break;
        case 1:{
            sortFiled = @"age";
        }
            break;
        case 2:{
            sortFiled = @"rate";
        }
            
        default:
            break;
    }
    
//    pages = 0;
//    [_model loadNurseDataWithPage:(int)pages prama:@{@"sortFiled": sortFiled} block:^(int code) {
//        self.DataList = [NurseListInfoModel nurseListModel];
        [pullTableView reloadData];
//        [self refreshTable];
//   }];
    
//    if(!self.pullTableView.pullTableIsRefreshing) {
//        self.pullTableView.pullTableIsRefreshing = YES;
//    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
