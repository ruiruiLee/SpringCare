//
//  AppDelegate.m
//  SpringCare
//
//  Created by forrestLee on 3/23/15.
//  Copyright (c) 2015 cmkj. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LCMenuViewController.h"
#import "SliderViewController.h"
#import "Pingpp.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>


/*
  测试
 */
#define AVOSCloudAppID  @"26x0xztg3ypms8o4ou42lxgk3gg6hl2rm6z9illft1pkoigh"
#define AVOSCloudAppKey @"0xjxw6o8kk5jtkoqfi8mbl17fxoymrk29fo7b1u6ankirw31"

/*
 正式
 */
//#define AVOSCloudAppID  @"mh5gyrc99m482n0bken77doebsr9u3sulj0arpqd172al9ki"
//#define AVOSCloudAppKey @"pdmukojziwgkcgus3rusw5wlao3orf7w0iw41470mrac73de"

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
    //[AVOSCloudCrashReporting enable];
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [SliderViewController sharedSliderController].LeftVC=[[LCMenuViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    self.window.rootViewController = nav;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
       // 第一次安装时运行打开推送
#if !TARGET_IPHONE_SIMULATOR
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                    | UIUserNotificationTypeBadge
                                                    | UIUserNotificationTypeSound
                                                       categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
        else{
            [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound];
        }
#endif       
        // 引导界面展示
        // [_rootTabController showIntroWithCrossDissolve];
        
    }

    //判断程序是不是由推送服务完成的
    if (launchOptions)
    {
        
        NSDictionary* notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notificationPayload)
        {
            [self performSelector:@selector(pushDetailPage:) withObject:notificationPayload afterDelay:1.0];
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
     [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [self.window makeKeyAndVisible];
    
    self.appModel = [[AppInfoObject alloc] init];
    [self.appModel LoadAppInfo];
    
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

     [self performSelector:@selector(openlocation) withObject:nil afterDelay:1.0f];
}
- (void)openlocation{
    [LcationInstance startUpdateLocation];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AVUser logOut];  //清除缓存用户对象
    [UserModel sharedUserInfo].userId = nil;
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    //[currentInstallation addUniqueObject:@"springCare" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"registerUser" forKey:@"channels"];
    [currentInstallation saveInBackground];
  
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

//推送跳转到指定页面

//推送跳转到指定页面
-(void) pushDetailPage: (id)dic
{
    [self pushDetailPage:dic PushType:PushFromTerminate];
}

-(void) pushDetailPage: (id)dic PushType:(PushType)myPushtype
{
    [(RootViewController*)[SliderViewController sharedSliderController].MainVC pushtoController:[[dic objectForKey:@"mt"] intValue] PushType:myPushtype];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // 程序在运行中接收到推送
    if (application.applicationState == UIApplicationStateActive)
    {
        [(RootViewController*)[SliderViewController sharedSliderController].MainVC pushtoController:userInfo];
    }
    else  //程序在后台中接收到推送
    {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
        [self pushDetailPage:userInfo PushType:PushFromBcakground];
    }

}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        NSString *msg;
       // if (error == nil) {
            if ([result isEqual:@"success"]) {
                msg = @"支付成功！";
            }
            else if([result isEqual:@"cancel"]) {
                 msg = @"支付已经取消！";
            }
            else if([result isEqual:@"fail"]) {
                 msg = @"支付失败，请稍后再试！";
            }
            else if([result isEqual:@"invalid"]) {
                 msg = @"支付无效，请稍后再试！";
            }
            else{
                msg = result;
            }
            
//        } else {
//            msg = [error getMsg];
         if (error != nil)
              NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, msg);
//            //msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
//        }
        [Util showAlertMessage:msg];
        [[SliderViewController sharedSliderController].navigationController popViewControllerAnimated:YES];
       
    }];
    return  YES;
}

- (void) setCurrentCityModel:(CityDataModel *)Model
{
    if(Model.city_id != _currentCityModel.city_id){
        
        _currentCityModel = Model;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_SelectCity_Change object:nil];
    }
    else{
        _currentCityModel = Model;
    }
}

@end
