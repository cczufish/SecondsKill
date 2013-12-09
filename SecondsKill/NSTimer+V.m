//
//  NSTimer+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-12-2.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSTimer+V.h"

@implementation NSTimer (V)

- (void)pause
{
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}


- (void)resume
{
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate date]];
}

@end
