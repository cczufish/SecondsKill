//
//  UIButton+MenuItem.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-7.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UIButton+MenuItem.h"
#import <objc/runtime.h>

static const void *menuInfoKey;
static const void *seletedKey;

#define kBtnLayerName @"leftBorder"

@implementation UIButton (MenuItem)

@dynamic menuInfo;
@dynamic seleted;

- (BOOL)isSeleted
{
    return [objc_getAssociatedObject(self, &seletedKey) boolValue];
}

- (void)setSeleted:(BOOL)seleted
{
    if (seleted) {
        [self setBackgroundColor:RGB(20.0f, 20.0f, 20.0f)];
        
        CALayer *newLayer = [CALayer layer];
        newLayer.name = kBtnLayerName;
        newLayer.backgroundColor = RGB(199, 55, 33).CGColor;
        newLayer.frame = CGRectMake(0, 0, 5, 50);
        [self.layer addSublayer:newLayer];
    }
    else {
        [self setBackgroundColor:[UIColor clearColor]];
        [self removeLayerWithName:kBtnLayerName];
    }

    objc_setAssociatedObject(self, &seletedKey, [NSNumber numberWithBool:seleted], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
