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
@synthesize delegate;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_backgroundView];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        
        _btnphotoImg = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnphotoImg.layer.masksToBounds = YES;
        [_backgroundView addSubview:_btnphotoImg];
        _btnphotoImg.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnphotoImg addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _attentionLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_attentionLogo];
        _attentionLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _attentionLogo.image = ThemeImage(@"relevancelogo");

        _lbRelation =[[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_lbRelation];
        _lbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _lbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbRelation.backgroundColor = [UIColor clearColor];
        
        ImgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:ImgSex];
        ImgSex.translatesAutoresizingMaskIntoConstraints = NO;

        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.backgroundColor = [UIColor clearColor];
        
        _Address = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_Address];
        _Address.translatesAutoresizingMaskIntoConstraints = NO;
        _Address.textColor = _COLOR(0x99, 0x99, 0x99);
        _Address.numberOfLines = 0;
        _Address.backgroundColor = [UIColor clearColor];
        
        _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_btnRing];
        _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnRing setImage:[UIImage imageNamed:@"userattentionring"] forState:UIControlStateNormal];
        [_btnRing addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _sview1 = [[UIView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_sview1];
        _sview1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _sview2 = [[UIView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_sview2];
        _sview2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _btnHealthRecord = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_btnHealthRecord];
        _btnHealthRecord.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnHealthRecord setImage:ThemeImage(@"healthrecord") forState:UIControlStateNormal];
        [_btnHealthRecord addTarget:self action:@selector(healthRecordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnphotoImg, _lbName, _lbRelation, _btnRing, _Address,ImgSex, _attentionLogo, _sview2, _sview1, _btnHealthRecord, _backgroundView);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_backgroundView]-5-|" options:0 metrics:nil views:views]];
        
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
    _Address.preferredMaxLayoutWidth = ScreenWidth - 150;
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_sview1]->=6-[_btnRing(42)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_sview2]->=6-[_btnRing(42)]-15-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnRing(42)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_lbName]->=4-[_btnRing(42)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_Address]->=6-[_btnRing(42)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_btnphotoImg(62)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-18-[_lbRelation]-25-[ImgSex]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sview1(>=10)]-0-[_lbRelation]-1-[_lbName]-4-[_Address]-0-[_sview2(>=10)]-0-[_btnHealthRecord]-10-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_sview1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_sview2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=15-[_btnHealthRecord]-15-|" options:0 metrics:nil views:views]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    _btnphotoImg.layer.cornerRadius = 36;
    _lbRelation.font = _FONT_B(20);
    _lbName.font = _FONT(15);
    _Address.font = _FONT(15);
    _Address.preferredMaxLayoutWidth = ScreenWidth - 166;
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_sview2]->=6-[_btnRing(48)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_sview1]->=6-[_btnRing(48)]-15-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_btnRing(48)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_lbName]->=4-[_btnRing(48)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_Address]->=6-[_btnRing(48)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(72)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sview1(>=10)]-0-[_lbRelation]-1-[_lbName]-4-[_Address]-0-[_btnHealthRecord]-0-[_sview2(>=10)]-10-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_sview1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_sview2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=15-[_btnHealthRecord]-15-|" options:0 metrics:nil views:views]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _btnphotoImg.layer.cornerRadius = 41;
    _lbRelation.font = _FONT_B(22);
    _lbName.font = _FONT(16);
    _Address.font = _FONT(16);
    _Address.preferredMaxLayoutWidth = ScreenWidth - 182;
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_sview2]->=6-[_btnRing(54)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_sview1]->=6-[_btnRing(54)]-15-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_btnRing(54)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_lbName]->=10-[_btnRing(54)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_Address]->=6-[_btnRing(54)]-15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_btnphotoImg(82)]->=10-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sview1(>=10)]-0-[_lbRelation]-1-[_lbName]-4-[_Address]-0-[_sview2(>=10)]-0-[_btnHealthRecord]-10-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_attentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnphotoImg attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_sview1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_sview2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=15-[_btnHealthRecord]-15-|" options:0 metrics:nil views:views]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)btnRingClicked{
    if (![phoneNum isEqual:@""] && phoneNum != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:phoneNum delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView setTag:11];
        [alertView show];
    }
    else{
       [Util showAlertMessage:@"您没有设置电话号码！" ];
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
    _model = data;
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
    _lbName.text = [NSString stringWithFormat:@"%@     %@     %@", [data.username isEqual:@""]?@"姓名":data.username,[data.age isEqual:@""]?@"年龄":[NSString stringWithFormat:@"%@岁",data.age ], data.height<=0?@"身高":[NSString stringWithFormat:@"%dcm",data.height]];
    _Address.text = data.address;
    if(data.address == nil){
        _Address.text = @"地址 ";
    }
}

- (void) healthRecordBtnClicked:(UIButton *)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyHealthRecordButtonClickedWithModel:)]){
        [delegate NotifyHealthRecordButtonClickedWithModel:self.model];
    }
}

@end
