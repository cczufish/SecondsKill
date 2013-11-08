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
//    [MobClick setLogEnabled:YES];//开启调试模式
//    //使用友盟统计分析,此方式每次启动app时向服务器发送上次数据。
//    [MobClick startWithAppkey:UMENG_APPKEY];
    //    [MobClick checkUpdate:@"New version" cancelButtonTitle:@"Skip" otherButtonTitles:@"Goto Store"];

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