//
//  SimpleCommodityTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-6.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"

@interface SimpleCommodityTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;//商品名称
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;//价格
@property (nonatomic, weak) IBOutlet UIImageView *sourceImg;//商品来源

@property (nonatomic, strong) Commodity *commodity;//商品对象

@end
