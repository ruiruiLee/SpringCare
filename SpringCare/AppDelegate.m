//
//  AppDelegate.m
//  SpringCare
//
//  Created by forrestLee on 3/23/15.
//  Copyright (c) 2015 cmkj. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
//#import "LCRefreshTableVC.h"
//#import "ProjectDefine.h"
#import "LCMenuViewController.h"
#import "SliderViewController.h"
#import "Pingpp.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

//#import "IQKeyboardManager.h"


//#define AVOSCloudAppID  @"26x0xztg3ypms8o4ou42lxgk3gg6hl2rm6z9illft1pkoigh"
//#define AVOSCloudAppKey @"0xjxw6o8kk5jtkoqfi8mbl17fxoymrk29fo7b1u6ankirw31"

#define AVOSCloudAppID  @"mh5gyrc99m482n0bken77doebsr9u3sulj0arpqd172al9ki"
#define AVOSCloudAppKey @"pdmukojziwgkcgus3rusw5wlao3orf7w0iw41470mrac73de"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize sliderViewController;
//@synthesize _observer;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _hospital_product_id=@"";
    _defaultProductId=@"";
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /* 重要! 注册子类 App生命周期内 只需要执行一次即可*/
//    [Student registerSubclass];
    
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = NO;
//    manager.enableAutoToolbar = NO;
    
#if !TARGET_IPHONE_SIMULATOR
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeAlert |
                                                     UIRemoteNotificationTypeSound];
#endif
    
   // [ProjectDefine shareProjectDefine];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [SliderViewController sharedSliderController].LeftVC=[[LCMenuViewController alloc] init];
    [SliderViewController sharedSliderController].RightVC=[[LCMenuViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
   
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [LcationInstance startUpdateLocation];
//    
//            });
            dispatch_async(dispatch_get_main_queue(), ^{
            [LcationInstance startUpdateLocation];
    
            });
   // [LcationInstance startUpdateLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //推送功能打开时, 注册当前的设备, 同时记录用户活跃, 方便进行有针对的推送
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    //可选 但是很重要. 我们可以在任何地方给currentInstallation设置任意值,方便进行有针对的推送
    //比如如果我们知道用户的年龄了,可以加上下面这一行 这样推送时我们可以选择age>20岁的用户进行通知
    //[currentInstallation setObject:@"28" forKey:@"age"];
    
    //我们当然也可以设置根据地理位置提醒 发挥想象力吧!
    
    
    //当然别忘了任何currentInstallation的变更后做保存
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //可选 通过统计功能追踪通过提醒打开应用的行为
    [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    
    //这儿你可以加入自己的代码 根据推送的数据进行相应处理
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        NSString *msg;
        if (error == nil) {
            NSLog(@"PingppError is nil");
            msg = result;
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
            msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
        }
        UIAlertView *mAlert =  [[UIAlertView alloc] initWithTitle:@"信息提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [mAlert show];

    }];
    return  YES;
}
@end
