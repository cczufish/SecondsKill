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

//@property (nonatomic, copy) NSArray *menus;

//根据不同源界面保存的菜单筛选条件设置菜单界面的数据选择状态，
//第一次打开菜单界面时，菜单项的选择状态通过cellForRowAtIndexPath方法设定
- (void)resetMenuItemStatus;

@end

static NSArray *menus;

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分类筛选";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.allMenuItems = [NSMutableSet setWithCapacity:50];
    
}

//打开菜单界面时重置菜单选择状态
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.seletedChanged = NO;

    [self resetMenuItemStatus];
    
    [MobClick beginLogPageView:@"\"分类筛选\"界面"];
}

//离开菜单选择界面时根据所选菜单项筛选界面数据
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSMutableString *ql = [[NSMutableString alloc] initWithCapacity:20];
    
    for (int i = 0; i < [self.seletedMenuItems count]; i++) {
        NSString *params = [self.seletedMenuItems[i] objectForKey:@"params"];
        if(![@"all" isEqualToString:params]) {
            [ql appendString:[NSString stringWithFormat:@"%@ and ", params]];
        }
    }
    
    UIViewController *vc = [self currentViewController];
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        KillingViewController *killingVC = (KillingViewController *) vc;
        if (self.seletedChanged) {
            [killingVC selectCommoditys:ql];
        }
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        NotBeginViewController *notBeginVC = (NotBeginViewController *) vc;
        if (self.seletedChanged) {
            [notBeginVC selectCommoditys:ql];
        }
    }
    
    [MobClick endLogPageView:@"\"分类筛选\"界面"];
}

#pragma mark -

+ (NSArray *)menus
{
    if (menus == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
        menus = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return menus;
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
	return [menus count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[menus objectAtIndex:section] count] - 1;
    
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
    headerView.backgroundColor = RGBCOLOR(43.0f, 47.0f, 51.0f);
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
    textLabel.text = [[menus objectAtIndex:section] objectAtIndex:0];
    textLabel.font = DEFAULT_FONT;
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];
    
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 2 ? @"menuCellID1" : @"menuCellID2"];

    NSArray *datas = [menus objectAtIndex:indexPath.section];

    if (indexPath.section == 2) {
        NSDictionary *menuItem = [datas objectAtIndex:(indexPath.row + 1)];
        [cell.centerMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.centerMenuItem.menuInfo = menuItem;
        [self.allMenuItems addObject:cell.centerMenuItem];
    }
    else {
        int index = indexPath.row * 2 + 1;//因为一行显示两个菜单数据，所以加此处理
        
        NSDictionary *menuItem = [datas objectAtIndex:index];
        [cell.leftMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.leftMenuItem.menuInfo = menuItem;
        [self.allMenuItems addObject:cell.leftMenuItem];
        
        //一行显示两个菜单项，如果数据不够填充两个菜单项时，右侧菜单项不显示内容
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
        [self.allMenuItems addObject:cell.rightMenuItem];
    }
    
    //只要新的菜单组(section)中有一个菜单项能够显示出来便设置菜单选择状态
    if (indexPath.row == 0) {
        [self resetMenuItemStatus];
    }
    
    return cell;
}

@end
