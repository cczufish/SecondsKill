//
//  VWebView.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-4.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VWebView.h"

@interface UIWebView ()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end

@implementation VWebView

@synthesize progressDelegate;
@synthesize resourceCount;
@synthesize resourceCompletedCount;

- (void)awakeFromNib
{
    self.progressBar = [[YLProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 5.0f)];
    self.progressBar.type = YLProgressBarTypeFlat;
    self.progressBar.progressTintColor = RGB(51, 153, 255);
    //    _progressBar.hideStripes = YES;
    self.progressBar.trackTintColor = [UIColor clearColor];
    [self addSubview:self.progressBar];

}
- (void)resetProgressBar
{
    self.progressBar.progress = 0.0f;
    self.progressBar.hidden = YES;
    self.resourceCount = 0;
    self.resourceCompletedCount = 0;
}
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    self.progressBar.hidden = NO;
    return [NSNumber numberWithInt:resourceCount++];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource {
    
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    resourceCompletedCount++;
    
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}

-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    resourceCompletedCount++;
    
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}

@end
