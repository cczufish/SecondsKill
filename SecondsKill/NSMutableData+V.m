//
//  NSMutableData+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSMutableData+V.h"

@implementation NSMutableData (V)

- (void)appendUTF8String:(NSString *)string
{
    [self appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
