//
//  UIImage+V.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (V)

//调整图片大小
- (UIImage *)imageWithNewSize:(CGSize)newSize;

//按比例缩放图片
- (UIImage *)scaleImage:(float)scale;

//在图片的某一位置上添加文字
- (UIImage *)drawText:(NSString *)text atPoint:(CGPoint)point;

@end
