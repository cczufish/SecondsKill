//
//  VNetworkHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VNetworkHelper.h"

#define kMonitorNetworkSuccessNotification @"monitorNetworkSuccessNotification"

static BOOL hasNetWork;
static BOOL monitorSuccess;

//防止重复注册通知
static id networkObserver;

@implementation VNetworkHelper

SHARD_INSTANCE_IMPL(VNetworkHelper)

- (void)monitorNetwork
{
    [[NSNotificationCenter defaultCenter] removeObserver:networkObserver];
    
    networkObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMonitorNetworkSuccessNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        monitorSuccess = YES;
    }];
    
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        static dispatch_once_t pred = 0;

        dispatch_once(&pred, ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kMonitorNetworkSuccessNotification object:self userInfo:nil];
        });

        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            hasNetWork = YES;
        }
        else {
            hasNetWork = NO;
        }
    }];
    
    [networkManager startMonitoring];
}

+ (BOOL)hasNetWork
{
    return hasNetWork;
}

+ (BOOL)monitorSuccess
{
    return monitorSuccess;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:networkObserver];
}

@end
