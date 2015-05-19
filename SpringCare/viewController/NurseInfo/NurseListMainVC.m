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
         parmas = [[NSMutableDictionary alloc] init];
        DataList = [[NSMutableArray alloc] init];
        pages = 0;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.lbTitle.text = @"陪护师";
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    //[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar sizeToFit];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.showsCancelButton = YES;
    
    searchBar.backgroundImage = [self imageWithColor:_COLOR(0xf3, 0xf5, 0xf7) size:CGSizeMake(ScreenWidth, 44)];
    
    [self.view addSubview:searchBar];
    
    pullTableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:pullTableView];
    pullTableView.dataSource = self;
    pullTableView.delegate = self;
    pullTableView.pullDelegate = self;
    
    self.prices = @[@"价格区间",@"0元-100元",@"100元-200元",@"200元以上"];
    self.ages = @[@"年龄区间",@"20岁-29岁",@"30岁-39岁",@"40岁以上"];
    self.goodes = @[@"距离最近",@"护龄最长",@"好评优先",@"评论最多"];
    //数据先初始化
    
    menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
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
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(64)]-0-[searchBar(44)]-0-[menu(40)]-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    else
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(64)]-0-[searchBar(44)]-0-[menu(40)]-0-[pullTableView]-49-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menu]-0-|" options:0 metrics:nil views:views]];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    pullTableView.tableFooterView = footer;
}

- (void) LoadDataList
{
    searchBar.text = @"";
    [menu ResetDropDownMenu];
    __weak NurseListMainVC *weakSelf = self;
    pages = 0;
    [parmas removeAllObjects];
    self.pullTableView.pullTableIsRefreshing = YES;
    [_model loadNurseDataWithPage:(int)pages type:EnumTypeHospital key:nil ordr:nil sortFiled:nil productId:nil block:^(int code) {
        [DataList removeAllObjects];
        [DataList addObjectsFromArray:[NurseListInfoModel nurseListModel]];
        [weakSelf.pullTableView reloadData];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [searchBar resignFirstResponder];
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
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
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
    [searchBar resignFirstResponder];
    if(![[UserModel sharedUserInfo] isLogin]){
        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
         }
    else{
        NurseListInfoModel *model = [DataList objectAtIndex:indexPath.row];
        PlaceOrderVC *vc = [[PlaceOrderVC alloc] initWithModel:model andproductId:[cfAppDelegate defaultProductId] ];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    pages = 0;
    __weak NurseListMainVC *weakSelf = self;
    [_model loadNurseDataWithPage:(int)pages prama:parmas block:^(int code, id content) {
        [weakSelf.DataList removeAllObjects];
        [weakSelf.DataList addObjectsFromArray:content];
        [weakSelf.pullTableView reloadData];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    pages ++;
    
    __weak NurseListMainVC *weakSelf = self;
    [_model loadNurseDataWithPage:(int)pages prama:parmas block:^(int code, id content) {
        [weakSelf.DataList addObjectsFromArray:content];
        [weakSelf.pullTableView reloadData];
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
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

- (void) LeftButtonClicked:(id)sender{
    [super LeftButtonClicked:sender];
    [searchBar resignFirstResponder];
}
#pragma mark - UISearchDisplayController delegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)Bar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    
    self.pullTableView.pullTableIsRefreshing = YES;
    pages = 0;
    __weak NurseListMainVC *_weakSelf = self;
    
     [ parmas setObject:@"" forKey:@"key"];
    [_model loadNurseDataWithPage:(int)pages prama:parmas block:^(int code, id content) {
        //
        [DataList removeAllObjects];
        [DataList addObjectsFromArray:[NurseListInfoModel nurseListModel]];
        
        [_weakSelf.pullTableView reloadData];
        [_weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    NSString *searchStr = _searchBar.text;
    if(searchStr == nil || [searchStr isKindOfClass:[NSNull class]])
        searchStr = @"";
    if([_SearchConditionStr isEqual:searchStr])
        return;
    
    _SearchConditionStr = searchStr;
    [searchBar resignFirstResponder];
    

    self.pullTableView.pullTableIsRefreshing = YES;
    pages = 0;
    __weak NurseListMainVC *_weakSelf = self;
    [ parmas setObject:searchStr forKey:@"key"];  //@{@"key": searchStr}
    [_model loadNurseDataWithPage:(int)pages prama:parmas block:^(int code, id content) {
//
        [DataList removeAllObjects];
        [DataList addObjectsFromArray:[NurseListInfoModel nurseListModel]];
        
        [_weakSelf.pullTableView reloadData];
        [_weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
    
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
    
//    NSString *sortFiled = nil;
//    switch (indexPath.column) {
//        case 0:{
//            sortFiled = @"price";
//        }
//            break;
//        case 1:{
//            sortFiled = @"age";
//        }
//            break;
//        case 2:{
//            sortFiled = @"rate";
//        }
//            
//        default:
//            break;
//    }
    
   
    
    if(indexPath.column == 0){
        NSInteger min = 0;
        NSInteger max = 0;
        if(indexPath.row == 0){
        }
        else if (indexPath.row == 1){
            min = 100;
            max = 0;
        }
        else if (indexPath.row == 2){
            min = 101;
            max = 299;
        }
        else if (indexPath.row == 3){
            max = 200;
        }
        
        [parmas setObject:[NSNumber numberWithInteger:min] forKey:@"minPrice"];
        [parmas setObject:[NSNumber numberWithInteger:max] forKey:@"maxPrice"];
    }
    else if (indexPath.column == 1){
        NSInteger min = 0;
        NSInteger max = 0;
        if(indexPath.row == 0){}
        else if (indexPath.row == 1){
            min = 20;
            max = 29;
        }
        else if (indexPath.row == 2){
            min = 30;
            max = 39;
        }
        else if (indexPath.row == 3){
            max = 40;
        }
        [parmas setObject:[NSNumber numberWithInteger:min] forKey:@"minAge"];
        [parmas setObject:[NSNumber numberWithInteger:max] forKey:@"maxAge"];
    }
    else{
        NSString *sortFiled = @"geoPoint";
        if(indexPath.row == 0){}
        else if (indexPath.row == 1){
            sortFiled = @"careAge";
        }
        else if (indexPath.row == 2){
            sortFiled = @"commentRate";
        }
        else if (indexPath.row == 3){
            sortFiled = @"commentCount";
        }
        [parmas setObject:sortFiled forKey:@"sortFiled"];
    }
    
    pages = 0;
    self.pullTableView.pullTableIsRefreshing = YES;
    __weak NurseListMainVC *weakSelf = self;
    [_model loadNurseDataWithPage:(int)pages prama:parmas block:^(int code, id content) {
        [weakSelf.DataList removeAllObjects];
        [weakSelf.DataList addObjectsFromArray:[NurseListInfoModel nurseListModel]];
        [weakSelf.pullTableView reloadData];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];

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
