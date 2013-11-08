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

@implementation CommodityTableViewAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellID];
    cell.adapterType = self.adapterType;
    
    Commodity *temp = [self.commoditys objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [temp.name stringByAppendingString:@"\n "];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", temp.price];
    cell.killPriceLabel.text = [NSString stringWithFormat:@"￥%g", temp.killPrice];
    [cell.sourceImg setImageWithURL:[NSURL URLWithString:temp.source] placeholderImage:nil];
    [cell.pictureImg setImageWithURL:[NSURL URLWithString:temp.pictureURL] placeholderImage:nil];
    [cell.upBtn setTitle:[NSString stringWithFormat:@"%d", temp.upCount] forState:UIControlStateNormal];

    
    if (self.adapterType == CommodityAdapterTypeKilling) {
        
        cell.alreadyOrderPB.indicatorTextLabel.text = [NSString stringWithFormat:@"现已订购: %g%%", temp.alreadyOrder];
        
        cell.alreadyOrderPB.type = YLProgressBarTypeFlat;
        cell.alreadyOrderPB.progressTintColor = RGB(255, 193, 0);
        cell.alreadyOrderPB.hideStripes = YES;
        cell.alreadyOrderPB.trackTintColor = [UIColor clearColor];
        cell.alreadyOrderPB.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.alreadyOrderPB.layer.borderWidth = 1.0f;
        cell.alreadyOrderPB.layer.cornerRadius = 2.0f;
        cell.alreadyOrderPB.layer.masksToBounds = YES;
        cell.alreadyOrderPB.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeTrack;
        cell.alreadyOrderPB.indicatorTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.alreadyOrderPB.indicatorTextLabel.font = [UIFont fontWithName:FONT_NAME size:13.0f];
        cell.alreadyOrderPB.indicatorTextLabel.textColor = [UIColor blackColor];

        if ([temp.surplus isEqualToString:@"00:00:00"]) {
            cell.surplusTipLabel.text = @"已被秒杀空了";
            cell.surplusLabel.hidden = YES;
        }
        else {
            cell.surplusLabel.text = temp.surplus;
        }
        
        cell.alreadyOrderPB.progress = temp.alreadyOrder/100;
        
        if (cell.alreadyOrderPB.progress == 1.0f) {
            cell.alreadyOrderPB.progressTintColor = [UIColor lightGrayColor];
        }
        
        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_link.png"];
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        if ([temp.detrusionTime isEqualToString:@"00:00:00"]) {
            cell.detrusionTimeTipLabel.text = @"已被秒杀空了";
            cell.detrusionTimeLabel.hidden = YES;
        }
        else {
            cell.detrusionTimeLabel.text = temp.detrusionTime;
        }
        
        cell.inventoryLabel.text = [NSString stringWithFormat:@"%d",temp.inventory];
        
        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_bell_off.png"];
    }
    
    cell.commodity = temp;
    
    return cell;
}


@end
