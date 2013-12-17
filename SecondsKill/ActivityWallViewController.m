//
//  ActivityWallViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ActivityWallViewController.h"
#import "ActivityWallTableViewCell.h"
#import "ActivityWall.h"

#define kActivityWallPath @"promotions"
#define kStartTimeLabelHeight 20.0f
#define kSourceImgHeight 44.0f
#define kPadding 5.0f

@interface ActivityWallViewController ()

@property (nonatomic, strong) NSMutableArray *activitys;

@end

@implementation ActivityWallViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BButton *refreshBtn = [BButton awesomeButtonWithOnlyIcon:FAIconRepeat color:[UIColor clearColor] style:BButtonStyleBootstrapV3];//V2有阴影
    refreshBtn.titleLabel.textColor = [UIColor whiteColor];
    refreshBtn.showsTouchWhenHighlighted = YES;
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];

    self.activitys = [NSMutableArray arrayWithCapacity:20];
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"created_at",@"sort",@"desc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page",@"ActivityWallViewController",@"model", nil];
    self.uri = [self.params toURLString:kActivityWallPath];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.activitys = datas;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick beginLogPageView:@"\"活动墙\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"\"活动墙\"界面"];
}

#pragma mark -

- (void)refresh
{
    self.pageNO = 1;
    [self.params setObject:@"1" forKey:@"page"];
    self.uri = [self.params toURLString:kActivityWallPath];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.activitys = datas;
        [SVProgressHUD dismiss];
    }];
}

- (void)pullDownRefresh
{
    self.pageNO = 1;
    [self.params setObject:@"1" forKey:@"page"];
    self.uri = [self.params toURLString:kActivityWallPath];
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.activitys = datas;
    }];
}

- (void)pullUpRefresh
{
    [self.params setObject:[NSString stringWithFormat:@"%d",++self.pageNO] forKey:@"page"];
    self.uri = [self.params toURLString:kActivityWallPath];
    
    [self refreshTableView:RefreshTableViewModePullUp callBack:^(NSMutableArray *datas) {
        [self.activitys addObjectsFromArray:datas];
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.activitys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityWall *activity = [self.activitys objectAtIndex:indexPath.row];

    CGSize size = [activity.title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(265.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = kPadding + MAX(size.height, 30) + kPadding + kStartTimeLabelHeight + kPadding;

    return MAX(cellHeight, 60.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ActivityWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityWallCellID"];
    
    ActivityWall *activity = [self.activitys objectAtIndex:indexPath.row];
    
    CGSize size = [activity.title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;
    
    cell.nameLabel.text = activity.title;
    
    CGRect createTimeLabelRect = cell.createTimeLabel.frame;
    createTimeLabelRect.origin.y = newRect.origin.y + MAX(newRect.size.height, 30) + kPadding;
    cell.createTimeLabel.frame = createTimeLabelRect;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[activity.created_at doubleValue]/1000];
    cell.createTimeLabel.text = [VDateTimeHelper formatDateToString:createDate];
    
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",activity.site]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
    webVC.navigationItem.title = self.navigationItem.title;
    
    ActivityWall *activity = [self.activitys objectAtIndex:indexPath.row];
    webVC.linkAddress = activity.link;
    webVC.shareImage = [UIImage imageNamed:@"logo@2x.png"];
    webVC.shareText = [NSString stringWithFormat:@"#秒杀惠# %@，赶紧来围观吧! %@", activity.title, activity.link];

    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_calendar.png";
}

- (NSString *)tabTitle
{
    return @"活动墙";
}

@end
