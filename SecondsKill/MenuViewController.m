//
//  MenuViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "KillingViewController.h"
#import "NotBeginViewController.h"
#import "UIButton+MenuItem.h"

#define kHeightForSectionHeader 30.0f

@interface MenuViewController ()

- (void)resetMenuItemStatus;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分类导航";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMenuItemDefaultBGColor;
    
    _allMenuItems = [[NSMutableSet alloc] initWithCapacity:50];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self resetMenuItemStatus];
    
    [MobClick beginLogPageView:@"\"分类导航\"界面"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIViewController *vc = [self currentViewController];
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        KillingViewController *killingVC = (KillingViewController *) vc;
        [killingVC refreshCommoditys];
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        NotBeginViewController *notBeginVC = (NotBeginViewController *) vc;
        [notBeginVC refreshCommoditys];
    }
    
    [MobClick endLogPageView:@"\"分类导航\"界面"];
}

- (void)resetMenuItemStatus
{
    UIViewController *vc = [self currentViewController];
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        KillingViewController *killingVC = (KillingViewController *) vc;
        self.seletedMenuItems = killingVC.seletedMenuItems;
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        NotBeginViewController *notBeginVC = (NotBeginViewController *) vc;
        self.seletedMenuItems = notBeginVC.seletedMenuItems;
    }
    
    for (UIButton *menuBtn in self.allMenuItems) {
        for (NSDictionary *seletedMenu in self.seletedMenuItems) {
            if ([[menuBtn.menuInfo objectForKey:@"title"] isEqualToString:[seletedMenu objectForKey:@"title"]]
                && [[menuBtn.menuInfo objectForKey:@"section"] integerValue] == [[seletedMenu objectForKey:@"section"] integerValue]) {
                menuBtn.menuSelected = YES;
                break;
            }
            else {
                menuBtn.menuSelected = NO;
            }
        }
    }
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.menus count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[self.menus objectAtIndex:section] count] - 1;
    
    //前两个菜单类别，每行显示两个菜单项，所以加此判断
    if (section < 2) {
        count = ceil(count/2.0f);//返回不小于函数参数的最小整数
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, kHeightForSectionHeader)];
    headerView.layer.borderColor = [UIColor blackColor].CGColor;
    headerView.layer.borderWidth = 0.5f;
    headerView.backgroundColor = RGB(43.0f, 47.0f, 51.0f);
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
    textLabel.text = [[self.menus objectAtIndex:section] objectAtIndex:0];
    textLabel.font = [UIFont fontWithName:FONT_NAME size:14];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];
    
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 2 ? @"menuCellID1" : @"menuCellID2"];

    NSArray *datas = [self.menus objectAtIndex:indexPath.section];

    if (indexPath.section == 2) {
        NSDictionary *menuItem = [datas objectAtIndex:(indexPath.row + 1)];
        [cell.centerMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.centerMenuItem.menuInfo = menuItem;
        [self.allMenuItems addObject:cell.centerMenuItem];
    }
    else {
        int index = indexPath.row * 2 + 1;
        
        NSDictionary *menuItem = [datas objectAtIndex:index];
        [cell.leftMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.leftMenuItem.menuInfo = menuItem;
        [self.allMenuItems addObject:cell.leftMenuItem];
        [self.allMenuItems addObject:cell.rightMenuItem];
        
        //前两个类别的菜单在cell中一行显示两个菜单项，当菜单个数为单数时，右侧菜单项不显示内容
        if ((index + 1) > [datas indexOfObject:[datas lastObject]]) {
            [cell.rightMenuItem setTitle:@"" forState:UIControlStateNormal];
            cell.rightMenuItem.enabled = NO;
        }
        else {
            NSDictionary *menuItem = [datas objectAtIndex:(index + 1)];
            [cell.rightMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
            cell.rightMenuItem.enabled = YES;
            cell.rightMenuItem.menuInfo = menuItem;
        }
    }
    
    //只要新的菜单组中有一个菜单能够显示出来便设置菜单选择状态，
    if (indexPath.row == 0) {
        [self resetMenuItemStatus];
    }
    
    return cell;
}

@end
