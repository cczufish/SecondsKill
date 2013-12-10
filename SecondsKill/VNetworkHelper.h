//
//  VNetworkHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VNetworkHelper : NSObject

+ (VNetworkHelper *)shardInstance;

- (void)monitorNetwork;

+ (BOOL)hasNetWork;

//监测成功表明，成功监测到网络当前状态是可用还是不可用
+ (BOOL)monitorSuccess;

@end
