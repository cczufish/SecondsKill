//
//  VNetworkHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VNetworkHelper.h"

static BOOL hasNetWork;

@implementation VNetworkHelper

SHARD_INSTANCE_IMPL(VNetworkHelper)

- (void)monitorNetwork
{
    hasNetWork = YES;
    
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
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

@end
