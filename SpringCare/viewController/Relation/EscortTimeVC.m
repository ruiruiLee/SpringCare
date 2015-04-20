//
//  EscortTimeVC.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UserRequestAcctionModel.h"
#import "LoginVC.h"

@interface EscortTimeVC ()
{
    
}


@property (nonatomic, strong) EscortTimeTableCell *prototypeCell;

@end

@implementation EscortTimeVC
@synthesize prototypeCell;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"userId"])
    {
//        [_btnUserName setTitle:model.username forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserModel *usermodel = [UserModel sharedUserInfo];
    [usermodel addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    if(usermodel.userId != nil){
        NSArray *data = [UserRequestAcctionModel GetRequestAcctionArray];
        if([data count] == 0){
            [UserAttentionModel loadLoverList:^(int code) {
            }];
        }
    }
    
    [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentAttentionId pages:0 block:^(int code) {
        if(code)
        {
            [tableView reloadData];
        }
    }];
    
    self.lbTitle.text = @"陪护时光";
    self.NavigationBar.alpha = 0.7f;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:[UIImage imageNamed:@"relationattentionselect"] forState:UIControlStateNormal];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:headerbg];
    headerbg.image = [UIImage imageNamed:@"relationheaderbg"];
    headerbg.translatesAutoresizingMaskIntoConstraints = NO;
    
    _photoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_photoImgView];
    _photoImgView.translatesAutoresizingMaskIntoConstraints = NO;
    [_photoImgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.font = _FONT_B(17);
    _lbName.textAlignment = NSTextAlignmentRight;
    _lbName.text = @"王莹莹";
    _lbName.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.userInteractionEnabled = NO;
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT_B(15);
    [_btnInfo setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [_btnInfo setTitle:@"四川人  38岁 护龄12年" forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnInfo);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerbg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerbg(182)]->=0-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbName]-5-[_photoImgView(82)]-16.5-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImgView(82)]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnInfo]-5-[_photoImgView(82)]-16.5-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(18)]-2-[_btnInfo(21)]-28-|" options:0 metrics:nil views:views]];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.NavigationBar];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    _bgView.hidden = YES;
    _bgView.alpha = 0.6;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_bgView addGestureRecognizer:singleRecognizer];
    _selectView = [[AttentionSelectView alloc] initWithFrame:CGRectMake(ScreenWidth, 64, ScreenWidth/2, SCREEN_HEIGHT - 64)];
    [[UIApplication sharedApplication].keyWindow addSubview:_selectView];
    _selectView.delegate = self;
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
    
    if(prototypeCell == nil){
        __weak EscortTimeVC *bself = self;
        prototypeCell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
            [bself replyContentWithId:itemId];
        }];
        prototypeCell.cellDelegate = self;
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat cellHeight = [prototypeCell getContentHeightWithData:data];
    return cellHeight;
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
//    _currentAttentionId = itemId;
}

- (void) ReloadTebleView
{
    [tableView reloadData];
}

- (void) RightButtonClicked:(id)sender
{
    [_selectView SetActionDataArray:[UserAttentionModel GetMyAttentionArray] withId:_currentAttentionId];
    
    [UIView animateWithDuration:0.25f animations:^{
        _selectView.frame = CGRectMake(ScreenWidth/2, 64, ScreenWidth/2, SCREEN_HEIGHT - 64);
        _bgView.hidden = NO;
        _bgView.backgroundColor = _COLOR(0x22, 0x22, 0x22);
    }];
}

- (void) SelectWiewDismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        _selectView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth/2, SCREEN_HEIGHT - 64);
        _bgView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        _bgView.hidden = YES;
    }];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    [self SelectWiewDismiss];
}

#pragma mark - 点中回复按钮
#pragma mark EscortTimeTableCellDelegate
-(void)commentButtonClick:(id)target userReply:(NSString*)userReply{
    if (_feedbackView==nil) {
        _feedbackView =[[feedbackView alloc ] initWithNibName:@"feedbackView" bundle:nil controlHidden:NO];
        _feedbackView.delegate=(id)self;
        [self.view addSubview:_feedbackView.view];

    }
       [_feedbackView.feedbackTextField becomeFirstResponder];
}

#pragma mark - feedbackViewDelegate
-(void)commitMessage:(NSString*)msg   //按确认按钮或者发送按钮实现消息发送
{
    NSLog(@"%@",msg);
}

-(void)changeParentViewFram:(int)newHeight
{
    //tableView.frame=CGRectMake(tableView.frame.origin.x,tableView.frame.origin.y,tableView.frame.size.width,newHeight);
   // [tableView setContentOffset:CGPointMake(0.0, newHeight) animated:YES];
}

#pragma AttentionSelectViewDelegate
- (void) ViewSelectWithModel:(UserAttentionModel *)usermodel
{
    [self SelectWiewDismiss];
    _currentAttentionId = usermodel.userid;
    [self.btnRight sd_setImageWithURL:[NSURL URLWithString:usermodel.photoUrl] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];
    
    [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentAttentionId pages:0 block:^(int code) {
        if(code)
        {
            [tableView reloadData];
        }
    }];
}

- (void) ViewShutDown
{
    [self SelectWiewDismiss];
}

@end
