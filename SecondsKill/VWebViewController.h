//
//  VWebViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "VWebView.h"

@interface VWebViewController : UIViewController<UIWebViewDelegate,VWebViewProgressDelegate>

@property (nonatomic, copy) NSString *linkAddress;

@property (nonatomic, weak) IBOutlet VWebView *webView;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backBarItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardBarItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshBarItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *stopBarItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionBarItem;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

- (IBAction)stop:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)action:(id)sender;

@end
