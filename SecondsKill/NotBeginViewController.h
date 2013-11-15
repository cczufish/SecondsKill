//
//  NotBeginViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"

@interface NotBeginViewController : SuperViewController<UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *commoditys;

@property (nonatomic, strong) NSMutableArray *seletedMenuItems;

- (void)refreshCommoditys;

@end
