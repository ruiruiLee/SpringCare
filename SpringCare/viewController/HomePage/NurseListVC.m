//
//  NurseListVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseListVC.h"
#import "NurseDetailInfoVC.h"
#import "SliderViewController.h"
#import "NurseIntroTableCell.h"
#import "ProductInfoCell.h"
#import "AppDelegate.h"

@interface NurseListVC ()

@end

@implementation NurseListVC
@synthesize pullTableView;
@synthesize DataList;
@synthesize prototypeCell;

- (id) initWithProductId:(NSString*)pid
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _productId = pid;
        _model = [[NurseListInfoModel alloc] init];
        _SearchConditionStr = @"";
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _model = [[NurseListInfoModel alloc] init];
        _SearchConditionStr = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.lbTitle.text = @"陪护师";
    
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
    
    self.prices = @[@"价格"];
    self.ages = @[@"年龄"];
    self.goodes = @[@"好评"];
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(64)]-0-[searchBar(44)]-0-[menu(40)]-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menu]-0-|" options:0 metrics:nil views:views]];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    pullTableView.tableFooterView = footer;
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *cityId = delegate.currentCityModel.city_id;
    NSString *productId = [[NurseListInfoModel PramaNurseDic] objectForKey:@"productId"];
    if(!([cityId isEqualToString:[[NurseListInfoModel PramaNurseDic] objectForKey:@"cityId"]] && [_productId isEqualToString:productId])){
        [_model loadNurseDataWithPage:0 type:EnumTypeHospital key:nil ordr:nil sortFiled:nil productId:_productId block:^(int code) {
            self.DataList = [NurseListInfoModel nurseListModel];
            [pullTableView reloadData];
            [self refreshTable];
        }];
        
        if(!self.pullTableView.pullTableIsRefreshing) {
            self.pullTableView.pullTableIsRefreshing = YES;
        }
        
    }
    else{
        self.DataList = [NurseListInfoModel nurseListModel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
    NurseDetailInfoVC *vc = [[NurseDetailInfoVC alloc] initWithModel:model];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
    
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    self.DataList = [NurseListInfoModel nurseListModel];
//    [_model loadNurseDataWithPage:(int)pages type:EnumTypeHospital key:searchStr ordr:nil sortFiled:nil productId:delegate.defaultProductId block:^(int code) {
//        self.DataList = [NurseListInfoModel nurseListModel];
//        [pullTableView reloadData];
//        [self refreshTable];
//    }];
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
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:{
            return self.prices[indexPath.row];
        }
            break;
        case 2: return self.goodes[indexPath.row];
            break;
        case 1: return self.ages[indexPath.row];
            
            break;
        default:
            return nil;
            break;
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
    
    pages = 0;
    [_model loadNurseDataWithPage:(int)pages prama:@{@"sortFiled": sortFiled} block:^(int code) {
        self.DataList = [NurseListInfoModel nurseListModel];
        [pullTableView reloadData];
        [self refreshTable];
    }];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
    }
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
