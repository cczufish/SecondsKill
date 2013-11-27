//
//  VAlertHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VAlertHelper.h"
#import "AppDelegate.h"
#import "ALAlertBanner.h"

#define ALERT_SHOW_SECONDS 2.0f

@implementation VAlertHelper

+ (void)success:(NSString *)message
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window style:ALAlertBannerStyleNotify position:ALAlertBannerPositionUnderNavBar title:message subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
        [alertBanner hide];
    }];
    
    banner.secondsToShow = ALERT_SHOW_SECONDS;
    [banner show];
}

+ (void)fail:(NSString *)message
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window style:ALAlertBannerStyleFailure position:ALAlertBannerPositionUnderNavBar title:message subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
        [alertBanner hide];
    }];
    
    banner.secondsToShow = ALERT_SHOW_SECONDS;
    [banner show];
}

@end
