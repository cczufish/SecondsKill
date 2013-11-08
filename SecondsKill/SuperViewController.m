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

@end

@implementation SuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    _menus = [[NSArray alloc] initWithContentsOfFile:path];
    
    if (self.revealController == nil) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.revealController = (PKRevealController *) appDelegate.window.rootViewController;
    }

    self.navigationItem.title = @"秒杀惠";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];


    if (REUIKitIsFlatMode()) {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:RGB(199, 55, 33)];
    } else {
        self.navigationController.navigationBar.tintColor = RGB(199, 55, 33);
    }

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    if (self.needPullRefresh) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor orangeColor];
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新" attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];

        [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    }
    //下拉/上拉刷新设置
//    [self configRefreshView];
}

- (UIViewController *)currentViewController
{
    AKTabBarController *tabBarController = (AKTabBarController *)self.revealController.frontViewController;
    UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
    
    return navigationController.topViewController;
}

- (void)refreshTableView
{

}

- (void)configRefreshView
{
    __typeof (self) __weak weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop:weakSelf];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom:weakSelf];
    }];
    
    self.tableView.pullToRefreshView.arrowColor = [UIColor orangeColor];
    self.tableView.pullToRefreshView.textColor = [UIColor orangeColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    [self.tableView.pullToRefreshView setTitle:@"松开加载数据" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"数据加载中" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"下拉加载数据" forState:SVPullToRefreshStateStopped];
    //    [self.tableView.pullToRefreshView setSubtitle:@"时间" forState:SVPullToRefreshStateAll];
    
    self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName
{
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGB(170, 42, 25).CGColor;

    btn.titleLabel.font = [UIFont fontWithName:FONT_NAME size:14];
    
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

- (void)insertRowAtTop:(SuperViewController *)weakSelf
{

}

- (void)insertRowAtBottom:(SuperViewController *)weakSelf
{

}

//自动刷新
//- (void)viewDidAppear:(BOOL)animated {
//    [self.tableView triggerPullToRefresh];
//}

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
