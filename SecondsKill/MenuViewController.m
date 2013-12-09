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

    UIViewController *vc = [self currentViewController];
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        KillingViewController *killingVC = (KillingViewController *) vc;
        self.seletedMenuTemp = [killingVC.seletedMenuItems deepMutableCopy];
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        NotBeginViewController *notBeginVC = (NotBeginViewController *) vc;
        self.seletedMenuTemp = [notBeginVC.seletedMenuItems deepMutableCopy];
    }
    
    for (UIButton *menuBtn in self.allMenuItems) {
        for (NSDictionary *seletedMenu in self.seletedMenuTemp) {
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
    
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    
    [MobClick beginLogPageView:@"\"分类筛选\"界面"];
}

//离开菜单选择界面时根据所选菜单项筛选界面数据
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSMutableString *ql = [[NSMutableString alloc] initWithCapacity:20];
    
    for (int i = 0; i < [self.seletedMenuTemp count]; i++) {
        NSString *params = [self.seletedMenuTemp[i] objectForKey:@"params"];
        if(![@"all" isEqualToString:params]) {
            [ql appendString:[NSString stringWithFormat:@"%@ and ", params]];
        }
    }

    UIViewController *vc = [self currentViewController];
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        KillingViewController *killingVC = (KillingViewController *) vc;
        if ([self selectedChanged:killingVC.seletedMenuItems]) {
            killingVC.seletedMenuItems = self.seletedMenuTemp;
            [killingVC selectCommoditys:ql];
        }
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        NotBeginViewController *notBeginVC = (NotBeginViewController *) vc;
        if ([self selectedChanged:notBeginVC.seletedMenuItems]) {
            notBeginVC.seletedMenuItems = self.seletedMenuTemp;
            [notBeginVC selectCommoditys:ql];
        }
    }
    
    [MobClick endLogPageView:@"\"分类筛选\"界面"];
}

- (BOOL)selectedChanged:(NSMutableArray *)target
{
    int flag = 0;
    int count = [self.seletedMenuTemp count];

    for (int i = 0; i < count; i ++) {
        if ([[self.seletedMenuTemp[i] objectForKey:@"title"] isEqualToString:[target[i] objectForKey:@"title"]]) {
            flag++;
        }
    }
    
    return (flag != count);
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
        
        [self setMenuBtnSeleted:menuItem menuBtn:cell.centerMenuItem sectionIndex:indexPath.section];
    }
    else {
        int index = indexPath.row * 2 + 1;//因为一行显示两个菜单数据，所以加此处理
        
        NSDictionary *menuItem = [datas objectAtIndex:index];
        [cell.leftMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
        cell.leftMenuItem.menuInfo = menuItem;

        [self setMenuBtnSeleted:menuItem menuBtn:cell.leftMenuItem sectionIndex:indexPath.section];
        
        //一行显示两个菜单项，如果数据不够填充两个菜单项时，右侧菜单项不显示内容
        if ((index + 1) > [datas indexOfObject:[datas lastObject]]) {
            [cell.rightMenuItem setTitle:@"" forState:UIControlStateNormal];
            cell.rightMenuItem.enabled = NO;
            cell.rightMenuItem.menuSelected = NO;
        }
        else {
            NSDictionary *menuItem = [datas objectAtIndex:(index + 1)];
            [cell.rightMenuItem setTitle:[menuItem objectForKey:@"title"] forState:UIControlStateNormal];
            cell.rightMenuItem.enabled = YES;
            cell.rightMenuItem.menuInfo = menuItem;
            
            [self setMenuBtnSeleted:menuItem menuBtn:cell.rightMenuItem sectionIndex:indexPath.section];
        }
        [self.allMenuItems addObject:cell.leftMenuItem];
        [self.allMenuItems addObject:cell.rightMenuItem];
    }

    return cell;
}

- (void)setMenuBtnSeleted:(NSDictionary *)menuInfo menuBtn:(UIButton *)menuBtn sectionIndex:(int)section
{
    if ([[menuInfo objectForKey:@"title"] isEqualToString:[[self.seletedMenuTemp objectAtIndex:section] objectForKey:@"title"]]) {
        menuBtn.menuSelected = YES;
    }
    else {
        menuBtn.menuSelected = NO;
    }
}

@end
