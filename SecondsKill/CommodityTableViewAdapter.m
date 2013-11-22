//
//  CommodityTableViewAdapter.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-5.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "CommodityTableViewAdapter.h"
#import "CommodityTableViewCell.h"

#define kPadding 5.0f
#define kSourceImgHeight 44.0f
#define kDetailViewHeight 140.0f

@implementation CommodityTableViewAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.commoditys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ApigeeEntity *entity = [self.commoditys objectAtIndex:indexPath.row];
    
    NSString *title = @"";//[entity getStringProperty:@"title"];

    CGSize size = [title sizeWithFont:DEFAULT_FONT constrainedToSize:CGSizeMake(260.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = kPadding + MAX(size.height, kSourceImgHeight) + kPadding + kDetailViewHeight + kPadding + kPadding;

    return MAX(cellHeight, 200.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellID];
    cell.adapterType = self.adapterType;

    /*ApigeeEntity *entity = [self.commoditys objectAtIndex:indexPath.row];
    
    NSString *title = [entity getStringProperty:@"title"];

    CGSize size = [title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;

    cell.nameLabel.text = title;
    
    CGRect detailRect = cell.detailView.frame;
    detailRect.origin.y = newRect.origin.y + MAX(newRect.size.height, kSourceImgHeight) + kPadding;
    cell.detailView.frame = detailRect;
    
    CGRect bottomViewRect = cell.bottomView.frame;
    bottomViewRect.size.height = detailRect.origin.y + kDetailViewHeight + kPadding;
    cell.bottomView.frame = bottomViewRect;
NSLog(@"-----------%f",cell.bottomView.frame.size.height);
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", [entity getFloatProperty:@"o_price"]];
    cell.killPriceLabel.text = [NSString stringWithFormat:@"￥%g", [entity getFloatProperty:@"m_price"]];
    cell.sourceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[entity getStringProperty:@"site"]]];
    [cell.pictureImg setImageWithURL:[NSURL URLWithString:[entity getStringProperty:@"img_url"]] placeholderImage:nil];
    [cell.upBtn setTitle:[NSString stringWithFormat:@"%d", [entity getIntProperty:@"likes"]] forState:UIControlStateNormal];
   
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HH:mm:ss"];
    
    if (self.adapterType == CommodityAdapterTypeKilling) {
        float alreadyOrder = 1 - [entity getFloatProperty:@"remain"]/[entity getFloatProperty:@"total"];

        cell.alreadyOrderPB.indicatorTextLabel.text = [NSString stringWithFormat:@"现已订购: %g%%", alreadyOrder*100];
        
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
        cell.alreadyOrderPB.indicatorTextLabel.font = DEFAULT_FONT;
        cell.alreadyOrderPB.indicatorTextLabel.textColor = [UIColor blackColor];
        
        NSDate *endTime = [fmt dateFromString:[NSString stringWithFormat:@"%ld",[entity getLongProperty:@"end_t"]]];
        //            NSDate *newdate = [date dateByAddingTimeInterval:-1.0f];

        NSLog(@"%ld,%@",[entity getLongProperty:@"end_t"],[fmt stringFromDate:endTime]);
        
//        if ([temp.surplus isEqualToString:@"00:00:00"]) {
//            cell.surplusTipLabel.text = @"已被秒杀空了";
//            cell.surplusLabel.hidden = YES;
//        }
//        else {
            cell.surplusLabel.text = [fmt stringFromDate:endTime];
//        }
        
        cell.alreadyOrderPB.progress = alreadyOrder;
        
        if (cell.alreadyOrderPB.progress == 1.0f) {
            cell.alreadyOrderPB.progressTintColor = [UIColor lightGrayColor];
        }
        
        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_link.png"];
    }
    
    "cate" : "图书/音像",
     "end_t" : 1384653398218,
     "site" : "jd",
     "start_t" : 1384646198218,
    
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
//        if ([temp.detrusionTime isEqualToString:@"00:00:00"]) {
//            cell.detrusionTimeTipLabel.text = @"已被秒杀空了";
//            cell.detrusionTimeLabel.hidden = YES;
//        }
//        else {
//            cell.detrusionTimeLabel.text = temp.detrusionTime;
//        }
        
        cell.inventoryLabel.text = [NSString stringWithFormat:@"%d", [entity getIntProperty:@"total"]];
        
        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_bell_off.png"];
    }
    
    cell.entity = entity;
    */
    return cell;
}

@end
