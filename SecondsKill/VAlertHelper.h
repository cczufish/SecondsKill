//
//  VAlertHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAlertHelper : NSObject

+ (void)requestDataSuccess:(UIView *)view;

+ (void)requestDataException:(UIView *)view;

+ (void)netWorkException:(UIView *)view;

+ (void)fail:(NSString *)message inView:(UIView *)view;

+ (void)success:(NSString *)message inView:(UIView *)view;

+ (void)sharedUMSocialSuccess:(UMSocialResponseEntity *)response inView:(UIView *)view;

+ (void)checkUpdateAPP:(BOOL)needUpdate inView:(UIView *)view;
@end
