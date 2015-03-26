//
//  MenuTableViewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "define.h"

@implementation MenuTableViewCell

@synthesize indexPath;
@synthesize lbContent;
@synthesize imgIcon;
@synthesize imgUnflod;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbContent];
        lbContent.translatesAutoresizingMaskIntoConstraints = NO;
        lbContent.backgroundColor = [UIColor clearColor];
        lbContent.backgroundColor = [UIColor greenColor];
        
        imgIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgIcon];
        imgIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        imgUnflod = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgUnflod];
        imgUnflod.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(lbContent, imgUnflod, imgIcon);
        NSString *format = [NSString stringWithFormat:@"H:|-20-[imgIcon]-10-[lbContent]->=10-[imgUnflod]-%f-|", ScreenWidth + 10 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lbContent attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imgIcon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgUnflod attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imgIcon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//    NSLog(@"set cell %ld Selected: %d", indexPath.row, selected);
//    if (selected) {
//        lbContent.textColor = [UIColor whiteColor];
//    }
//    else {
//        lbContent.textColor = [UIColor blackColor];
//    }
//}
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    
//    NSLog(@"set cell %ld highlighted: %d", indexPath.row, highlighted);
//    if (highlighted) {
//        lbContent.textColor = [UIColor whiteColor];
//    }
//    else {
//        lbContent.textColor = [UIColor blackColor];
//    }
//}

- (void)setContentTitle:(NSString*)content
{
    lbContent.text = content;
}


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}

@end
