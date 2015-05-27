//
//  CouponsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/5/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponsVC.h"
#import "PullTableView.h"
#import "CouponsDataModel.h"
#import "CouponsListCell.h"

@interface CouponsVC ()<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, copy) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger totals;

@end

@implementation CouponsVC
@synthesize pullTableView;
@synthesize dataList;
@synthesize pages;
@synthesize totals;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    dataList = [[NSMutableArray alloc] init];
    
    self.pages = 0;
    self.totals = INT_MAX;
    
    self.pullTableView.pullTableIsRefreshing = YES;
    __weak CouponsVC *weakSelf = self;
    [self LoadCouponsWithBlock:^(int code, id content) {
        if(code){
            [weakSelf.dataList addObjectsFromArray:content];
            [weakSelf.pullTableView reloadData];
        }
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pullTableView);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pullTableView]-0-|" options:0 metrics:nil views:views]];
}

#pragma Networks
- (void)LoadCouponsWithBlock:(CompletionBlock) block
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    if(self.pages == 0){
        [parmas setObject:[NSNumber numberWithInteger:0] forKey:@"offset"];
    }else{
        [parmas setObject:[NSNumber numberWithInteger:[self.dataList count]] forKey:@"offset"];
    }
    
    __weak CouponsVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/coupon/mine" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content objectForKey:@"code"] == nil){
                weakSelf.totals = [[content objectForKey:@"total"] integerValue];
                NSArray *rows = [content objectForKey:@"rows"];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int i = 0; i < [rows count]; i++) {
                    NSDictionary *dic = [rows objectAtIndex:i];
                    CouponsDataModel *model = [CouponsDataModel modelFromDictionary:dic];
                    [array addObject:model];
                }
                
                if(block){
                    block(1, array);
                }
                
            }else{
                if(block){
                    block(0, nil);
                }
            }
        }else{
            if(block){
                block(0, nil);
            }
        }
    }];
}

#pragma Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [dataList count];
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[CouponsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    self.pages = 0;
    self.totals = INT_MAX;
    
    __weak CouponsVC *weakSelf = self;
    [self LoadCouponsWithBlock:^(int code, id content) {
        if(code){
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:content];
            [weakSelf.pullTableView reloadData];
        }
        
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2f];
    }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    if([self.dataList count] >= self.totals){
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2f];
        return;
    }
    
    self.pages ++;
    __weak CouponsVC *weakSelf = self;
    [self LoadCouponsWithBlock:^(int code, id content) {
        if(code){
            [weakSelf.dataList addObjectsFromArray:content];
            [weakSelf.pullTableView reloadData];
        }
        [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2f];
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


@end