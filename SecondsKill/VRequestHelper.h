//
//  VRequestHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRequestHelper : NSObject
typedef void (^CompletionRequest)(NSHTTPURLResponse *response, id json, NSError *error);
typedef void (^CancelRequest)();

@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, copy) NSString *httpBody;

- (id)initWithURI:(NSString *)uri httpMethod:(NSString *)httpMethod;

//通过URI来取消请求
- (void)cancelRequestByURI:(NSString *)uri cancelBlock:(CancelRequest)cancelBlock;

//请求数据并通过block处理返回数据
- (void)requestWithCompletionBlock:(CompletionRequest)completionBlock;

//请求数据并添加HTTP头,通过block处理返回数据
- (void)requestWithHttpHeader:(NSDictionary *)header completion:(CompletionRequest)completionBlock;

@end
