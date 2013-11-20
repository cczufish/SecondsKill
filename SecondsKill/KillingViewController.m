//
//  KillingViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "KillingViewController.h"
#import "CommodityTableViewAdapter.h"

@interface KillingViewController ()

@property (nonatomic, strong) NSMutableArray *entities;

@property (nonatomic, strong) NSString *cursor;

@property (nonatomic, strong) CommodityTableViewAdapter *tableViewAdapter;
@property (nonatomic, strong) REMenu *menu;

@end

@implementation KillingViewController

- (void)requestDatas:(NSString *)queryString
{
    [self.refreshControl beginRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ApigeeClientResponse *clientResponse = [APIGeeHelper requestByQL:queryString];
        if([clientResponse completedSuccessfully]) {
            self.entities = (NSMutableArray *) clientResponse.entities;
            self.cursor = clientResponse.cursor;
            
            self.tableViewAdapter.commoditys = self.entities;
            NSLog(@"%@",clientResponse.rawResponse);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            
            [AlertHelper success:[NSString stringWithFormat:@"%d条新数据", 20] inView:self.view];
        });
    });
}

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, -40, 30, 30)];
    [imageview setImage:[UIImage imageNamed:@"btn_hui.png"]];
    [self.tableView addSubview:imageview];

    
    self.entities = [NSMutableArray arrayWithCapacity:20];
    
    // and cate='家居/家装/厨具/汽配'
    [self requestDatas:@"select * where site='jd' and remain>0 order by end_t asc&limit=10"];
    
    
    _seletedMenuItems = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];
    for (int i = 0; i < [self.menus count]; i++) {
        [self.seletedMenuItems addObject:[self.menus[i] objectAtIndex:1]];//放title为“全部“的菜单设置为默认选择菜单
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectMenu)];
    
    
    //
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(selectMenu)];
    //
    
    UIBarButtonItem *timeSortItem = [[UIBarButtonItem alloc] initWithTitle:@"时间" style:UIBarButtonItemStylePlain target:self action:@selector(xx)];
    UIBarButtonItem *discountSortItem = [[UIBarButtonItem alloc] initWithTitle:@"折扣" style:UIBarButtonItemStylePlain target:self action:@selector(xx)];
    self.navigationItem.rightBarButtonItems = @[timeSortItem, discountSortItem];
    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self setButtonStyle:leftBtn imageName:@"down_arrow.png"];
//    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(selectMenu) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self setButtonStyle:rightBtn imageName:@"down_arrow.png"];
//    [rightBtn setTitle:@"按时间" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(showDownMenu:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    //下拉菜单设置
//    [self configDownMenu];
    
    _tableViewAdapter = [[CommodityTableViewAdapter alloc] init];
    _tableViewAdapter.commoditys = self.entities;
    _tableViewAdapter.adapterType = CommodityAdapterTypeKilling;
    _tableViewAdapter.cellID = @"killingCellID";
    
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)xx{}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"秒杀中\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"秒杀中\"界面"];
}

//from menu
- (void)refreshCommoditys
{
    NSLog(@"%@",self.seletedMenuItems);
//ps://www.athui.com/athui/sandbox/promotions?ql=select%20*%20&limit=2
    [self requestDatas:@"select * order by end_t asc&limit=3"];
}

- (void)refreshTableView
{
     [self requestDatas:@"select * order by end_t asc&limit=3"];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
////        Commodity *temp = [Commodity commodityWithName:@"来自下拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
////        temp.link = @"http://tudou.com";
////        temp.surplus = @"00:00:05";
////        temp.pictureURL = @"http://pic4.nipic.com/20091028/735390_104541056365_2.jpg";
////        temp.upCount = 3;
////        temp.alreadyOrder = 100;
////        
////        [self.commoditys insertObject:temp atIndex:0];
////        [NSThread sleepForTimeInterval:2];
//       dispatch_async(dispatch_get_main_queue(), ^{
////            [self.refreshControl endRefreshing];
//////            self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
////            
////            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
////            //    [self.tableView reloadData];
////            
//            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功加载%d条数据", 1] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//                [alertBanner hide];
//            }];
//            banner.secondsToShow = ALERT_SHOW_SECONDS;
//            [banner show];
//        });
//   });
}

#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [AlertHelper sharedUMSocialSuccess:response inView:self.view];
}

- (void)selectMenu
{
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)configDownMenu
{
    REMenuItem *sortTime = [[REMenuItem alloc] initWithTitle:@"按时间"
                                                       image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                       }];
    
    REMenuItem *sortXX = [[REMenuItem alloc] initWithTitle:@"按折扣"
                                                     image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[sortTime, sortXX]];
    
    self.menu.itemHeight = 30.0f;
    self.menu.backgroundColor = [UIColor lightGrayColor];
    self.menu.font = DEFAULT_FONT;
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
- (void)insertRowAtBottom:(SuperViewController *)weakSelf {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
//        Commodity *temp = [Commodity commodityWithName:@"来自上拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
//        temp.link = @"http://tudou.com";
//        temp.surplus = @"00:00:05";
//        temp.pictureURL = @"http://pic4.nipic.com/20091028/735390_104541056365_2.jpg";
//        temp.upCount = 3;
//        temp.alreadyOrder = 23.6;
//        
//        [self.commoditys addObject:temp];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(self.commoditys.count - 1) inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
//        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_energy_normal.png";
}

- (NSString *)tabTitle
{
    return @"秒杀中";
}

@end
