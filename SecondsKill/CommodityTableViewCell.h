//
//  CommodityTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "CommodityTableViewAdapter.h"
#import "Commodity.h"

@interface CommodityTableViewCell : UITableViewCell

@property (nonatomic, assign) CommodityAdapterType adapterType;

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *detailView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;//商品名称
@property (nonatomic, weak) IBOutlet StrikeThroughLabel *priceLabel;//原价格
@property (nonatomic, weak) IBOutlet UILabel *killPriceLabel;//秒杀价格
@property (nonatomic, weak) IBOutlet UILabel *surplusLabel;//秒杀剩余时间
@property (nonatomic, weak) IBOutlet UILabel *surplusTipLabel;//剩余时间左侧的提示标签
@property (weak, nonatomic) IBOutlet YLProgressBar *alreadyOrderPB;//已订购比率

@property (nonatomic, weak) IBOutlet UILabel *inventoryLabel;//剩余库存
@property (nonatomic, weak) IBOutlet UILabel *detrusionTimeTipLabel;//推出时间左侧的提示标签
@property (nonatomic, weak) IBOutlet UILabel *detrusionTimeLabel;//秒杀推出时间

@property (nonatomic, weak) IBOutlet UIImageView *sourceImg;//商品来源
@property (nonatomic, weak) IBOutlet UIImageView *pictureImg;//商品图片

@property (nonatomic, weak) IBOutlet UIButton *shareBtn;//分享
@property (nonatomic, weak) IBOutlet UIButton *upBtn;//顶
@property (nonatomic, weak) IBOutlet UIButton *linkOrAlertBtn;//直达链接

@property (nonatomic, strong) Commodity *commodity;//商品对象

//分享
- (IBAction)share:(id)sender;
//顶
- (IBAction)up:(id)sender;
//直达链接
- (IBAction)linkOrAlert:(id)sender;

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName;

- (void)updateSurplusOrDetrusionTime;

@end
