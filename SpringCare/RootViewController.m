//
//  RootViewController.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/16.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "RootViewController.h"
#import "SliderViewController.h"
#import "define.h"
#import "LoginVC.h"
#import "MPNotificationView.h"
@interface RootViewController ()

//@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController
@synthesize nurseVC;
@synthesize homeVC;
@synthesize messageListVC;

//@synthesize modelController = _modelController;

-(id)init{
    self = [super init];
    if (self) {
        // 设置弹出消息观察者
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tapReceivedNotificationHandler:)
                                                     name:kMPNotificationViewTapReceivedNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.ContentView.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    
    homeVC = [[HomePageVC alloc] initWithNibName:nil bundle:nil];
    homeVC.tabBarItem.title=@"首页";
    homeVC.tabBarItem.tag = 1000;
    homeVC.tabBarItem.image=[UIImage imageNamed:@"tab-home-selected"];
    [homeVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    nurseVC = [[NurseListMainVC alloc] initWithNibName:nil bundle:nil];
    nurseVC.tabBarItem.title=@"陪护师";
    nurseVC.tabBarItem.tag = 1001;
    nurseVC.tabBarItem.image=[UIImage imageNamed:@"tab-nurse"];
    [nurseVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:nurseVC];
    
    messageListVC = [[EscortTimeVC alloc] initWithNibName:nil bundle:nil];
    messageListVC.tabBarItem.title=@"陪护时光";
    messageListVC.tabBarItem.tag = 1002;
    [messageListVC.tabBarItem setImage:[UIImage imageNamed:@"tab-lovetime"]];
    [messageListVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:messageListVC];
    
    self.viewControllers=@[nav1, nav2, nav3];
    
    UIColor *normalColor = Disabled_Color;
    if(!_IPHONE_OS_VERSION_UNDER_7_0){
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           normalColor, UITextAttributeTextColor,
                                                        nil] forState:UIControlStateNormal];
        UIColor *titleHighlightedColor = Abled_Color;
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           titleHighlightedColor, UITextAttributeTextColor,
                                                        nil] forState:UIControlStateSelected];
        [[UITabBar appearance] setTintColor:Abled_Color];//UITextAttributeFont
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           _FONT(12), UITextAttributeFont,
                                                           nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           _FONT(12), UITextAttributeFont,
                                                           nil] forState:UIControlStateSelected];
        UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
        tabBarBgView.backgroundColor = _COLOR(0xe5, 0xe4, 0xe5);
        [self.tabBar insertSubview:tabBarBgView atIndex:0];
    }
    else{
        self.tabBar.backgroundImage = [Util imageWithColor:_COLOR(0xe5, 0xe4, 0xe5) size:CGSizeMake(ScreenWidth, 49)];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           normalColor, UITextAttributeTextColor,
                                                           nil] forState:UIControlStateNormal];
        UIColor *titleHighlightedColor = Abled_Color;
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           titleHighlightedColor, UITextAttributeTextColor,
                                                           nil] forState:UIControlStateHighlighted];
        [[UITabBar appearance] setTintColor:Disabled_Color];
        [[UITabBar appearance] setSelectedImageTintColor:Abled_Color];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           _FONT(12), UITextAttributeFont,
                                                           nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           _FONT(12), UITextAttributeFont,
                                                           nil] forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1002){
        if(![UserModel sharedUserInfo].isLogin){
            LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [messageListVC.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }else if(item.tag == 1001){
        [nurseVC LoadDataList];
//        [nurseVC performSelector:@selector(LoadDataList) withObject:nil afterDelay:0.2];
    }
}

//弹出消息回调
- (void)tapReceivedNotificationHandler:(NSNotification *)notice
{
    MPNotificationView *notificationView = (MPNotificationView *)notice.object;
    [self pushtoController:[[notificationView.msgInfo objectForKey:@"mt"] intValue] PushType:PushFromBcakground];
}

-(void) pushtoController:(id)dic{

    [MPNotificationView notifyWithText:@"信息提示"
                                detail:[[dic objectForKey:@"aps"] objectForKey:@"alert"]
                                 image:ThemeImage(@"icontitle")
                           andDuration:4.0
                             msgparams:dic];
    

}
-(void) pushtoController:(NSInteger)mt PushType:(PushType)curentPushtype{
      switch (mt) {
        case 1:   // 订单
        {
           MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
            if (curentPushtype==PushFromBcakground) {
                if ([[SliderViewController sharedSliderController].MainVC isKindOfClass: [MyOrderListVC class]]) {
                    [vc pullTableViewDidTriggerRefresh:nil];
                }
                else{
                   [self.navigationController pushViewController:vc animated:YES];
                }
             }
            else{
                  // [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
                 [self.navigationController pushViewController:vc animated:YES];
              }
         
            break;
        }
        case 2:   // 陪护时光
        {
           if (curentPushtype==PushFromBcakground) {
                self.selectedIndex=2;
             //  EscortTimeVC *vc = [[EscortTimeVC alloc] initWithNibName:nil bundle:nil];
             //  [vc pullTableViewDidTriggerRefresh:nil];
             }
            else{
                self.selectedIndex=2;
            }
            break;

        }
        case 3:  // 关注
        {
             UserAttentionVC *vc = [[UserAttentionVC alloc] initWithNibName:nil bundle:nil];
          if (curentPushtype==PushFromBcakground) {
                if ([[SliderViewController sharedSliderController].MainVC isKindOfClass: [UserAttentionVC class]]) {
                    [vc refreshTable];
                }
                else{
                    [self.navigationController pushViewController:vc animated:YES];
                  }
            }
            else{
                 [self.navigationController pushViewController:vc animated:YES];
            }
            break;

        }
        default:
            break;
            
    }
}
@end
