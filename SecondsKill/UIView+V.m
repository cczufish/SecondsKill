//
//  UIView+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UIView+V.h"

@implementation UIView (V)

- (void)removeLayerWithName:(NSString *)name
{
    NSArray *subLayers = [self.layer sublayers];
    
    for (int i = 0; i < [subLayers count]; i++) {
        CALayer *temp = (CALayer *)[subLayers objectAtIndex:i];
        if ([temp.name isEqualToString:name]) {
            [temp removeFromSuperlayer];
        }
    }
}

- (BOOL)hasLayer:(NSString *)name
{
    BOOL flag = NO;
    
    NSArray *subLayers = [self.layer sublayers];
    
    for (int i = 0; i < [subLayers count]; i++) {
        CALayer *temp = (CALayer *)[subLayers objectAtIndex:i];
        if ([temp.name isEqualToString:name]) {
            flag = YES;
        }
    }
    return flag;
}

- (UIViewController*)viewController
{
    UIViewController *vc = nil;
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)nextResponder;
            break;
        }
    }
    return vc;
}

@end
