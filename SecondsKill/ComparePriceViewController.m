//
//  CompareCostViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceViewController.h"
#import "SimpleCommodityTableViewCell.h"
#import "Commodity.h"

@interface ComparePriceViewController ()

@end

@implementation ComparePriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonStyle:rightBtn imageName:nil];
    [rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _commoditys = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i < 5; i ++) {
        NSString *name = [NSString stringWithFormat:@"商品%d", i];
        if (i == 0) {
            name = @"利用objective-c的category特性，修改UILabel的绘制代码。";
        }
        
        Commodity *temp = [Commodity commodityWithName:name source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"cocoachina.com";
        [_commoditys addObject:temp];
    }
    self.tableView.backgroundColor = RGB(38.0f, 38.0f, 38.0f);
    
    if (REUIKitIsFlatMode()) {
        [self.searchDisplayController.searchBar performSelector:@selector(setBarTintColor:) withObject:RGB(199, 55, 33)];
    } else {
        self.searchDisplayController.searchBar.tintColor = RGB(199, 55, 33);
    }
    
}


- (void)refresh
{
    NSLog(@"refresh");
}

- (void)insertRowAtTop:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
        Commodity *temp = [Commodity commodityWithName:@"来自下拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"http://tudou.com";
        [self.commoditys insertObject:temp atIndex:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:[NSString stringWithFormat:@"成功加载%d条数据",1] subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
            NSLog(@"tapped!");
            [alertBanner hide];
        }];
        banner.secondsToShow = 2.5f;
        [banner show];
    });
}

- (void)insertRowAtBottom:(SuperViewController *)weakSelf
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        Commodity *temp = [Commodity commodityWithName:@"来自上拉刷新" source:@"http://newsimages.mainone.com/2013-04/01153154889.png" price:100 killPrice:50];
        temp.link = @"http://tudou.com";
        [self.commoditys addObject:temp];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(self.commoditys.count - 1) inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
        
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SimpleCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCommodityCellID"];

    Commodity *temp = [self.commoditys objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [temp.name stringByAppendingString:@"\n "];;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", temp.price];
    [cell.sourceImg setImageWithURL:[NSURL URLWithString:temp.source] placeholderImage:nil];

    cell.commodity = temp;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
    webVC.navigationItem.title = self.navigationItem.title;
    Commodity *temp = [self.commoditys objectAtIndex:indexPath.row];
    webVC.linkAddress = temp.link;
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消当前行被选择后的样式
}

- (NSString *)tabImageName
{
    return @"icon_handbag_normal.png";
}

- (NSString *)tabTitle
{
    return @"去比价";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
