//
//  Commodity.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "Commodity.h"

@implementation Commodity

- (instancetype)initWithName:(NSString *)name source:(NSString *)source price:(CGFloat)price killPrice:(CGFloat)killPrice
{
    self = [super init];
    if (self) {
        self.name = name;
        self.source = source;
        self.price = price;
        self.killPrice = killPrice;
    }
    return self;
}

+ (instancetype)commodityWithName:(NSString *)name source:(NSString *)source price:(CGFloat)price killPrice:(CGFloat)killPrice
{
    return [[Commodity alloc] initWithName:name source:source price:price killPrice:killPrice];
}

@end
