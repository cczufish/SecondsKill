//
//  SuperViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"
#import "AppDelegate.h"
#import "Commodity.h"

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
    
    self.tableView.backgroundColor = RGBCOLOR(38.0f, 38.0f, 38.0f);
    
    if (self.revealController == nil) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        self.revealController = (PKRevealController *) appDelegate.window.rootViewController;
    }

    self.navigationItem.title = @"秒杀惠";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (!IS_RUNNING_IOS7) {
        self.navigationController.navigationBar.tintColor = NAV_BACKGROUND_COLOR;
    }
 
    if (self.canRefreshTableView) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor orangeColor];
        [self.refreshControl addTarget:self action:@selector(pullDownRefresh) forControlEvents:UIControlEventValueChanged];
   
        __typeof (self) __weak weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf pullUpRefresh];
        }];
        
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    if (self.canShowMenuViewController) {
        BButton *menuBtn = [BButton awesomeButtonWithOnlyIcon:FAIconReorder color:[UIColor clearColor] style:BButtonStyleBootstrapV3];//V2有阴影
        menuBtn.titleLabel.textColor = [UIColor whiteColor];
        [menuBtn addTarget:self action:@selector(showMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        
        BButton *sortBtn = [BButton awesomeButtonWithOnlyIcon:FAIconSort color:[UIColor clearColor] style:BButtonStyleBootstrapV3];
        sortBtn.titleLabel.textColor = [UIColor whiteColor];
        [sortBtn addTarget:self action:@selector(showSortMenuView:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
        
        [self configSortMenuView];
    }
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
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark -

- (UIViewController *)currentViewController
{
    AKTabBarController *tabBarController = (AKTabBarController *)self.revealController.frontViewController;
    UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
    
    return navigationController.topViewController;
}

- (void)showMenuViewController
{
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)refreshTableView:(RefreshTableViewMode)refreshMode callBack:(RefreshTableViewCallBack)callBack
{
    if ([VNetworkHelper hasNetWork]) {
        __typeof (self) __weak weakSelf = self;
        
        if (refreshMode == RefreshTableViewModePullDown) {
            [self.refreshControl beginRefreshing];
        }
        else {
            [weakSelf.tableView.infiniteScrollingView startAnimating];
        }
        
        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:self.uri];
        
        [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([response statusCode] == 200) {
                    NSLog(@"%@",json);
                    
                    if ([json count] > 0) {
                        NSMutableArray *commoditys = [NSMutableArray arrayWithCapacity:20];
                        
                        for (int i = 0; i < [json count]; i++) {
                            Commodity *temp = [[Commodity alloc] initWithDictionary:json[i] error:nil];
                            [commoditys addObject:temp];
                        }
                        
                        if (callBack) {
                            callBack(commoditys);
                        }
                        
                        [weakSelf.tableView reloadData];
                        
                        [VAlertHelper success:[NSString stringWithFormat:@"成功请求%d条数据!", [json count]]];
                    }
                    else {
                        [VAlertHelper success:@"没有更多数据!"];
                    }
                }
                else {
                    [VAlertHelper fail:@"数据请求失败，请重试!"];
                }
                
                if (refreshMode == RefreshTableViewModePullDown) {
                    [weakSelf.refreshControl endRefreshing];
                }
                else {
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
            });
        }];
    }
    else {
        [VAlertHelper fail:@"网络异常！"];
    }
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName
{
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGBCOLOR(170, 42, 25).CGColor;
    
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

#pragma mark - 需要子类重写的方法

//下拉刷新
- (void)pullDownRefresh{}

//上拉刷新
- (void)pullUpRefresh{}

#pragma mark - 菜单

- (void)configSortMenuView
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


- (void)showSortMenuView:(UIButton *)sender
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
#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseType == UMSResponseShareToMutilSNS) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            [VAlertHelper success:[NSString stringWithFormat:@"成功分享至%@!",[[response.data allKeys] objectAtIndex:0]]];
        }
    }
}

@end
