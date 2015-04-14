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
#import "PlaceOrderEditCell.h"
#import "UIImageView+WebCache.h"
#import "NurseListInfoModel.h"

#define LIMIT_LINES 4

@interface PlaceOrderVC ()
{
    NurseListInfoModel *_nurseModel;
}

@end

@implementation PlaceOrderVC

- (id) initWithModel:(NurseListInfoModel*) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _nurseModel = model;
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
    
    UIView *headerView = [self createTableViewHeader];
    _tableview.tableHeaderView = headerView;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-40-[btnSubmit(44)]-40-|" options:0 metrics:nil views:views]];
    
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

- (UIView*) createTableViewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 293)];
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_photoImage];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:_nurseModel.headerImage] placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(18);
    _lbName.text = _nurseModel.name;//@"王莹莹";
    
    _btnCert = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnCert];
    _btnCert.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCert setImage:[UIImage imageNamed:@"placeoredercert"] forState:UIControlStateNormal];
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT(12);
    [_btnInfo setTitleColor:_COLOR(0x6b, 0x4e, 0x3e) forState:UIControlStateNormal];
    [_btnInfo setTitle: [NSString stringWithFormat:@"%@ %ld岁 护龄%@年", _nurseModel.birthPlace, _nurseModel.age, _nurseModel.careAge] forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    _btnInfo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 21);
    
    _detailInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_detailInfo];
    _detailInfo.textColor = _COLOR(0x99, 0x99, 0x99);
    _detailInfo.font = _FONT(13);
    _detailInfo.numberOfLines = LIMIT_LINES;
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 44;
    _detailInfo.text = _nurseModel.detailIntro;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_detailInfo.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_detailInfo.text length])];
    _detailInfo.attributedText = attributedString;
    
    CGRect frame = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:4];
    CGRect frame1 = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:5];
    
    _btnUnfold = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnUnfold];
    [_btnUnfold setTitle:@"全文" forState:UIControlStateNormal];
    [_btnUnfold setTitle:@"关闭" forState:UIControlStateSelected];
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
        return cell;
    }
    else{
        PlaceOrderEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[PlaceOrderEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setNurseListInfo:_nurseModel];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
