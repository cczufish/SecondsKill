
//
//  NSArray+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-12-9.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSArray+V.h"

@implementation NSArray (V)

- (NSArray *)sortWithDescriptorKey:(NSString *)key
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}

@end
