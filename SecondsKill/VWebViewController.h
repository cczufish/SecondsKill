//
//  VWebViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "VWebView.h"

@interface VWebViewController : UIViewController<UMSocialUIDelegate, VWebViewDelegate>

@property (nonatomic, copy) NSString *linkAddress;

@property (nonatomic, weak) IBOutlet VWebView *webView;

@end
