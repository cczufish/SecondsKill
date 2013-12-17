//
//  CompareCostViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceViewController.h"
#import "ComparePriceTableViewCell.h"
#import "ComparePrice.h"

#define kComparePricePath @"http://api.box-z.com/api/search.ldo"
#define kPadding 5.0f
#define kSearchBGViewTag 8080

@interface ComparePriceViewController ()

@property (nonatomic, strong) NSMutableArray *commoditys;

@property (nonatomic, assign) int maxResult;
@property (nonatomic, assign) int begin;

@end

@implementation ComparePriceViewController

- (void)viewDidLoad
{
    self.canRefreshTableView = YES;
    
    [super viewDidLoad];
    
    self.maxResult = 50;
    self.begin = 0;
    
    if (IS_RUNNING_IOS7) {
        self.searchBar.barTintColor = NAV_BACKGROUND_COLOR;
    } else {
        self.searchBar.tintColor = NAV_BACKGROUND_COLOR;
    }
    
    self.commoditys = [NSMutableArray arrayWithCapacity:20];
    
    UIToolbar *keyBoardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    keyBoardBar.barStyle = UIBarStyleBlack;
    keyBoardBar.translucent = YES;
    
    BButton *okBtn = [BButton awesomeButtonWithOnlyIcon:FAIconOk color:[UIColor clearColor] style:BButtonStyleBootstrapV3];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];

    BButton *cancelBtn = [BButton awesomeButtonWithOnlyIcon:FAIconRemove color:[UIColor clearColor] style:BButtonStyleBootstrapV3];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *okBarBtn = [[UIBarButtonItem alloc] initWithCustomView:okBtn];
    UIBarButtonItem *spaceBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    keyBoardBar.items = @[cancelBarBtn, spaceBarBtn, okBarBtn];
    
    self.searchBar.inputAccessoryView = keyBoardBar;
    
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIImageView *backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-120/2, (SCREEN_HEIGHT-20-44-44-50)/2-100/2, 120, 100)];
    [backgroundIV setImage:[UIImage imageNamed:@"searchbg.png"]];
    backgroundIV.tag = kSearchBGViewTag;
    [self.tableView addSubview:backgroundIV];
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

#pragma mark -

- (void)ok:(id)sender
{
    [self searchCommodityByKeyWord:RefreshTableViewModeNone];
}

- (void)cancel:(id)sender
{
    [self.searchBar resignFirstResponder];
}

- (void)refresh:(RefreshTableViewMode)refreshMode
{
    if ([VNetworkHelper hasNetWork]) {
        __typeof (self) __weak weakSelf = self;
        
        weakSelf.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weakSelf.searchBar.text,@"keyword", [NSString stringWithFormat:@"%d",weakSelf.maxResult],@"maxResult",[NSString stringWithFormat:@"%d",weakSelf.begin],@"begin", nil];

        NSURL *url = [NSURL URLWithString:[weakSelf.params toURLString:kComparePricePath]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        if (refreshMode == RefreshTableViewModeNone) {
            [SVProgressHUD show];
        }

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refreshMode == RefreshTableViewModeNone) {
                    [SVProgressHUD dismiss];
                }
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([operation.response statusCode] == 200) {
                    NSMutableArray *commoditys = [[NSMutableArray alloc] initWithCapacity:20];
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                    NSArray *items = [[dict objectForKey:@"bean"] objectForKey:@"items"];

                    for (int i = 0; i < [items count]; i++) {
                        ComparePrice *temp = [[ComparePrice alloc] initWithDictionary:items[i] error:nil];
                        temp.price = temp.price/100;
                        
                        if (temp.vendorId > 0 && temp.vendorId < 8) {
                            [commoditys addObject:temp];
                        }
                    }

                    if (refreshMode == RefreshTableViewModePullUp) {
                        [self.commoditys addObjectsFromArray:commoditys];
                    }
                    else {
                        self.commoditys = commoditys;
                    }

                    if ([self.commoditys count] > 0) {
                        self.tableView.backgroundColor = RGBCOLOR(38.0f, 38.0f, 38.0f);
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                        [self.tableView viewWithTag:kSearchBGViewTag].hidden = YES;
                    }
                    else {
                        self.tableView.backgroundColor = [UIColor whiteColor];
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                        [self.tableView viewWithTag:kSearchBGViewTag].hidden = NO;
                    }
                    
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf endRefresh:[NSString stringWithFormat:@"成功请求%d条数据!", [commoditys count]] style:ALAlertBannerStyleNotify refreshMode:refreshMode];
                }
                else {
                    NSLog(@"%@",error);
                    [weakSelf endRefresh:@"数据请求失败，请重试!" style:ALAlertBannerStyleFailure refreshMode:refreshMode];
                }
                
                if (refreshMode == RefreshTableViewModeNone) {
                    [SVProgressHUD dismiss];
                }
            });
        }];
        
        [operation start];
    }
    else {
        [self endRefresh:NETWORK_ERROR style:ALAlertBannerStyleFailure refreshMode:refreshMode];
    }
}

- (void)pullDownRefresh
{
    [self searchCommodityByKeyWord:RefreshTableViewModePullDown];
}

- (void)pullUpRefresh
{
    self.begin += self.maxResult;
    [self refresh:RefreshTableViewModePullUp];
}

- (void)searchCommodityByKeyWord:(RefreshTableViewMode)refreshMode
{
    [self.searchBar resignFirstResponder];

    self.begin = 0;
    [self refresh:refreshMode];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComparePrice *commodity = [self.commoditys objectAtIndex:indexPath.row];
    
    CGSize size = [commodity.name sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(222.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = kPadding + size.height + kPadding + kPadding;
    
    return MAX(cellHeight, 65.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ComparePriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparePriceCellID"];
    
    ComparePrice *commodity = [self.commoditys objectAtIndex:indexPath.row];
    
    CGSize size = [commodity.name sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;
    
    cell.nameLabel.text = commodity.name;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g",commodity.price];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"vendor%d", commodity.vendorId]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
    webVC.navigationItem.title = self.navigationItem.title;
    
    ComparePrice *commodity = [self.commoditys objectAtIndex:indexPath.row];
    webVC.linkAddress = commodity.url;
    webVC.shareImage = [UIImage imageNamed:@"logo@2x.png"];
    webVC.shareText = [NSString stringWithFormat:@"#秒杀惠# %g元的%@，亮瞎了有木有? %@", commodity.price, self.searchBar.text, commodity.url];

    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchCommodityByKeyWord:RefreshTableViewModeNone];
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_handbag.png";
}

- (NSString *)tabTitle
{
    return @"去比价";
}

@end
