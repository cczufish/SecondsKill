//
//  UserManager.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef void (^CompletionUserOperation)(User *user, NSString *msg);

@interface UserManager : NSObject

+ (UserManager *)shardInstance;

- (void)registerUser:(NSString *)userInfo completion:(CompletionUserOperation)completionBlock;

- (void)login:(NSString *)userInfo completion:(CompletionUserOperation)completionBlock;

@end
