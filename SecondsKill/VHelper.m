//
//  VHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-4.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VHelper.h"

BOOL isFirstRunAPP = NO;

NSURL *GenerateURL(NSString *baseURL, NSDictionary *params)
{
    __block NSMutableString *url = [NSMutableString stringWithString:baseURL];
    if (params) {
        __block BOOL isFirstParam = YES;
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (isFirstParam) {
                [url appendFormat:@"?%@=%@", key, obj];
                isFirstParam = NO;
            }
            else {
                [url appendFormat:@"&%@=%@", key, obj];
            };
        }];
    }
    return [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

NSString *PathForDocuments(NSString *fileName)
{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

BOOL isFirstRun()
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"runed"]) {
        return NO;
    }
    else {
        isFirstRunAPP = YES;
        [userDefaults setBool:YES forKey:@"runed"];
        [userDefaults synchronize];
        return YES;
    }
}

void InitProject()
{
    //使用友盟统计分析,此方式每次启动app时向服务器发送上次数据。
    [MobClick startWithAppkey:UMENG_APPKEY];
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    
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

    //网络请求时提示
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //新浪微博：@"text/plain"  QQ:@"text/html"
    
    
//    //时时检测网络状态
//    [[CLNetworkHelper shardInstance] monitorNetwork];
//    
//    //如果是第一次运行程序，需要复制数据库到沙盒
//    if (isFirstRun()) {
//        CLDataBaseHelper *dbHelper = [CLDataBaseHelper shardInstance];
//        [dbHelper copyDBToSandbox];
//    }
}