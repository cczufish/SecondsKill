//
//  VCommonHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>
NSString* URLencode(NSString *originalString, NSStringEncoding stringEncoding);
NSString *AES256AuthorizationInfo();

//返回文件在documents目录下的全路径名
NSString *PathForDocuments(NSString *fileName);

//App是否是第一次运行
BOOL isFirstRun();

//App每次启动时初始化一些设置
void InitProject();

//根据baseurl和参数拼接url
NSURL *GenerateURL(NSString *baseURL, NSDictionary *params);
