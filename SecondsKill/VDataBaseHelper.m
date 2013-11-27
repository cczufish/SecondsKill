//
//  VDataBaseHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VDataBaseHelper.h"

#define DB_NAME @"secondskill.sqlite3"

@implementation VDataBaseHelper

SHARD_INSTANCE_IMPL(VDataBaseHelper)

- (void)copyDBToSandbox
{
    NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:nil];
    NSString *dbSandboxPath = NIPathForDocumentsResource(DB_NAME);
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbSandboxPath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:dbBundlePath toPath:dbSandboxPath error:nil];
    }
}

- (void)batchDeleteAndInsert:(NSString *)tableName
                       datas:(NSArray *)datas
{
    NSString *dbPath = NIPathForDocumentsResource(DB_NAME);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if ([db open]) {
        [db beginTransaction];
        
        [db executeUpdate:@"delete from ?", tableName];
        
        //根据json格式的data数据insert相关表
        
        [db commit];
    }
    
    [db close];
}

@end
