//
//  MoreViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MoreViewController.h"
#import "UMFeedback.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"更多\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"更多\"界面"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:@"邀请好友来和你一起秒！"
                                         shareImage:[UIImage imageNamed:@"icon_bell_on.png"]
                                    shareToSnsNames:nil
                                           delegate:self];

    }
    else if (indexPath.row == 1) {
        [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
    }
    else if (indexPath.row == 2) {
        [MobClick checkUpdateWithDelegate:self selector:@selector(checkUpdateDelegate:)];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)checkUpdateDelegate:(NSDictionary *)appInfo
{
    if ([[appInfo objectForKey:@"update"] boolValue]) {
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
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:@"您的应用已经是最新版!" subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
            [alertBanner hide];
        }];
        banner.secondsToShow = ALERT_SHOW_SECONDS;
        [banner show];
    }
}
//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    
    if (response.responseType == UMSResponseShareToMutilSNS) {
        ALAlertBanner *banner = nil;
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功发送至%@!",[[response.data allKeys] objectAtIndex:0]] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
                [alertBanner hide];
            }];
        }
        else {
            if (response.responseCode != UMSResponseCodeCancel) {
                banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleFailure position:ALAlertBannerPositionTop title:@"邀请失败!" subtitle:response.message tappedBlock:^(ALAlertBanner *alertBanner) {
                    [alertBanner hide];
                }];
            }
        }
        //问题是发了两个通知
        
        banner.secondsToShow = ALERT_SHOW_SECONDS;
        [banner show];
    }
}
#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_more_normal.png";
}

- (NSString *)tabTitle
{
    return @"更多";
}

@end
