//
//  LCMenuViewController.m
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCMenuViewController.h"
#import "define.h"
#import "MenuTableViewCell.h"
#import "SliderViewController.h"
#import "UIImageView+WebCache.h"

#import "UserAttentionVC.h"
#import "EditUserInfoVC.h"
#import "EditCellTypeData.h"
#import "MyOrderListVC.h"
#import "FeedBackVC.h"
#import "UserSettingVC.h"

#import "UserModel.h"
#import "SliderViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation LCMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void) dealloc
{
//    UserModel *model = [UserModel sharedUserInfo];
//    [model removeObserver:self forKeyPath:@"username"];
//    [model removeObserver:self forKeyPath:@"chineseName"];
//    [model removeObserver:self forKeyPath:@"headerFile"];
}


//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    UserModel *model = [UserModel sharedUserInfo];
//    if([keyPath isEqualToString:@"username"])
//    {
//        [_btnUserName setTitle:model.username forState:UIControlStateNormal];
//    }
//    if([keyPath isEqualToString:@"chineseName"])
//    {
//        [_btnUserName setTitle:model.chineseName forState:UIControlStateNormal];
//    }
//    if ([keyPath isEqualToString:@"headerFile"]){
//        [_photoImgView sd_setImageWithURL:[NSURL URLWithString:model.headerFile]];
//    }
//}

//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
  //  UserModel *model = [UserModel sharedUserInfo];
//    [model addObserver:self forKeyPath:@"chineseName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    [model addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    [model addObserver:self forKeyPath:@"headerFile" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    self.navigationController.navigationBarHidden=YES;
    
    _imgViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_imgViewBg];
    _imgViewBg.image = [UIImage imageNamed:@"usercenterbg"];
    _imgViewBg.translatesAutoresizingMaskIntoConstraints = NO;
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 240);
    _headerView.userInteractionEnabled = YES;
    
    _photoBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_photoBg];
    _photoBg.translatesAutoresizingMaskIntoConstraints = NO;
    _photoBg.image = [UIImage imageNamed:@"usercenterphotobg"];
    
    _photoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_photoBg addSubview:_photoImgView];
    _photoImgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _btnUserName = [[UIButton alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_btnUserName];
    _btnUserName.translatesAutoresizingMaskIntoConstraints = NO;
    _btnUserName.titleLabel.font = _FONT(18);
    [_btnUserName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnUserName.imageEdgeInsets = UIEdgeInsetsMake(6, 136, 8, 0);
    _btnUserName.titleEdgeInsets = UIEdgeInsetsMake(7, 0, 7, 14);
    [_btnUserName setImage:[UIImage imageNamed:@"usercentershut"] forState:UIControlStateNormal];
    _btnUserName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnUserName addTarget:self action:@selector(doEditUserInfo:) forControlEvents:UIControlEventTouchUpInside];
 
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_photoBg, _photoImgView, _btnUserName);
    NSString *format = [NSString stringWithFormat:@"H:|-20-[_photoBg(93)]->=5-[_btnUserName(148)]-%f-|", ScreenWidth + 24 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
    unflodConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:headerViews];
    [_headerView addConstraints:unflodConstraints];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-88.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnUserName(30)]->=0-|" options:0 metrics:nil views:headerViews]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_btnUserName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_photoBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_photoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImgView]-11-|" options:0 metrics:nil views:headerViews]];
    [_photoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-11-[_photoImgView]-11-|" options:0 metrics:nil views:headerViews]];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    
    tableview.tableHeaderView = _headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    tableview.tableFooterView = footerView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view, tableview, _imgViewBg);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imgViewBg]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imgViewBg]-0-|" options:0 metrics:nil views:views]];
    
    _imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_imgLogo];
    _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
    _imgLogo.image = [UIImage imageNamed:@"logo"];
    
    _btnHotLine = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnHotLine];
    _btnHotLine.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnHotLine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnHotLine.titleLabel.font = _FONT(15);
    _btnHotLine.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 6, 0);
    [_btnHotLine setImage:[UIImage imageNamed:@"usercenterring"] forState:UIControlStateNormal];
    [_btnHotLine setTitle:@"400-626-8787" forState:UIControlStateNormal];
    
    
    NSDictionary *footViews = NSDictionaryOfVariableBindings(_imgLogo, _btnHotLine);
    NSString *footFormat = [NSString stringWithFormat:@"H:|-21-[_imgLogo(110)]-24-[_btnHotLine]-%f-|", ScreenWidth + 20 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(39)]-61.5-|" options:0 metrics:nil views:footViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(39)]-61.5-|" options:0 metrics:nil views:footViews]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyUserInfo:) name:NOTIFY_USERIN_DISPLAY object:nil];
}

- (void) NotifyUserInfo:(NSNotification*) notify
{
    AVUser *currentUser = [AVUser currentUser];
    if ([currentUser objectForKey:@"chinese_name"]==nil) {
        [_btnUserName setTitle:currentUser.username forState:UIControlStateNormal];
    }
    else{
        [_btnUserName setTitle:[currentUser objectForKey:@"chinese_name"] forState:UIControlStateNormal];
    }
    // 头像判断
    
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorLine.hidden = NO;
    if(indexPath.row == 0){
        cell.imgIcon.image = [UIImage imageNamed:@"usercentermyattention"];
        cell.lbContent.text = @"我的关注";
    }
    else if (indexPath.row == 1){
        cell.imgIcon.image = [UIImage imageNamed:@"usercentermyorders"];
        cell.lbContent.text = @"我的订单";
    }
    else if (indexPath.row == 2){
        cell.imgIcon.image = [UIImage imageNamed:@"usercenterfeedback"];
        cell.lbContent.text = @"意见反馈";
    }
    else if (indexPath.row == 3){
        cell.imgIcon.image = [UIImage imageNamed:@"usercentersetting"];
        cell.lbContent.text = @"设置";
        cell.separatorLine.hidden = YES;
    }
    return cell;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MENU_CHANGED object:nil userInfo:@{@"type" : @"1"}];
        }
            break;
        case 1:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MENU_CHANGED object:nil userInfo:@{@"type" : @"2"}];
        }
            break;
        case 2:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MENU_CHANGED object:nil userInfo:@{@"type" : @"3"}];
        }
            break;
        case 3:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MENU_CHANGED object:nil userInfo:@{@"type" : @"4"}];
        }
            break;
        default:
            break;
    }

    [[SliderViewController sharedSliderController] closeSideBar];
}

#pragma ACTION



- (void) doEditUserInfo:(UIButton*)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MENU_CHANGED object:nil userInfo:@{@"type" : @"5"}];
    
    [[SliderViewController sharedSliderController] closeSideBar];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

@end
