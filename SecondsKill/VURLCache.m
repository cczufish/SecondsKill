//
//  VURLCache.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VURLCache.h"

#define kDiskCachePath @"vcache"
#define kCacheDBName @"vcache.sqlite3"

@interface VURLCache ()

@property (nonatomic, copy) NSString *dbDir;
@property (nonatomic, copy) NSString *fileDir;

@end

@implementation VURLCache

SHARD_INSTANCE_IMPL(VURLCache)

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (!cachedResponse) {
        NSData *fileData = [NSData dataWithContentsOfFile:[self cacheFileName:[request URL]]];
        NSHTTPURLResponse *httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[request URL] statusCode:200 HTTPVersion:nil headerFields:[request allHTTPHeaderFields]];

        cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:httpResponse data:fileData];
    }

    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    [super storeCachedResponse:cachedResponse forRequest:request];
    
    NSURL *url = [request URL];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)cachedResponse.response;

    FMDatabase *db = [FMDatabase databaseWithPath:self.dbDir];
    
    if ([db open]) {
        [db beginTransaction];
    
        [db executeUpdate:@"delete from v_cache_base where url=?", [url absoluteString]];
        [db executeUpdate:@"insert into v_cache_base(url,fileName,etag,createtime) values(?,?,?,?)",
            [url absoluteString], [self cacheFileName:url], [[httpResponse allHeaderFields] objectForKey:@"ETag"],[VDateTimeHelper formatDateToString:[NSDate date]]];
        
        [db commit];
    }
    
    [db close];
    
    NSString *contentType = [[httpResponse allHeaderFields] objectForKey:@"Content-Type"];
    
    if ([contentType containsString:@"image"] || [contentType containsString:@"application/json"]) {
        [cachedResponse.data writeToFile:[self cacheFileName:url] atomically:YES];
    }
}

- (NSString *)getETagWithURL:(NSString *)url
{
    NSString *etag = @"";
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbDir];
    
    if ([db open]) {
        //limit 0,1 表示在查出的结果中从下标为0的记录开始，选取1条
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select etag from v_cache_base where url like '%%%@' order by createtime desc limit 0,1", url]];
        if ([rs next]) {
            etag = [rs stringForColumn:@"etag"];
        }
    }
    
    [db close];

    return etag;
}

- (NSString *)cacheFileName:(NSURL *)url
{
    NSMutableString *fileName = [[NSMutableString alloc] initWithString:[url lastPathComponent]];
    NSString *query = [url query];

    if (query) {
        if ([query containsString:@"model"]) {
            NSArray *params = [query componentsSeparatedByString:@"&"];
            for (int i =0; i < [params count]; i++) {
                if ([params[i] containsString:@"model"]) {
                    [fileName appendString:[params[i] componentsSeparatedByString:@"="][1]];
                }
                if ([params[i] containsString:@"page"]) {
                    [fileName appendString:[params[i] componentsSeparatedByString:@"="][1]];
                }
            }
        }
    }
    
    //就通用性考虑还是注释的这段代码好些，因为秒杀应用中每次生成的url都设及当前时间，所以不适用
//    if([url query]) {
//        fileName = [fileName stringByAppendingFormat:@"?%@",[url query]];
//    }
    
    return [self.fileDir stringByAppendingPathComponent:fileName];
}

- (NSString *)diskCacheSize
{
    unsigned long long size = 0;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *fileList = [fileManager subpathsAtPath:self.fileDir];
    
    for (NSString *fileName in fileList) {
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[self.fileDir stringByAppendingPathComponent:fileName] error:nil];
        
        size += [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    }

    return [NSString stringWithFormat:@"%.1lfM", size/(1024.0*1024)];
}

- (void)clearDiskCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager subpathsAtPath:self.fileDir];
    
    for (NSString *fileName in fileList) {
        [fileManager removeItemAtPath:[self.fileDir stringByAppendingPathComponent:fileName] error:nil];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbDir];
    if ([db open]) {
        [db executeUpdate:@"delete from v_cache_base"];
    }
    [db close];
}

- (void)clearDiskCacheWithDay:(NSInteger)day
{
    NSString *date = [VDateTimeHelper formatDateToString:[VDateTimeHelper dateAfterday:-day]];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbDir];
    if ([db open]) {
        [db beginTransaction];

        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select fileName from v_cache_base where createtime < '%@'", date]];
        while ([rs next]) {
            [[NSFileManager defaultManager] removeItemAtPath:[rs stringForColumn:@"fileName"] error:nil];
        }
        
        [db executeUpdate:@"delete from v_cache_base where createtime < ?", date];
        
        [db commit];
    }
    [db close];
}

- (void)createDiskCachePath
{
    NSString *cachePath = NIPathForCachesResource(kDiskCachePath);
    
    self.dbDir = [cachePath stringByAppendingPathComponent:kCacheDBName];
    self.fileDir = [cachePath stringByAppendingPathComponent:@"files"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        [fileManager createDirectoryAtPath:self.fileDir withIntermediateDirectories:YES attributes:nil error:NULL];

        FMDatabase *db = [FMDatabase databaseWithPath:self.dbDir];
        if ([db open]) {
            [db executeUpdate:@"create table if not exists v_cache_base(id integer primary key AUTOINCREMENT, url text, fileName text, etag text, createtime text);"];
        }
        [db close];
    }
}

@end
