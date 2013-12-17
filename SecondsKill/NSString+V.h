//
//  NSString+V.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (V)

- (BOOL)isEmail;

//base64后的字符串会包括"="号，所以如果要将它用在url中，就不能对“＝“转码
//排序用的参数，对应的值里会包含逗号
- (NSString *)URLParameterSupportEqualSignAndCommaSymbol;

@end
