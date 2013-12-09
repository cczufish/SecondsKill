//
//  KillingViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "CommodityTableViewAdapter.h"

@interface KillingViewController : SuperViewController

@property (nonatomic, strong) REMenu *sortMenu;

@property (nonatomic, strong) CommodityTableViewAdapter *tableViewAdapter;

@property (nonatomic, strong) NSMutableArray *seletedMenuItems;//用于记录当前界面数据筛选条件

//从菜单界面返回时，触发此方法
- (void)selectCommoditys:(NSString *)ql;

@end
