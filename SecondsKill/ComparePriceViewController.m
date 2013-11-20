//
//  CompareCostViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceViewController.h"
#import "ComparePriceTableViewCell.h"

#define kPadding 5.0f;

@interface ComparePriceViewController ()
@property (nonatomic, strong) NSMutableArray *entities;

@property (nonatomic, strong) NSString *cursor;
@property (nonatomic, strong) NSString *queryString;
@end

@implementation ComparePriceViewController
//一开始不加载数据
- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"搜索";
    
    /*
    @property (nonatomic, readwrite, retain) UIView *inputAccessoryView
   */
    
 
    self.entities = [NSMutableArray arrayWithCapacity:20];

        
    if (REUIKitIsFlatMode()) {
        self.searchBar.barTintColor = RGB(199, 55, 33);
    } else {
        self.searchBar.tintColor = RGB(199, 55, 33);
    }
}

- (void)requestDatas:(NSString *)queryString
{
    ApigeeClientResponse *clientResponse = [APIGeeHelper requestByQL:queryString];
    
    if([clientResponse completedSuccessfully]) {
        self.entities = (NSMutableArray *) clientResponse.entities;
        self.cursor = clientResponse.cursor;
        self.queryString = queryString;
        NSLog(@"rawResponse = %@",clientResponse.rawResponse);
        [self.tableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick beginLogPageView:@"\"去比价\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"\"去比价\"界面"];
}




- (void)insertRowAtTop:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
//        Commodity *temp = [Commodity commodityWithName:@"来自下拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
//        temp.link = @"http://tudou.com";
//        [self.commoditys insertObject:temp atIndex:0];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
//        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
//        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功加载%d条数据",1] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//            NSLog(@"tapped!");
//            [alertBanner hide];
//        }];
//        banner.secondsToShow = 2;
//        [banner show];
    });
}

- (void)insertRowAtBottom:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
//        Commodity *temp = [Commodity commodityWithName:@"来自上拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
//        temp.link = @"http://tudou.com";
//        [self.commoditys addObject:temp];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(self.commoditys.count - 1) inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
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
    
    CGSize size = [title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(240.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = size.height + kPadding;
    return MAX(cellHeight, 80.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ComparePriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparePriceCellID"];
    
    ApigeeEntity *entity = [self.entities objectAtIndex:indexPath.row];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[entity getStringProperty:@"site"]]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", [entity getFloatProperty:@"m_price"]];
    NSString *title = [entity getStringProperty:@"title"];

    CGSize size = [title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;
    
    cell.nameLabel.text = title;

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self requestDatas:@"select * order by end_t asc&limit=3"];
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_handbag_normal.png";
}

- (NSString *)tabTitle
{
    return @"去比价";
}

@end
