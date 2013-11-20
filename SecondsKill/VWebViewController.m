//
//  VWebViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VWebViewController.h"

@interface VWebViewController ()

@end

@implementation VWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegateV = self;

    if (![self.linkAddress hasPrefix:@"http://"] && ![self.linkAddress hasPrefix:@"https://"]) {
        self.linkAddress = [NSString stringWithFormat:@"http://%@",self.linkAddress];
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.linkAddress]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"\"浏览器\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"\"浏览器\"界面"];
}


#pragma mark - VWebViewDelegate

- (void)actionUp:(VWebView *)webView
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:self.linkAddress
                                     shareImage:[UIImage imageNamed:@"icon_bell_on.png"]
                                shareToSnsNames:nil
                                       delegate:self];
}

#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [AlertHelper sharedUMSocialSuccess:response inView:self.view];
}

@end
