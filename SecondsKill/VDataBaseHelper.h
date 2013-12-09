//
//  VDataBaseHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDataBaseHelper : NSObject

+ (VDataBaseHelper *)shardInstance;

- (void)copyDBToSandbox;

+ (void)insert:(NSObject *)obj;

+ (void)update:(NSObject *)obj;

+ (void)remove:(NSObject *)obj;

+ (NSDictionary *)queryById:(NSString *)itemId from:(NSString *)tableName;

+ (NSMutableArray *)query:(NSString *)sql, ... ;

@end
