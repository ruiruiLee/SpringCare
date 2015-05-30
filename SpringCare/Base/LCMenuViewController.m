//
//  LCMenuViewController.m
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCMenuViewController.h"
#import "define.h"
#import "Util.h"
#import "MenuTableViewCell.h"
#import "SliderViewController.h"

#import "UIButton+WebCache.h"

#import "UserAttentionVC.h"
#import "EditUserInfoVC.h"
#import "EditCellTypeData.h"
#import "MyOrderListVC.h"
#import "FeedBackVC.h"
#import "UserSettingVC.h"

#import "UserModel.h"
#import <AVOSCloud/AVOSCloud.h>

#import "CouponsVC.h"

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
    [[UserModel sharedUserInfo] removeObserver:self forKeyPath:@"chineseName"];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if([keyPath isEqualToString:@"chineseName"])
    {
        [_btnUserName setTitle:[UserModel sharedUserInfo].displayName forState:UIControlStateNormal];
        [_btnphotoImg sd_setImageWithURL:[NSURL URLWithString:[UserModel sharedUserInfo].headerFile] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UserModel *model = [UserModel sharedUserInfo];
    [model addObserver:self forKeyPath:@"chineseName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    self.navigationController.navigationBarHidden=YES;
    
    _imgViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_imgViewBg];
    _imgViewBg.image = [UIImage imageNamed:@"usercenterbg"];
    _imgViewBg.translatesAutoresizingMaskIntoConstraints = NO;
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headerView.userInteractionEnabled = YES;
    
    
    _photoBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_photoBg];
    _photoBg.translatesAutoresizingMaskIntoConstraints = NO;
    _photoBg.image = [UIImage imageNamed:@"usercenterphotobg"];
    _photoBg.userInteractionEnabled = YES;
    
     _btnphotoImg = [[UIButton alloc] initWithFrame:CGRectZero];
     _btnphotoImg.layer.masksToBounds = YES;
     _btnphotoImg.layer.cornerRadius = (140) / 4;
     [_photoBg addSubview:_btnphotoImg];
     _btnphotoImg.translatesAutoresizingMaskIntoConstraints = NO;
     [_btnphotoImg addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
      [_btnphotoImg sd_setImageWithURL:[NSURL URLWithString:[UserModel sharedUserInfo].headerFile] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];
    _btnUserName = [[UIButton alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_btnUserName];
    _btnUserName.translatesAutoresizingMaskIntoConstraints = NO;
    _btnUserName.titleLabel.font = _FONT(18);
    [_btnUserName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnUserName.imageEdgeInsets = UIEdgeInsetsMake(6, ScreenWidth - (ScreenWidth + 24 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)) - 20 - 93 - 5 - 14, 8, 0);
    _btnUserName.titleEdgeInsets = UIEdgeInsetsMake(7, -16, 7, 14);
    [_btnUserName setImage:[UIImage imageNamed:@"usercentershut"] forState:UIControlStateNormal];
    _btnUserName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnUserName addTarget:self action:@selector(doEditUserInfo:) forControlEvents:UIControlEventTouchUpInside];
  [_btnUserName setTitle:[UserModel sharedUserInfo].displayName forState:UIControlStateNormal];
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_photoBg, _btnphotoImg, _btnUserName);
    NSString *format = [NSString stringWithFormat:@"H:|-20-[_photoBg(93)]-5-[_btnUserName(%f)]-%f-|", ScreenWidth - (ScreenWidth + 24 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)) - 20 - 93 - 5, ScreenWidth + 24 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
    unflodConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:headerViews];
    [_headerView addConstraints:unflodConstraints];
//    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-88.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnUserName(30)]->=0-|" options:0 metrics:nil views:headerViews]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_btnUserName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_photoBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_photoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_btnphotoImg]-11-|" options:0 metrics:nil views:headerViews]];
    [_photoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-11-[_btnphotoImg]-11-|" options:0 metrics:nil views:headerViews]];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    
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
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    
    if(type == EnumValueTypeiPhone4S)
    {
        if(_IPHONE_OS_VERSION_UNDER_7_0){
            [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-38.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, 140);
        }
        else{
            [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-58.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, 160);
        }
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(34)]-26.5-|" options:0 metrics:nil views:footViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(34)]-26.5-|" options:0 metrics:nil views:footViews]];
        NSString *footFormat = [NSString stringWithFormat:@"H:|-21-[_imgLogo(96)]-4-[_btnHotLine]-%f-|", ScreenWidth + 20 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
        _btnHotLine.titleLabel.font = _FONT(13);
        _btnUserName.titleLabel.font = _FONT(14);
    }
    else if (type == EnumValueTypeiPhone5)
    {
        if(_IPHONE_OS_VERSION_UNDER_7_0){
            [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-63.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, 185);
        }
        else{
            [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-83.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, 205);
        }
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(34)]-41.5-|" options:0 metrics:nil views:footViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(34)]-41.5-|" options:0 metrics:nil views:footViews]];
        NSString *footFormat = [NSString stringWithFormat:@"H:|-21-[_imgLogo(96)]-4-[_btnHotLine]-%f-|", ScreenWidth + 20 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
        _btnHotLine.titleLabel.font = _FONT(13);
        _btnUserName.titleLabel.font = _FONT(14);
    }
    else if(type == EnumValueTypeiPhone6){
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-88.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(39)]-61.5-|" options:0 metrics:nil views:footViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(39)]-61.5-|" options:0 metrics:nil views:footViews]];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 210);
        NSString *footFormat = [NSString stringWithFormat:@"H:|-21-[_imgLogo(110)]-24-[_btnHotLine]-%f-|", ScreenWidth + 20 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
    }
    else if (type == EnumValueTypeiPhone6P){
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-88.5-[_photoBg(93)]->=0-|" options:0 metrics:nil views:headerViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(39)]-61.5-|" options:0 metrics:nil views:footViews]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(39)]-61.5-|" options:0 metrics:nil views:footViews]];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 220);
        NSString *footFormat = [NSString stringWithFormat:@"H:|-21-[_imgLogo(110)]-24-[_btnHotLine]-%f-|", ScreenWidth + 20 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
    }
    
    tableview.tableHeaderView = _headerView;
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    
    if(type == EnumValueTypeiPhone4S)
        return 50;
    else if (type == EnumValueTypeiPhone5)
        return 55;
    else
        return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor clearColor];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
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
        cell.imgIcon.image = [UIImage imageNamed:@"usercentercouponlogo"];
        cell.lbContent.text = @"我的优惠券";
    }
    else if (indexPath.row == 3){
        cell.imgIcon.image = [UIImage imageNamed:@"usercenterfeedback"];
        cell.lbContent.text = @"意见反馈";
    }
    else if (indexPath.row == 4){
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
    case 0:
    {
        UserAttentionVC *vc = [[UserAttentionVC alloc] initWithNibName:nil bundle:nil];
        [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
    }
        break;
    case 1:
    {
       MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
      [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
    }
        break;
    case 2:
    {
        CouponsVC *vc = [[CouponsVC alloc] initWithNibName:nil bundle:nil];
        vc.isActive = NO;
        vc.NavTitle = @"我的优惠券";
        [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
    }
        break;
    case 3:
    {
      FeedBackVC *vc = [[FeedBackVC alloc] initWithNibName:nil bundle:nil];
       [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
    }
        break;
    case 4:
    {
       UserSettingVC *vc = [[UserSettingVC alloc] initWithNibName:nil bundle:nil];
    [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
    }
        break;
    default:
        break;
     }
        // [[SliderViewController sharedSliderController] closeSideBar];

}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [Util openPhotoLibrary:self allowEdit:YES completion:^{
        }];
        
    }else if (buttonIndex == 1)
    {
        [Util openCamera:self allowEdit:YES completion:^{}];
    }
    else{
        
    }
}
#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
      //image = [Util fitSmallImage:image scaledToSize:imgCoverSize];
   [self dismissViewControllerAnimated:YES completion:^{
    NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],0.5);
    UIImage *image= [UIImage imageWithData:imageData];
    image = [Util fitSmallImage:image scaledToSize:imgHeaderSize];
    [_btnphotoImg setImage:image forState:UIControlStateNormal];
    AVFile *file = [AVFile fileWithName:@"head.jpg" data:imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            AVUser *user = [AVUser currentUser];
            [user setObject:file forKey:@"headerImage"];
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[UserModel sharedUserInfo] setHeaderFile:file.url];
                }
            }];
        }];

      }];
    }];
    
}
#pragma ACTION
- (void) btnPhotoPressed:(UIButton*)sender{
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                    delegate:(id)self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"从相册选取"
                                           otherButtonTitles:@"拍照",nil];
    ac.actionSheetStyle = UIBarStyleBlackTranslucent;
    [ac showInView:self.view];

}

- (void) doEditUserInfo:(UIButton*)sender
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    EditCellTypeData *data1 = [[EditCellTypeData alloc] init];
    data1.cellTitleName = @"电话（账户）";
    data1.cellType = EnumTypeAccount;
    [mArray addObject:data1];
    
    EditCellTypeData *data2 = [[EditCellTypeData alloc] init];
    data2.cellTitleName = @"姓名";
    data2.cellType = EnumTypeUserName;
    [mArray addObject:data2];
    
    EditCellTypeData *data3 = [[EditCellTypeData alloc] init];
    data3.cellTitleName = @"性别";
    data3.cellType = EnumTypeSex;
    [mArray addObject:data3];
    
    EditCellTypeData *data4 = [[EditCellTypeData alloc] init];
    data4.cellTitleName = @"年龄";
    data4.cellType = EnumTypeAge;
    [mArray addObject:data4];
    
    EditCellTypeData *data5 = [[EditCellTypeData alloc] init];
    data5.cellTitleName = @"地址";
    data5.cellType = EnumTypeAddress;
    [mArray addObject:data5];
    
    
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
    [vc setContentArray:mArray andmodel:[UserModel sharedUserInfo]];
    vc.NavTitle = @"编辑我的资料";
   [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];


}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

@end
