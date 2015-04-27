//
//  PlaceOrderVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderVC.h"
#import "define.h"
#import "UserAppraisalCell.h"
#import "PayTypeCell.h"
#import "UIImageView+WebCache.h"
#import "NurseListInfoModel.h"
#import "MyEvaluateListVC.h"
#import "WorkAddressSelectVC.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"
#import "LoginVC.h"

#define LIMIT_LINES 4

@interface PlaceOrderVC () <WorkAddressSelectVCDelegate>
{
    NurseListInfoModel *_nurseModel;
    
    UserAttentionModel *_loverModel;
    NSString * productId;
}

@property (nonatomic, strong)UserAttentionModel *_loverModel;

@end

@implementation PlaceOrderVC
@synthesize _loverModel = _loverModel;


- (id) initWithModel:(NurseListInfoModel*) model andproductId:(NSString*)_productId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _nurseModel = model;
        productId = _productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"下 单";
    
    [self initSubviews];
    
    __weak PlaceOrderVC *weakSelf = self;
    __weak NurseListInfoModel *weaknurseModel = _nurseModel;
   //if([UserModel sharedUserInfo].isLogin){
        [_nurseModel loadetailDataWithproductId:productId block:^(id content) {

         NSDictionary *dic = [content objectForKey:@"care"];
        weaknurseModel.detailIntro =[dic objectForKey:@"detailIntro"];
        weaknurseModel.isLoadDetail=YES;
          NSDictionary *dicLover = [content objectForKey:@"defaultLover"];
        if (dicLover.count>0) {
            weakSelf._loverModel =  [[UserAttentionModel alloc] init];
            weakSelf._loverModel.userid = [dicLover objectForKey:@"id"];
            weakSelf._loverModel.address =[dicLover objectForKey:@"addr"];
        }
        [weakSelf modifyDetailView];
        [weakSelf NotifyAddressSelected:nil model:weakSelf._loverModel];
    }];
 //  }
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PICKVIEW_HIDDEN object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableview registerClass:[PlaceOrderEditCell class] forCellReuseIdentifier:@"cell1"];
    [_tableview registerClass:[PayTypeCell class] forCellReuseIdentifier:@"cell2"];
    
    UIView *headerView = [self createTableViewHeader];
    _tableview.tableHeaderView = headerView;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    [btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = YES;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-20-[btnSubmit(44)]-20-|" options:0 metrics:nil views:views]];
    
}

- (void) newAttentionWithAddress:(NSString*)address block:(Completion)block;
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [mDic setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];

    [mDic setObject:address forKey:@"addr"];
    
    [LCNetWorkBase postWithMethod:@"api/lover/save" Params:mDic Completion:^(int code, id content) {
        if(code){
            if(block){
                block(code, content);
            }
            
            [UserAttentionModel loadLoverList:@"true" block:^(int code) {

            }];
        }
    }];

}

- (void) btnSubmitOrder:(UIButton*)sender
{
    if(![[UserModel sharedUserInfo] isLogin]){
        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else if( !_loverModel){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择陪护地址！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alert show];
        return;
    }
    else if(!_loverModel.address||[_loverModel.address isEqual:@""]){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择陪护地址！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
//        __weak PlaceOrderVC *weakSelf = self;
//        [self newAttentionWithAddress:[LocationManagerObserver sharedInstance].currentDetailAdrress block:^(int code, id content) {
//            if(code){
//                if([content objectForKey:@"code"] == nil)
//                    [weakSelf submitWithloverId:@"message"];
//            }
//        }];
        return;
    }
    else{
        [self submitWithloverId:_loverModel.userid];
    }
}

- (void) submitWithloverId:(NSString*)loverId
{
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(editcell.lbTitle.text == nil || [editcell.lbTitle.text length] < 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择订单开始时间！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alert show];
        return;
    }
    
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:_nurseModel.nid forKey:@"careId"];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:loverId forKey:@"loverId"];
    [Params setObject:[cfAppDelegate defaultProductId] forKey:@"productId"];
    [Params setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];
    
    BusinessType type = cell.businessTypeView.businesstype;
    NSString *dateType = @"1";
    
    if(type == EnumType24Hours)
        dateType = @"2";
    [Params setObject:dateType forKey:@"dateType"];//
    
    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@:00", [Util reductionTimeFromOrderTime:editcell.lbTitle.text]]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithInteger:cell.dateSelectView.countNum] forKey:@"orderCount"];//
    
    NSInteger unitPrice = _nurseModel.priceDiscount;
    //NSInteger orgUnitPrice = _nurseModel.price;
    if(type == EnumType12Hours){
        unitPrice = unitPrice/2;
       // orgUnitPrice = orgUnitPrice/2;
    }
    
    [Params setObject:[NSNumber numberWithInteger:_nurseModel.price] forKey:@"orgUnitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice * cell.dateSelectView.countNum] forKey:@"totalPrice"];//
    
    __weak PlaceOrderVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSString *code = [content objectForKey:@"code"];
                if(code == nil)
                {
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
                    [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
                }
            }
        }
    }];
}

- (void) doBtnDetailFoldOrUnfold:(UIButton*)sender
{
    UIView *headerView = _tableview.tableHeaderView;

    if(!sender.selected){
        _detailInfo.numberOfLines = 0;
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    }else{
        _detailInfo.numberOfLines = LIMIT_LINES;
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    }
    sender.selected = !sender.selected;
    _tableview.tableHeaderView = headerView;
}

-(void)modifyDetailView{
    if(_nurseModel.detailIntro != nil){
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nurseModel.detailIntro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_nurseModel.detailIntro length])];
        _detailInfo.attributedText = attributedString;
        
        UIView *headerView = _tableview.tableHeaderView;
        
        CGRect frame = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:4];
        CGRect frame1 = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:5];
        
        [headerView removeConstraints:headerViewHeightConstraint];
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _btnUnfold, _btnInfo, _btnCert,
                                                             _detailInfo);
        if(frame1.size.height != frame.size.height){
            headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[_lbName(20)]-4-[_btnInfo(21)]-18-[_detailInfo]-8-[_btnUnfold(20)]->=0-|" options:0 metrics:nil views:views];
            _btnUnfold.hidden = NO;
        }
        else{
            headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[_lbName(20)]-4-[_btnInfo(21)]-18-[_detailInfo]-8-|" options:0 metrics:nil views:views];
            _btnUnfold.hidden = YES;
        }
        
        [headerView addConstraints:headerViewHeightConstraint];
        
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
        
        _tableview.tableHeaderView = headerView;
    }
}

- (UIView*) createTableViewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 293)];
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_photoImage];

    [_photoImage sd_setImageWithURL:[NSURL URLWithString:_nurseModel.headerImage] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:_nurseModel.sex]])];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(18);
    _lbName.text = _nurseModel.name;
    
    _btnCert = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnCert];
    _btnCert.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCert setImage:[UIImage imageNamed:@"placeoredercert"] forState:UIControlStateNormal];
    [_btnCert addTarget:self action:@selector(lookImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT(12);
    [_btnInfo setTitleColor:_COLOR(0x6b, 0x4e, 0x3e) forState:UIControlStateNormal];
    NSString *title = [NSString stringWithFormat:@"%@ %ld岁 护龄%@年", _nurseModel.birthPlace, _nurseModel.age, _nurseModel.careAge];
    [_btnInfo setTitle:title  forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    float width = [NSStrUtil widthForString:title fontSize:12];//screenwidth - 183
    if(width > ScreenWidth - 178 - 21)
        width = ScreenWidth - 178 - 21;
    _btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _btnInfo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, width);
    _btnInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _detailInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_detailInfo];
    _detailInfo.textColor = _COLOR(0x99, 0x99, 0x99);
    _detailInfo.font = _FONT(13);
    _detailInfo.numberOfLines = LIMIT_LINES;
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 44;
    
    CGRect frame = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:4];
    CGRect frame1 = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:5];
    
    _btnUnfold = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnUnfold];
    [_btnUnfold setTitle:@"全文" forState:UIControlStateNormal];
    [_btnUnfold setTitle:@"收起" forState:UIControlStateSelected];
    [_btnUnfold setTitleColor:_COLOR(0x10, 0x9d, 0x59) forState:UIControlStateNormal];
    _btnUnfold.titleLabel.font = _FONT(15);
    _btnUnfold.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnUnfold addTarget:self action:@selector(doBtnDetailFoldOrUnfold:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _btnUnfold, _btnInfo, _btnCert,
                                                         _detailInfo);
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImage(82)]-5-[_lbName]->=10-[_btnCert(43)]-36-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImage]-5-[_btnInfo]->=10-[_btnCert(43)]-16-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_detailInfo]-29-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_btnUnfold]->=20-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImage(82)]->=20-|" options:0 metrics:nil views:views]];
    if(frame1.size.height != frame.size.height){
        headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[_lbName(20)]-4-[_btnInfo(21)]-18-[_detailInfo]-8-[_btnUnfold(20)]->=0-|" options:0 metrics:nil views:views];
        _btnUnfold.hidden = NO;
    }
    else{
        headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[_lbName(20)]-4-[_btnInfo(21)]-18-[_detailInfo]-8-|" options:0 metrics:nil views:views];
        _btnUnfold.hidden = YES;
    }
    [headerView addConstraints:headerViewHeightConstraint];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_btnCert attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    
    return headerView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return 1;
    }
    else if (section == 2){
        return 1;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 50.f;
    else if (indexPath.section == 1)
    {
        return 248.f;
    }
    else{
        return 170.f;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        UserAppraisalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if(!cell){
            cell = [[UserAppraisalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell._lbAppraisalNum.text = [NSString stringWithFormat:@"用户评价（%ld）", _nurseModel.commentsNumber];
        return cell;
    }
    else if (indexPath.section == 2){
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else{
        PlaceOrderEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNurseListInfo:_nurseModel];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(_nurseModel.commentsNumber > 0){
            MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initVCWithNurseId:_nurseModel.nid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13.5f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    return view;
}

- (void) NotifyToSelectAddr
{
    WorkAddressSelectVC *vc = [[WorkAddressSelectVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    if(_loverModel != nil){
       
        vc.view.backgroundColor = [UIColor clearColor];
        [vc setSelectItemWithLoverId:_loverModel.userid];
        
    }
   else{
       vc.currentAdress = [LcationInstance currentDetailAdrress];
    }
   [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (model==nil) {
        NSLog(@"%@",[LcationInstance currentDetailAdrress]);
        if ([LcationInstance currentDetailAdrress]) {
            editcell.lbTitle.font = _FONT_B(16);
            editcell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
            editcell.lbTitle.text=[LcationInstance currentDetailAdrress];

           }
      }
    else{
        _loverModel = model;
        editcell.lbTitle.font = _FONT_B(16);
        editcell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
        editcell.lbTitle.text = model.address;
    }


}

-(void)lookImageAction:(UIButton *)sender
{
    NSLog(@"lookImageAction");
    _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    [_imageList addImagesURL:nil withSmallImage:nil];
    [self.view.window addSubview:_imageList];
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
}

@end
