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
    homeVC.tabBarItem.image=[UIImage imageNamed:@"image-1"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    nurseVC = [[NurseListMainVC alloc] initWithNibName:nil bundle:nil];
    nurseVC.tabBarItem.title=@"护工";
    nurseVC.tabBarItem.image=[UIImage imageNamed:@"image-1"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:nurseVC];
    
    messageListVC = [[MessageInfoListVC alloc] initWithNibName:nil bundle:nil];
    messageListVC.tabBarItem.title=@"陪护时光";
    messageListVC.tabBarItem.image=[UIImage imageNamed:@"image-1"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:messageListVC];
    
    self.viewControllers=@[nav1, nav2, nav3];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor greenColor], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor redColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
    
    UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    [tabBarBgView setImage:[UIImage imageNamed:@"navBg"]];
    [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
    [self.tabBar insertSubview:tabBarBgView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (ModelController *)modelController {
//    // Return the model controller object, creating it if necessary.
//    // In more complex implementations, the model controller may be passed to the view controller.
//    if (!_modelController) {
//        _modelController = [[ModelController alloc] init];
//    }
//    return _modelController;
//}

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
