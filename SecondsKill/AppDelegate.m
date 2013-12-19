//
//  AppDelegate.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "AKTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.0f];
    
    InitializeProject();
    
    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;

    AKTabBarController *akTabbarController = [[AKTabBarController alloc] initWithTabBarHeight:50.0f];
    akTabbarController.viewControllers = (NSMutableArray *) tabBarController.viewControllers;
    akTabbarController.selectedTextColor = [UIColor orangeColor];
    akTabbarController.selectedIconColors = [NSArray arrayWithObjects:[UIColor orangeColor],[UIColor orangeColor], nil];

    MenuViewController *menuVC = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:akTabbarController leftViewController:menuVC];
    revealController.animationDuration = 0.3f;
    
    self.window.rootViewController = revealController;

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableString *version = [NSMutableString stringWithFormat:@"version_ios_%@", appVersion];
    [version replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [version length])];
    
    [APService setTags:[NSSet setWithObjects:version, nil] alias:[APService openUDID] callbackSelector:nil object:self];
    
    //把deviceId放到NSUserDefaults里
    NSString *deviceId = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                          stringByReplacingOccurrencesOfString:@" " withString:@""];//以<>作为分割条件进行分割，并替换空格
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceId forKey:DEVICE_KEY];
    [userDefaults synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//    NSString *sound = [aps valueForKey:@"sound"];
//    
//    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);

    // 处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"秒杀惠" message:content cancelTitle:@"知道了" otherTitle:nil completion:nil];
    [alert setCancelButtonBackgroundColor:[UIColor orangeColor]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"注册推送通知功能失败: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark - 单点登录会用到的相关代理方法

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

@end
