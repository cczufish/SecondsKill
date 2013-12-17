//
//  VWebViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "VWebView.h"
#import "CommodityTableViewAdapter.h"
#import "Commodity.h"

@interface VWebViewController : UIViewController<UMSocialUIDelegate, VWebViewDelegate>

@property (nonatomic, assign) CommodityAdapterType adapterType;

@property (nonatomic, strong) Commodity *commodity;

@property (nonatomic, copy) NSString *linkAddress;

@property (nonatomic, strong) UIImage *shareImage;//分享用的图片

@property (nonatomic, copy) NSString *shareText;//分享用的文字


@property (nonatomic, strong) VWebView *webView;

@end
