//
//  MainBaseVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/2.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "define.h"
#import "LCNavigationbar.h"

@interface MainBaseVC : UIViewController<LCNavigationbarDelegate>


@property (nonatomic, strong) UIView *ContentView;
@property (nonatomic, strong) LCNavigationbar *NavigationBar;

@property (nonatomic, strong, readonly) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;

- (void) LeftButtonClicked:(id)sender;
- (void) RightButtonClicked:(id)sender;

@end
