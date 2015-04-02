//
//  EscortTimeVC.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeVC.h"

@interface EscortTimeVC ()

@property (nonatomic, strong) EscortTimeTableCell *prototypeCell;

@end

@implementation EscortTimeVC
@synthesize prototypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
//    CGRect frame = [UIScreen mainScreen].bounds;
    
    model = [[EscortTimeDataModel alloc] init];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [[EscortTimeDataModel GetEscortTimeData] count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray = [EscortTimeDataModel GetEscortTimeData];
    EscortTimeDataModel *data = [dataArray objectAtIndex:indexPath.row];
//    return [EscortTimeTableCell GetCellHeightWithData:data];
    
    if(prototypeCell == nil){
        __weak EscortTimeVC *bself = self;
        prototypeCell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
            [bself replyContentWithId:itemId];
        }];
        prototypeCell.cellDelegate = self;
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EscortTimeTableCell *cell = (EscortTimeTableCell *)self.prototypeCell;
    [cell setContentData:data];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}

- (UITableViewCell*) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscortTimeTableCell *cell = nil;
    cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        __weak EscortTimeVC *bself = self;
        cell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
            [bself replyContentWithId:itemId];
        }];
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *dataArray = [EscortTimeDataModel GetEscortTimeData];
    EscortTimeDataModel *data = [dataArray objectAtIndex:indexPath.row];
    [cell setContentData:data];
    
    return cell;
}

- (void) replyContentWithId:(NSString*)itemId
{
    NSLog(itemId);
}

- (void) ReloadTebleView
{
    [tableView reloadData];
}

@end
