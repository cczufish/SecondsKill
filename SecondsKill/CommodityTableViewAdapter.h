//
//  CommodityTableViewAdapter.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-5.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommodityAdapterTypeKilling = 0,
    CommodityAdapterTypeNotBegin,
} CommodityAdapterType;

@interface CommodityTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *commoditys;

- (id)initWithType:(CommodityAdapterType)adapterType;

@end
