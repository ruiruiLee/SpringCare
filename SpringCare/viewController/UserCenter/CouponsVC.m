//
//  CouponsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/5/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponsVC.h"
#import "PullTableView.h"
#import "CouponsListCell.h"
#import "WebContentVC.h"

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
@synthesize delegate;
@synthesize selectModel = selectModel;
@synthesize productId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.isActive = YES;
        self.type = EnumCouponsVCTypeMine;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.NavigationBar.btnRight setTitle:@"使用说明" forState:UIControlStateNormal];
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.layer.cornerRadius = 8;
    self.NavigationBar.btnRight.backgroundColor = [UIColor whiteColor];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(11);
    
    [self initSubviews];
    dataList = [[NSMutableArray alloc] init];
    
    [self loadDataWithNoproductInfo];
}

- (void) loadDataWithNoproductInfo
{
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
- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"使用说明" url:@""];
    vc.hidesBottomBarWhenPushed = YES;
    [vc loadInfoFromUrl:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, CouponExplain]];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    if(self.productId){
        [parmas setObject:self.productId forKey:@"productId"];
    }
    
    if(self.isActive){
        [parmas setObject:@"true" forKey:@"isActive"];
    }else
        [parmas setObject:@"false" forKey:@"isActive"];
    
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


-(void)displayEmpityImageView:(UIImage *)img{
    if (backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pullTableView.frame.size.width/2-img.size.width/2, pullTableView.frame.size.height/2-img.size.height + 30, img.size.width, img.size.height)];
        // [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderend"]];
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        backgroundImageView.image = img;
        [self.ContentView addSubview:backgroundImageView];
        
        [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-30]];
    }
    
}

-(void)removeBackgroudImgView{
    if (backgroundImageView != nil) {
        [backgroundImageView removeFromSuperview];
        backgroundImageView = nil;
    }
}

#pragma Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([dataList count] > 0)
    {
        [self removeBackgroudImgView];
    }else{
        [self displayEmpityImageView:ThemeImage(@"couponBackground")];
    }
    return [dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S || type == EnumValueTypeiPhone5){
        return 112;
    }
    else if (type == EnumValueTypeiPhone6){
        return 131.f;
    }else if(type == EnumValueTypeiPhone6P){
        return 146.5;
    }
    return 0.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[CouponsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CouponsDataModel *model = [dataList objectAtIndex:indexPath.row];
    if(self.type == EnumCouponsVCTypeSelect){
        cell.cellType = EnumCouponCellTypeSelect;
        if(selectModel != nil
            && [selectModel.couponsId isEqualToString:model.couponsId])
            [cell SetCellSelected:YES];
        else
            [cell SetCellSelected:NO];
    }else
        cell.cellType = EnumCouponCellTypeNormal;
    
    [cell SetContentWithModel:model];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.type == EnumCouponsVCTypeSelect){
        selectModel = [dataList objectAtIndex:indexPath.row];
        [tableView reloadData];
        if(delegate && [delegate respondsToSelector:@selector(NotifySelectCouponsWithModel:)]){
            [delegate NotifySelectCouponsWithModel:[dataList objectAtIndex:indexPath.row]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
