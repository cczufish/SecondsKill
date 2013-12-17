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

@property (nonatomic, assign) int selectedMenuTag;

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

    BButton *titleBtn = [BButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:@"秒杀惠" forState:UIControlStateNormal];
    [titleBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn addAwesomeIcon:FAIconCaretDown beforeTitle:NO];
    titleBtn.showsTouchWhenHighlighted = YES;
    [titleBtn addTarget:self action:@selector(showSortMenuView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    [self configSortMenuView];
    
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

    _tableViewAdapter = [[CommodityTableViewAdapter alloc] initWithType:CommodityAdapterTypeKilling];
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self defaultQL] base64EncodedString], @"ql", @"end_t,liking",@"sort",@"asc,desc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page",@"KillingViewController",@"model", nil];
    self.uri = [self.params toURLString:DEFAULT_URI];
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^ {
        //刚打开应用时只有监测到网络状态后才进行数据请求
        while (YES) {
            if ([VNetworkHelper monitorSuccess]) {
                [self reqeustDatas];
                break;
            }
        }
    });
}

- (void)reqeustDatas
{
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        
        [SVProgressHUD dismiss];
        
        [APService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY] callbackSelector:nil object:nil];
        
        [self updateCommodityInfos];
    }];
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

    //所有 timer 暂停
    for (NSTimer *timer in self.timers) {
        [timer pause];
    }
    
    [self showSortMenuView:nil];
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
        
        [self updateCommodityInfos];//异步更新国美和亚马逊的商品数据
    }];
}

- (void)pullDownRefresh
{
    [super pullDownRefresh];
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        
        [self updateCommodityInfos];//异步更新国美和亚马逊的商品数据
    }];
}

- (void)pullUpRefresh
{
    [super pullUpRefresh];

    [self refreshTableView:RefreshTableViewModePullUp callBack:^(NSMutableArray *datas) {
        [self.tableViewAdapter.commoditys addObjectsFromArray:datas];
        
        [self updateCommodityInfos];//异步更新国美和亚马逊的商品数据
    }];
}

- (void)refresh
{
    [super pullDownRefresh];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        [SVProgressHUD dismiss];
        
        [self updateCommodityInfos];//异步更新国美和亚马逊的商品数据
    }];
}

- (void)sortTableView:(SortTableViewType)sortType
{
    if (sortType == SortTableViewTypeTime) {
        [self.params setObject:@"end_t,liking" forKey:@"sort"];
    }
    else {
        [self.params setObject:@"discount,liking" forKey:@"sort"];
    }
    
    [super pullDownRefresh];//设置查询条件
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.tableViewAdapter.commoditys = datas;
        [SVProgressHUD dismiss];
        
        [self updateCommodityInfos];//异步更新国美和亚马逊的商品数据
    }];
}

#pragma mark - 菜单

- (void)configSortMenuView
{
    BButton *timeBtn = [BButton buttonWithType:UIButtonTypeCustom];
    [timeBtn setTitle:@"  按时间" forState:UIControlStateNormal];
    [timeBtn addAwesomeIcon:FAIconTime beforeTitle:YES];
    timeBtn.color = RGBCOLOR(38.0f, 38.0f, 38.0f);
    timeBtn.tag = 8080;
    [timeBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    BButton *discountBtn = [BButton buttonWithType:UIButtonTypeCustom];
    [discountBtn setTitle:@"  按折扣" forState:UIControlStateNormal];
    [discountBtn addAwesomeIcon:FAIconTag beforeTitle:YES];
    discountBtn.color = RGBCOLOR(38.0f, 38.0f, 38.0f);
    discountBtn.tag = 8088;
    [discountBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectedMenuTag = timeBtn.tag;
    
    REMenuItem *sortTime = [[REMenuItem alloc] initWithCustomView:timeBtn action:nil];
    REMenuItem *sortDiscount = [[REMenuItem alloc] initWithCustomView:discountBtn action:nil];
    
    _sortMenu = [[REMenu alloc] initWithItems:@[sortTime, sortDiscount]];
    _sortMenu.itemHeight = 35.0f;
    _sortMenu.font = [UIFont fontWithName:FONT_NAME size:14];
    _sortMenu.textShadowColor = [UIColor clearColor];
}

- (void)menuBtnPressed:(UIButton *)btn
{
    [self showSortMenuView:btn];
    
    if (btn.tag == 8080 && btn.tag != self.selectedMenuTag) {
        self.selectedMenuTag = 8080;
        [self sortTableView:SortTableViewTypeTime];
    }
    else if(btn.tag == 8088 && btn.tag != self.selectedMenuTag) {
        self.selectedMenuTag = 8088;
        [self sortTableView:SortTableViewTypeDiscount];
    }
}

- (void)showSortMenuView:(UIButton *)sender
{
    BButton *titleBtn = (BButton *)self.navigationItem.titleView;
    [titleBtn setTitle:@"秒杀惠" forState:UIControlStateNormal];
    
    if (self.sortMenu.isOpen || !sender) {
        [self.sortMenu close];
        [titleBtn addAwesomeIcon:FAIconCaretDown beforeTitle:NO];
    }
    else {
        [self.sortMenu showFromRect:CGRectMake(SCREEN_WIDTH/2 - 110/2, self.tableView.contentOffset.y, 110, 75) inView:self.view];
        
        [titleBtn addAwesomeIcon:FAIconCaretUp beforeTitle:NO];
        
        BButton *timeBtn = (BButton *)((REMenuItem *)self.sortMenu.items[0]).customView;
        BButton *discountBtn = (BButton *)((REMenuItem *)self.sortMenu.items[1]).customView;
        
        if (self.selectedMenuTag == 8080) {
            [timeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [discountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if (self.selectedMenuTag == 8088) {
            [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [discountBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 更新国美商品的剩余数量，亚马逊的剩余数量和秒杀价格

- (void)updateCommodityInfos
{
    if ([VNetworkHelper hasNetWork]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^ {
            NSMutableString *gmSkus = [[NSMutableString alloc] initWithCapacity:20];
            NSMutableArray *amazonDealIds = [[NSMutableArray alloc] initWithCapacity:20];
            
            for (Commodity *commodity in self.tableViewAdapter.commoditys) {
                if ([@"gm" isEqualToString:commodity.site]) {
                    [gmSkus appendFormat:@"%@%%7C", commodity.sku];// %7c -> |
                }
                if ([@"az" isEqualToString:commodity.site]) {
                    [amazonDealIds addObject:commodity.deal_id];
                }
            }
            
            if (![@"" isEqualToString:gmSkus]) {
                [self updateGMRemain:gmSkus];
            }
            if ([amazonDealIds count] > 0) {
                [self updateAmazonRemain:amazonDealIds];
            }
            
            [self updateAmazonPrice];
        });
    }
}

- (void)updateAmazonPrice
{
    NSMutableArray *amazonDealIds = [[NSMutableArray alloc] initWithCapacity:20];
    
    for (Commodity *commodity in self.tableViewAdapter.commoditys) {
        if ([@"az" isEqualToString:commodity.site] && commodity.price <= 0) {
            [amazonDealIds addObject:commodity.deal_id];
        }
    }
    
    if ([amazonDealIds count] > 0) {
        NSString *amazonURL = [[NSString alloc] initWithFormat:@"http://www.amazon.cn/xa/goldbox/GetDeals?nocache=1383095403473"];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [postDict setObject:@{@"marketplaceID": @"AAHKV2X7AFYLW"} forKey:@"requestMetadata"];
        [postDict setObject:@"" forKey:@"customerID"];
        [postDict setObject:[NSArray array] forKey:@"ordering"];
        [postDict setObject:@1 forKey:@"page"];
        [postDict setObject:@20 forKey:@"resultsPerPage"];
        [postDict setObject:@YES forKey:@"includeVariations"];
        [postDict setObject:@{@"dealIDs": amazonDealIds, @"__type":@"DealIDDealFilter:http://internal.amazon.com/coral/com.amazon.DealService.model/"} forKey:@"filter"];
        
        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:amazonURL httpMethod:@"POST"];
        requestHelper.httpBody = [postDict toJSONString:nil];
        
        [requestHelper requestSimpleWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            if (json) {
                NSArray *deals = (NSArray *)[json objectForKey:@"deals"];
                
                if (deals) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    for (int i = 0; i < [deals count]; i++) {
                        NSDictionary *temp = [deals[i] objectForKey:@"asins"][0];
                        @try {
                            [dict setObject:[[temp objectForKey:@"dealPrice"] objectForKey:@"price"] forKey:[temp objectForKey:@"dealID"]];
                        }
                        @catch (NSException *exception) {
                            [dict setObject:@0 forKey:[temp objectForKey:@"dealID"]];
                            NSLog(@"======== %@:%@ =======", [exception name], [exception reason]);
                        }
                    }
                    
                    for (Commodity *commodity in self.tableViewAdapter.commoditys) {
                        if ([@"az" isEqualToString:commodity.site] && commodity.price <= 0 && [dict objectForKey:commodity.deal_id]) {
                            NSMutableDictionary *postData = [[NSMutableDictionary alloc] initWithCapacity:2];
                            
                            CGFloat price = [[dict objectForKey:commodity.deal_id] floatValue];
                            if (price > 0) {
                                commodity.price = price;
                                NSString *discount = [NSString stringWithFormat:@"%.1f", commodity.price*10/commodity.o_price];

                                commodity.discount = discount;
                                
                                [postData setObject:[dict objectForKey:commodity.deal_id] forKey:@"price"];
                                [postData setObject:discount forKey:@"discount"];
                            }
                            else {
                                [self.tableViewAdapter.commoditys removeObject:commodity];
                                
                                [postData setObject:@1000L forKey:@"end_t"];
                            }
                            
                            [self updateServerDatas:commodity.itemID httpBody:[postData toJSONString:nil]];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }
        }];
    }
}

- (void)updateServerDatas:(NSString *)itemID httpBody:(NSString *)httpBody
{
    NSString *updateURL = [[NSString alloc] initWithFormat:@"msitems/%@",itemID];
    
    VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:updateURL httpMethod:@"PUT"];
    requestHelper.httpBody = httpBody;
    [requestHelper requestWithCompletionBlock:nil];
}

- (void)updateAmazonRemain:(NSArray *)amazonDealIds
{
    NSString *amazonURL = [[NSString alloc] initWithFormat:@"http://www.amazon.cn/xa/goldbox/GetDealStatus?nocache=1383022654715"];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [postDict setObject:@{@"marketplaceID": @"AAHKV2X7AFYLW"} forKey:@"requestMetadata"];
    [postDict setObject:amazonDealIds forKey:@"dealIDs"];
    
    VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:amazonURL httpMethod:@"POST"];
    requestHelper.httpBody = [postDict toJSONString:nil];
    
    [requestHelper requestSimpleWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
        if (json) {
            NSDictionary *dealStatus = [json objectForKey:@"dealStatus"];
            
            if (dealStatus) {
                for (Commodity *commodity in self.tableViewAdapter.commoditys) {
                    NSDictionary *temp = [dealStatus objectForKey:commodity.deal_id];

                    if ([@"az" isEqualToString:commodity.site] && temp) {
                        int remain = (int)((1 - [[temp objectForKey:@"percentClaimed"] floatValue] / 100) * [[temp objectForKey:@"totalAvailable"] intValue]);
                        
                        if(commodity.remain != remain) {
                            commodity.remain = remain;
                            
                            [self updateServerDatas:commodity.itemID httpBody:[@{@"remain": [NSString stringWithFormat:@"%d",remain]} toJSONString:nil]];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

- (void)updateGMRemain:(NSString *)gmSkus
{
    NSString *gmURL = [[NSString alloc] initWithFormat:@"http://g.gome.com.cn/ec/homeus/n/indexJson/exactLimitbuy.jsp?productId=%@",gmSkus];
    
    VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:gmURL];
    [requestHelper requestSimpleWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
        if (json) {
            NSString *jsonStr = [json stringByReplacingOccurrencesOfString:@"rushRest" withString:@""];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@";" withString:@""];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            if (jsonObj) {
                NSArray *dataList = (NSArray *)[jsonObj objectForKey:@"dataList"];
                if (dataList) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *temp in dataList) {
                        [dict setObject:[temp objectForKey:@"num"] forKey:[temp objectForKey:@"id"]];
                    }
                    
                    for (Commodity *commodity in self.tableViewAdapter.commoditys) {
                        if ([@"gm" isEqualToString:commodity.site] && [dict objectForKey:commodity.sku]) {
                            commodity.remain = [[dict objectForKey:commodity.sku] integerValue];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }
            }
        }
    }];
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
