//
//  Commodity.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : JSONModel<NSCoding>

@property (copy, nonatomic) NSString *itemID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *cate;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *site;
@property (copy, nonatomic) NSString *des;
@property (copy, nonatomic) NSString *discount;
@property (copy, nonatomic) NSString *sku;
@property (copy, nonatomic) NSString *deal_id;

@property (assign, nonatomic) CGFloat o_price;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) NSInteger remain;
@property (assign, nonatomic) NSInteger total;

@property (copy, nonatomic) NSString *end_t;
@property (copy, nonatomic) NSString *start_t;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *updated_at;

@property (copy, nonatomic) NSString<Ignore> *surplusTime;
@property (copy, nonatomic) NSString<Ignore> *detrusionTime;

@property (copy, nonatomic) NSString<Ignore> *isUp;
@property (copy, nonatomic) NSString<Ignore> *likingCount;

@property (copy, nonatomic) NSString<Ignore> *isAlert;

@end
