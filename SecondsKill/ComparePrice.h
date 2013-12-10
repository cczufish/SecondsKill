//
//  ComparePrice.h
//  SecondsKill
//
//  Created by lijingcheng on 13-12-9.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComparePrice : JSONModel

@property (copy, nonatomic) NSString *itemID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *minPriceDate;

@property (assign, nonatomic) NSInteger vendorId;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat minPrice;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger comments;

@end