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
#import "LCNetWorkBase.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"

#define LIMIT_LINES 4

@interface PlaceOrderVC () <WorkAddressSelectVCDelegate>
{
    NurseListInfoModel *_nurseModel;
    
    UserAttentionModel *_loverModel;
}

@end

@implementation PlaceOrderVC

- (void) dealloc
{
    [_nurseModel removeObserver:self forKeyPath:@"detailIntro"];
}

- (id) initWithModel:(NurseListInfoModel*) model andproductId:(NSString*)productId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _nurseModel = model;
        
        [_nurseModel loadetailDataWithproductId:productId block:^(int code) {
            if(code){
                
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"下 单";
    
    [self initSubviews];
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
    
    UIView *headerView = [self createTableViewHeader];
    _tableview.tableHeaderView = headerView;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-20-[btnSubmit(44)]-20-|" options:0 metrics:nil views:views]];
    
}

- (void) btnSubmitOrder:(UIButton*)sender
{
    
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(editcell.lbTitle.text == nil || [editcell.lbTitle.text length] < 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择订单开始时间！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(_loverModel == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择陪护对象地址！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:_nurseModel.nid forKey:@"careId"];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:_loverModel.userid forKey:@"loverId"];
    [Params setObject:((AppDelegate*)[UIApplication sharedApplication].delegate).defaultProductId forKey:@"productId"];
    [Params setObject:((AppDelegate*)[UIApplication sharedApplication].delegate).currentCityModel.city_id forKey:@"cityId"];
    
    BusinessType type = cell.businessTypeView.businesstype;
    NSString *dateType = @"1";
    if(type == EnumType24Hours)
        dateType = @"2";
    [Params setObject:dateType forKey:@"dateType"];//
    
//    NSString *beginDate = [NSString stringWithFormat:@"%@:00", editcell.lbTitle.text];
    [Util ChangeToUTCTime:[NSString stringWithFormat:@"%@", editcell.lbTitle.text]];
    
    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@", editcell.lbTitle.text]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithInteger:cell.dateSelectView.countNum] forKey:@"orderCount"];//
    
    NSInteger unitPrice = _nurseModel.priceDiscount;
    NSInteger orgUnitPrice = _nurseModel.price;
    if(type == EnumType12Hours){
        unitPrice = unitPrice/2;
        orgUnitPrice = orgUnitPrice/2;
    }
    
    [Params setObject:[NSNumber numberWithInteger:_nurseModel.price] forKey:@"orgUnitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice * cell.dateSelectView.countNum] forKey:@"totalPrice"];//
    
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSString *code = [content objectForKey:@"code"];
                if(code == nil)
                {
                    //[self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToRootViewControllerAnimated:NO];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"detailIntro"])
    {
        if(_nurseModel.detailIntro != nil){
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nurseModel.detailIntro];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:2];//调整行间距
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_nurseModel.detailIntro length])];
            _detailInfo.attributedText = attributedString;
            
            UIView *headerView = _tableview.tableHeaderView;
            
            [headerView setNeedsLayout];
            [headerView layoutIfNeeded];
            
            CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
            
            _tableview.tableHeaderView = headerView;
        }
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
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT(12);
    [_btnInfo setTitleColor:_COLOR(0x6b, 0x4e, 0x3e) forState:UIControlStateNormal];
    NSString *title = [NSString stringWithFormat:@"%@ %ld岁 护龄%@年", _nurseModel.birthPlace, _nurseModel.age, _nurseModel.careAge];
    [_btnInfo setTitle:title  forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    float width = [NSStrUtil widthForString:title fontSize:12];
    _btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _btnInfo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, width);
    _btnInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _detailInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_detailInfo];
    _detailInfo.textColor = _COLOR(0x99, 0x99, 0x99);
    _detailInfo.font = _FONT(13);
    _detailInfo.numberOfLines = LIMIT_LINES;
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 44;
    [_nurseModel addObserver:self forKeyPath:@"detailIntro" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    if(_nurseModel.detailIntro != nil){
        _detailInfo.text = _nurseModel.detailIntro;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_detailInfo.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_detailInfo.text length])];
        _detailInfo.attributedText = attributedString;
    }
    
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
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-29-[_photoImage(82)]-10-[_lbName]->=10-[_btnCert(43)]-36-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-29-[_photoImage]-10-[_btnInfo]->=10-[_btnCert(43)]-16-|" options:0 metrics:nil views:views]];
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
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if(!cell){
            cell = [[PayTypeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setPaytype:EnumTypeAfter];
        
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
            MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initWithNibName:nil bundle:nil];
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    editcell.lbTitle.text = model.address;
    editcell.lbTitle.font = _FONT_B(18);
    editcell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
    
    _loverModel = model;
}

@end
