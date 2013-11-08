//
//  NotBeginViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "NotBeginViewController.h"
#import "CommodityTableViewAdapter.h"
#import "Commodity.h"

@interface NotBeginViewController ()

@property (nonatomic, strong) CommodityTableViewAdapter *tableViewAdapter;
@property (nonatomic, strong) REMenu *menu;

@end

static id previousLocationObserver;

@implementation NotBeginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    previousLocationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"tapViewNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        //        self.menuOpened = YES;
        //        if (self.menuOpened) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *seletedMenus = [userDefaults objectForKey:SELECTED_MENU_KEY];
        NSLog(@"%@",[seletedMenus[1] objectForKey:@"title"]);
        UIButton *leftBtn2 = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        [leftBtn2 setTitle:[seletedMenus[1] objectForKey:@"title"] forState:UIControlStateNormal];
        //        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:previousLocationObserver];
}


- (void)configDownMenu
{
    REMenuItem *sortTime = [[REMenuItem alloc] initWithTitle:@"按时间"
                                                       image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                       }];
    
    REMenuItem *sortXX = [[REMenuItem alloc] initWithTitle:@"按XX"
                                                     image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[sortTime, sortXX]];
    
    self.menu.itemHeight = 30.0f;
    self.menu.backgroundColor = RGB(199, 55, 33);
    self.menu.font = [UIFont fontWithName:FONT_NAME size:14];
    self.menu.textColor = [UIColor whiteColor];
    self.menu.textShadowColor = [UIColor clearColor];
}


- (void)showDownMenu:(UIButton *)sender
{
    if (self.menu.isOpen) {
        [self.menu close];
    }
    else {
        CGRect menuRect = sender.frame;
        menuRect.size.height *= 2;
        [self.menu showFromRect:menuRect inView:self.view];
    }
}

- (void)selectMenu
{
    //    if (self.menuOpened) {
    //        [self.revealController showViewController:self.revealController.frontViewController];
    //    }
    //    else {
//    self.revealController.leftViewController.view.tag = self.view.tag;
    [self.revealController showViewController:self.revealController.leftViewController];
    //    }
    //    self.menuOpened = !self.menuOpened;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tag = 1;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonStyle:leftBtn imageName:@"down_arrow.png"];
    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(selectMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonStyle:rightBtn imageName:@"down_arrow.png"];
    [rightBtn setTitle:@"按时间" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    //下拉菜单设置
    [self configDownMenu];

    
    _commoditys = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i < 5; i ++) {
        NSString *name = [NSString stringWithFormat:@"商品%d", i];
        if (i == 0) {
            name = @"利用objective-c的category特性，修改UILabel的绘制代码。";
        }
        
        Commodity *temp = [Commodity commodityWithName:name source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"http://baidu.com";
        if (i == 0) {
            temp.detrusionTime = @"00:00:05";
        }
        else {
            temp.detrusionTime = @"00:02:02";
        }
        temp.pictureURL = @"http://pic4.nipic.com/20091028/735390_104541056365_2.jpg";
        temp.upCount = 3;
        temp.inventory = 43;
        [_commoditys addObject:temp];
    }
    
    _tableViewAdapter = [[CommodityTableViewAdapter alloc] init];
    _tableViewAdapter.commoditys = self.commoditys;
    _tableViewAdapter.adapterType = CommodityAdapterTypeNotBegin;
    _tableViewAdapter.cellID = @"notBeginCellID";
    
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    
    self.tableView.backgroundColor =  RGB(38.0f, 38.0f, 38.0f);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)insertRowAtTop:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
        Commodity *temp = [Commodity commodityWithName:@"来自下拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"http://tudou.com";
        temp.detrusionTime = @"00:00:05";
        temp.pictureURL = @"http://pic4.nipic.com/20091028/735390_104541056365_2.jpg";
        temp.upCount = 3;
        temp.inventory = 100;
        
        [self.commoditys insertObject:temp atIndex:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功加载%d条数据",1] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
            NSLog(@"tapped!");
            [alertBanner hide];
        }];
        banner.secondsToShow = 1.5f;
        [banner show];
    });
}

- (void)insertRowAtBottom:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        Commodity *temp = [Commodity commodityWithName:@"来自上拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"http://tudou.com";
        temp.detrusionTime = @"00:00:05";
        temp.pictureURL = @"http://pic4.nipic.com/20091028/735390_104541056365_2.jpg";
        temp.upCount = 3;
        temp.inventory = 23;
        
        [self.commoditys addObject:temp];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(self.commoditys.count - 1) inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

- (NSString *)tabImageName
{
    return @"icon_hourglass_normal.png";
}

- (NSString *)tabTitle
{
    return @"未开始";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
