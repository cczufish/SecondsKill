//
//  VAlertHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAlertBanner.h"

@interface VAlertHelper : NSObject

+ (void)fail:(NSString *)message;

+ (void)fail:(NSString *)message position:(ALAlertBannerPosition)position;

+ (void)fail:(NSString *)message style:(ALAlertBannerStyle)style;

+ (void)success:(NSString *)message;

+ (void)success:(NSString *)message position:(ALAlertBannerPosition)position;

+ (void)success:(NSString *)message style:(ALAlertBannerStyle)style;

+ (void)alert:(NSString *)message style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position;

@end
