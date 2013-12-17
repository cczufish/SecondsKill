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
#import "ActivityWall.h"
#import "UserManager.h"
#import "KillingViewController.h"
#import "NotBeginViewController.h"
#import "ActivityWallViewController.h"
#import "SVPullToRefresh.h"
#import "AKTabBarController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timers = [NSMutableArray arrayWithCapacity:20];

//    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, -40, 30, 30)];
//    [logoIV setImage:[UIImage imageNamed:@"logo.png"]];
//    [self.tableView addSubview:logoIV];
    
    self.tableView.backgroundColor = RGBCOLOR(38.0f, 38.0f, 38.0f);
    
    if (self.revealController == nil) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        self.revealController = (PKRevealController *) appDelegate.window.rootViewController;
    }

    self.navigationController.navigationBar.translucent = NO;
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
            if (weakSelf.tableView.contentSize.height > SCREEN_HEIGHT) {
                [weakSelf pullUpRefresh];
            }
            else {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
            }
        }];
        
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    NSLog(@"------didReceiveMemoryWarning------");
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    __typeof (self) __weak weakSelf = self;
    
    if ([VNetworkHelper hasNetWork]) {
        //当NSUserDefaults中不存在session时，说明用户没登录过，所以在此注册并登录
        if ([[NSUserDefaults standardUserDefaults] objectForKey:SESSION_KEY] == nil) {
            NSDictionary *userInfo = @{@"phone_num": [APService openUDID], @"username": @"iOSUser", @"password": [AESCrypt encrypt:@"password" password:AES256_KEY], @"role": @2, @"deviceId": @"ios"};
            
            //获取不到session的原因有可能是因为用户注册过但没登录，在这种情况下会注册失败，此处不多做处理，等做注册登录界面功能后再做处理
            [[UserManager shardInstance] registerUser:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                
                //如果登录失败，session仍然会为空，所以下面请求数据时会出401错误，出401错误后会重新登录，以后有界面时会弹出登录界面，但此时不多做处理
                [[UserManager shardInstance] login:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                    NSLog(@"register and login.........");

                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:user.itemID forKey:USER_ID_KEY];
                    [userDefaults synchronize];

                    [weakSelf refreshTableView:refreshMode callBack:callBack];
                }];
            }];
        }
        else {
            UIViewController *vc = [self currentViewController];
            if ([vc isKindOfClass:[KillingViewController class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    KillingViewController *killingVC = (KillingViewController *)vc;
                    [killingVC showSortMenuView:nil];
                });
            }

            VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:weakSelf.uri];
            
            [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([response statusCode] == 200) {
//                        NSLog(@"%@",json);
                        NSMutableArray *commoditys = [[NSMutableArray alloc] initWithCapacity:20];
                        
                        if ([json count] > 0) {
                            for (int i = 0; i < [json count]; i++) {
                                if ([vc isKindOfClass:[KillingViewController class]] || [vc isKindOfClass:[NotBeginViewController class]]) {
                                    Commodity *temp = [[Commodity alloc] initWithDictionary:json[i] error:nil];
                                    
                                    if ([json[i] objectForKey:@"liking"]) {
                                        temp.likingCount = [NSString stringWithFormat:@"%d",[[json[i] objectForKey:@"liking"] count]];
                                    }
                                    else {
                                        temp.likingCount = @"0";
                                    }
                                    
                                    if ([VDataBaseHelper queryById:temp.itemID from:[temp tableName]]) {
                                        [VDataBaseHelper update:temp];
                                    }
                                    else {
                                        [VDataBaseHelper insert:temp];
                                    }
                                    
                                    [commoditys addObject:temp];
                                }
                                else if ([vc isKindOfClass:[ActivityWallViewController class]]) {
                                    ActivityWall *temp = [[ActivityWall alloc] initWithDictionary:json[i] error:nil];
                                    [commoditys addObject:temp];
                                }
                            }
                            
                            if (callBack) {
                                callBack(commoditys);
                            }
                            
                            if (refreshMode != RefreshTableViewModePullUp) {
                                [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                            [weakSelf endRefresh:[NSString stringWithFormat:@"更新成功!"] style:ALAlertBannerStyleNotify refreshMode:refreshMode];
                        }
                        else {
                            if (refreshMode != RefreshTableViewModePullUp) {
                                if (callBack) {
                                    callBack(commoditys);
                                }
                                
                                [weakSelf.tableView reloadData];
                            }
                            
                            [weakSelf endRefresh:@"没有啦~" style:ALAlertBannerStyleWarning refreshMode:refreshMode];
                        }
                    }
                    else {
                        NSLog(@"%@",error);
                        if ([error code] == -1004) {
                            [self loadDiskCacheDatas:refreshMode callBack:callBack];//没网，加载缓存数据
                        }
                        else {
                            //401错误是因为没权限访问数据造成，在本应用中是因为session不存在，或session失效造成，此时模拟登录处理，以后弹出登录界面
                            if ([response statusCode] == 401) {
                                NSDictionary *userInfo = @{@"phone_num": [APService openUDID], @"username": @"iOSUser", @"password": [AESCrypt encrypt:@"password" password:AES256_KEY], @"role": @2, @"deviceId": @"ios"};
                                
                                [[UserManager shardInstance] login:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                                    NSLog(@"register and login.........");
                                    [weakSelf refreshTableView:refreshMode callBack:callBack];
                                }];
                            }
                            //后台提示不需要更新数据
                            else if ([response statusCode] == 304) {
                                [weakSelf endRefresh:@"没有啦~" style:ALAlertBannerStyleNotify refreshMode:refreshMode];
                            }
                            else {
                                [weakSelf endRefresh:NETWORK_ERROR style:ALAlertBannerStyleFailure refreshMode:refreshMode];
                            }
                        }
                    }
                });
            }];

        }
    }
    else {
        [self loadDiskCacheDatas:refreshMode callBack:callBack];//没网，加载缓存数据
    }
}

- (void)loadDiskCacheDatas:(RefreshTableViewMode)refreshMode callBack:(RefreshTableViewCallBack)callBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:self.uri];
        
        NSData *fileData = [NSData dataWithContentsOfFile:[[VURLCache shardInstance] cacheFileName:url]];
        
        if (fileData) {
            NSMutableArray *commoditys = [NSMutableArray arrayWithCapacity:20];
            NSArray *dic = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
 
            for (int i = 0; i < [dic count]; i++) {
                Commodity *temp = [[Commodity alloc] initWithDictionary:dic[i] error:nil];
                [commoditys addObject:temp];
            }
            
            if (callBack) {
                callBack(commoditys);
            }
            
            if (refreshMode != RefreshTableViewModePullUp) {
                [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            }
            
            [self.tableView reloadData];
            
            [self endRefresh:@"正在加载本地缓存数据，该数据已过期!" style:ALAlertBannerStyleWarning refreshMode:refreshMode];
        }
        else {
            if (callBack) {
                callBack(nil);
            }
            [self endRefresh:NETWORK_ERROR style:ALAlertBannerStyleFailure refreshMode:refreshMode];
        }
    });
}

- (void)endRefresh:(NSString *)msg style:(ALAlertBannerStyle)style refreshMode:(RefreshTableViewMode)refreshMode
{
    if (refreshMode == RefreshTableViewModePullDown || refreshMode == RefreshTableViewModeNone) {
        [self.refreshControl endRefreshing];
        
        if (style == ALAlertBannerStyleNotify) {
            [VAlertHelper success:msg];
        }
        else {
            [VAlertHelper fail:msg style:style];
        }
    }
    else {
        [self.tableView.infiniteScrollingView stopAnimating];
        
        if (style == ALAlertBannerStyleNotify) {
            [VAlertHelper success:msg position:ALAlertBannerPositionBottom];
        }
        else {
            [VAlertHelper alert:msg style:style position:ALAlertBannerPositionBottom];
        }
    }
}

#pragma mark - 需要子类重写的方法

- (void)pullDownRefresh
{
    self.pageNO = 1;
    [self.params setObject:@"1" forKey:@"page"];
    [self.params setObject:[[self defaultQL] base64EncodedString] forKey:@"ql"];
    self.uri = [self.params toURLString:DEFAULT_URI];
}

- (void)pullUpRefresh
{
    [self.params setObject:[NSString stringWithFormat:@"%d",++self.pageNO] forKey:@"page"];
    [self.params setObject:[[self defaultQL] base64EncodedString] forKey:@"ql"];
    self.uri = [self.params toURLString:DEFAULT_URI];
}

- (NSString *)defaultQL
{
    return @"";
}

#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseType == UMSResponseShareToMutilSNS) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            [VAlertHelper success:[NSString stringWithFormat:@"分享成功!"]];
        }
    }
}

@end
