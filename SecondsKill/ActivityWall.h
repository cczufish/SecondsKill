//
//  ActivityWall.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-27.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityWall : JSONModel

@property (copy, nonatomic) NSString *itemID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *site;

@property (assign, nonatomic) BOOL is_hot;
@property (assign, nonatomic) BOOL is_new;
@property (assign, nonatomic) BOOL is_rec;

@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *updated_at;

@end
