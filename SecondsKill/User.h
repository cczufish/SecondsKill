//
//  User.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : JSONModel

@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, copy) NSString *phone_num;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;

@end
