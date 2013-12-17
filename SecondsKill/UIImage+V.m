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
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)tintColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:rect];
    
    [color set];
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)scaleImage:(float)scale
{
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self imageWithNewSize:newSize];
}

- (UIImage *)drawText:(NSString *)text
              atPoint:(CGPoint)point
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [[UIColor blackColor] set];
    
    CGRect textRect = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    [text drawInRect:CGRectIntegral(textRect) withFont:DEFAULT_FONT];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)getWebSiteIcon:(NSString *)website
{
    NSString *fixedWeb = [[NSString alloc] initWithString:website];

    if (![website hasPrefix:@"http://"] && ![website hasPrefix:@"https://"]) {
        fixedWeb = [NSString stringWithFormat:@"http://%@", website];
    }
    
    NSString *basicCode = [NSString stringWithFormat:@"http://g.etfv.co/%@", fixedWeb];
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString: basicCode]];
    UIImage *myImage = [UIImage imageWithData:myData];

    CGSize imageSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContext(imageSize);
    [myImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *iconData = [NSData dataWithData:UIImagePNGRepresentation(iconImage)];
    iconImage = [UIImage imageWithData:iconData];
    
    return iconImage;
}

@end
