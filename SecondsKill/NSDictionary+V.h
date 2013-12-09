//
//  NSDictionary+V.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (V)

- (NSString *)toURLString:(NSString *)baseURL;

- (NSString *)toJSONString:(NSError *__autoreleasing*)error;

@end
