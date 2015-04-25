//
//  UserAttentionTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionTableCell.h"
#import "define.h"
#import "UIButton+WebCache.h"
#import "UserAttentionVC.h"

@implementation UserAttentionTableCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _btnphotoImg = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnphotoImg.layer.masksToBounds = YES;
        [self.contentView addSubview:_btnphotoImg];
        _btnphotoImg.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnphotoImg addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _attentionLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_attentionLogo];
        _attentionLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _attentionLogo.image = ThemeImage(@"relevancelogo");

        _lbRelation =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbRelation];
        _lbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _lbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        
        ImgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:ImgSex];
        ImgSex.translatesAutoresizingMaskIntoConstraints = NO;

        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        
        _Address = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_Address];
        _Address.translatesAutoresizingMaskIntoConstraints = NO;
        _Address.textColor = _COLOR(0x99, 0x99, 0x99);
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
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnphotoImg, _lbName, _lbRelation, _btnRing, _line, _Address,ImgSex, _attentionLogo);
        
        EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
        if(type == EnumValueTypeiPhone4S){
            [self InitConstraintsForiPhone5:views];
        }
        else if (type == EnumValueTypeiPhone5){
            [self InitConstraintsForiPhone5:views];
        }
        else if (type == EnumValueTypeiPhone6){
            [self InitConstraintsForiPhone6:views];
        }
        else if (type == EnumValueTypeiPhone6P){
            [self InitConstraintsForiPhone6P:views];
        }else{
            [self InitConstraintsForiPhone5:views];
        }
    }
    return self;
}

- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
    _btnphotoImg.layer.cornerRadius = 31;
    _lbRelation.font = _FONT_B(18);
    _lbName.font = _FONT(14);
    _Address.font = _FONT(14);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnRing(42)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_lbName]->=10-[_btnRing(42)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_Address]->=10-[_btnRing(42)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(62)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(62)]-15-[_line]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbRelation(30)]-1-[_lbName(20)]-2-[_Address]->=10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    _btnphotoImg.layer.cornerRadius = 36;
    _lbRelation.font = _FONT_B(20);
    _lbName.font = _FONT(15);
    _Address.font = _FONT(15);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnRing(48)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_lbName]->=10-[_btnRing(48)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_Address]->=10-[_btnRing(48)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(72)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(72)]-15-[_line]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbRelation(30)]-1-[_lbName(20)]-2-[_Address]->=10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _btnphotoImg.layer.cornerRadius = 41;
    _lbRelation.font = _FONT_B(22);
    _lbName.font = _FONT(16);
    _Address.font = _FONT(16);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnRing(54)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_lbName]->=10-[_btnRing(54)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_Address]->=10-[_btnRing(54)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(82)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(82)]-15-[_line]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbRelation(30)]-1-[_lbName(20)]-2-[_Address]->=10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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


#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [Util openPhotoLibrary:_parentController allowEdit:YES completion:^{
            self.parentController.currentCell=self;
        }];
    }else if (buttonIndex == 1)
    {
        [Util openCamera:_parentController allowEdit:YES completion:^{
            self.parentController.currentCell=self;
        }];
        
    }
    else{
        
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

#pragma ACTION
- (void) btnPhotoPressed:(UIButton*)sender{
    NSLog(@"%@",[self class ]);
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                    delegate:(id)self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"从相册选取"
                                           otherButtonTitles:@"拍照",nil];
    ac.actionSheetStyle = UIBarStyleBlackTranslucent;
    [ac showInView:self];
    
}



- (void) SetContentData:(UserAttentionModel*) data
{
    _model=data;
    phoneNum = data.ringNum;
    [_btnphotoImg sd_setImageWithURL:[NSURL URLWithString:data.photoUrl] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];

    if(data.isCare){
        _attentionLogo.hidden = NO;
    }else{
        _attentionLogo.hidden = YES;
    }
    
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
    _lbName.text = [NSString stringWithFormat:@"%@     %@     %@", [data.username isEqual:@""]?@"姓名":data.username,[data.age isEqual:@"0"]?@"年龄":[NSString stringWithFormat:@"%@岁",data.age ], !data.height?@"身高":[NSString stringWithFormat:@"%@cm",data.height]];
    _Address.text = data.address;
    if(data.address == nil){
        _Address.text = @"地址 ";
    }
}

@end
