//
//  KillingViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "KillingViewController.h"
#import "MenuViewController.h"
#import "User.h"
#import "UserManager.h"
#import "Commodity.h"
#import "NSTimer+V.h"

@interface KillingViewController ()

@property (nonatomic, copy) NSString *ql;

@end

@implementation KillingViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
    self.ql = @"";
    
    BButton *menuBtn = [BButton awesomeButtonWithOnlyIcon:FAIconReorder color:[UIColor clearColor] style:BButtonStyleBootstrapV3];//V2有阴影
    menuBtn.titleLabel.textColor = [UIColor whiteColor];
    menuBtn.showsTouchWhenHighlighted = YES;
    [menuBtn addTarget:self action:@selector(showMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    BButton *sortBtn = [BButton awesomeButtonWithOnlyIcon:FAIconSort color:[UIColor clearColor] style:BButtonStyleBootstrapV3];
    sortBtn.titleLabel.textColor = [UIColor whiteColor];
    sortBtn.showsTouchWhenHighlighted = YES;
    [sortBtn addTarget:self action:@selector(showSortMenuView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
    
    [self configSortMenuView];

    NSArray *menus = [MenuViewController menus];
    self.seletedMenuItems = [NSMutableArray arrayWithCapacity:[menus count]];
    for (int i = 0; i < [menus count]; i++) {
        [self.seletedMenuItems addObject:[menus[i] objectAtIndex:1]];//将title为“全部“的菜单项设置为默认选择菜单
    }

    _tableViewAdapter = [[CommodityTableViewAdapter alloc] initWithType:CommodityAdapterTypeKilling];
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self defaultQL] base64EncodedString], @"ql", @"end_t",@"sort",@"asc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page",@"KillingViewController",@"model", nil];
    self.uri = [self.params toURLString:DEFAULT_URI];
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^ {

        //模拟注册、登录
        while (YES) {
            if ([VNetworkHelper monitorSuccess]) {
                if ([VNetworkHelper hasNetWork]) {
                    #if TARGET_IPHONE_SIMULATOR
                        [[NSUserDefaults standardUserDefaults] setObject:@"e5e1a6cb5cd41bc46db89995073ae0daf4636c199cbe9fc06c7bfd666457a591" forKey:DEVICE_KEY];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    #endif
                    
                    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_KEY];
 
                    //获取到deviceId后才能够进行注册或登录操作
                    if(deviceId != nil) {
                        
                        //当NSUserDefaults中不存在session时，说明用户没登录过，所以在此注册并登录
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:SESSION_KEY] == nil) {
                            
                            NSDictionary *userInfo = @{@"phone_num": [APService openUDID], @"username": @"iOSUser", @"password": [AESCrypt encrypt:@"password" password:AES256_KEY], @"role": @2, @"deviceId": deviceId};
                            
                            //获取不到session的原因有可能是因为用户注册过但没登录，在这种情况下会注册失败，此处不多做处理，等做注册登录界面功能后再做处理
                            [[UserManager shardInstance] registerUser:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                                
                                //如果登录失败，session仍然会为空，所以下面请求数据时会出401错误，出401错误后会重新登录，以后有界面时会弹出登录界面，但此时不多做处理
                                [[UserManager shardInstance] login:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                                    [self reqeustDatas];
                                }];
                            }];
                        }
                        else {
                            [self reqeustDatas];
                        }
                        
                        break;
                    }
                }
                else {
                    [self reqeustDatas];
                    
                    break;
                }
            }
        }
    });
}

- (void)reqeustDatas
{
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        
        [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
            self.tableViewAdapter.commoditys = datas;
            [SVProgressHUD dismiss];
        }];
//    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"秒杀中\"界面"];
    
    //所有 timer 开始
    for (NSTimer *timer in self.timers) {
        [timer resume];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"秒杀中\"界面"];
    
    [self.sortMenu close];
    
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
    
    return [NSString stringWithFormat:@"%@start_t<=%lld and end_t>%lld",self.ql,currentTime,currentTime];
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

- (void)sortTableView:(SortTableViewType)sortType
{
    if (sortType == SortTableViewTypeTime) {
        [self.params setObject:@"end_t" forKey:@"sort"];
    }
    else {
        [self.params setObject:@"discount" forKey:@"sort"];
    }
    
    [super pullDownRefresh];//设置查询条件
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 菜单

- (void)configSortMenuView
{
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sortLabel.text = @"按时间";
    sortLabel.backgroundColor = RGBCOLOR(38.0f, 38.0f, 38.0f);
    sortLabel.textAlignment = NSTextAlignmentCenter;
    sortLabel.textColor = [UIColor orangeColor];
    
    UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    discountLabel.text = @"按折扣";
    discountLabel.backgroundColor = RGBCOLOR(38.0f, 38.0f, 38.0f);
    discountLabel.textAlignment = NSTextAlignmentCenter;
    discountLabel.textColor = [UIColor whiteColor];
    
    REMenuItem *sortTime = [[REMenuItem alloc] initWithCustomView:sortLabel action:^(REMenuItem *item) {
        if (sortLabel.textColor == [UIColor whiteColor]) {
            [self sortTableView:SortTableViewTypeTime];
        }
        sortLabel.textColor = [UIColor orangeColor];
        discountLabel.textColor = [UIColor whiteColor];
    }];
    
    REMenuItem *sortDiscount = [[REMenuItem alloc] initWithCustomView:discountLabel action:^(REMenuItem *item) {
        if (discountLabel.textColor == [UIColor whiteColor]) {
            [self sortTableView:SortTableViewTypeDiscount];
        }
        sortLabel.textColor = [UIColor whiteColor];
        discountLabel.textColor = [UIColor orangeColor];
    }];
    
    _sortMenu = [[REMenu alloc] initWithItems:@[sortTime, sortDiscount]];
    _sortMenu.itemHeight = 40.0f;
    _sortMenu.font = [UIFont fontWithName:FONT_NAME size:14];
    _sortMenu.textShadowColor = [UIColor clearColor];
}

- (void)showSortMenuView:(UIButton *)sender
{
    if (self.sortMenu.isOpen) {
        [self.sortMenu close];
    }
    else {
        int padding = 10;
        [self.sortMenu showFromRect:CGRectMake(SCREEN_WIDTH - 80 - padding, self.tableView.contentOffset.y, 80, 85) inView:self.view];
    }
}

#pragma mark - AKTabBarController

- (NSString *)tabImageName
{
    return @"icon_energy.png";
}

- (NSString *)tabTitle
{
    return @"秒杀中";
}

@end
