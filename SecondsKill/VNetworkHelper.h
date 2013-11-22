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

@end
