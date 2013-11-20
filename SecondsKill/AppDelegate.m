//
//  AppDelegate.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    InitProject();

    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;

    AKTabBarController *akTabbarController = [[AKTabBarController alloc] initWithTabBarHeight:50.0f];
    akTabbarController.viewControllers = (NSMutableArray *) tabBarController.viewControllers;
    akTabbarController.selectedTextColor = [UIColor orangeColor];
    akTabbarController.selectedIconColors = [NSArray arrayWithObjects:[UIColor orangeColor],[UIColor orangeColor], nil];

    MenuViewController *menuVC = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:akTabbarController leftViewController:menuVC];
    revealController.animationDuration = 0.3f;
    
    self.window.rootViewController = revealController;
    
    // 注册APNS类型
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // 初始化
    [APService setupWithOption:launchOptions];
 
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 向服务器上报Device Token
    [APService registerDeviceToken:deviceToken];

    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableString *version = [NSMutableString stringWithFormat:@"version_ios_%@", appVersion];
    [version replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [version length])];
    
    [APService setTags:[NSSet setWithObjects:version, nil] alias:[APService openUDID] callbackSelector:nil object:self];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);

    // 处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
