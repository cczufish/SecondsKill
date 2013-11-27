//
//  CommodityTableViewAdapter.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-5.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "CommodityTableViewAdapter.h"
#import "CommodityTableViewCell.h"
#import "Commodity.h"

#define kPadding 5.0f
#define kSourceImgHeight 44.0f
#define kDetailViewHeight 140.0f

@interface CommodityTableViewAdapter ()

@property (nonatomic, assign) CommodityAdapterType adapterType;

@end

@implementation CommodityTableViewAdapter

- (id)initWithType:(CommodityAdapterType)adapterType
{
    self = [super init];
    if (self) {
        self.adapterType = adapterType;
        self.commoditys = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    
    CGSize size = [commodity.title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(260.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = kPadding + MAX(size.height, kSourceImgHeight) + kPadding + kDetailViewHeight + kPadding + kPadding;

    return MAX(cellHeight, 200.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.adapterType == CommodityAdapterTypeKilling?@"killingCellID":@"notBeginCellID"];
    cell.adapterType = self.adapterType;

    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    cell.commodity = commodity;
    
    CGSize size = [commodity.title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newRect = cell.nameLabel.frame;
//    NSLog(@"_________%f",newRect.size.height);
    newRect.size.height = size.height;// + 50 就可以，说明还是能换行，可能只是没靠上对齐的原因
    cell.nameLabel.frame = newRect;
//NSLog(@"_________%f,%@",newRect.size.height,commodity.title);
    cell.nameLabel.text = commodity.title;
    
    CGRect detailRect = cell.detailView.frame;
    detailRect.origin.y = newRect.origin.y + MAX(newRect.size.height, kSourceImgHeight) + kPadding;
    cell.detailView.frame = detailRect;
    
    CGRect bottomViewRect = cell.bottomView.frame;
    bottomViewRect.size.height = detailRect.origin.y + kDetailViewHeight + kPadding;
    cell.bottomView.frame = bottomViewRect;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", commodity.o_price];
    cell.killPriceLabel.text = [NSString stringWithFormat:@"￥%g", commodity.price];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",commodity.site]];
    [cell.pictureImg setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:nil];
    [cell.upBtn setTitle:[NSString stringWithFormat:@"%d", 2] forState:UIControlStateNormal];

    if (self.adapterType == CommodityAdapterTypeKilling) {
        float alreadyOrder = 0.0f;
        if (commodity.total != 0) {
            alreadyOrder = 1 - (float)commodity.remain/commodity.total;
        }
        
        cell.alreadyOrderPB.indicatorTextLabel.text = [NSString stringWithFormat:@"现已订购: %.3g%%", alreadyOrder*100];
        cell.alreadyOrderPB.progress = alreadyOrder;
        
        if (cell.alreadyOrderPB.progress == 1.0f) {
            cell.alreadyOrderPB.progressTintColor = [UIColor lightGrayColor];
        }
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        cell.inventoryLabel.text = [NSString stringWithFormat:@"%d",commodity.total];
    }

    [cell updateSurplusOrDetrusionTime];

    return cell;
}

@end
