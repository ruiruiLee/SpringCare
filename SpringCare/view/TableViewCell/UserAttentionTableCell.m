//
//  UserAttentionTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionTableCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation UserAttentionTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImage];
        _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
        _photoImage.layer.cornerRadius = 43;
        
        _lbRelation =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbRelation];
        _lbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _lbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbRelation.font = _FONT_B(20);
        
        ImgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:ImgSex];
        ImgSex.translatesAutoresizingMaskIntoConstraints = NO;

        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(15);
        
        _Address = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_Address];
        _Address.translatesAutoresizingMaskIntoConstraints = NO;
        _Address.textColor = _COLOR(0x99, 0x99, 0x99);
        _Address.font = _FONT(15);
        _Address.numberOfLines = 0;
        _Address.preferredMaxLayoutWidth = ScreenWidth - 169;
        
        _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnRing];
        _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnRing setImage:[UIImage imageNamed:@"userattentionring"] forState:UIControlStateNormal];
        [_btnRing addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = SeparatorLineColor;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _lbRelation, _btnRing, _line, _Address,ImgSex);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-10-[_lbName]->=10-[_btnRing(48)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-10-[_Address]->=10-[_btnRing(48)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photoImage(86)]->=15-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_photoImage(86)]-15-[_line]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbRelation(30)]-1-[_lbName(20)]-2-[_Address]->=10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)btnRingClicked{
    if (![phoneNum isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:phoneNum delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView setTag:11];
        [alertView show];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有设置电话号码！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }
   
}

#pragma alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 11) {
        if (buttonIndex==0) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

- (void) SetContentData:(UserAttentionModel*) data
{
    phoneNum = data.ringNum;
    [_photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholderimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    NSString *relation = data.relation;
    if(relation == nil || [relation length] == 0)
        relation = @"昵称";
    
    _lbRelation.text =relation;
    UserSex sex = [Util GetSexByName:data.sex];
    if(sex == EnumUnknown){

    }
    else if (sex == EnumMale){
        [ImgSex setImage:ThemeImage(@"mail")];
    }
    else{
        [ImgSex setImage:ThemeImage(@"femail")];
    }
     NSString * personH=[NSString stringWithFormat:@"%@",data.height ];
    _lbName.text = [NSString stringWithFormat:@"%@     %@     %@", [data.username isEqual:@""]?@"姓名":data.username,[data.age isEqual:@"0"]?@"年龄":[NSString stringWithFormat:@"%@岁",data.age ], [personH isEqual:@"0"]?@"身高":[NSString stringWithFormat:@"%@米",personH]];
    _Address.text = data.address;
    if(data.address == nil){
        _Address.text = @"地址 ";
    }
}

@end
