//
//  VCommonHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
    extern "C" {
#endif

typedef void (^CompletionOperation)(BOOL success, NSString *msg);
        
//App每次启动时初始化一些设置
void InitializeProject();
        
//目前已用session代替authorization方式进行用户权限认证
NSString *AES256AuthorizationInfo();

#if defined __cplusplus
    };
#endif