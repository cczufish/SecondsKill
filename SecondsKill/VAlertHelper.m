//
//  VAlertHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VAlertHelper.h"
#import "AppDelegate.h"

#define ALERT_SHOW_SECONDS 1.5f

@implementation VAlertHelper

+ (void)success:(NSString *)message
{
    [self success:message position:ALAlertBannerPositionUnderNavBar];
}

+ (void)success:(NSString *)message position:(ALAlertBannerPosition)position
{
    [self alert:message style:ALAlertBannerStyleNotify position:position];
}

+ (void)success:(NSString *)message style:(ALAlertBannerStyle)style
{
    [self alert:message style:style position:ALAlertBannerPositionUnderNavBar];
}

+ (void)fail:(NSString *)message
{
    [self fail:message position:ALAlertBannerPositionUnderNavBar];
}

+ (void)fail:(NSString *)message position:(ALAlertBannerPosition)position
{
    [self alert:message style:ALAlertBannerStyleFailure position:position];
}

+ (void)fail:(NSString *)message style:(ALAlertBannerStyle)style
{
    [self alert:message style:style position:ALAlertBannerPositionUnderNavBar];
}

+ (void)alert:(NSString *)message style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window style:style position:position title:message subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
        [alertBanner hide];
    }];
    
    banner.secondsToShow = ALERT_SHOW_SECONDS;
    [banner show];
}

@end
