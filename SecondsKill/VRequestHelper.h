//
//  VRequestHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionRequest)(NSHTTPURLResponse *response, id json, NSError *error);
typedef void (^CancelRequest)();

@interface VRequestHelper : NSObject

@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, copy) NSString *httpBody;

- (id)initWithURI:(NSString *)uri;

- (id)initWithURI:(NSString *)uri httpMethod:(NSString *)httpMethod;

- (void)cancelRequestByURI:(NSString *)uri cancelBlock:(CancelRequest)cancelBlock;

- (void)requestWithCompletionBlock:(CompletionRequest)completionBlock;

@end
