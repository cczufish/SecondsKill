//
//  NSDictionary+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSDictionary+V.h"

@implementation NSDictionary (V)

- (NSString *)toString
{
    __block NSMutableArray *params = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [params addObject:[NSString stringWithFormat:@"%@=%@", key, [obj stringByAddingPercentEscapesForURLParameter]]];
    }];
    return [params componentsJoinedByString:@"&"];
}

@end
