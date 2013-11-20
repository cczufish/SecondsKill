//
//  ALAlertHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-20.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "AlertHelper.h"

#import "PXAlertView.h"
#import "ALAlertBanner.h"


#warning 在App Store新建应用后，将appid添加到进来。
#define APP_ID @""
#define ALERT_SHOW_SECONDS 2.0f

@implementation AlertHelper

+ (void)success:(NSString *)message inView:(UIView *)view
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:message subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
        [alertBanner hide];
    }];
    
    banner.secondsToShow = ALERT_SHOW_SECONDS;
    [banner show];
}

+ (void)sharedUMSocialSuccess:(UMSocialResponseEntity *)response inView:(UIView *)view
{
    if (response.responseType == UMSResponseShareToMutilSNS) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功分享至%@!",[[response.data allKeys] objectAtIndex:0]] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
                [alertBanner hide];
            }];
            
            banner.secondsToShow = ALERT_SHOW_SECONDS;
            [banner show];
        }
    }
}

#warning 有时间时把跳转改成程序内跳
+ (void)checkUpdateAPP:(BOOL)needUpdate inView:(UIView *)view
{
    if (needUpdate) {
        PXAlertView *alert = [PXAlertView showAlertWithTitle:@"检查更新" message:@"您的应用不是最新版!" cancelTitle:@"跳过此版本" otherTitle:@"去更新" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (!cancelled) {
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", APP_ID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesString]];
            }
        }];
        [alert setCancelButtonBackgroundColor:[UIColor orangeColor]];
        [alert setOtherButtonBackgroundColor:[UIColor orangeColor]];
    }
    else {
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:@"您的应用是最新版，不需要更新!" subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
            [alertBanner hide];
        }];
        banner.secondsToShow = ALERT_SHOW_SECONDS;
        [banner show];
    }
}

@end
