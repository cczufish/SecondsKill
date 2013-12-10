//
//  VCommonHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VCommonHelper.h"
#import "AFNetworkActivityIndicatorManager.h"

#define TENCENT_APPID @"801430933"
#define WEIXIN_APPID @"wxwxcdef309f0d88c12b"

//通过NSUserDefaults中的值判断app是否第一次运行，主要适用于用户在第二次运行程序时。
//而isFirstRunAPP是用于用户第一次运行程序，并且设置完NSUserDefaults后，仍然能够知道此次是第一次运行程序。
BOOL isFirstRun();
BOOL isFirstRunAPP = NO;

void InitializeProject()
{
    if (isFirstRun()) {
        [[VDataBaseHelper shardInstance] copyDBToSandbox];
    }
    
    [[VURLCache shardInstance] createDiskCachePath];
    [[VNetworkHelper shardInstance] monitorNetwork];//时时监测网络状态
    [NSURLCache setSharedURLCache:[VURLCache shardInstance]];
    [[VURLCache shardInstance] clearDiskCacheWithDay:7];

    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:3.0f]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"itemID"}]];//所有json中的id对应类中的itemID属性
    
    if (IS_RUNNING_IOS7) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(0, 1);
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:FONT_NAME size:21.0], NSFontAttributeName, nil]];
        [[UINavigationBar appearance] setBarTintColor:NAV_BACKGROUND_COLOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        //修改状态栏颜色为亮色,前提是在info.plist增加key"View controller-based status bar appearance"并设置值为NO
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //使用友盟统计分析,此方式每次启动app时向服务器发送上次数据。
    [MobClick startWithAppkey:UMENG_APPKEY];
    [UMSocialData setAppKey:UMENG_APPKEY];

    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setQQAppId:TENCENT_APPID url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setSupportSinaSSO:YES];
    [UMSocialConfig setWXAppId:WEIXIN_APPID url:nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
}

NSString *AES256AuthorizationInfo()
{
    NSString *crypt = [NSString stringWithFormat:@"%@:%@", @"13691343119", [AESCrypt encrypt:@"password" password:AES256_KEY]];
    return [AESCrypt encrypt:crypt password:AES256_KEY];
}

#pragma mark - private method

BOOL isFirstRun()
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"runed"]) {
        return NO;
    }
    else {
        [userDefaults setBool:YES forKey:@"runed"];
        [userDefaults synchronize];
        
        isFirstRunAPP = YES;
        
        return YES;
    }
}
