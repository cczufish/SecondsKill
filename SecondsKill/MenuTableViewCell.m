//
//  MenuTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "MenuTableViewCell.h"

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
    NSLog(@"%d,%d",self.viewController.view.tag,self.viewController.revealController.frontViewController.view.tag);
    for (UIView *view = self.superview; view; view = view.superview) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;

//            UIButton *selectedBtn = [tableView.selectedBtnOfSection objectAtIndex:[[btn.menuInfo objectForKey:@"section"] integerValue]];
            btn.seleted = NO;
            [tableView.selectedBtnOfSection replaceObjectAtIndex:[[btn.menuInfo objectForKey:@"section"] integerValue] withObject:btn];

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *seletedMenus = [NSMutableArray arrayWithArray:[userDefaults objectForKey:SELECTED_MENU_KEY]];

            [seletedMenus replaceObjectAtIndex:[[btn.menuInfo objectForKey:@"section"] integerValue] withObject:btn.menuInfo];
            
            [userDefaults setObject:seletedMenus forKey:SELECTED_MENU_KEY];
            [userDefaults synchronize];

            break;
        }
    }
    
    btn.seleted = YES;
    
//    SuperViewController *superVC = (SuperViewController *) self.viewController;
//    [superVC showFrontViewController];
}

@end
