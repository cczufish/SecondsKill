//
//  VRequestHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VRequestHelper.h"

#define kBaseURL @"http://192.168.40.182:8080/"
#define kAppKey @"dGVzdDp0ZXN0"
#define kUserInfoKey @"uri"

@implementation VRequestHelper

- (id)initWithURI:(NSString *)uri httpMethod:(NSString *)httpMethod
{
    self = [super init];
    if (self) {
        self.uri = uri;
        self.httpMethod = [httpMethod uppercaseString];
    }
    return self;
}

- (id)initWithURI:(NSString *)uri
{
    return [self initWithURI:uri httpMethod:@"GET"];
}

#pragma mark - about request

- (void)cancelRequestByURI:(NSString *)uri cancelBlock:(CancelRequest)cancelBlock
{
    NSArray *operations = [[NSOperationQueue mainQueue] operations];
    
    for (AFHTTPRequestOperation *op in operations) {
        if ([uri isEqualToString:[op.userInfo objectForKey:kUserInfoKey]]) {
            [op cancel];
        }
    }
    
    if (cancelBlock) {
        cancelBlock();
    }
}

- (void)requestWithCompletionBlock:(CompletionRequest)completionBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kBaseURL, self.uri];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:self.httpMethod];
    
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:kAppKey forHTTPHeaderField:@"AppKey"];
    [request addValue:AES256AuthorizationInfo() forHTTPHeaderField:@"Authorization"];

    if ([self.httpMethod isEqualToString:@"PUT"] || [self.httpMethod isEqualToString:@"POST"]) {
        [request setHTTPBody:[self.httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.userInfo = @{kUserInfoKey: self.uri};

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionBlock) {
            completionBlock(operation.response, responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (![operation isCancelled] && completionBlock) {
            completionBlock(operation.response, nil, error);
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

@end
