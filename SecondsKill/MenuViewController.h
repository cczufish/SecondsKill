//
//  MenuViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SuperViewController.h"

@interface MenuViewController : SuperViewController

@property (nonatomic, assign) BOOL seletedChanged;

@property (nonatomic, strong) NSMutableSet *allMenuItems;

@property (nonatomic, weak) NSMutableArray *seletedMenuItems;//临时记录所选菜单项，由于这里不是copy，所以修改它的同时也修改了它的源数据

@end
