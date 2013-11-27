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
    self.backgroundColor = RGBCOLOR(30.0f, 30.0f, 30.0f);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    [self.leftMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [self.leftMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.rightMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [self.rightMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.centerMenuItem setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [self.centerMenuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(UIButton *)btn
{
    MenuViewController *menuVC = (MenuViewController *) self.viewController;
    
    int section = [[btn.menuInfo objectForKey:@"section"] integerValue];
    
    NSDictionary *seletedMenuItem = menuVC.seletedMenuItems[section];

    for (UIButton *menuBtn in menuVC.allMenuItems) {
        if ([[menuBtn.menuInfo objectForKey:@"title"] isEqualToString:[seletedMenuItem objectForKey:@"title"]]
            && [[menuBtn.menuInfo objectForKey:@"section"] integerValue] == [[seletedMenuItem objectForKey:@"section"] integerValue]) {
            menuBtn.menuSelected = NO;
            break;
        }
    }
    
    if (![[btn.menuInfo objectForKey:@"title"] isEqualToString:[seletedMenuItem objectForKey:@"title"]]) {
        menuVC.seletedChanged = YES;
    }
    
    btn.menuSelected = YES;
    [menuVC.seletedMenuItems replaceObjectAtIndex:section withObject:btn.menuInfo];
}

@end
