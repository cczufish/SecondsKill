//
//  VURLCache.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VURLCache : NSURLCache

+ (VURLCache *)shardInstance;

- (void)createDiskCachePath;

- (NSString *)cacheFileName:(NSURL *)url;

- (NSString *)diskCacheSize;

- (void)clearDiskCache;

//清理 N 天前的缓存
- (void)clearDiskCacheWithDay:(NSInteger)day;

- (NSString *)getETagWithURL:(NSString *)url;

@end
