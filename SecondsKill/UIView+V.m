//
//  UIView+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UIView+V.h"

@interface UIView (private)

- (CALayer *)layerByName:(NSString *)name;

@end

@implementation UIView (V)

- (void)removeLayerWithName:(NSString *)name
{
    CALayer *layer = [self layerByName:name];
    
    if (layer) {
        [layer removeFromSuperlayer];
    }
}

- (BOOL)hasLayer:(NSString *)name
{
    if ([self layerByName:name]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UIViewController *)inViewController
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

#pragma mark - private method

- (CALayer *)layerByName:(NSString *)name
{
    CALayer *layer = nil;
    
    NSArray *subLayers = [self.layer sublayers];
    
    for (int i = 0; i < [subLayers count]; i++) {
        CALayer *temp = (CALayer *)[subLayers objectAtIndex:i];
        if ([temp.name isEqualToString:name]) {
            layer = temp;
            break;
        }
    }
    
    return layer;
}

@end
