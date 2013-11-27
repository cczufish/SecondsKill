//
//  KillingViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "KillingViewController.h"
#import "CommodityTableViewAdapter.h"
#import "MenuViewController.h"

#define kKillingPath @"msitems"

@interface KillingViewController ()

@property (nonatomic, strong) CommodityTableViewAdapter *tableViewAdapter;

@end

@implementation KillingViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    self.canShowMenuViewController = YES;
    
    [super viewDidLoad];

    NSArray *menus = [MenuViewController menus];
    self.seletedMenuItems = [NSMutableArray arrayWithCapacity:[menus count]];
    for (int i = 0; i < [menus count]; i++) {
        [self.seletedMenuItems addObject:[menus[i] objectAtIndex:1]];//将title为“全部“的菜单项设置为默认选择菜单
    }

    _tableViewAdapter = [[CommodityTableViewAdapter alloc] initWithType:CommodityAdapterTypeKilling];
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self defaultQL] base64EncodedString], @"ql", @"end_t",@"sort",@"asc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page", nil];
    self.uri = GenerateURLString(kKillingPath, self.params);
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"秒杀中\"界面"];
    
    //所有 timer 开始
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"秒杀中\"界面"];
    
    //所有 timer 暂停
}

#pragma mark -

- (NSString *)defaultQL
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long currentTime = (long long)(time * 1000);
    return [NSString stringWithFormat:@"start_t<=%lld and end_t>%lld and remain>0",currentTime,currentTime];
}

- (void)selectCommoditys:(NSString *)ql
{
    self.pageNO = 1;
    
    NSString *newQL = [NSString stringWithFormat:@"%@%@",ql,[self defaultQL]];
    [self.params setObject:[newQL base64EncodedString] forKey:@"ql"];
    [self.params setObject:@"1" forKey:@"page"];
    self.uri = GenerateURLString(kKillingPath, self.params);
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
    }];
    
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

//下拉刷新
- (void)pullDownRefresh
{
    self.pageNO = 1;
    [self.params setObject:@"1" forKey:@"page"];
    self.uri = GenerateURLString(kKillingPath, self.params);
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
    }];
}

//上拉刷新
- (void)pullUpRefresh
{
    [self.params setObject:[NSString stringWithFormat:@"%d",++self.pageNO] forKey:@"page"];
    self.uri = GenerateURLString(kKillingPath, self.params);

    [self refreshTableView:RefreshTableViewModePullUp callBack:^(NSMutableArray *datas) {
        [self.tableViewAdapter.commoditys addObjectsFromArray:datas];
    }];
}

#pragma mark - AKTabBarController

- (NSString *)tabImageName
{
    return @"icon_energy_normal.png";
}

- (NSString *)tabTitle
{
    return @"秒杀中";
}

@end
