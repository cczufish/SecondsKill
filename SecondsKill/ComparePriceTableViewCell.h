//
//  ComparePriceTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComparePriceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;//商品名称
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;//价格
@property (nonatomic, weak) IBOutlet UIImageView *sourceImg;//商品来源

@end
