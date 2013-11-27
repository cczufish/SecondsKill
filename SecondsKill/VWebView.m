//
//  VWebView.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-4.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VWebView.h"

@interface UIWebView ()

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;

@end

@interface VWebView ()

@property (nonatomic, strong) YLProgressBar *progressBar;

@property (nonatomic, copy) NSArray *defaultBarItems;
@property (nonatomic, copy) NSArray *loadingBarItems;

@property (nonatomic, strong) UIBarButtonItem *backBarItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarItem;

@property (nonatomic, strong) UIToolbar *toolBar;

- (void)stop:(id)sender;
- (void)refresh:(id)sender;
- (void)back:(id)sender;
- (void)forward:(id)sender;
- (void)action:(id)sender;

- (void)updateLoadingStatus:(BOOL)isEndLoading;

@end

@implementation VWebView
{
    int resourceCount;
    int resourceCompletedCount;
}

- (void)awakeFromNib
{
    self.delegate = self;
    self.scalesPageToFit = YES;
    
    //工具条
    _backBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    _forwardBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];
    _refreshBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    _stopBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
    _actionBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    UIBarButtonItem *flexibleBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.defaultBarItems = @[_backBarItem, flexibleBarItem, _forwardBarItem, flexibleBarItem, _refreshBarItem, flexibleBarItem, _actionBarItem];
    self.self.loadingBarItems = @[_backBarItem, flexibleBarItem, _forwardBarItem, flexibleBarItem, _stopBarItem, flexibleBarItem, _actionBarItem];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - 64.0f - 44.0f, SCREEN_WIDTH, 44.0f)];
    _toolBar.barStyle = UIBarStyleBlackTranslucent;
    self.toolBar.items = self.defaultBarItems;
    
    [self.superview addSubview:self.toolBar];

    //网页加载进度条
    _progressBar = [[YLProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 5.0f)];
    _progressBar.type = YLProgressBarTypeFlat;
    _progressBar.progressTintColor = RGBCOLOR(51, 153, 255);
    _progressBar.hideStripes = YES;
    _progressBar.trackTintColor = [UIColor clearColor];
    
    [self addSubview:self.progressBar];
}

#pragma mark - overrides

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    
    return [NSNumber numberWithInt:++resourceCount];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    
    self.progressBar.progress = ++resourceCompletedCount / (float)resourceCount;
    
    if (self.progressBar.progress == 1) {
        [self updateLoadingStatus:YES];
    }
}

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];

    self.progressBar.progress = ++resourceCompletedCount / (float)resourceCount;
    
    if (self.progressBar.progress == 1) {
        [self updateLoadingStatus:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateLoadingStatus:NO];
    
    return YES;
}

#pragma mark -

- (void)updateLoadingStatus:(BOOL)isEndLoading
{
    self.backBarItem.enabled = self.canGoBack;
    self.forwardBarItem.enabled = self.canGoForward;
    
    self.actionBarItem.enabled = isEndLoading;
    self.progressBar.hidden = isEndLoading;
    
    if (isEndLoading) {
        resourceCount = 0;
        resourceCompletedCount = 0;
        
        self.progressBar.progress = 0.0f;
        
        self.toolBar.items = self.defaultBarItems;
    }
    else {
        self.toolBar.items = self.loadingBarItems;
    }
}

#pragma mark - UIButton Action

- (void)stop:(id)sender
{
    [self stopLoading];
    
    [self updateLoadingStatus:YES];
}

- (void)refresh:(id)sender
{
    [self reload];
}

- (void)back:(id)sender
{
    [self goBack];
}

- (void)forward:(id)sender
{
    [self goForward];
}

- (void)action:(id)sender
{
    if (self.delegateV && [self.delegateV respondsToSelector:@selector(actionUp:)]) {
        [self.delegateV actionUp:self];
    }
}

@end
