//
//  VWebView.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-4.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWebView;

@protocol VWebViewProgressDelegate <NSObject>
@optional
- (void)webView:(VWebView*)vwebView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end

@interface VWebView : UIWebView

@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@property (nonatomic, weak) id<VWebViewProgressDelegate> progressDelegate;

@end
