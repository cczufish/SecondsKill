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
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pullDownRefresh)];
    
    self.activitys = [NSMutableArray arrayWithCapacity:20];
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"created_at",@"sort",@"desc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page", nil];
    self.uri = GenerateURLString(kActivityWallPath, self.params);
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.activitys = datas;
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

//下拉刷新
- (void)pullDownRefresh
{
    self.pageNO = 1;
    [self.params setObject:@"1" forKey:@"page"];
    self.uri = GenerateURLString(kActivityWallPath, self.params);
    
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.activitys = datas;
    }];
}

//上拉刷新
- (void)pullUpRefresh
{
    [self.params setObject:[NSString stringWithFormat:@"%d",++self.pageNO] forKey:@"page"];
    self.uri = GenerateURLString(kActivityWallPath, self.params);
    
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
    CGFloat cellHeight = kPadding + MAX(size.height, kSourceImgHeight) + kPadding + kStartTimeLabelHeight + kPadding;
    
    return MAX(cellHeight, 70.0f);
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
    createTimeLabelRect.origin.y = newRect.origin.y + MAX(newRect.size.height, kSourceImgHeight) + kPadding;
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
    
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_calendar_normal.png";
}

- (NSString *)tabTitle
{
    return @"活动墙";
}

@end
