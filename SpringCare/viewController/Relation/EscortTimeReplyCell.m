//
//  EscortTimeReplyCell.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeReplyCell.h"
#import "EscortTimeTableCell.h"

@implementation EscortTimeReplyCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        _lbReplyContent = [[TextAndEmojiView alloc]init];
        [self.contentView addSubview:_lbReplyContent];
    
        _lbReplyContent.fontsize = 14.0f;
        _lbReplyContent.fontcolor = _COLOR(0x66, 0x66, 0x66);
        _lbReplyContent.translatesAutoresizingMaskIntoConstraints = NO;
        _lbReplyContent.maxWidth=240;
       
       

        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbReplyContent);
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-0-[_lbReplyContent]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"V:|-2-[_lbReplyContent]-2-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContentWithData:(EscortTimeReplyDataModel*)data
{
    _lbReplyContent.textString = data.publishContent;
}

@end
