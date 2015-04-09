//
//  LCTabBar.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTabBar;

@protocol LCTabBarDelegate <NSObject>

- (void) NotifyItemClickedWithIdx:(NSInteger) idx;

@end

@interface LCTabBar : UIView
{
    NSMutableArray *_btnArray;
    UILabel *_lbLine;
}

@property (nonatomic, assign) id<LCTabBarDelegate> delegate;

- (void) SetItemTitleArray:(NSArray*) array;

@end
