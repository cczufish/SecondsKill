//
//  VAnimationHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAnimationHelper : NSObject

+ (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView;

//将旧视图移开,显示下面的新视图
+ (void)animationRevealFromBottom:(UIView *)view;
+ (void)animationRevealFromTop:(UIView *)view;
+ (void)animationRevealFromLeft:(UIView *)view;
+ (void)animationRevealFromRight:(UIView *)view;

// 交叉淡化过渡
+ (void)animationEaseIn:(UIView *)view;
+ (void)animationEaseOut:(UIView *)view;

// 翻转
+ (void)animationFlipFromLeft:(UIView *)view;
+ (void)animationFlipFromRight:(UIView *)view;

// 翻页
+ (void)animationCurlUp:(UIView *)view;
+ (void)animationCurlDown:(UIView *)view;

// 新视图把旧视图推出去
+ (void)animationPushUp:(UIView *)view;
+ (void)animationPushDown:(UIView *)view;
+ (void)animationPushLeft:(UIView *)view;
+ (void)animationPushRight:(UIView *)view;

// 新视图移到旧视图上面
+ (void)animationMoveUp:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveDown:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveLeft:(UIView *)view;
+ (void)animationMoveRight:(UIView *)view;

// 各种旋转缩放效果
+ (void)animationRotateAndScaleEffects:(UIView *)view;

// 旋转同时缩小放大效果
+ (void)animationRotateAndScaleDownUp:(UIView *)view;

//先放大再恢复
+ (void)animationScaleAndRestore:(UIView *)view;

#pragma mark - 私有API

//上下左右翻转效果
+ (void)animationFlipFromTop:(UIView *)view;
+ (void)animationFlipFromBottom:(UIView *)view;

//立方体翻滚效果
+ (void)animationCubeFromLeft:(UIView *)view;
+ (void)animationCubeFromRight:(UIView *)view;
+ (void)animationCubeFromTop:(UIView *)view;
+ (void)animationCubeFromBottom:(UIView *)view;

//收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
+ (void)animationSuckEffect:(UIView *)view;
//滴水效果,(不支持过渡方向)
+ (void)animationRippleEffect:(UIView *)view;

//向上翻一页
+ (void)animationPageCurl:(UIView *)view;
//向下翻一页
+ (void)animationPageUnCurl:(UIView *)view;

@end
