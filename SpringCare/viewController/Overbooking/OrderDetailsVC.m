//
//  OrderDetailsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "PayForOrderVC.h"
#import "EvaluateOrderVC.h"

@implementation OrderPriceCell
@synthesize delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbPrice];
        
        _lbTotalPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTotalPrice.font = _FONT(15);
        _lbTotalPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbTotalPrice];
        
        _btnStatus = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnStatus.titleLabel.font = _FONT(16);
        [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_btnStatus];
        [_btnStatus addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnStatus.layer.cornerRadius = 5;
//        _btnStatus.text = @"已付款";
        
        _imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgLogo];
        _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _imgLogo.image = [UIImage imageNamed:@"orderend"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbTotalPrice, _btnStatus, _imgLogo);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]->=20-[_btnStatus(80)]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbTotalPrice]->=20-[_btnStatus]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbPrice(20)]-5-[_lbTotalPrice(20)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=20-[_imgLogo]-20-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价:¥%ld", model.unitPrice]];
    if(model.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12h X %ld天", model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/天 X %ld天", model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周 X %ld周", model.orderCount]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月 X %ld月", model.orderCount]];
    }
    
    _lbPrice.text = priceStr;
    _lbTotalPrice.text = [NSString stringWithFormat:@"总价:¥%ld", model.totalPrice];
    
    _btnStatus.userInteractionEnabled = YES;
    [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnStatus.backgroundColor = [UIColor clearColor];
    _btnStatus.tag = 4;
    if(model.orderStatus == EnumOrderStatusTypeCancel){
        _imgLogo.hidden = YES;
        [_btnStatus setTitle:@"订单取消" forState:UIControlStateNormal];
        _btnStatus.userInteractionEnabled = NO;
    }
    else{
        if(model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeCommented && model.payStatus == EnumTypePayed)
        {
            [_btnStatus setTitle:@"已完成" forState:UIControlStateNormal];
            _btnStatus.userInteractionEnabled = NO;
        }
        else if(model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeNoComment && model.payStatus == EnumTypePayed){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 2;
            [_btnStatus setTitle:@"去评价" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnStatus.backgroundColor = Abled_Color;
        }else if (model.orderStatus == EnumOrderStatusTypeNew && model.payStatus == EnumTypeNopay){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 3;
            [_btnStatus setTitle:@"取消订单" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnStatus.backgroundColor = Abled_Color;
        }
        else if(model.payStatus == EnumTypeNopay){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 1;
            [_btnStatus setTitle:@"去付款" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnStatus.backgroundColor = Abled_Color;
        }
        else{
            _imgLogo.hidden = YES;
            _btnStatus.userInteractionEnabled = NO;
            [_btnStatus setTitle:@"已付款" forState:UIControlStateNormal];
        }
    }
}

- (void) doBtnClicked:(UIButton*)sender
{

        if(delegate && [delegate respondsToSelector:@selector(NotifyButtonClickedWithFlag:)])
            [delegate NotifyButtonClickedWithFlag:(int)(sender.tag - 1)];

}

@end

@implementation OrderInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imgPhoto];
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(18);
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        
        _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnInfo];
        _btnInfo.titleLabel.font = _FONT(14);
        [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
        [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbIntro = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbIntro];
        _lbIntro.translatesAutoresizingMaskIntoConstraints = NO;
        _lbIntro.numberOfLines = 0;
        _lbIntro.font = _FONT(13);
        _lbIntro.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbIntro.preferredMaxLayoutWidth = ScreenWidth - 132;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = SeparatorLineColor;
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbType = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbType];
        _lbType.translatesAutoresizingMaskIntoConstraints = NO;
        _lbType.font = _FONT(15);
        _lbType.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbDetailTime];
        _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbDetailTime.font = _FONT(15);
        _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPrice];
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        _lbPrice.font = _FONT(18);
        _lbPrice.textColor = _COLOR(0xf1, 0x13, 0x59);
        _lbPrice.text = @"单价：380元/24小时";
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_line]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbDetailTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbType]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbName]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_btnInfo]->=20-|" options:0 metrics:nil views:views]];
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbIntro]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:constraintArray];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-3-[_btnInfo(20)]-1-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:nurseConstraintArray];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    
    _lbType.text = [NSString stringWithFormat:@"类型：%@", model.product.name];
//    _lbDetailTime.text = [NSString stringWithFormat:@""];//@"时间：3天（2015.03.19-2015.03.21）";
    NSMutableString *detailTime = [[NSMutableString alloc] init];
    [detailTime appendString:@"时间："];
    [detailTime appendString:[NSString stringWithFormat:@"%ld", model.orderCount]];
    if(model.dateType == EnumTypeHalfDay){
        [detailTime appendString:[NSString stringWithFormat:@"天"]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [detailTime appendString:[NSString stringWithFormat:@"天"]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [detailTime appendString:[NSString stringWithFormat:@"周"]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [detailTime appendString:[NSString stringWithFormat:@"月"]];
    }
    
    [detailTime appendString:[NSString stringWithFormat:@"(%@时-%@时)", [Util StringFromDate:model.beginDate], [Util StringFromDate:model.endDate]]];
    _lbDetailTime.text = detailTime;
    
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价:%ld元", model.unitPrice]];
    if(model.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12小时"]];
    }
    else if (model.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/24小时"]];
    }
    else if (model.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周"]];
    }
    else if (model.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月"]];
    }
    _lbPrice.text = priceStr;
    
    NSArray *nurseArray = model.nurseInfo;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
    [self.contentView removeConstraints:constraintArray];
    [self.contentView removeConstraints:nurseConstraintArray];
    if([nurseArray count] > 0){
        NurseListInfoModel *nurseModel = [nurseArray objectAtIndex:0];
        _lbIntro.text = nurseModel.intro;
        _lbName.text = nurseModel.name;
//        [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:nurseModel.headerImage] placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
        if(nurseArray != nil && [nurseArray count] > 0)
            [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:((NurseListInfoModel*)[nurseArray objectAtIndex:0]).headerImage] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:((NurseListInfoModel*)[nurseArray objectAtIndex:0]).sex]])];
        else
            [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
        
        NSString *info = [NSString stringWithFormat:@"%@  %ld岁  护龄%@年", nurseModel.birthPlace, nurseModel.age, nurseModel.careAge];
        [_btnInfo setTitle:info forState:UIControlStateNormal];
        
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-3-[_btnInfo(20)]-1-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        _btnInfo.hidden = NO;
    }else{
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imgPhoto(0)]-0-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        _btnInfo.hidden = YES;
    }
    
    [self.contentView addConstraints:constraintArray];
    [self.contentView addConstraints:nurseConstraintArray];
}

@end

@implementation BeCareInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgPhoto];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(15);
        _lbName.textAlignment = NSTextAlignmentCenter;
        
        _LbRelation = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_LbRelation];
        _LbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _LbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _LbRelation.font = _FONT(18);
        
        _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbAge];
        _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
        _lbAge.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbAge.font = _FONT(15);
        
        _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnMobile];
        _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnMobile setImage:[UIImage imageNamed:@"orderdetailtel"] forState:UIControlStateNormal];
        [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnMobile.titleLabel.font = _FONT(15);
        
        _btnAddress = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAddress];
        _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnAddress setImage:[UIImage imageNamed:@"orderdetailaddr"] forState:UIControlStateNormal];
        [_btnAddress setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnAddress.titleLabel.font = _FONT(15);
        
        _imgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgSex];
        _imgSex.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _LbRelation, _lbAge, _btnMobile, _btnAddress, _imgSex);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_LbRelation]-10-[_imgSex]-10-[_lbAge]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_btnMobile]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_btnAddress]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_imgPhoto(62)]-2-[_lbName(20)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_LbRelation(26)]-3-[_btnMobile(20)]-3-[_btnAddress(20)]->=0-|" options:0 metrics:nil views:views]];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAddress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgPhoto attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.lover.photoUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    _lbName.text = model.lover.username;
    if(model.lover.username == nil || [model.lover.username length] == 0)
        _lbName.text = @"姓名";
    _LbRelation.text = model.lover.relation;
    if(model.lover.relation == nil || [model.lover.relation length] == 0)
        _LbRelation.text = @"关系";
    _lbAge.text = [NSString stringWithFormat:@"%@岁", model.lover.age];
    if(model.lover.age == nil || [model.lover.age length] == 0)
        _lbAge.text = @"年龄";
    [_btnMobile setTitle:model.lover.ringNum forState:UIControlStateNormal];
    if(model.lover.ringNum == nil || [model.lover.ringNum length] == 0)
        [_btnMobile setTitle:@"电话" forState:UIControlStateNormal];
    [_btnAddress setTitle:model.lover.address forState:UIControlStateNormal];
    
    UserSex sex = [Util GetSexByName:model.lover.sex];
    if(sex == EnumMale){
        _imgSex.image = [UIImage imageNamed:@"mail"];
    }
    else if (sex == EnumFemale){
        _imgSex.image = [UIImage imageNamed:@"femail"];
    }
    else
        {
            _imgSex.image = nil;
        }
}

@end


@interface OrderDetailsVC ()

@end

@implementation OrderDetailsVC

- (id) initWithOrderModel:(MyOrderdataModel *) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _orderModel = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"订单详情";
    
    [self initSubviews];
    
    if(!_orderModel.isLoadDetail){
        [_orderModel LoadDetailOrderInfo:^(int code) {
            if(code){
                [_tableview reloadData];
                [self initDataForView];
            }
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[OrderPriceCell class] forCellReuseIdentifier:@"cell0"];
    [_tableview registerClass:[OrderInfoCell class] forCellReuseIdentifier:@"cell1"];
    [_tableview registerClass:[BeCareInfoCell class] forCellReuseIdentifier:@"cell2"];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 93.f;
    else if (indexPath.section == 1){
//        return 223.f;
        if(!ordercell)
        ordercell = [[OrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [ordercell setContentData:_orderModel];
        [ordercell setNeedsLayout];
        [ordercell layoutIfNeeded];
        
        CGSize size = [ordercell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
    else
        return 103.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        OrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1){
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        BeCareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    if(section == 0){
        _stepView = [[OrderStepView alloc] initWithFrame:CGRectZero];
        _stepView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:_stepView];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
            [_stepView SetStepViewType:StepViewType2Step];
            [_stepView SetCurrentStepWithIdx:3];//此处为3
        }else{
            [_stepView SetStepViewType:StepViewType4Step];
            [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
        }
    }
    else if (section == 1){
        lbOrderNum = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderNum.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderNum];
        lbOrderNum.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderNum.font = _FONT(14);
        lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
        
        lbOrderTime = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderTime.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderTime];
        lbOrderTime.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderTime.font = _FONT(14);
        lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", [Util StringFromDate:_orderModel.createdDate]];//@"下单时间：2015-03-19 12:46";
        
        NSDictionary*views = NSDictionaryOfVariableBindings(lbOrderNum, lbOrderTime);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderNum]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderTime]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[lbOrderNum(20)]-2-[lbOrderTime(20)]-6-|" options:0 metrics:nil views:views]];
    }
    else{
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
        lb.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lb];
        lb.textColor = _COLOR(0x66, 0x66, 0x66);
        lb.font = _FONT(14);
        lb.text = @"被保护人信息";
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lb]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    }
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 85.f;
    }else if(section == 1)
        return 54.f;
    else
        return 29.f;
}

- (void) initDataForView
{
    lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
    lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", [Util StringFromDate:_orderModel.createdDate]];//@"下单时间：2015-03-19 12:46";
    if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
        [_stepView SetStepViewType:StepViewType2Step];
        [_stepView SetCurrentStepWithIdx:3];//此处为3
    }else{
        [_stepView SetStepViewType:StepViewType4Step];
        [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
    }
}

- (int) GetStepWithModel:(MyOrderdataModel *) model
{
    if(model.orderStatus == EnumOrderStatusTypeNew)
        return 1;
    else if (model.orderStatus == EnumOrderStatusTypeConfirm)
        return 2;
    else if (model.orderStatus == EnumOrderStatusTypeServing)
        return 3;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeNoComment)
        return 4;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeCommented)
        return 5;
    else
        return 0;
}

- (void) NotifyButtonClickedWithFlag:(int) flag
{
//    0 去付款， 1 去评论
    if(flag == 0){
        PayForOrderVC *vc = [[PayForOrderVC alloc] initWithModel:_orderModel];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(flag == 1){
        EvaluateOrderVC *vc = [[EvaluateOrderVC alloc] initWithModel:_orderModel];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (flag == 2){
            [LCNetWorkBase postWithMethod:@"api/order/cancel" Params:@{@"orderId" : _orderModel.oId, @"registerId" : [UserModel sharedUserInfo].userId} Completion:^(int code, id content) {
                if(code){
                    if([content isKindOfClass:[NSDictionary class]]){
                        NSString *code = [content objectForKey:@"code"];
                        if(code == nil)
                        {
                            _orderModel.orderStatus = EnumOrderStatusTypeCancel;
                            if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
                                [_stepView SetStepViewType:StepViewType2Step];
                                [_stepView SetCurrentStepWithIdx:3];//此处为3
                            }else{
                                [_stepView SetStepViewType:StepViewType4Step];
                                [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
                            }
                        }
                    }
                }
            }];
    }
}

@end
