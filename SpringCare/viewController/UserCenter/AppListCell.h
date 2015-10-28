//
//  AppListCell.h
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfoView.h"

@protocol AppListCellDelegate <NSObject>

- (void) NotifyAPpIconClicked:(AppInfoView *)sender;

@end

@interface AppListCell : UITableViewCell

@property (nonatomic , strong) UIScrollView *scrollview;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) NSMutableArray *appIconArray;
@property (nonatomic, weak) id<AppListCellDelegate> delegate;

@end
