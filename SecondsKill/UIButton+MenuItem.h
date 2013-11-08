//
//  UIButton+MenuItem.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-7.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuItemDefaultBGColor RGB(38.0f, 38.0f, 38.0f)
#define kMenuItemSelectedBGColor RGB(20.0f, 20.0f, 20.0f)

@interface UIButton (MenuItem)

@property (nonatomic, copy) NSDictionary *menuInfo;

@property (nonatomic, assign, getter=isSeleted) BOOL seleted;

@end
