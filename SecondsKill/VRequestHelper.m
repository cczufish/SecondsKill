//
//  VRequestHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-1.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VRequestHelper.h"

#define kHttpHeaderURIKey @"uri"

//存放所有发起的请求，当请求结束后或cancel请求时剔除NSOperation对象
static NSMutableDictionary *operations = nil;

@implementation VRequestHelper

- (id)initWithURI:(NSString *)uri httpMethod:(NSString *)httpMethod
{
    self = [super init];
    if (self) {
        self.uri = uri;
        self.httpMethod = [httpMethod uppercaseString];
        if (operations == nil) {
            operations = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
    }
    return self;
}

- (void)cancelRequestByURI:(NSString *)uri cancelBlock:(CancelRequest)cancelBlock
{
    [[operations objectForKey:uri] cancel];
    
    if (cancelBlock) {
        cancelBlock();
    }
}

- (void)requestWithCompletionBlock:(CompletionRequest)completionBlock
{
    [self requestWithHttpHeader:nil completion:completionBlock];
}
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", nil];
////    NSURL *URL = [NSURL URLWithString:self.linkAddress];
////    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    op.responseSerializer = responseSerializer;
//    chromeBar.progress = 0.0f;
//    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"%f",(float)totalBytesRead / totalBytesExpectedToRead);
//        [chromeBar setProgress:(float)totalBytesRead / totalBytesExpectedToRead animated:NO];
//    }];
//
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject: %@", responseObject);
//        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self.webView.request.URL scheme], [self.webView.request.URL host]]];
//        [self.webView loadData:responseObject MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
////    [[NSOperationQueue mainQueue] addOperation:op];
- (void)requestWithHttpHeader:(NSDictionary *)header completion:(CompletionRequest)completionBlock
{
    //防止重复请求
    if ([operations objectForKey:self.uri]) {
        return;
    }
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",@"",self.uri];
    NSLog(@"url = %@",urlStr);
    NSURL *url = [[NSURL alloc] initWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:self.httpMethod];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"" forHTTPHeaderField:@"AppKey"];
    [request addValue:self.uri forHTTPHeaderField:kHttpHeaderURIKey];
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request addValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if ([self.httpMethod isEqualToString:@"PUT"] || [self.httpMethod isEqualToString:@"POST"]) {
        [request setHTTPBody:[self.httpBody dataUsingEncoding:NSUTF8StringEncoding] ];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionBlock) {
            completionBlock(operation.response, responseObject, nil);
        }
        [operations removeObjectForKey:[operation.request valueForHTTPHeaderField:kHttpHeaderURIKey]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        //如果cancel掉请求，会进failure块，所以加此处理。
        if (![operation isCancelled] && completionBlock) {
            completionBlock(operation.response, nil, error);
        }
        [operations removeObjectForKey:[operation.request valueForHTTPHeaderField:kHttpHeaderURIKey]];
    }];
    
    [operations setObject:operation forKey:self.uri];
    [operation start];
}

@end
