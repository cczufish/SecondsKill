//
//  UIButton+MenuItem.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-7.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UIButton+MenuItem.h"

static const void *menuInfoKey;
static const void *menuSelectedKey;

#define kMenuItemLayerName @"menuSelected"

@implementation UIButton (MenuItem)

@dynamic menuInfo;
@dynamic menuSelected;

- (BOOL)menuSelected
{
    return [objc_getAssociatedObject(self, &menuSelectedKey) boolValue];
}

- (void)setMenuSelected:(BOOL)menuSelected
{
    if (menuSelected) {
        [self setBackgroundColor:RGBCOLOR(20.0f, 20.0f, 20.0f)];
        
        if(![self hasLayer:kMenuItemLayerName]) {
            CALayer *newLayer = [CALayer layer];
            newLayer.name = kMenuItemLayerName;
            newLayer.backgroundColor = RGBCOLOR(199, 55, 33).CGColor;
            newLayer.frame = CGRectMake(0, 0, 5, 50);
            [self.layer addSublayer:newLayer];
        }
    }
    else {
        [self setBackgroundColor:[UIColor clearColor]];
        [self removeLayerWithName:kMenuItemLayerName];
    }

    objc_setAssociatedObject(self, &menuSelectedKey, [NSNumber numberWithBool:menuSelected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)menuInfo
{
    return objc_getAssociatedObject(self, &menuInfoKey);
}

- (void)setMenuInfo:(NSDictionary *)menuInfo
{
    objc_setAssociatedObject(self, &menuInfoKey, menuInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
