//
//  SuperViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "AppDelegate.h"

@interface SuperViewController ()

@property (nonatomic, strong) REMenu *sortMenu;

@end

@implementation SuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, -40, 30, 30)];
    [logoIV setImage:[UIImage imageNamed:@"btn_hui.png"]];
    [self.tableView addSubview:logoIV];
    
    self.tableView.backgroundColor = RGB(38.0f, 38.0f, 38.0f);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    _menus = [[NSArray alloc] initWithContentsOfFile:path];
    
    if (self.revealController == nil) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.revealController = (PKRevealController *) appDelegate.window.rootViewController;
    }

    self.navigationItem.title = @"秒杀惠";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (!REUIKitIsFlatMode()) {
        self.navigationController.navigationBar.tintColor = RGB(199, 55, 33);
    }
 
    
    //下/上拉刷新
    if (self.canRefreshTableView) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor orangeColor];
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新" attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];

        [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
   
        __typeof (self) __weak weakSelf = self;
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom:weakSelf];
        }];
        
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    if (YES) {
        //初始化导航条内容
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuViewController)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_sort.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showDownMenu:)];
        
        [self configDownMenu];//下拉菜单设置
    }
}

- (UIViewController *)currentViewController
{
    AKTabBarController *tabBarController = (AKTabBarController *)self.revealController.frontViewController;
    UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
    
    return navigationController.topViewController;
}

//- (void)requestDatas:(NSString *)ql
//{
//    [self.refreshControl beginRefreshing];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ApigeeClientResponse *clientResponse = [APIGeeHelper requestByQL:ql];
//        if([clientResponse completedSuccessfully]) {
//            self.entities = (NSMutableArray *) clientResponse.entities;
//            self.cursor = clientResponse.cursor;
//            
//            self.tableViewAdapter.commoditys = self.entities;
//            NSLog(@"%@",clientResponse.rawResponse);
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.refreshControl endRefreshing];
//            [self.tableView reloadData];
//            
//            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"%d条新数据", 20] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//                [alertBanner hide];
//            }];
//            banner.secondsToShow = ALERT_SHOW_SECONDS;
//            [banner show];
//        });
//    });
//}
- (void)refreshTableView
{

}

- (void)insertRowAtBottom:(SuperViewController *)weakSelf
{
    
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName
{
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGB(170, 42, 25).CGColor;

    btn.titleLabel.font = DEFAULT_FONT;
    
    if (imageName) {
        btn.frame = CGRectMake(0, 0, 90, 30);
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 55.0, 0.0, 0.0)];
        [btn setImage:[[UIImage imageNamed:imageName] imageWithNewSize:CGSizeMake(8, 5)] forState:UIControlStateNormal];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
    }
    else {
        btn.frame = CGRectMake(0, 0, 50, 30);
    }
}


- (void)configDownMenu
{
    REMenuItem *sortTime = [[REMenuItem alloc] initWithTitle:@"按结束时间排序"
                                                       image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                       }];
    
    REMenuItem *sortXX = [[REMenuItem alloc] initWithTitle:@"按折扣大小排序"
                                                     image:nil highlightedImage:nil action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                     }];
    
    self.sortMenu = [[REMenu alloc] initWithItems:@[sortTime, sortXX]];
    
    self.sortMenu.itemHeight = 30.0f;
    self.sortMenu.backgroundColor = [UIColor lightGrayColor];
    self.sortMenu.font = DEFAULT_FONT;
    self.sortMenu.textColor = [UIColor whiteColor];
    self.sortMenu.textShadowColor = [UIColor clearColor];
}


- (void)showDownMenu:(UIButton *)sender
{
    if (self.sortMenu.isOpen) {
        [self.sortMenu close];
    }
    else {
        CGRect menuRect = sender.frame;
        menuRect.size.height *= 2;
        [self.sortMenu showFromRect:menuRect inView:self.view];
    }
}

- (void)showMenuViewController
{
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
