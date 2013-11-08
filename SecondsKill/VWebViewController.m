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

@property (nonatomic, strong) YLProgressBar *progressBar;

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
    
    _progressBar = [[YLProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 5.0f)];
    _progressBar.type = YLProgressBarTypeFlat;
    _progressBar.progressTintColor = RGB(51, 153, 255);
//    _progressBar.hideStripes = YES;
    _progressBar.trackTintColor = [UIColor clearColor];
    [self.view addSubview:_progressBar];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.linkAddress]]];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.progressBar.hidden = NO;

    return YES;
}
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
    [self resetProgressBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateToolbarItems];
    [self resetProgressBar];
}

- (void)webView:(VWebView *)_vwebView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    self.progressBar.progress = (float)resourceNumber / totalResources;
}

- (void)resetProgressBar
{
    self.progressBar.progress = 0.0f;
    self.progressBar.hidden = YES;
    _webView.resourceCount = 0;
    _webView.resourceCompletedCount = 0;
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
