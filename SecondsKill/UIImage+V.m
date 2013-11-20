//
//  UIImage+V.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UIImage+V.h"

@implementation UIImage (V)

- (UIImage *)imageWithNewSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleImage:(float)scale
{
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self imageWithNewSize:newSize];
}

- (UIImage *)drawText:(NSString *)text
              atPoint:(CGPoint)point
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [[UIColor blackColor] set];
    
    CGRect textRect = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    [text drawInRect:CGRectIntegral(textRect) withFont:DEFAULT_FONT];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
