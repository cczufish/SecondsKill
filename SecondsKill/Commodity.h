//
//  Commodity.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : JSONModel

@property (assign, nonatomic) int id;

@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString *cate;
@property (copy, nonatomic) NSString* link;
@property (copy, nonatomic) NSString* image;
@property (copy, nonatomic) NSString* site;
@property (copy, nonatomic) NSString* des;

@property (assign, nonatomic) CGFloat discount;
@property (assign, nonatomic) CGFloat o_price;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat sku;
@property (assign, nonatomic) NSInteger remain;
@property (assign, nonatomic) NSInteger total;

@property (assign, nonatomic) NSInteger end_t;
@property (assign, nonatomic) NSInteger start_t;

@end
