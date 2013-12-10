//
//  NSDictionary+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSDictionary+V.h"
#import "NSString+V.h"

@implementation NSDictionary (V)

- (NSString *)toURLString:(NSString *)baseURL
{
    __block NSMutableArray *params = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [params addObject:[NSString stringWithFormat:@"%@=%@", key, [obj URLParameterSupportEqualSign]]];
    }];
    
    NSString *url = nil;
    
    if (baseURL) {
        url = [NSString stringWithFormat:@"%@?%@", baseURL, [params componentsJoinedByString:@"&"]];
    }
    else {
        url = [params componentsJoinedByString:@"&"];
    }
    
    return url;
}

- (NSString *)toJSONString:(NSError *__autoreleasing*)error
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:error];
    NSString *httpBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return httpBody;
}

@end
