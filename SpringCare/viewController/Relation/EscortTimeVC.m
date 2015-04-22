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
#import "NurseListInfoModel.h"

@interface EscortTimeVC ()
{
    
}


@property (nonatomic, strong) EscortTimeTableCell *prototypeCell;

@end

@implementation EscortTimeVC
@synthesize prototypeCell;
@synthesize tableView = tableView;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"userId"])
    {
        NSString *new = [change objectForKey:@"new"];
        if([new isKindOfClass:[NSNull class]]){
            _defaultImgView.hidden = NO;
            [self SetHeaderInfoWithModel:nil];
            pages = 0;
            [_dataList removeAllObjects];
            [self.btnRight setImage:[UIImage imageNamed:@"relationattentionselect"] forState:UIControlStateNormal];
            
            LoginVC *vc = [[LoginVC alloc] init];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        else{
        
            [UserAttentionModel loadLoverList:^(int code) {
            }];
            [self LoaddefaultLoverInfo];
        }
    }
}

- (void) LoaddefaultLoverInfo
{
    UserModel *usermodel = [UserModel sharedUserInfo];
    if(!usermodel.isLogin)
        return;
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:usermodel.userId forKey:@"registerId"];
    __weak EscortTimeVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/care/default" Params:parmas Completion:^(int code, id content) {
        if(code){
            if(content == nil){
                [weakSelf CheckDefaultImgViewShow];
            }
            if([content isKindOfClass:[NSDictionary class]]){
                if([content objectForKey:@"code"] == nil){
                    if([content objectForKey:@"defaultLoverId"] != nil){
                        UserAttentionModel *model = [[UserAttentionModel alloc] init];
                        model.userid = [content objectForKey:@"defaultLoverId"];
                        [weakSelf ViewSelectWithModel:model];
                        
                        if([content objectForKey:@"id"] != nil){
                            NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:content];
                            [weakSelf SetHeaderInfoWithModel:model];
                        }else {
                            [weakSelf SetHeaderInfoWithModel:nil];
                        }
                    }
                }
            }
        }
    }];
}

- (void) SetHeaderInfoWithModel:(NurseListInfoModel *) nurse
{
    if(nurse){
        _lbName.text = nurse.name;
        _lbName.hidden = NO;
        _btnInfo.hidden = NO;
        NSString *info = [NSString stringWithFormat:@"%@  %ld岁 护龄%@年", nurse.birthPlace, nurse.age, nurse.careAge];
        [_btnInfo setTitle:info forState:UIControlStateNormal];
        NSString *imgPath = [Util headerImagePathWith:[Util GetSexByName:nurse.sex]];
        [_photoImgView sd_setImageWithURL:[NSURL URLWithString:nurse.headerImage] placeholderImage:ThemeImage(imgPath)];
    }else{
        _lbName.text = @"";
        _lbName.hidden = YES;
        [_btnInfo setTitle:@"" forState:UIControlStateNormal];
        _btnInfo.hidden = YES;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pages = 0;
    _dataList = [[NSMutableArray alloc] init];
    
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
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.font = _FONT_B(17);
    _lbName.textAlignment = NSTextAlignmentRight;
    _lbName.textColor = _COLOR(0xff, 0xff, 0xff);
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.userInteractionEnabled = NO;
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT_B(15);
    [_btnInfo setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerbg, _photoImgView, _lbName, _btnInfo);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerbg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerbg(182)]->=0-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbName]-5-[_photoImgView(82)]-16.5-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImgView(82)]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnInfo]-5-[_photoImgView(82)]-16.5-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(18)]-2-[_btnInfo(21)]-28-|" options:0 metrics:nil views:views]];
    
    tableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.NavigationBar];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.pullDelegate = self;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
    
    _defaultImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_defaultImgView belowSubview:self.NavigationBar];
    _defaultImgView.translatesAutoresizingMaskIntoConstraints = NO;
    _defaultImgView.image = ThemeImage(@"img_index_03bg");
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_defaultImgView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImgView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_defaultImgView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImgView)]];
    _defaultImgView.hidden = YES;
    
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
    
    UserModel *usermodel = [UserModel sharedUserInfo];
    if(!usermodel.isLogin){
        _defaultImgView.hidden = NO;
    }else{
        _defaultImgView.hidden = YES;
    }
    [usermodel addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    if(usermodel.userId != nil){
        NSArray *data = [UserAttentionModel GetMyAttentionArray];
        if([data count] == 0){
            [UserAttentionModel loadLoverList:^(int code) {
            }];
        }
        
        [self LoaddefaultLoverInfo];
    }
}

- (void) CheckDefaultImgViewShow
{
    UserModel *usermodel = [UserModel sharedUserInfo];
    if(!usermodel.isLogin){
        _defaultImgView.hidden = NO;
    }else{
        _defaultImgView.hidden = YES;
    }
    if([[EscortTimeDataModel GetEscortTimeData] count] == 0){
        _defaultImgView.hidden = NO;
    }else
        _defaultImgView.hidden = YES;
    
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
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    
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
    
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    [cell setContentData:data];
    if(indexPath.row > 0){
        EscortTimeDataModel *data1 = [_dataList objectAtIndex:indexPath.row - 1];
        if([Util isOneDay:[Util convertDateFromDateString:data.createAt] end:[Util convertDateFromDateString:data1.createAt]]){
            cell._lbToday.hidden = YES;
        }else{
            cell._lbToday.hidden = NO;
        }
        
    }
    
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
    UserModel *usermodel = [UserModel sharedUserInfo];
    if(usermodel.isLogin){
        [_selectView SetActionDataArray:[UserAttentionModel GetMyAttentionArray] withId:_currentAttentionId];
        [UIView animateWithDuration:0.25f animations:^{
            _selectView.frame = CGRectMake(ScreenWidth/2, 64, ScreenWidth/2, SCREEN_HEIGHT - 64);
            _bgView.hidden = NO;
            _bgView.backgroundColor = _COLOR(0x22, 0x22, 0x22);
        }];
    }else{
        
    }
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
//    _replyContentModel = target.model;
    if([target isKindOfClass:[EscortTimeTableCell class]]){
        _replyContentModel = ((EscortTimeTableCell*)target)._model;
    }else
        _replyContentModel = nil;
    
    _reReplyPId = userReply;
    
    if (_feedbackView == nil) {
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
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    if(msg)
        [parmas setObject:msg forKey:@"content"];
    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"replyUserId"];
    if(_replyContentModel){
        [parmas setObject:_replyContentModel.itemId forKey:@"careTimeId"];
    }
    if(_reReplyPId){
        [parmas setObject:_reReplyPId forKey:@"orgUserId"];
    }
    
    __weak EscortTimeVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/careTime/reply" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                if ([content objectForKey:@"code"] == nil) {
                    NSString *replyId = [content objectForKey:@"message"];
                    [weakSelf replyCompleteWithReplyId:replyId content:msg];
                }
            }
        }
    }];
}

- (void) replyCompleteWithReplyId:(NSString *) replyId content:(NSString *) content
{
    NSMutableArray *replyinfos = (NSMutableArray*)_replyContentModel.replyInfos;
    EscortTimeReplyDataModel *replyModel = [[EscortTimeReplyDataModel alloc] init];
    replyModel.guId = replyId;
    replyModel.content = content;
    replyModel.replyUserId = [UserModel sharedUserInfo].userId;
    replyModel.replyUserName = [UserModel sharedUserInfo].chineseName;
    replyModel.orgUserId = _reReplyPId;
    [replyinfos addObject:replyModel];
    [tableView reloadData];
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
    
    self.tableView.pullTableIsRefreshing = YES;
    
    _currentAttentionId = usermodel.userid;
    [self.btnRight sd_setImageWithURL:[NSURL URLWithString:usermodel.photoUrl] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];
    
    __weak EscortTimeVC *weakSelf = self;
    __weak PullTableView *weakTableView = tableView;
    __weak NSMutableArray *weakDataList = _dataList;
    [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentAttentionId pages:0 block:^(int code, id content) {
        if(code)
        {
            [weakDataList removeAllObjects];
            [weakDataList addObjectsFromArray:content];
            [weakSelf CheckDefaultImgViewShow];
            [weakTableView reloadData];
        }
        
//        [weakSelf refreshTable];
        [weakSelf performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
    
    if(usermodel && usermodel.userid)
        [self LoadCareInfoWithLoveId:usermodel.userid];
}

- (void)LoadCareInfoWithLoveId:(NSString*) loverId
{
    if(loverId == nil || [loverId isKindOfClass:[NSNull class]])
        return;
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:loverId forKey:@"loverId"];
    __weak EscortTimeVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/care/default" Params:parmas Completion:^(int code, id content) {
        if(code){
            if(content == nil){
                [weakSelf CheckDefaultImgViewShow];
            }
            if([content isKindOfClass:[NSDictionary class]]){
                if([content objectForKey:@"code"] == nil){
                        
                    if([content objectForKey:@"id"] != nil){
                        NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:content];
                        [weakSelf SetHeaderInfoWithModel:model];
                    }else {
                        [weakSelf SetHeaderInfoWithModel:nil];
                    }
                }
            }
        }
    }];
}

- (void) ViewShutDown
{
    [self SelectWiewDismiss];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    pages = 0;
    
    UserAttentionModel *model = [[UserAttentionModel alloc] init];
    model.userid = _currentAttentionId;
    [self ViewSelectWithModel:model];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
    pages ++;
    
    __weak EscortTimeVC *weakSelf = self;
    __weak PullTableView *weakTableView = tableView;
    __weak NSMutableArray *weakDataList = _dataList;
    [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentAttentionId pages:pages block:^(int code, id content) {
        [weakSelf loadMoreDataToTable];
        if(code)
        {
            [weakDataList addObjectsFromArray:content];
            [weakSelf CheckDefaultImgViewShow];
            [weakTableView reloadData];
        }
    }];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    NSLog(@"refreshTable");
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    NSLog(@"loadMoreDataToTable");
    self.tableView.pullTableIsLoadingMore = NO;
}

@end
