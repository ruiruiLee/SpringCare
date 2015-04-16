//
//  RootViewController.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/16.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "RootViewController.h"
#import "SliderViewController.h"

@interface RootViewController ()

//@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController
@synthesize nurseVC;
@synthesize homeVC;
@synthesize messageListVC;

//@synthesize modelController = _modelController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
//    self.ContentView.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    
    homeVC = [[HomePageVC alloc] initWithNibName:nil bundle:nil];
    homeVC.tabBarItem.title=@"首页";
    homeVC.tabBarItem.image=[UIImage imageNamed:@"tab-home-selected"];
    [homeVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    nurseVC = [[NurseListMainVC alloc] initWithNibName:nil bundle:nil];
    nurseVC.tabBarItem.title=@"陪护师";
    nurseVC.tabBarItem.image=[UIImage imageNamed:@"tab-nurse"];
    [nurseVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:nurseVC];
    
    messageListVC = [[EscortTimeVC alloc] initWithNibName:nil bundle:nil];
    messageListVC.tabBarItem.title=@"陪护时光";
    [messageListVC.tabBarItem setImage:[UIImage imageNamed:@"tab-lovetime"]];
    [messageListVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:messageListVC];
    
    self.viewControllers=@[nav1, nav2, nav3];
    
    UIColor *normalColor = Disabled_Color;
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

@end
