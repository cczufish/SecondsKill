//
//  Commodity.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject

@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *source;//商品来源
@property (nonatomic, copy) NSString *link;//直达链接
@property (nonatomic, copy) NSString *surplus;//秒杀剩余时间
@property (nonatomic, copy) NSString *detrusionTime;//秒杀推出时间

@property (nonatomic, copy) NSString *pictureURL;//商品图片

@property (nonatomic, assign) CGFloat price;//原价格
@property (nonatomic, assign) CGFloat killPrice;//秒杀价格
@property (nonatomic, assign) NSInteger upCount;//顶的次数
@property (nonatomic, assign) NSInteger inventory;//剩余库存
@property (nonatomic, assign) CGFloat alreadyOrder;//已订购比率

@property (nonatomic, assign) BOOL uped;

- (instancetype)initWithName:(NSString *)name source:(NSString *)source price:(CGFloat)price killPrice:(CGFloat)killPrice;

+ (instancetype)commodityWithName:(NSString *)name source:(NSString *)source price:(CGFloat)price killPrice:(CGFloat)killPrice;

@end
