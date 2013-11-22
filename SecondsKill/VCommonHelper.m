//
//  VCommonHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VCommonHelper.h"

#import "AFNetworkActivityIndicatorManager.h"
#define kAES256Key @"citylife20130609trackup"

BOOL isFirstRunAPP = NO;
NSString* URLencode(NSString *originalString, NSStringEncoding stringEncoding)
{
    //!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
    //%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [[originalString
                              stringByAddingPercentEscapesUsingEncoding:stringEncoding]
                             mutableCopy];
    
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString: temp];
    
    return outStr;
}
NSString *AES256AuthorizationInfo()
{
    //授权用的“手机号“和“用户密码“暂时写死，未来考虑从"NSUserDefault"或"KeyChain"中获取。
    NSString *crypt = [NSString stringWithFormat:@"%@:%@", @"111111", [AESCrypt encrypt:@"password" password:kAES256Key]];
    
    return [AESCrypt encrypt:crypt password:kAES256Key];
}

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
    [[VNetworkHelper shardInstance] monitorNetwork];
    
    
    if (REUIKitIsFlatMode()) {
        [[UINavigationBar appearance] setBarTintColor:RGB(199, 55, 33)];// only ios7
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
    
    
    //    APIGeeHelper *apigeeHelper = [APIGeeHelper shardInstance];
    //    [apigeeHelper initialize];
    //
    
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