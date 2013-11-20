//
//  ActivityWallViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ActivityWallViewController.h"
#import "ActivityWallTableViewCell.h"

#define kPadding 5.0f

@interface ActivityWallViewController ()
@property (nonatomic, strong) NSMutableArray *entities;

@property (nonatomic, strong) NSString *cursor;
@property (nonatomic, strong) NSString *queryString;
@end

@implementation ActivityWallViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self setButtonStyle:rightBtn imageName:nil];
//    [rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(requestDatas) forControlEvents:UIControlEventTouchUpInside];
//    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestDatas)];
    
    self.entities = [NSMutableArray arrayWithCapacity:20];
    self.queryString = @"select * order by end_t asc&limit=3";
    
    [self requestDatas];
}

- (void)requestDatas
{
    ApigeeClientResponse *clientResponse = [APIGeeHelper requestByQL:self.queryString];
    
    if([clientResponse completedSuccessfully]) {
        self.entities = (NSMutableArray *) clientResponse.entities;
        self.cursor = clientResponse.cursor;
        
        NSLog(@"rawResponse = %@",clientResponse.rawResponse);
        [self.tableView reloadData];
    }
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

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.entities count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApigeeEntity *entity = [self.entities objectAtIndex:indexPath.row];
    
    NSString *title = [entity getStringProperty:@"title"];
    
    CGSize size = [title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(265.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    return kPadding + size.height + kPadding + 20.0f + kPadding;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ActivityWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityWallCellID"];

    ApigeeEntity *entity = [self.entities objectAtIndex:indexPath.row];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[entity getStringProperty:@"site"]]];
    
    NSString *title = [entity getStringProperty:@"title"];
    
    CGSize size = [title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;

    cell.nameLabel.text = title;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    CGRect startTimeLabelRect = cell.startTimeLabel.frame;
    startTimeLabelRect.origin.y = newRect.origin.y + newRect.size.height + kPadding;
    
    cell.startTimeLabel.frame = startTimeLabelRect;
    cell.startTimeLabel.text = [fmt stringFromDate:[NSDate date]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
    webVC.navigationItem.title = self.navigationItem.title;
    
    ApigeeEntity *entity = [self.entities objectAtIndex:indexPath.row];
    webVC.linkAddress = [entity getStringProperty:@"link"];
    
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消当前行被选择后的样式
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
