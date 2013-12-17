//
//  NSString+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NSString+V.h"

@implementation NSString (V)

- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)URLParameterSupportEqualSignAndCommaSymbol
{
    
    CFStringRef buffer =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)self,
                                            NULL,
                                            (__bridge CFStringRef)@";/?:@&+$",
                                            kCFStringEncodingUTF8);
    
    NSString *result = [NSString stringWithString:(__bridge NSString *)buffer];
    
    CFRelease(buffer);
    
    return result;
}

@end
