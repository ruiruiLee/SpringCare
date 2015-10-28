//
//  AppListCell.m
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "AppListCell.h"
#import "define.h"
#import "AppDelegate.h"

@implementation AppListCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _appIconArray = [[NSMutableArray alloc] init];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, ScreenWidth - 70, 20)];
        [self.contentView addSubview:_lbTitle];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbTitle.font = _FONT(18);
        _lbTitle.text = @"精品应用";
        
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 40, ScreenWidth - 70, 60)];
        [self.contentView addSubview:_scrollview];
        
        AppDelegate *appdel = [UIApplication sharedApplication].delegate;
        
        NSArray *apparray = appdel.appModel.appArray;
        for (int i = 0; i < [apparray count]; i++) {
            AppInfo *info = [apparray objectAtIndex:i];
            
            AppInfoView *view = [[AppInfoView alloc] initWithFrame:CGRectMake(60 * i, 0, 60, 60)];
            [_scrollview addSubview:view];
            view.lbName.text = info.title;
            [view.logo sd_setImageWithURL:[NSURL URLWithString:info.imgUrl]];
            view.data = info;
            
            [view addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _scrollview.contentSize = CGSizeMake(60 * [apparray count], 60);
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

- (void) doBtnClicked:(AppInfoView*)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(NotifyAPpIconClicked:)]){
        [_delegate NotifyAPpIconClicked:sender];
    }
}

@end
