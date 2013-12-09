//
//  MenuViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"

@interface MenuViewController : SuperViewController

@property (nonatomic, strong) NSMutableSet *allMenuItems;

@property (nonatomic, strong) NSMutableArray *seletedMenuTemp;//临时记录所选菜单项

+ (NSArray *)menus;

@end
