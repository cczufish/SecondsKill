//
//  CompareCostViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceViewController.h"
#import "ComparePriceTableViewCell.h"
#import "Commodity.h"

#define kComparePricePath @"msitems"
#define kPadding 5.0f
#define kSearchBGViewTag 8080

@interface ComparePriceViewController ()

@property (nonatomic, strong) NSMutableArray *commoditys;

@end

@implementation ComparePriceViewController
//http://api.box-z.com/api/search.ldo?keyword=%E8%8B%B9%E6%9E%9C&maxResult=10&begin=0
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_RUNNING_IOS7) {
        self.searchBar.barTintColor = NAV_BACKGROUND_COLOR;
    } else {
        self.searchBar.tintColor = NAV_BACKGROUND_COLOR;
    }
    
    self.commoditys = [NSMutableArray arrayWithCapacity:20];
    
    self.pageNO = 1;
    self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"created_at",@"sort",@"desc",@"order",[NSString stringWithFormat:@"%d",DEFAULT_PAGE_SIZE],@"size",@"1",@"page", nil];
    self.uri = [self.params toURLString:kComparePricePath];
    
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
    [self searchCommodityByKeyWord:self.searchBar.text];
}

- (void)cancel:(id)sender
{
    [self.searchBar resignFirstResponder];
}

- (void)searchCommodityByKeyWord:(NSString *)keyWord
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [[self.tableView viewWithTag:kSearchBGViewTag] removeFromSuperview];
    
    [self.searchBar resignFirstResponder];
    
    [SVProgressHUD show];
    [self refreshTableView:RefreshTableViewModePullDown callBack:^(NSMutableArray *datas) {
        self.commoditys = datas;
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    
    CGSize size = [commodity.title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(222.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = kPadding + size.height + kPadding;
    
    return MAX(cellHeight, 65.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ComparePriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparePriceCellID"];
    
    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    
    CGSize size = [commodity.title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;
    
    cell.nameLabel.text = commodity.title;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g",commodity.price];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%@", commodity.site]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
    webVC.navigationItem.title = self.navigationItem.title;
    
    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    webVC.linkAddress = commodity.link;
    
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchCommodityByKeyWord:self.searchBar.text];
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
