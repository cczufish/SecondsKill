//
//  VWebViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VWebViewController.h"

#define kStopBarItemIndex 4
#define kRefreshBarItemIndex 5

@interface VWebViewController ()

@property (nonatomic, strong) NSMutableArray *defaultBarItems;
@property (nonatomic, strong) NSMutableArray *loadingBarItems;

@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@end

@implementation VWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _defaultBarItems = [NSMutableArray arrayWithArray:self.toolBar.items];
    [_defaultBarItems removeObjectAtIndex:kStopBarItemIndex];
    
    _loadingBarItems = [NSMutableArray arrayWithArray:self.toolBar.items];
    [_loadingBarItems removeObjectAtIndex:kRefreshBarItemIndex];
    
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    if (![self.linkAddress hasPrefix:@"http://"] && ![self.linkAddress hasPrefix:@"https://"]) {
        self.linkAddress = [NSString stringWithFormat:@"http://%@",self.linkAddress];
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.linkAddress]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"浏览器\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"浏览器\"界面"];
}

- (void)updateToolbarItems {
    self.backBarItem.enabled = self.webView.canGoBack;
    self.forwardBarItem.enabled = self.webView.canGoForward;
    self.actionBarItem.enabled = !self.webView.isLoading;

    if (self.webView.isLoading) {
        self.toolBar.items = self.loadingBarItems;
    }
    else {
        self.toolBar.items = self.defaultBarItems;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateToolbarItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSURL *url = [[NSURL alloc] initWithScheme:[webView.request.URL scheme] host:[webView.request.URL host] path:@"/favicon.ico"];
//    UIButton *rightBtn = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
//    [rightBtn setImageForState:UIControlStateNormal withURL:url];
    
    [self updateToolbarItems];

    [self.webView resetProgressBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateToolbarItems];
    [self.webView resetProgressBar];
}

- (void)webView:(VWebView *)_vwebView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    self.webView.progressBar.progress = (float)resourceNumber / totalResources;
}

#pragma mark - UIButton Action

- (IBAction)stop:(id)sender
{
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

- (IBAction)back:(id)sender
{
    [self.webView goBack];
}

- (IBAction)forward:(id)sender
{
    [self.webView goForward];
}

- (IBAction)action:(id)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:self.linkAddress
                                     shareImage:[UIImage imageNamed:@"icon_bell_on.png"]
                                shareToSnsNames:nil
                                       delegate:self];

}
//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    
    if (response.responseType == UMSResponseShareToMutilSNS) {
        ALAlertBanner *banner = nil;
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功分享至%@!",[[response.data allKeys] objectAtIndex:0]] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
                [alertBanner hide];
            }];
        }
        else {
            if (response.responseCode != UMSResponseCodeCancel) {
                banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleFailure position:ALAlertBannerPositionTop title:@"分享失败!" subtitle:response.message tappedBlock:^(ALAlertBanner *alertBanner) {
                    [alertBanner hide];
                }];
            }
        }
        //问题是发了两个通知
        
        banner.secondsToShow = ALERT_SHOW_SECONDS;
        [banner show];
    }
}

@end
