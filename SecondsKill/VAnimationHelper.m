//
//  VAnimationHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VAnimationHelper.h"

#define kAnimationDuration 0.3f

@implementation VAnimationHelper

+ (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    
    /*
     动画的开始与结束的快慢,有五个预置分别为(下同):
     kCAMediaTimingFunctionLinear            线性,即匀速
     kCAMediaTimingFunctionEaseIn            先慢后快
     kCAMediaTimingFunctionEaseOut           先快后慢
     kCAMediaTimingFunctionEaseInEaseOut     先慢后快再慢
     kCAMediaTimingFunctionDefault           实际效果是动画中间比较快.
     */
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    
    /*
     决定当前对象过了非active时间段的行为,比如动画开始之前,动画结束之后.
     kCAFillModeRemoved   默认,当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards  当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 和kCAFillModeForwards相对,具体参考上面的URL
     kCAFillModeBoth      kCAFillModeForwards和kCAFillModeBackwards在一起的效果
     */
    animation.fillMode = kCAFillModeForwards;
    animation.type = type;
    animation.subtype = subType;
    [theView.layer addAnimation:animation forKey:nil];
}

+ (void)animationWithType:(NSString *)type subType:(NSString *)subType inView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = kAnimationDuration;
    animation.type = type;
    animation.subtype = subType;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationRevealFromTop:(UIView *)view
{
    [self animationWithType:kCATransitionReveal subType:kCATransitionFromTop inView:view];
}

+ (void)animationRevealFromBottom:(UIView *)view
{
    [self animationWithType:kCATransitionReveal subType:kCATransitionFromBottom inView:view];
}

+ (void)animationRevealFromLeft:(UIView *)view
{
    [self animationWithType:kCATransitionReveal subType:kCATransitionFromLeft inView:view];
}

+ (void)animationRevealFromRight:(UIView *)view
{
    [self animationWithType:kCATransitionReveal subType:kCATransitionFromRight inView:view];
}

+ (void)animationEaseIn:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = kAnimationDuration;
    animation.type = kCATransitionFade;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationEaseOut:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = kAnimationDuration;
    animation.type = kCATransitionFade;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationFlipFrom:(UIViewAnimationTransition)animationTransition inView:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationTransition:animationTransition forView:view cache:NO];
    [UIView commitAnimations];
}

+ (void)animationFlipFromLeft:(UIView *)view
{
    [self animationFlipFrom:UIViewAnimationTransitionFlipFromLeft inView:view];
}

+ (void)animationFlipFromRight:(UIView *)view
{
    [self animationFlipFrom:UIViewAnimationTransitionFlipFromRight inView:view];
}

+ (void)animationCurlUp:(UIView *)view
{
    [self animationFlipFrom:UIViewAnimationTransitionCurlUp inView:view];
}

+ (void)animationCurlDown:(UIView *)view
{
    [self animationFlipFrom:UIViewAnimationTransitionCurlDown inView:view];
}

+ (void)animationPushUp:(UIView *)view
{
    [self animationWithType:kCATransitionPush subType:kCATransitionFromTop inView:view];
}

+ (void)animationPushDown:(UIView *)view
{
    [self animationWithType:kCATransitionPush subType:kCATransitionFromBottom inView:view];
}

+ (void)animationPushLeft:(UIView *)view
{
    [self animationWithType:kCATransitionPush subType:kCATransitionFromLeft inView:view];
}

+ (void)animationPushRight:(UIView *)view
{
    [self animationWithType:kCATransitionPush subType:kCATransitionFromRight inView:view];
}

+ (void)animationMoveUp:(UIView *)view duration:(CFTimeInterval)duration
{
    [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromTop inView:view];
}

+ (void)animationMoveDown:(UIView *)view duration:(CFTimeInterval)duration
{
    [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromBottom inView:view];
}

+ (void)animationMoveLeft:(UIView *)view
{
    [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromLeft inView:view];
}

+ (void)animationMoveRight:(UIView *)view
{
    [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromRight inView:view];
}

+(void)animationRotateAndScaleEffects:(UIView *)view
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        // 向右旋转45°缩小到最小,然后再从小到大推出.
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80)];
        //从底部向上收缩一半后弹出
        //animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0)];
        //从底部向上完全收缩后弹出
        //animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0)];
        //左旋转45°缩小到最小,然后再从小到大推出.
        //animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.50, -0.50, 0.50)];
        //旋转180°缩小到最小,然后再从小到大推出.
        //animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2)];
        
        animation.duration = 0.45;
        animation.repeatCount = 1;
        [view.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

+ (void)animationScaleAndRestore:(UIView *)view
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//缩放
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

+ (void)animationRotateAndScaleDownUp:(UIView *)view
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕z轴旋转,单位:弧度
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 2];
    rotationAnimation.duration = kAnimationDuration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//缩放
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimationDuration;
    animationGroup.autoreverses = YES;//动画完成后自动重新开始
    animationGroup.repeatCount = 1;
    animationGroup.animations =[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil];
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

#pragma mark - Private API

+ (void)animationFlipFromTop:(UIView *)view
{
    [self animationWithType:@"oglFlip" subType:@"fromTop" inView:view];
}

+ (void)animationFlipFromBottom:(UIView *)view
{
    [self animationWithType:@"oglFlip" subType:@"fromBottom" inView:view];
}

+ (void)animationCubeFromLeft:(UIView *)view
{
    [self animationWithType:@"cube" subType:@"fromLeft" inView:view];
}

+ (void)animationCubeFromRight:(UIView *)view
{
    [self animationWithType:@"cube" subType:@"fromRight" inView:view];
}

+ (void)animationCubeFromTop:(UIView *)view
{
    [self animationWithType:@"cube" subType:@"fromTop" inView:view];
}

+ (void)animationCubeFromBottom:(UIView *)view
{
    [self animationWithType:@"cube" subType:@"fromBottom" inView:view];
}

+ (void)animationSuckEffect:(UIView *)view
{
    [self animationWithType:@"suckEffect" subType:nil inView:view];
}

+ (void)animationRippleEffect:(UIView *)view
{
    [self animationWithType:@"rippleEffect" subType:nil inView:view];
}

+ (void)animationPageCurl:(UIView *)view
{
    [self animationWithType:@"pageCurl" subType:nil inView:view];
}

+ (void)animationPageUnCurl:(UIView *)view
{
    [self animationWithType:@"pageUnCurl" subType:nil inView:view];
}

@end
