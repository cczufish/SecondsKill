//
//  UIImage+V.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (V)

- (UIImage *)imageWithNewSize:(CGSize)newSize;

- (UIImage *)scaleImage:(float)scale;

- (UIImage *)drawText:(NSString *)text atPoint:(CGPoint)point;

- (UIImage *)tintColor:(UIColor *)color;

+ (UIImage *)getWebSiteIcon:(NSString *)website;

@end
