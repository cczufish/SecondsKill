//
//  NotBeginViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NotBeginViewController.h"
#import "MenuViewController.h"
#import "NSTimer+V.h"

@interface NotBeginViewController ()

@property (nonatomic, copy) NSString *ql;

@end

static NSDate *preRefreshTime = nil;

@implementation NotBeginViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];

    self.ql = @"";
    
    BButton *refreshBtn = [BButton awesomeButtonWithOnlyIcon:FAIconRepeat color:[UIColor clearColor] style:BButtonStyleBootstrapV3];//V2有阴影
    refreshBtn.titleLabel.textColor = [UIColor whiteColor];
    refreshBtn.showsTouchWhenHighlighted = YES;
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];

    NSArray *menus = [MenuViewController menus];
    self.seletedMenuItems = [NSMutableArray arrayWithCapacity:[menus count]];
    for (int i = 0; i < [menus count]; i++) {
        [self.seletedMenuItems addObject:[menus[i] objectAtIndex:1]];//将title为“全部“的菜单项设置为默认选择菜单
    }
    
    _tableViewAdapter = [[CommodityTableViewAdapter alloc] initWithType:CommodityAdapterTypeNotBegin];
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self defaultQL] base64EncodedString], @"ql", @"start_t,liking",@"sort",@"asc,desc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page",@"NotBeginViewController",@"model", nil];
    self.uri = [self.params toURLString:DEFAULT_URI];

    [SVProgressHUD show];
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        
        [SVProgressHUD dismiss];
        
        preRefreshTime = [NSDate date];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"未开始\"界面"];
    
    //所有 timer 开始
    for (NSTimer *timer in self.timers) {
        [timer resume];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"未开始\"界面"];
    
    //所有 timer 暂停
    for (NSTimer *timer in self.timers) {
        [timer pause];
    }
}

#pragma mark -

- (NSString *)defaultQL
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long currentTime = (long long)(time * 1000);
   
    return [NSString stringWithFormat:@"%@start_t>%lld",self.ql,currentTime];
}

- (void)selectCommoditys:(NSString *)ql
{
    self.ql = ql;
    
    [super pullDownRefresh];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        [SVProgressHUD dismiss];
    }];
}

- (void)refresh
{
    //此方法会由定时器控制的代码连续刷新多次，所以做次处理，5秒内只响应一次刷新要求
    NSDateComponents *comp = [VDateTimeHelper dateBetween:preRefreshTime toDate:[NSDate date]];

    if (comp.second < 3) {
        return;
    }

    preRefreshTime = [NSDate date];
    
    [super pullDownRefresh];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        [SVProgressHUD dismiss];
    }];
}

- (void)pullDownRefresh
{
    [super pullDownRefresh];
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
    }];
}

- (void)pullUpRefresh
{
    [super pullUpRefresh];
    
    [self refreshTableView:RefreshTableViewModePullUp callBack:^(NSMutableArray *datas) {
        [self.tableViewAdapter.commoditys addObjectsFromArray:datas];
    }];
}

#pragma mark - AKTabBarController

- (NSString *)tabImageName
{
    return @"icon_hourglass.png";
}

- (NSString *)tabTitle
{
    return @"未开始";
}

@end
