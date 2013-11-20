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

#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [AlertHelper sharedUMSocialSuccess:response inView:self.view];
}

- (void)checkUpdateDelegate:(NSDictionary *)appInfo
{
    BOOL needUpdate = [[appInfo objectForKey:@"update"] boolValue];
    
    [AlertHelper checkUpdateAPP:needUpdate inView:self.view];
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
