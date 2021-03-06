
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
            [self SetHeaderInfoWithModel:nil];
            pages = 0;
            AttentionArray = nil;
            [_dataList removeAllObjects];
            _currentLoverId = nil;
            self.btnRight.hidden=YES;
            [self.tableView reloadData];
            [self performSelector:@selector(Login) withObject:nil afterDelay:0.2];
        }
        else{
            self.btnRight.hidden = NO;
            [self loadDataList:nil];
            
            if([UserModel sharedUserInfo].userId != nil)
                [self LoadDefaultDoctorInfo:nil];
        }
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        CGRect new = [[change objectForKey:@"new"] CGRectValue];
        CGRect rect = _feedbackView.targetFrame;
        CGFloat viewoffset = rect.origin.y + rect.size.height;
        
        if(new.origin.y < [UIScreen mainScreen].bounds.size.height - 20){
            if(viewoffset - new.origin.y >= 0 ){
                [tableView setContentOffset:CGPointMake(0.0,tableView.contentOffset.y + viewoffset - new.origin.y - _offset) animated:YES];
                _offset = viewoffset - new.origin.y;
            }
        }else{
            [tableView setContentOffset:CGPointMake(0.0,tableView.contentOffset.y - _offset) animated:YES];
            _offset = 0;
        }
    }
}

- (void) Login
{
    LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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
        _photoImgView.image=ThemeImage(@"nurselistfemale");
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentLoverId = nil;
    _offset = 0;
    pages = 0;
    _dataList = [[NSMutableArray alloc] init];
    self.lbTitle.text = @"陪护时光";
    self.NavigationBar.alpha = 0.7f;
    self.btnRight.layer.masksToBounds = YES;
    [self.btnRight setAlpha:0.7f];
    self.btnRight.layer.cornerRadius = 20;

    tableView = [[PullTableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.NavigationBar];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.pullDelegate = self;
    
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    else
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    
    [self creatHeadView];
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
    
    UserModel *usermodel = [UserModel sharedUserInfo];
    [usermodel addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *usermodel = [UserModel sharedUserInfo];
    if(usermodel.isLogin){
        self.btnRight.hidden = NO;
        AttentionArray =[UserAttentionModel GetMyAttentionArray];
        if([AttentionArray count] == 0)
            [self loadDataList:nil];
//        else
//            [self SetDefaultLoverWhenNoDefault];
        
        if( _currentLoverId == nil)
            [self LoadDefaultDoctorInfo:nil];
        
    }else{
        self.btnRight.hidden = YES;
    }
}

-(void)SetDefaultLoverWhenNoDefault
{
    if(AttentionArray.count > 0 && _currentLoverId == nil){
        _currentLoverId= [AttentionArray[0] userid];
        NSURL *imgurl =[NSURL URLWithString:[AttentionArray[0] photoUrl]];
        [self.btnRight sd_setImageWithURL:imgurl forState:UIControlStateNormal  placeholderImage:ThemeImage(@"placeholderimage")];
    }
}

-(void)loadDataList:(NSString*)loverID{
    [_dataList removeAllObjects];
//    __weak EscortTimeVC *weakSelf = self;
    [UserAttentionModel loadLoverList:@"true" block:^(int code) {    //获取 用户的陪护对象
     AttentionArray =[UserAttentionModel GetMyAttentionArray];
//        [weakSelf SetDefaultLoverWhenNoDefault];
    }] ;

}

- (void) LoadDefaultDoctorInfo:(NSString*)loverID
{
     NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    if (loverID==nil) {
        [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    }
    else{
        [parmas setObject:loverID forKey:@"loverId"];
    }
    __weak EscortTimeVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/care/default" Params:parmas Completion:^(int code, id content) {
        if(code){
               // if([content objectForKey:@"defaultLoverId"] != nil){
            if([content objectForKey:@"id"] != nil){
                NurseListInfoModel *model = [NurseListInfoModel objectFromDictionary:content];
                [weakSelf SetHeaderInfoWithModel:model];
            }else {
                [weakSelf SetHeaderInfoWithModel:nil];
            }
            if([content objectForKey:@"defaultLoverId"] != nil)
            {
                _currentLoverId = [content objectForKey:@"defaultLoverId"];
                [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentLoverId previousDate:previousDate pages:pages block:^(int code, id content) {
                    if(code)
                    {
                        [_dataList removeAllObjects];
                        [_dataList addObjectsFromArray:content];
                        if(_dataList.count>0)
                         previousDate = [(EscortTimeDataModel*)_dataList[_dataList.count-1] createDate];
                        [weakSelf.tableView reloadData];
                    }
                    
                    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
                }];
                
                NSString *headerImage = [content objectForKey:@"loverHeaderImageUrl"];
                [weakSelf.btnRight sd_setImageWithURL:[NSURL URLWithString:headerImage] forState:UIControlStateNormal  placeholderImage:ThemeImage(@"placeholderimage")];
            }
            else{
                [weakSelf SetDefaultLoverWhenNoDefault];
            }
        }
    }];
}

-(void)creatHeadView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:headerbg];
    headerbg.image = [UIImage imageNamed:@"relationheaderbg"];
    headerbg.translatesAutoresizingMaskIntoConstraints = NO;
    
    _photoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_photoImgView];
    _photoImgView.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImgView.clipsToBounds = YES;
    _photoImgView.layer.cornerRadius = 41;
    _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.font = _FONT_B(17);
    _lbName.textAlignment = NSTextAlignmentRight;
    _lbName.textColor = _COLOR(0xff, 0xff, 0xff);
    _lbName.backgroundColor = [UIColor clearColor];
    
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
    if (_dataList.count==0) {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:TimeBackbroundImg];
        imageView.contentMode =UIViewContentModeScaleAspectFill;
       [_tableView setBackgroundView:imageView];
        tableView.tableHeaderView.hidden=YES;
    
         }
    else{
        [_tableView setBackgroundView:nil];
         tableView.tableHeaderView.hidden=NO;
         }
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    
    if(prototypeCell == nil){
        prototypeCell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
//            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
//            [self replyContentWithId:itemId];
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
        cell = [[EscortTimeTableCell alloc] initWithReuseIdentifier:@"cell" blocks:^(int index) {
//            NSString *itemId = ((EscortTimeDataModel*)[[EscortTimeDataModel GetEscortTimeData] objectAtIndex:index]).itemId;
//            [self replyContentWithId:itemId];
        }];
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EscortTimeDataModel *data = [_dataList objectAtIndex:indexPath.row];
    [cell setContentData:data];
    
    return cell;
}

//- (void) replyContentWithId:(NSString*)itemId
//{
////    _currentAttentionId = itemId;
//}


- (void) RightButtonClicked:(id)sender
{
    if (AttentionArray.count>0) {
        if([UserModel sharedUserInfo].isLogin){
            [_selectView SetActionDataArray:AttentionArray withId:_currentLoverId];
            [UIView animateWithDuration:0.25f animations:^{
                _selectView.frame = CGRectMake(ScreenWidth/2, 64, ScreenWidth/2, SCREEN_HEIGHT - 64);
                _bgView.hidden = NO;
                _bgView.backgroundColor = _COLOR(0x22, 0x22, 0x22);
            }];
        }
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
-(void)commentButtonClick:(id)target ReplyName:(NSString*)ReplyName ReplyID:(NSString*)ReplyID  subframe:(CGRect)frame{
//    _replyContentModel = target.model;
    CGRect rect = CGRectZero;
    if([target isKindOfClass:[EscortTimeTableCell class]]){
        rect = [self.view convertRect:((EscortTimeTableCell*)target).frame fromView:tableView];
        _replyContentModel = ((EscortTimeTableCell*)target)._model;
    }else
        _replyContentModel = nil;
    
    _reReplyPId = ReplyID;
    _reReplyName=ReplyName;
    if (_feedbackView == nil) {
        _feedbackView =[[feedbackView alloc ] initWithNibName:@"feedbackView" bundle:nil controlHidden:NO];
        _feedbackView.delegate=(id)self;
        [self.view addSubview:_feedbackView.view];
        [_feedbackView.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    
    _feedbackView.targetFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, frame.size.height + frame.origin.y);
    _feedbackView.offset = 0;
    if(ReplyName != nil){
        _feedbackView.feedbackTextField.placeholder = [NSString stringWithFormat:@"@%@:", ReplyName];
    }else
        _feedbackView.feedbackTextField.placeholder = @"我要回复";
    [_feedbackView.feedbackTextField becomeFirstResponder];
}

#pragma mark - feedbackViewDelegate
-(void)commitMessage:(NSString*)msg   //按确认按钮或者发送按钮实现消息发送
{
    NSLog(@"%@",msg);
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:msg forKey:@"content"];
    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"replyUserId"];
    if(_replyContentModel){
        [parmas setObject:_replyContentModel.itemId forKey:@"careTimeId"];
    }
    if(_reReplyPId){
        [parmas setObject:_reReplyPId forKey:@"orgUserId"];
    }
    
    [LCNetWorkBase postWithMethod:@"api/careTime/reply" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                if ([content objectForKey:@"code"] == nil) {
                    NSString *replyId = [content objectForKey:@"message"];
                    [self replyCompleteWithReplyId:replyId content:msg];
                }
            }
        }
    }];
}




#pragma  EscortTimeTableCellDelegate
- (void) ReloadTebleView{
    [tableView reloadData];
}

- (void) replyCompleteWithReplyId:(NSString *) replyId content:(NSString *) content
{
    NSMutableArray *replyinfos = (NSMutableArray*)_replyContentModel.replyInfos;
    EscortTimeReplyDataModel *replyModel = [[EscortTimeReplyDataModel alloc] init];
    replyModel.guId = replyId;
  
    replyModel.replyUserId = [UserModel sharedUserInfo].userId;
    replyModel.replyUserName = [UserModel sharedUserInfo].chineseName;
    if(_reReplyPId==nil){
        replyModel.content =content;//[NSString stringWithFormat:@"%@:%@",@"我", content] ;
    }
    else{
        replyModel.content =content;//[NSString stringWithFormat:@"我@%@:%@",_reReplyName,content]  ;
          replyModel.orgUserId = _reReplyPId;
        replyModel.orgUserName = _reReplyName;
        }
    [replyinfos addObject:replyModel];
    [tableView reloadData];
}


-(void)changeParentViewFram:(int)newHeight
{
//    newHeight=newHeight>0?newHeight-50:newHeight+50;
//    NSLog(@"%f",tableView.contentOffset.y);
//   [tableView setContentOffset:CGPointMake(0.0,tableView.contentOffset.y+ newHeight) animated:YES];
//     NSLog(@"%f",tableView.contentOffset.y);
    [tableView setContentOffset:CGPointMake(0.0,tableView.contentOffset.y+ newHeight) animated:YES];
}
#pragma AttentionSelectViewDelegat
- (void) ViewSelectWithModel:(NSString*) loverID imagurl:(NSString*)imgUrl
{
    pages=0;
    previousDate=nil;
    [self SelectWiewDismiss];
    _currentLoverId=loverID;
    self.tableView.pullTableIsRefreshing = YES;
    [self LoadDefaultDoctorInfo:loverID]; // 获取护工信息
    [self.btnRight sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal  placeholderImage:ThemeImage(@"placeholderimage")];

    [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentLoverId previousDate:previousDate pages:pages block:^(int code, id content) {
        if(code)
        {
            [_dataList removeAllObjects];
            [_dataList addObjectsFromArray:content];
            if(_dataList.count>0)
                previousDate = [(EscortTimeDataModel*)_dataList[_dataList.count-1] createDate];
            [tableView reloadData];
        }

        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
    }];
        
}



- (void) ViewShutDown
{
    [self SelectWiewDismiss];
}

#pragma mark - PullTableViewDelegate

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
//    NSLog(@"%f",tableView.contentInset.bottom);
//}


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)_pullTableView
{
    if([UserModel sharedUserInfo].isLogin){
        pages = 0;
        previousDate=nil;
//        [self loadDataList:_currentLoverId];
        [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentLoverId previousDate:previousDate pages:pages block:^(int code, id content) {
            if(code)
            {
                [_dataList removeAllObjects];
                [_dataList addObjectsFromArray:content];
                if(_dataList.count>0)
                 previousDate = [(EscortTimeDataModel*)_dataList[_dataList.count-1] createDate];
                [tableView reloadData];
            }
        }];

      }
     [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)_pullTableView
{
     if([UserModel sharedUserInfo].isLogin){
        pages ++;
        [EscortTimeDataModel LoadCareTimeListWithLoverId:_currentLoverId previousDate:previousDate pages:pages block:^(int code, id content) {
            if([(NSArray*)content count]>0)
            {
                [_dataList addObjectsFromArray:content];
                
                previousDate = [(EscortTimeDataModel*)_dataList[_dataList.count-1] createDate];
                [tableView reloadData];
            }
        }];
     }
     [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2];
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
