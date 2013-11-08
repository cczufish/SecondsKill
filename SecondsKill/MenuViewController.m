//
//  MenuViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"

#define kHeightForSectionHeader 30.0f

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分类导航";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMenuItemDefaultBGColor;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    _menus = [[NSArray alloc] initWithContentsOfFile:path];

    NSMutableArray *tempForBtn = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];
    NSMutableArray *tempForDict = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];

    for (int i = 0; i < [self.menus count]; i++) {
        [tempForBtn addObject:[NSNull null]];
        [tempForDict addObject:[[self.menus objectAtIndex:i] objectAtIndex:1]];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tempForDict forKey:SELECTED_MENU_KEY];
    [userDefaults synchronize];
    
    self.tableView.selectedBtnOfSection = tempForBtn;
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
    textLabel.textColor = [UIColor whiteColor];
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
        
        if ([[tableView.selectedBtnOfSection objectAtIndex:indexPath.section] isEqual:[NSNull null]]) {
            cell.centerMenuItem.seleted = YES;
            [tableView.selectedBtnOfSection replaceObjectAtIndex:indexPath.section withObject:cell.centerMenuItem];
        }
    }
    else {
        int index = indexPath.row * 2 + 1;
        
        NSDictionary *menuItem = [datas objectAtIndex:index];
        [cell.leftMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.leftMenuItem.menuInfo = menuItem;
        
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
        
        if ([[tableView.selectedBtnOfSection objectAtIndex:indexPath.section] isEqual:[NSNull null]]) {
            cell.leftMenuItem.seleted = YES;
            [tableView.selectedBtnOfSection replaceObjectAtIndex:indexPath.section withObject:cell.leftMenuItem];
        }
    }
    return cell;
}

@end
