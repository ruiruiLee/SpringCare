//
//  UserSettingVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserSettingVC.h"
#import "UserSettingTableCell.h"
#import "define.h"
#import "WebContentVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SliderViewController.h"
#import "HomePageVC.h"
#import "InputRecommendVC.h"
#import "QuickmarkVC.h"
#import "FeedBackVC.h"
#import "AppListCell.h"

@interface UserSettingVC ()<AppListCellDelegate>

@end

@implementation UserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"设置";
    
    [self initSubViews];
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = TableBackGroundColor;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    
    UILabel *_lbVersion = [[UILabel alloc] initWithFrame:CGRectZero];
    [footView addSubview:_lbVersion];
    _lbVersion.translatesAutoresizingMaskIntoConstraints = NO;
    _lbVersion.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbVersion.font = _FONT(12);
    _lbVersion.textAlignment = NSTextAlignmentCenter;
    _lbVersion.text = [NSString stringWithFormat:@"iphone版: V %@",[Util getCurrentVersion]];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
    btnCancel.translatesAutoresizingMaskIntoConstraints = NO;
    btnCancel.layer.cornerRadius = 5;
    [btnCancel setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [btnCancel setTitle:@"退 出" forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnCancel.clipsToBounds = YES;
    [footView addSubview:btnCancel];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[btnCancel]-28-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnCancel, _lbVersion)]];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbVersion]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnCancel, _lbVersion)]];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-26-[btnCancel]-13-[_lbVersion(20)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnCancel, _lbVersion)]];
    [btnCancel addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 110);
        btnCancel.titleLabel.font = _FONT(17);
    }
    else if (type == EnumValueTypeiPhone5){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 110);
        btnCancel.titleLabel.font = _FONT(17);
    }
    else if (type == EnumValueTypeiPhone6){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 120);
        btnCancel.titleLabel.font = _FONT(18);
    }
    else if (type == EnumValueTypeiPhone6P){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 130);
        btnCancel.titleLabel.font = _FONT(20);
    }else{
        footView.frame = CGRectMake(0, 0, ScreenWidth, 110);
        btnCancel.titleLabel.font = _FONT(17);
    }
    
    _tableview.tableFooterView = footView;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    
    
}

- (void) btnCancelPressed:(id)sender
{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation removeObject:[UserModel sharedUserInfo].userId forKey:@"channels"];
    [currentInstallation saveInBackground];
    [AVUser logOut];  //清除缓存用户对象
    [UserModel sharedUserInfo].userId = nil;
    [Util DeleteCity];
    [[SliderViewController sharedSliderController].navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Register_Logout object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 4;
    else if (section == 1)
        return 1;
    else
        return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
        return 120.f;
    
    return 50.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(indexPath.section == 0){
//        // 版本更新
////        [Util  updateVersion:^(NSArray *info) {
////            NSDictionary *releaseInfo = [info objectAtIndex:0];
////            NSString  *appVersion  = [releaseInfo objectForKey:@"version"];
////            _appDownUrl = [releaseInfo objectForKey:@"trackViewUrl"]; // 获取 更新用滴 URL
////            if ([[Util getCurrentVersion] floatValue] < [appVersion floatValue])
////            {
////             UIAlertView * updateAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"升级到新版本%@", appVersion]
////                                                                message:[releaseInfo objectForKey:@"releaseNotes"] delegate:self
////                                                      cancelButtonTitle:@"取消"
////                                                      otherButtonTitles:@"升级", nil];
////                updateAlert.tag=512;
////                updateAlert.delegate = self;
////                [updateAlert show];
////           
////            }
////
////        }];
//    }

    if(indexPath.section == 0){
        if(indexPath.row == 0)
        {
           // 告诉朋友
            QuickmarkVC *vc = [[QuickmarkVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.row == 1){
           // 给app好评
            NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",KEY_APPLE_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else if (indexPath.row == 2){
            FeedBackVC *vc = [[FeedBackVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            InputRecommendVC *vc = [[InputRecommendVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if(indexPath.section == 2){
        if(indexPath.row == 0)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, About_Us];
            WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"关于我们" url:url];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Agreement];
            WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"用户陪护协议" url:url];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        AppListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[AppListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
            cell.delegate = self;
        }
        
        return cell;
    }
    else{
        UserSettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UserSettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
        }
        
    //    if(indexPath.section == 0)
    //    {
    //        cell._lbTitle.text = @"当前版本";
    //        cell._lbContent.text =[NSString stringWithFormat:@"V %@",[Util getCurrentVersion]] ;
    //        cell._lbContent.hidden = NO;
    //        cell._imgFold.hidden = YES;
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }else
        if (indexPath.section == 0)
        {
            if(indexPath.row == 0){
                cell._lbTitle.text = @"告诉朋友";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
            else if(indexPath.row == 1){
                cell._lbTitle.text = @"给我们好评";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
            else if (indexPath.row == 2){
                cell._lbTitle.text = @"意见反馈";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
            else{
                cell._lbTitle.text = @"邀请码";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
        }
        else if (indexPath.section == 2)
        {
            if(indexPath.row == 0){
                cell._lbTitle.text = @"关于我们";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
            else{
                cell._lbTitle.text = @"用户陪护协议";
                cell._lbContent.hidden = YES;
                cell._imgFold.hidden = NO;
            }
        }
        else{
            
        }
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.5f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==512 && buttonIndex > 0) // 升级版本
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appDownUrl]];
    }
}

- (void)NotifyAPpIconClicked:(AppInfoView *)sender
{
    AppInfo *data = sender.data;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.url]];
}

@end
