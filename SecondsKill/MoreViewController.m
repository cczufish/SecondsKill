//
//  MoreViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MoreViewController.h"
#import "UMFeedback.h"
#import "PXAlertView.h"

#define APP_ID @"785820116"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick beginLogPageView:@"\"更多\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"\"更多\"界面"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENG_APPKEY shareText:@"#秒杀惠# 强烈推荐一个秒杀神器，可以将京东亚马逊神马的秒杀信息一网打尽，赶快下载吧! http://ms.athui.com" shareImage:[UIImage imageNamed:@"logo@2x.png"] shareToSnsNames:nil delegate:self];
    }
    else if (indexPath.row == 1) {
        [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
    }
    else if (indexPath.row == 2) {
        [VAlertHelper success:@"您的应用是最新版，不需要更新!"];
        
        
        
        
//        [MobClick checkUpdateWithDelegate:self selector:@selector(checkUpdateDelegate:)];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UMSocialUIDelegate

- (void)checkUpdateDelegate:(NSDictionary *)appInfo
{
    BOOL needUpdate = [[appInfo objectForKey:@"update"] boolValue];

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
        [VAlertHelper success:@"您的应用是最新版，不需要更新!"];
    }
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_more.png";
}

- (NSString *)tabTitle
{
    return @"更多";
}

@end
