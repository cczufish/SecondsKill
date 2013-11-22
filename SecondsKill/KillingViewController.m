//
//  KillingViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "KillingViewController.h"
#import "CommodityTableViewAdapter.h"
#import "Commodity.h"

@interface KillingViewController ()

@property (nonatomic, copy) NSArray *commoditys;
@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) CommodityTableViewAdapter *tableViewAdapter;

@end

@implementation KillingViewController
{
    int currentPage;
}

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
    self.commoditys = [NSMutableArray arrayWithCapacity:20];

    self.seletedMenuItems = [NSMutableArray arrayWithCapacity:[self.menus count]];
    for (int i = 0; i < [self.menus count]; i++) {
        [self.seletedMenuItems addObject:[self.menus[i] objectAtIndex:1]];//将title为“全部“的菜单项设置为默认选择菜单
    }

    _tableViewAdapter = [[CommodityTableViewAdapter alloc] init];
    _tableViewAdapter.commoditys = self.commoditys;
    _tableViewAdapter.adapterType = CommodityAdapterTypeKilling;
    _tableViewAdapter.cellID = @"killingCellID";
    
    self.tableView.delegate = _tableViewAdapter;
    self.tableView.dataSource = _tableViewAdapter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.uri = [NSString stringWithFormat:@"msitems?ql=%@&sort=end_t&order=desc&size=20&page=1",[@"remain>0" base64EncodedString]];
    [self refreshTableView];
    {
    /*//毫秒转化为时间格式
     -(NSString *)getTimeFromMarkTime:(NSString *)markTime
     {
     NSTimeInterval time = [markTime doubleValue]/1000;
     NSDateFormatter * fmatre = [[NSDateFormatter alloc] init];
     [fmatre setDateFormat:@"MM-dd HH:mm:ss"];
     NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
     NSString * stri = [fmatre stringFromDate:date];
     //NSLog(@"time = %@",stri);//输入的时间
     return stri;
     }
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     
     [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
     
     [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
     
     //[dateFormatter setDateFormat:@"hh:mm:ss"]
     
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
     
     NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
     
     [dateFormatter release];   // CFTimeInterval CFAbsoluteTimeGetCurrent();
     //NSDateFormatter *nsdf2=[[[NSDateFormatter alloc] init]autorelease];   [nsdf2 setDateStyle:NSDateFormatterShortStyle];   [nsdf2 setDateFormat:@"YYYYMMDDHHmmssSSSS"];   NSString *t2=[nsdf2 stringFromDate:[NSDate date]];   long curr=[t2 longLongValue];
     */
    }
}

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

#pragma mark -

- (void)refreshTableView
{
    if ([VNetworkHelper hasNetWork]) {
        [self.refreshControl beginRefreshing];
        
        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:self.uri];
        [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (json && [response statusCode] == 200) {
                    NSLog(@"%@",json);
                    
                    NSArray *ary = (NSArray *)json;
                    
                    for (int i = 0; i < [ary count]; i++) {
                        Commodity *temp = [[Commodity alloc] initWithDictionary:ary[i] error:nil];
                        
                        NSLog(@"%@",[temp autoDescribe]);
                    }
                    
//                    NSString* json = (fetch here JSON from Internet) ...
//                    NSError* err = nil;
//                    CountryModel* country = [[CountryModel alloc] initWithString:json error:&err];
                    
                    //                self.entities = (NSMutableArray *) clientResponse.entities;
                    //                self.cursor = clientResponse.cursor;
                    //
                    //                self.tableViewAdapter.commoditys = self.entities;
                    
                    [self.refreshControl endRefreshing];
                    
                    [self.tableView reloadData];
                    
                    [VAlertHelper requestDataSuccess:self.view];
                }
                else {
                    [VAlertHelper requestDataException:self.view];
                    NSLog(@"error = %@",error);
                }
            });
        }];
        //msitems?ql=start_t<234235325 and end_t>3525235 and remain>0 and site=jd&sort=created_at&order=asc/desc&size=20&page=1
        //promotions?ql=&size
        //String str = "start_t<234235325 and end_t>3525235 and remain>0 and site=jd";
        ///msitems?ql=Base64.encode(str)&size

    }
    else {
        [VAlertHelper netWorkException:self.view];
    }
}

//from menu
- (void)selectCommoditys:(NSString *)ql 
{
    self.uri = [NSString stringWithFormat:@"msitems?ql=%@&sort=end_t&order=desc&size=20&page=1",[ql base64EncodedString]];
    [self refreshTableView];
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

#pragma mark - UMSocialUIDelegate

//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [VAlertHelper sharedUMSocialSuccess:response inView:self.view];
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
