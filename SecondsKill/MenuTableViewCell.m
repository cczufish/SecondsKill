//
//  MenuTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuViewController.h"
#import "UIButton+MenuItem.h"

@implementation MenuTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor =  kMenuItemDefaultBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    [self.leftMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [self.rightMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [self.centerMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    
    [self.leftMenuItem setBackgroundColor:kMenuItemDefaultBGColor];
    [self.rightMenuItem setBackgroundColor:kMenuItemDefaultBGColor];
    [self.centerMenuItem setBackgroundColor:kMenuItemDefaultBGColor];
    
    [self.leftMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.rightMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.centerMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(UIButton *)btn
{
    int section = [[btn.menuInfo objectForKey:@"section"] integerValue];
    
    MenuViewController *menuVC = (MenuViewController *) self.viewController;
    
    NSDictionary *seletedMenuItem = menuVC.seletedMenuItems[section];
    
    for (UIButton *menuBtn in menuVC.allMenuItems) {
        if ([[menuBtn.menuInfo objectForKey:@"title"] isEqualToString:[seletedMenuItem objectForKey:@"title"]]
            && [[menuBtn.menuInfo objectForKey:@"section"] integerValue] == [[seletedMenuItem objectForKey:@"section"] integerValue]) {
            menuBtn.menuSelected = NO;
            break;
        }
    }
    
    btn.menuSelected = YES;
    [menuVC.seletedMenuItems replaceObjectAtIndex:section withObject:btn.menuInfo];
    
    //index == 1 只有所选菜单项是电商名称时才更新leftBarButtonItem
    if (section == 1) {
        UIViewController *vc = [menuVC currentViewController];
        
        UIButton *leftBtn = (UIButton *)vc.navigationItem.leftBarButtonItem.customView;
        [leftBtn setTitle:[btn.menuInfo objectForKey:@"title"] forState:UIControlStateNormal];
    }
}

@end
