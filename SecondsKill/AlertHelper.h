//
//  ALAlertHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-20.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

+ (void)success:(NSString *)message inView:(UIView *)view;

+ (void)sharedUMSocialSuccess:(UMSocialResponseEntity *)response inView:(UIView *)view;

+ (void)checkUpdateAPP:(BOOL)needUpdate inView:(UIView *)view;

@end
