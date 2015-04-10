//
//  EditUserTableviewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EditUserTableviewCell.h"
#import "define.h"

@implementation EditUserTableviewCell
@synthesize tfEdit = _tfEdit;
@synthesize cellType;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews
{
    _lbTite = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTite];
    _lbTite.font = _FONT(16);
    _lbTite.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbTite.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tfEdit = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_tfEdit];
    _tfEdit.font = _FONT(16);
    _tfEdit.textColor = _COLOR(0x99, 0x99, 0x99);
    _tfEdit.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imgUnflod = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgUnflod];
    _imgUnflod.translatesAutoresizingMaskIntoConstraints = NO;
    _imgUnflod.image = [UIImage imageNamed:@"usercentershut"];
    
    _lbLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbLine];
    _lbLine.translatesAutoresizingMaskIntoConstraints = NO;
    _lbLine.backgroundColor = SeparatorLineColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbTite, _tfEdit, _imgUnflod, _lbLine);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(100)]-30-[_tfEdit]-30-[_imgUnflod(12)]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-19-[_lbTite]-19-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_tfEdit]-5-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_imgUnflod(16)]-17-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=17-[_lbLine(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbLine]-0-|" options:0 metrics:nil views:views]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) SetcontentData:(EditCellTypeData*) celldata info:(NSDictionary*) info
{
    _lbTite.text = celldata.cellTitleName;
    [_tfEdit setEnabled:YES];
    _imgUnflod.hidden = NO;
    cellType = celldata.cellType;
    
    if(celldata.cellType == EnumTypeAccount){
        [_tfEdit setEnabled:NO];
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeUserName){
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeSex){
        [_tfEdit setEnabled:NO];
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeAge){
        [_tfEdit setEnabled:NO];
    }
    else if (celldata.cellType == EnumTypeAddress){
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeMobile){
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeRelationName){
        _imgUnflod.hidden = YES;
    }
    else if (celldata.cellType == EnumTypeHeight){
        _imgUnflod.hidden = YES;
    }
    _imgUnflod.hidden = YES;
}

@end
