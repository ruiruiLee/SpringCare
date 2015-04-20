//
//  AttentionSelectView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "AttentionSelectView.h"
#import "define.h"
#import "AttentionSelectTableViewCell.h"

@implementation AttentionSelectView
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        attentionArray = [UserAttentionModel GetMyAttentionArray];
        self.backgroundColor = [UIColor whiteColor];
        
        _btnShut = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnShut];
        _btnShut.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnShut setImage:[UIImage imageNamed:@"EscortTimeSelect"] forState:UIControlStateNormal];
        [_btnShut addTarget:self action:@selector(doBtnShutDown:) forControlEvents:UIControlEventTouchUpInside];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.font = _FONT(15);
        _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.text = @"我的关注";
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tableview];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnShut, _lbTitle, _tableview);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_btnShut]->=10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_btnShut]->=10-|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_lbTitle]-5-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_lbTitle(20)]-5-[_tableview]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
        
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attentionArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[AttentionSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;

    }
       UserAttentionModel *model = [attentionArray objectAtIndex:indexPath.row];
    [cell setContentWithModel:model];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(delegate && [delegate respondsToSelector:@selector(ViewSelectWithId:)])
    {
        [delegate ViewSelectWithId:@""];
    }
}

- (void) doBtnShutDown:(UIButton*)sender
{
    if(delegate && [delegate respondsToSelector:@selector(ViewShutDown)])
        [delegate ViewShutDown];
}

@end
