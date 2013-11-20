//
//  UIButton+MenuItem.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-7.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MenuItem)

@property (nonatomic, copy) NSDictionary *menuInfo;

@property (nonatomic, assign) BOOL menuSelected;

@end
