//
//  VWebView.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-4.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWebView;
@protocol VWebViewDelegate <NSObject>

- (void)actionUp:(VWebView *)webView;

@end

@interface VWebView : UIWebView<UIWebViewDelegate>

@property (nonatomic, weak) id<VWebViewDelegate> delegateV;

@end
