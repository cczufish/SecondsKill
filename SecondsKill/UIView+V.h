//
//  UIView+V.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (V)

- (BOOL)hasLayer:(NSString *)name;

- (void)removeLayerWithName:(NSString *)name;

- (UIViewController*)viewController;

@end
