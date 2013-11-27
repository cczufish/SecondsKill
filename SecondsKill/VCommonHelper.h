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
    
NSString *AES256AuthorizationInfo();

//App是否是第一次运行
BOOL isFirstRun();

//App每次启动时初始化一些设置
void InitProject();

//根据baseurl和参数拼接url
NSString *GenerateURLString(NSString *baseURL, NSDictionary *params);

#if defined __cplusplus
};
#endif