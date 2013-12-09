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
    [[VURLCache shardInstance] createDiskCachePath];
    [[VURLCache shardInstance] clearDiskCacheWithDay:7];
    //把自己数据库里的也清一下
    
    
    
    //使用自己的缓存类
	[NSURLCache setSharedURLCache:[VURLCache shardInstance]];

    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:3.0f]];

    //网络请求时提示
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //所有json中的id对应类中的itemID属性
    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"itemID"}]];
    
    [[VNetworkHelper shardInstance] monitorNetwork];
 

    //时时监测网络状态
    
    
    
    if (IS_RUNNING_IOS7) {
        [[UINavigationBar appearance] setBarTintColor:NAV_BACKGROUND_COLOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        //        UITextAttributeFont – 字体key
        //        UITextAttributeTextColor – 文字颜色key
        //        UITextAttributeTextShadowColor – 文字阴影色key
        //        UITextAttributeTextShadowOffset – 文字阴影偏移量key
        //        如下代码所示，对导航栏的标题风格做了修改：
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:FONT_NAME size:21.0], NSFontAttributeName, nil]];
        
        //修改状态栏颜色为亮色,前提是在info.plist增加key"View controller-based status bar appearance"并设置值为NO
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //使用友盟统计分析,此方式每次启动app时向服务器发送上次数据。
    [MobClick startWithAppkey:UMENG_APPKEY];
    
    [UMSocialData setAppKey:UMENG_APPKEY];
#ifdef DEBUG
    //[UMSocialData openLog:YES];
#endif
    //打开调试log的开关
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    
    
    //打开Qzone的SSO开关
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialConfig setQQAppId:TENCENT_APPID url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
    [UMSocialConfig setWXAppId:WEIXIN_APPID url:nil];
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    //UMSocialWXMessageTypeImage 为纯图片类型
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
    
    
    //新浪微博：@"text/plain"  QQ:@"text/html"
    //如果是第一次运行程序，需要复制数据库到沙盒
    if (isFirstRun()) {
        VDataBaseHelper *dbHelper = [VDataBaseHelper shardInstance];
        [dbHelper copyDBToSandbox];
    }
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
