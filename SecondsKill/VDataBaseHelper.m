//
//  VDataBaseHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VDataBaseHelper.h"

#define kIdName @"itemID"
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

+ (void)insert:(NSObject *)obj
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    NSMutableArray *columns = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];

    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];

        if ([obj valueForKey:propertyName]) {
            [columns addObject:propertyName];
            [placeholder addObject:@"?"];
            [values addObject:[obj valueForKey:propertyName]];
        }
    }
    free(properties);
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", [obj tableName], [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
    
    FMDatabase *db = [FMDatabase databaseWithPath:NIPathForDocumentsResource(DB_NAME)];
    
    if ([db open]) {
        [db executeUpdate:sql withArgumentsInArray:values];
    }
    
    [db close];
}

+ (void)update:(NSObject *)obj
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    NSMutableArray *settings = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];

    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        if ([obj valueForKey:propertyName]) {
            [settings addObject:[NSString stringWithFormat:@"%@=?", propertyName]];
            [values addObject:[obj valueForKey:propertyName]];
        }
    }
    [values addObject:[obj valueForKey:kIdName]];
    
    free(properties);
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@=?", [obj tableName], [settings componentsJoinedByString:@","], kIdName];
    FMDatabase *db = [FMDatabase databaseWithPath:NIPathForDocumentsResource(DB_NAME)];

    if ([db open]) {
        [db executeUpdate:sql withArgumentsInArray:values];
    }
    
    [db close];
}

+ (void)remove:(NSObject *)obj
{
    FMDatabase *db = [FMDatabase databaseWithPath:NIPathForDocumentsResource(DB_NAME)];
    
    if ([db open]) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?", [obj tableName], kIdName], [obj valueForKey:kIdName]];
    }
    
    [db close];
}

+ (NSDictionary *)queryById:(NSString *)itemId from:(NSString *)tableName
{
    NSDictionary *result = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:NIPathForDocumentsResource(DB_NAME)];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=?", tableName, kIdName], itemId];
        if ([rs next]) {
            result = [rs resultDictionary];
        }
    }
    
    [db close];
    
    return result;
}

+ (NSMutableArray *)query:(NSString *)sql, ...
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:100];
    
    va_list args;
    va_start(args, sql);
    
    NSString *querySQL = [[NSString alloc] initWithFormat:sql arguments:args];
    va_end(args);
    
    FMDatabase *db = [FMDatabase databaseWithPath:NIPathForDocumentsResource(DB_NAME)];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:querySQL];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
    }
    
    [db close];

    return result;
}

@end

