//
//  VRequestHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VRequestHelper.h"

#define kBaseURL @"https://115.29.46.104/"
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kBaseURL, self.uri];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:self.httpMethod];
    
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:kAppKey forHTTPHeaderField:@"AppKey"];
    [request addValue:[userDefaults objectForKey:SESSION_KEY] forHTTPHeaderField:@"X-SESSION"];
    
    NSString *etagForURL = [[VURLCache shardInstance] getETagWithURL:self.uri];

    if (etagForURL) {
        [request addValue:etagForURL forHTTPHeaderField:@"If-None-Match"];
    }

    if ([self.httpMethod isEqualToString:@"PUT"] || [self.httpMethod isEqualToString:@"POST"]) {
        [request setHTTPBody:[self.httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *session = [[operation.response allHeaderFields] objectForKey:@"X-SESSION"];

        if (session != nil) {
            [userDefaults setObject:session forKey:SESSION_KEY];
            [userDefaults synchronize];
        }
        
        if (completionBlock) {
            completionBlock(operation.response, responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (![operation isCancelled] && completionBlock) {
            completionBlock(operation.response, nil, error);
        }
    }];
    operation.userInfo = @{kUserInfoKey: self.uri};
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

@end
