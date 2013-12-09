//
//  UserManager.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

#define kRegisterPath @"users/reg"
#define kLoginPath @"users/login"

SHARD_INSTANCE_IMPL(UserManager)

- (void)registerUser:(NSString *)userInfo completion:(CompletionUserOperation)completionBlock
{
    if ([VNetworkHelper hasNetWork]) {
        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:kRegisterPath httpMethod:@"POST"];
        requestHelper.httpBody = userInfo;
        
        [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            if ([response statusCode] == 201) {
                if (completionBlock) {
                    User *user = [[User alloc] initWithDictionary:json error:nil];
                    completionBlock(user, nil);
                }
            }
            else {
                if (completionBlock) {
                    completionBlock(nil, [error localizedDescription]);
                }
            }
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [VAlertHelper fail:NETWORK_ERROR];
        });
    }
}

- (void)login:(NSString *)userInfo completion:(CompletionUserOperation)completionBlock
{
    if ([VNetworkHelper hasNetWork]) {
        VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:kLoginPath httpMethod:@"POST"];
        requestHelper.httpBody = userInfo;
        
        [requestHelper requestWithCompletionBlock:^(NSHTTPURLResponse *response, id json, NSError *error) {
            if ([response statusCode] == 200) {
                if (completionBlock) {
                    User *user = [[User alloc] initWithDictionary:json error:nil];
                    completionBlock(user, nil);
                }
            }
            else {
                if (completionBlock) {
                    completionBlock(nil, [error localizedDescription]);
                }
            }
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [VAlertHelper fail:NETWORK_ERROR];
        });
    }
}

@end
