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
#import "ComparePriceViewController.h"
#import "ComparePrice.h"
#import "SVPullToRefresh.h"
#import "AKTabBarController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timers = [NSMutableArray arrayWithCapacity:20];
    
#warning image需要更换
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, -40, 30, 30)];
    [logoIV setImage:[UIImage imageNamed:@"icon_bell.png"]];
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
    if ([VNetworkHelper hasNetWork]) {
        UIViewController *vc = [self currentViewController];
        
        __typeof (self) __weak weakSelf = self;

        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:weakSelf.uri];
        
        [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([response statusCode] == 200) {
                    NSLog(@"%@",json);
                    NSMutableArray *commoditys = [[NSMutableArray alloc] initWithCapacity:20];
                    
                    if ([json count] > 0) {
                        for (int i = 0; i < [json count]; i++) {
                            if ([vc isKindOfClass:[KillingViewController class]] || [vc isKindOfClass:[NotBeginViewController class]]) {
                                Commodity *temp = [[Commodity alloc] initWithDictionary:json[i] error:nil];
                                temp.likingCount = [NSString stringWithFormat:@"%d",[[json[i] objectForKey:@"liking"] count]];
                                
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
                            else if ([vc isKindOfClass:[ComparePriceViewController class]]) {
                                ComparePrice *temp = [[ComparePrice alloc] initWithDictionary:json[i] error:nil];
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
    
                        [weakSelf endRefresh:[NSString stringWithFormat:@"成功请求%d条数据!", [json count]] style:ALAlertBannerStyleNotify refreshMode:refreshMode];
                    }
                    else {
                        if (refreshMode != RefreshTableViewModePullUp) {
                            if (callBack) {
                                callBack(commoditys);
                            }
                            
                            [weakSelf.tableView reloadData];
                        }
                        [weakSelf endRefresh:@"没有相关数据!" style:ALAlertBannerStyleWarning refreshMode:refreshMode];
                    }
                }
                else {
                    //-1004表示连接不上服务器，通常是因为没有网络造成，加载缓存数据
                    if ([error code] == -1004) {
                        [weakSelf loadDiskCacheDatas:refreshMode callBack:callBack];
                    }
                    else {
                        //401错误是因为没权限访问数据造成，在本应用中是因为session不存在，或session失效造成，此时模拟登录处理，以后弹出登录界面
                        if ([response statusCode] == 401) {
                            NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_KEY];
                            
                            if(deviceId != nil) {
                                NSDictionary *userInfo = @{@"phone_num": [APService openUDID], @"username": @"iOSUser", @"password": [AESCrypt encrypt:@"password" password:AES256_KEY], @"role": @2, @"deviceId": deviceId};
                                
                                [[UserManager shardInstance] login:[userInfo toJSONString:nil] completion:^(User *user, NSString *msg) {
                                    [weakSelf refreshTableView:refreshMode callBack:callBack];
                                }];
                            }
                        }
                        //后台提示不需要更新数据
                        else if ([response statusCode] == 304) {
                            [weakSelf endRefresh:@"没有新数据!" style:ALAlertBannerStyleNotify refreshMode:refreshMode];
                        }
                        else {
                            [weakSelf endRefresh:@"数据请求失败，请重试!" style:ALAlertBannerStyleFailure refreshMode:refreshMode];
                        }
                    }
                }
            });
        }];
    }
    else {
        [self loadDiskCacheDatas:refreshMode callBack:callBack];//没网，加载缓存数据
    }
}

- (void)loadDiskCacheDatas:(RefreshTableViewMode)refreshMode callBack:(RefreshTableViewCallBack)callBack
{
    NSURL *url = [NSURL URLWithString:self.uri];
    NSData *fileData = [NSData dataWithContentsOfFile:[[VURLCache shardInstance] cacheFileName:url]];

    if (fileData) {
        NSMutableArray *commoditys = [NSMutableArray arrayWithCapacity:20];
        NSArray * dic = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
        
        for (int i = 0; i < [dic count]; i++) {
            Commodity *temp = [[Commodity alloc] initWithDictionary:dic[i] error:nil];
            [commoditys addObject:temp];
        }
        
        if (callBack) {
            callBack(commoditys);
        }
        
        [self.tableView reloadData];
        
        [self endRefresh:@"正在加载本地缓存数据，该数据已过期!" style:ALAlertBannerStyleWarning refreshMode:refreshMode];
    }
    else {
        [self endRefresh:NETWORK_ERROR style:ALAlertBannerStyleFailure refreshMode:refreshMode];
    }

}

- (void)endRefresh:(NSString *)msg style:(ALAlertBannerStyle)style refreshMode:(RefreshTableViewMode)refreshMode
{
    if (refreshMode == RefreshTableViewModePullDown) {
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
            [VAlertHelper success:[NSString stringWithFormat:@"成功分享至%@!",[[response.data allKeys] objectAtIndex:0]]];
        }
    }
}

@end
