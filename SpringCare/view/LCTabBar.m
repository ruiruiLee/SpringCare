//
//  LCTabBar.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCTabBar.h"
#import "define.h"

@implementation LCTabBar
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _btnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) SetItemTitleArray:(NSArray*) array
{
    for (id obj in [self subviews]) {
        [((UIView*)obj) removeFromSuperview];
    }
    [_btnArray removeAllObjects];
    
    [_lbLine removeFromSuperview];
    
    CGFloat len = ScreenWidth / [array count];
    
    for (int i = 0; i < [array count]; i++) {
        NSString *title = [array objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(len * i, 0, len, self.frame.size.height)];
        [self addSubview:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        [btn setTitleColor:_COLOR(0x10, 0x9d, 0x59) forState:UIControlStateSelected];
        [_btnArray addObject:btn];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(DoBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _lbLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, len, 2)];
    [self addSubview:_lbLine];
    _lbLine.backgroundColor = Abled_Color;
    
    UIButton *btn = (UIButton*)[self viewWithTag:100];
    [self DoBtnItemClicked:btn];
}

- (void) DoBtnItemClicked:(UIButton*)sender
{
    if(sender.selected == YES)
        return;
    
    for (int  i = 0; i < [_btnArray count]; i ++) {
        UIButton *btn = [_btnArray objectAtIndex:i];
        btn.selected = NO;
    }
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyItemClickedWithIdx:)])
    {
        [delegate NotifyItemClickedWithIdx:sender.tag - 100];
    }
    sender.selected = YES;
    CGRect frame = _lbLine.frame;
    NSInteger idx = sender.tag - 100;
    __weak UILabel *weakLine = _lbLine;
    [UIView animateWithDuration:0.2f animations:^{
        weakLine.frame = CGRectMake(frame.size.width * idx, frame.origin.y, frame.size.width, 1);
    }];
}



@end
