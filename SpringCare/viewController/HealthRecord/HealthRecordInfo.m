//
//  HealthRecordInfo.m
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "HealthRecordInfo.h"
#import "define.h"

#import "LineChartView.h"
#import "NSData+ImageContentType.h"
#import "NSDate+Additions.h"
#import "PullTableView.h"
#import "RecordListTableViewCell.h"

#import "HealthRecordDetail.h"

@interface HealthRecordInfo ()<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    PullTableView  *_tableview;
    
//    UILabel *_lbTime;
//    UILabel *_lbSBP;
//    UILabel *_lbDBP;
//    UILabel *_lbHeartRate;
    
    UIButton *_btnDay;
    UIButton *_btnWeek;
    UIButton *_btnMonth;
    
    UIImageView *_imageViewBg;
    UIScrollView *_scrollview;
    
    LineChartView *chartView;
    
    UILabel *_lbBeginTime;
}

@property (nonatomic, strong) PullTableView  *tableview;

@end


@implementation HealthRecordInfo

@synthesize tableview = _tableview;

- (id) initWithLoverId:(NSString *)loverId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _model = [[HealthRecordModel alloc] init];
        _loverId = loverId;
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.ContentView.backgroundColor = _COLOR(247, 247, 247);
    
    _imageViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_imageViewBg];
    _imageViewBg.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewBg.image = ThemeImage(@"chartbg");
    _imageViewBg.backgroundColor = [UIColor greenColor];
    _imageViewBg.userInteractionEnabled = YES;
    
    
    UILabel *lbExplainSBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:lbExplainSBP];
    lbExplainSBP.backgroundColor = [UIColor redColor];
    lbExplainSBP.layer.cornerRadius = 4;
    lbExplainSBP.translatesAutoresizingMaskIntoConstraints = NO;
    lbExplainSBP.clipsToBounds = YES;
    
    UILabel *lbExplainSBPText = [[UILabel alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:lbExplainSBPText];
    lbExplainSBPText.text = @"收缩压";
    lbExplainSBPText.translatesAutoresizingMaskIntoConstraints = NO;
    lbExplainSBPText.backgroundColor = [UIColor clearColor];
    lbExplainSBPText.font = _FONT(12);
    lbExplainSBPText.textColor = _COLOR(146, 254, 252);
    
    UILabel *lbExplainDBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:lbExplainDBP];
    lbExplainDBP.backgroundColor = _COLOR(251, 214, 110);
    lbExplainDBP.layer.cornerRadius = 4;
    lbExplainDBP.translatesAutoresizingMaskIntoConstraints = NO;
    lbExplainDBP.clipsToBounds = YES;
    
    UILabel *lbExplainDBPText = [[UILabel alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:lbExplainDBPText];
    lbExplainDBPText.text = @"舒张压";
    lbExplainDBPText.translatesAutoresizingMaskIntoConstraints = NO;
    lbExplainDBPText.backgroundColor = [UIColor clearColor];
    lbExplainDBPText.font = _FONT(12);
    lbExplainDBPText.textColor = _COLOR(146, 254, 252);
    
    _lbBeginTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:_lbBeginTime];
    _lbBeginTime.textColor = [UIColor whiteColor];
    _lbBeginTime.translatesAutoresizingMaskIntoConstraints = NO;
    _lbBeginTime.font = _FONT(13);
    
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:_scrollview];
    _scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollview.backgroundColor = [UIColor yellowColor];
    
    chartView = [[LineChartView alloc] initWithFrame:CGRectMake(20, 400, 500, 300)];
    chartView.translatesAutoresizingMaskIntoConstraints = NO;
    chartView.yMin = 0;
    chartView.yMax = 5;
    chartView.ySteps = @[@"0",@"50",@"100",@"150",@"200"];
    chartView.backgroundColor = [UIColor clearColor];
    
    [_imageViewBg addSubview:chartView];
    
    _btnDay = [[UIButton alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:_btnDay];
    _btnDay.translatesAutoresizingMaskIntoConstraints = NO;
    _btnDay.layer.borderWidth = 1;
    _btnDay.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnDay.layer.cornerRadius = 4;
    [_btnDay setTitle:@"日" forState:UIControlStateNormal];
    [_btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDay setTitleColor:_COLOR(73, 216, 143) forState:UIControlStateSelected];
    [_btnDay addTarget:self action:@selector(btnClicked2SelectTimeBucket:) forControlEvents:UIControlEventTouchUpInside];
    _btnDay.tag = 1000;
    _btnDay.titleLabel.font = _FONT(15);
    
    _btnWeek = [[UIButton alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:_btnWeek];
    _btnWeek.translatesAutoresizingMaskIntoConstraints = NO;
    _btnWeek.layer.borderWidth = 1;
    _btnWeek.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnWeek.layer.cornerRadius = 4;
    [_btnWeek setTitle:@"周" forState:UIControlStateNormal];
    [_btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnWeek setTitleColor:_COLOR(73, 216, 143) forState:UIControlStateSelected];
    [_btnWeek addTarget:self action:@selector(btnClicked2SelectTimeBucket:) forControlEvents:UIControlEventTouchUpInside];
    _btnWeek.tag = 1001;
    _btnWeek.titleLabel.font = _FONT(15);
    
    _btnMonth = [[UIButton alloc] initWithFrame:CGRectZero];
    [_imageViewBg addSubview:_btnMonth];
    _btnMonth.translatesAutoresizingMaskIntoConstraints = NO;
    _btnMonth.layer.borderWidth = 1;
    _btnMonth.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnMonth.layer.cornerRadius = 4;
    [_btnMonth setTitle:@"月" forState:UIControlStateNormal];
    [_btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnMonth setTitleColor:_COLOR(73, 216, 143) forState:UIControlStateSelected];
    [_btnMonth addTarget:self action:@selector(btnClicked2SelectTimeBucket:) forControlEvents:UIControlEventTouchUpInside];
    _btnMonth.tag = 1002;
    _btnMonth.titleLabel.font = _FONT(15);
    
    _tableview = [[PullTableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.pullDelegate = self;
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _tableview, _btnDay, _btnMonth, _btnWeek, _imageViewBg, _scrollview, lbExplainSBP, lbExplainSBPText, lbExplainDBP, lbExplainDBPText, chartView, _lbBeginTime);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageViewBg(240)]-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageViewBg]-0-|" options:0 metrics:nil views:views]];
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbSBP(50)]->=0-|" options:0 metrics:nil views:views]];
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbHeartRate(50)]->=0-|" options:0 metrics:nil views:views]];
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTime(50)]->=0-|" options:0 metrics:nil views:views]];
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbTime]-10-[_lbSBP]-10-[_lbDBP]-10-[_lbHeartRate]-10-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDBP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbTime attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbTime attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbSBP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbTime attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbSBP attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_btnDay]-54-[_btnWeek]-54-[_btnMonth]-30-|" options:0 metrics:nil views:views]];
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnDay(26)]-30-[lbExplainSBP(8)]-20-[chartView]-10-|" options:0 metrics:nil views:views]];
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnWeek(26)]->=0-|" options:0 metrics:nil views:views]];
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_btnMonth(26)]->=0-|" options:0 metrics:nil views:views]];
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:_btnWeek attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_btnDay attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:_btnMonth attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_btnDay attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:lbExplainSBPText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbExplainSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:lbExplainDBPText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbExplainSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:lbExplainDBP attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbExplainSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_imageViewBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbBeginTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbExplainSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbBeginTime]->=20-[lbExplainSBP(8)]-10-[lbExplainSBPText]-30-[lbExplainDBP(8)]-10-[lbExplainDBPText]-30-|" options:0 metrics:nil views:views]];
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbExplainDBP(8)]->=0-|" options:0 metrics:nil views:views]];
    
    [_imageViewBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:nil views:views]];
    
    [self btnClicked2SelectTimeBucket:_btnDay];
    
    if(_model){
        [self LoadRecordListWithLoverId:_loverId block:^(int code) {
            NSArray *array = [_tableview indexPathsForVisibleRows];
            if([array count] > 0){
                NSIndexPath *indexpath = [array objectAtIndex:0];
                
                [self initdataWithIndexpath:indexpath];
            }
        }];
    }
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
    return 54.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordListTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!Cell){
        Cell = [[RecordListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:indexPath.section];
    [Cell SetContentWithModel:model];
    
    return Cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HealthRecordDetail *vc = [[HealthRecordDetail alloc] init];
    vc.lover = self.lover;
    vc.data = [_model.recordList objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    __weak HealthRecordInfo *weakSelf = self;
//    if(_btnDay.selected){
        _model.pages = 0;
        [self LoadRecordListWithLoverId:_loverId block:^(int code) {
            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
        }];
//    }else if (_btnWeek.selected){
//        [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeWeek block:^(int code) {
//            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
//        }];
//    }
//    else{
//        [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeMonth block:^(int code) {
//            [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
//        }];
//    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    __weak HealthRecordInfo *weakSelf = self;
//    if(_btnDay.selected){
        _model.pages ++;
        
        [self LoadRecordListWithLoverId:_loverId block:^(int code) {
            [weakSelf performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
        }];
//    }else{
//        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
//    }
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
    view.backgroundColor = _COLOR(247, 247, 247);
    
    UILabel *lbDateString = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbDateString];
    lbDateString.translatesAutoresizingMaskIntoConstraints = NO;
    lbDateString.backgroundColor = [UIColor clearColor];
    lbDateString.font = _FONT(13);
    lbDateString.textAlignment = NSTextAlignmentCenter;
    lbDateString.textColor = _COLOR(0x66, 0x66, 0x66);
    
    HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:section];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter1 dateFromString:model.dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *string = [formatter stringFromDate:date];
    lbDateString.text = string;
    
//    _lbTime = [[UILabel alloc] initWithFrame:CGRectZero];
//    [self.ContentView addSubview:_lbTime];
//    _lbTime.translatesAutoresizingMaskIntoConstraints = NO;
//    _lbTime.backgroundColor = [UIColor clearColor];
//    _lbTime.font = _FONT(15);
//    _lbTime.textAlignment = NSTextAlignmentCenter;
//    _lbTime.textColor = _COLOR(0x88, 0x88, 0x88);
    
    UILabel *lbSBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbSBP];
    lbSBP.translatesAutoresizingMaskIntoConstraints = NO;
    lbSBP.backgroundColor = [UIColor clearColor];
    lbSBP.font = _FONT(13);
    lbSBP.textAlignment = NSTextAlignmentCenter;
    lbSBP.textColor = _COLOR(0x88, 0x88, 0x88);
    lbSBP.text = @"收缩压";
    
    
    UILabel *lbDBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbDBP];
    lbDBP.translatesAutoresizingMaskIntoConstraints = NO;
    lbDBP.backgroundColor = [UIColor clearColor];
    lbDBP.font = _FONT(13);
    lbDBP.textAlignment = NSTextAlignmentCenter;
    lbDBP.textColor = _COLOR(0x88, 0x88, 0x88);
    lbDBP.text = @"舒张压";
    
    
    UILabel *lbHeartRate = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbHeartRate];
    lbHeartRate.translatesAutoresizingMaskIntoConstraints = NO;
    lbHeartRate.backgroundColor = [UIColor clearColor];
    lbHeartRate.font = _FONT(13);
    lbHeartRate.textAlignment = NSTextAlignmentCenter;
    lbHeartRate.textColor = _COLOR(0x88, 0x88, 0x88);
    lbHeartRate.text = @"心率";
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbDateString, lbDBP, lbHeartRate, lbSBP);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbDBP]-0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbHeartRate]-0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbSBP]-0-|" options:0 metrics:nil views:views]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lbDateString]-10-[lbSBP]-10-[lbDBP]-10-[lbHeartRate]-10-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbDateString]-10-|" options:0 metrics:nil views:views]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lbDateString attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:40]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lbSBP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lbHeartRate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
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


- (void) tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"didEndDisplayingHeaderView");
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"willDisplayHeaderView");
}

- (void) ResetBtnSelectStatus:(UIButton *)sender
{
    sender.selected = NO;
    sender.backgroundColor = [UIColor clearColor];
}

#pragma ACTIONS
- (void) btnClicked2SelectTimeBucket:(UIButton*)sender
{
    if(sender.selected)
        return;
    
    [self ResetBtnSelectStatus:_btnDay];
    [self ResetBtnSelectStatus:_btnMonth];
    [self ResetBtnSelectStatus:_btnWeek];
    
    sender.selected = YES;
    sender.backgroundColor = [UIColor whiteColor];
    
    if(sender == _btnDay){
        NSArray *array = [_tableview indexPathsForVisibleRows];
        if([array count] > 0){
            NSIndexPath *indexpath = [array objectAtIndex:0];
            
            [self initdataWithIndexpath:indexpath];
        }
        
    }else if (sender == _btnWeek){
        [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeWeek block:^(int code) {
        }];
    }
    else{
        [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeMonth block:^(int code) {
        }];
    }
}


# pragma data
- (void) LoadRecordListWithLoverId:(NSString *)loverId block:(block) block
{
    __weak HealthRecordInfo *weakSelf = self;
    [_model LoadRecordListWithLoverId:_loverId block:^(int code, id content) {
        
        [weakSelf.tableview reloadData];
        
        if(block){
            block(1);
        }
    }];
}

- (void) LoadRecordListWithLoverId:(NSString *)loverId type:(EnumDataType) type block:(block) block
{
    __weak HealthRecordInfo *weakSelf = self;
    
    NSArray *array = [_tableview indexPathsForVisibleRows];
    if([array count] > 0){
        NSIndexPath *indexpath = [array objectAtIndex:0];
        HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:indexpath.section];
        
        NSString *begin = model.dateString;
        
        [_model LoadRecordListWithSata:loverId begin:begin type:type block:^(int code, id content) {
            if(code){
                NSArray *data = [content objectForKey:@"data"];
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (int i = 0; i < [data count]; i++) {
                    HealthRecordItemDataModel *model = [HealthRecordItemDataModel modelDateFromDictionary:[data objectAtIndex:i]];
                    [result addObject:model];
                }
                _lbBeginTime.text = [NSString stringWithFormat:@"%@ ~ %@", [content objectForKey:@"st"], [content objectForKey:@"et"]];
                
                [weakSelf initDataWithArray:result];
                
            }
            
            if(block){
                block(1);
            }
        }];
    }
}

- (void)pullTableViewDidScrolled:(PullTableView*)pullTableView
{
    NSArray *array = [pullTableView indexPathsForVisibleRows];
    if([array count] > 0){
        NSIndexPath *indexpath = [array objectAtIndex:0];
        HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:indexpath.section];
        
        if([model.dateString isEqualToString:_prevDateString])
            return;
        
        _prevDateString = model.dateString;
        __weak HealthRecordInfo *weakSelf = self;
        if( _btnDay.selected){
                [self initdataWithIndexpath:indexpath];
            
        }else if ( _btnWeek.selected){
            [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeWeek block:^(int code) {
                
            }];
        }
        else{
            [self LoadRecordListWithLoverId:_loverId type:EnumDataTypeMonth block:^(int code) {
                
            }];
        }
    }
    
}

- (void)initDataWithArray:(NSArray*)array
{
    LineChartData *d1x = [LineChartData new];
    {
//        HealthRecordItemDataModel *model1 = [array firstObject];
//        HealthRecordItemDataModel *model2 = [array lastObject];
        
        LineChartData *d1 = d1x;
        d1.title = @"收缩压";
        d1.color = [UIColor redColor];
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;//[Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        d1.xMin = 0;//[Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        
        int j = 1;
        for(int i = 0; i < [array count]; i++){
            HealthRecordItemDataModel *model = [array objectAtIndex:i];
//            NSString *dateString = model.dt;
            [arr addObject:@(j)];
            NSString *lp = model.hp;
            [arr2 addObject:lp];
            
            [arr3 addObject:model.dt];
            
            NSAttributedString *attstring = [self getAttStringWithSBP:model.lp DBP:model.hp rate:model.pulse];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@"心率：%@次/分钟", model.pulse]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            y = y / 200.0 * 5;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
        
    }
    
    LineChartData *d2x = [LineChartData new];
    {
        LineChartData *d1 = d2x;
//        HealthRecordItemDataModel *model1 = [array firstObject];
//        HealthRecordItemDataModel *model2 = [array lastObject];
        d1.title = @"舒张压";
        d1.color = _COLOR(251, 214, 110);
        d1.itemCount = [array count];
        //        d1.xMax = [Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        //        d1.xMin = [Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        d1.xMax = d1.itemCount + 1;//[Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        d1.xMin = 0;//[Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        NSMutableArray *arr4 = [NSMutableArray array];
        NSMutableArray *arr5 = [NSMutableArray array];//y
        int j = 1;
        for(int i = 0; i < [array count]; i++){
            HealthRecordItemDataModel *model = [array objectAtIndex:i];
//            NSString *dateString = model.dt;
            //            [arr addObject:@(([Util convertDateFromDateString:dateString].timeIntervalSince1970/1000) + 1)];
            
            [arr addObject:@(j)];
            
            NSString *lp = model.lp;
            [arr2 addObject:lp];
            
            [arr3 addObject:model.dt];
            
            NSAttributedString *attstring = [self getAttStringWithSBP:model.lp DBP:model.hp rate:model.pulse];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@"心率：%@次/分钟", model.pulse]];
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            y = y / 200.0 * 5;
            NSString *label1 = arr3[item];//[NSString stringWithFormat:@"%d", 1];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
    }
    
    chartView.data = @[d1x,d2x];
}

- (void)initdataWithIndexpath:(NSIndexPath*) indexpath
{
    HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:indexpath.section];
    _lbBeginTime.text = [model.dateString substringToIndex:10];
    NSArray *array = [self dataFromArray:model.dateString];
    
    if([array count] == 0){
        LineChartData *d1x = [LineChartData new];
        LineChartData *d2x = [LineChartData new];
        chartView.data = @[d1x,d2x];
        return;
    }
    
    LineChartData *d1x = [LineChartData new];
    {
        
        LineChartData *d1 = d1x;
        d1.title = @"收缩压";
        d1.color = [UIColor redColor];
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;
        d1.xMin = 0;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        int j = 1;
        for(int i = [array count] - 1; i >= 0; i--){
            HealthRecordItemDataModel *model = [array objectAtIndex:i];
            [arr addObject:@(j)];
            NSString *lp = model.hp;
            [arr2 addObject:lp];
            
            NSDate *date = [Util convertDateFromDateString:model.dateString];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"HH:mm"];
            NSString *string = [formatter stringFromDate:date];
            [arr3 addObject:string];
            
            NSAttributedString *attstring = [self getAttStringWithSBP:model.lp DBP:model.hp rate:model.pulse];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@"心率：%@次/分钟", model.pulse]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            y = y / 200.0 * 5;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
        
    }
    
    LineChartData *d2x = [LineChartData new];
    {
        LineChartData *d1 = d2x;
        d1.title = @"舒张压";
        d1.color = _COLOR(251, 214, 110);
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;
        d1.xMin = 0;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        int j = 1;
        for(int i = [array count] - 1; i >= 0; i--){
            HealthRecordItemDataModel *model = [array objectAtIndex:i];
            
            [arr addObject:@(j)];
            
            NSString *lp = model.lp;
            [arr2 addObject:lp];
            
            NSDate *date = [Util convertDateFromDateString:model.dateString];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"HH:mm"];
            NSString *string = [formatter stringFromDate:date];
            [arr3 addObject:string];
            
            NSAttributedString *attstring = [self getAttStringWithSBP:model.lp DBP:model.hp rate:model.pulse];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@"心率：%@次/分钟", model.pulse]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            y = y / 200.0 * 5;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
    }

    chartView.data = @[d1x,d2x];
}

- (NSArray*)dataFromArray:(NSString*) dateString
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_model.recordList count]; i++) {
        HealthRecordItemDataModel *model = [_model.recordList objectAtIndex:i];
        if([Util isDateShowFirstDate:[dateString substringToIndex:10] secondDate:[model.dateString substringToIndex:10]])
            {
                [result addObject:model];
            }
    }
    
    return result;
}

/**
 dbp 收缩压
 sbp 舒张压
 */
- (NSAttributedString*) getAttStringWithSBP:(NSString*)sbp DBP:(NSString*)dbp rate:(NSString*)rate
{
    NSString *string = [NSString stringWithFormat:@"%@/%@ mmHg",dbp, sbp];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:string];
    NSString *string1 = [NSString stringWithFormat:@"%@/%@",dbp, sbp];
    [attstring addAttribute:NSFontAttributeName value:_FONT(15) range:NSMakeRange(0, [string1 length])];
    
    return attstring;
}

@end
