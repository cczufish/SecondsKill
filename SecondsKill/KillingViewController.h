//
//  KillingViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"

@interface KillingViewController : SuperViewController<UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *seletedMenuItems;//用于记录当前界面数据筛选条件

//从菜单界面返回时，触发此方法
- (void)refreshCommoditys;

@end
