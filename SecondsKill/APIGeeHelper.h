//
//  APIGeeHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-15.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apigee.h"

@interface APIGeeHelper : NSObject

+ (APIGeeHelper *)shardInstance;

- (void)initialize;

+ (ApigeeClientResponse *)requestByQL:(NSString *)ql;

@end
