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
    cell.tableView = tableView;

    Commodity *commodity = [self.commoditys objectAtIndex:indexPath.row];
    cell.commodity = commodity;
    
    CGSize size = [commodity.title sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(cell.nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newRect = cell.nameLabel.frame;
    newRect.size.height = size.height;
    cell.nameLabel.frame = newRect;
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
    
    [cell.upBtn setTitle:commodity.likingCount forState:UIControlStateNormal];
    [cell.upBtn setImage:[cell.upBtn.imageView.image tintColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [cell.linkOrAlertBtn setImage:[cell.linkOrAlertBtn.imageView.image tintColor:[UIColor blackColor]] forState:UIControlStateNormal];
    
    NSDictionary *dict = [VDataBaseHelper queryById:commodity.itemID from:[commodity tableName]];
    
    if (dict) {
        if ([@"YES" isEqualToString:[dict objectForKey:@"isUp"]]) {
            commodity.isUp = @"YES";
            [cell.upBtn setImage:[cell.upBtn.imageView.image tintColor:NAV_BACKGROUND_COLOR] forState:UIControlStateNormal];
        }
    }

    if (self.adapterType == CommodityAdapterTypeKilling) {
        
        //京东的剩余库存没数据，所以做此处理
        if ([@"jd" isEqualToString:commodity.site]) {
            cell.alreadyOrderPB.hidden = YES;
        }
        else {
            cell.alreadyOrderPB.hidden = NO;
            
            float alreadyOrder = 0.0f;
            if (commodity.total != 0) {
                alreadyOrder = 1 - (float)commodity.remain/commodity.total;
            }
            
            cell.alreadyOrderPB.type = YLProgressBarTypeFlat;
            cell.alreadyOrderPB.progressTintColor = RGBCOLOR(255, 193, 0);
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
            
            cell.alreadyOrderPB.indicatorTextLabel.text = [NSString stringWithFormat:@"现已订购: %d%%", (int)(alreadyOrder * 100)];
            cell.alreadyOrderPB.progress = alreadyOrder;
            
            if (cell.alreadyOrderPB.progress == 1.0f) {
                cell.alreadyOrderPB.progressTintColor = [UIColor lightGrayColor];
                cell.surplusLabel.hidden = YES;
                cell.surplusTipLabel.hidden = YES;
            }
            else {
                cell.surplusLabel.hidden = NO;
                cell.surplusTipLabel.hidden = NO;
            }
        }
        
        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_link.png"];
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {

        [cell setButtonStyle:cell.linkOrAlertBtn imageName:@"icon_bell.png"];
        
        //京东的剩余库存没数据，所以做此处理
        if ([@"jd" isEqualToString:commodity.site]) {
            cell.inventoryLabel.text = @"有库存";
        }
        else {
            cell.inventoryLabel.text = [NSString stringWithFormat:@"%d",commodity.total];
        }
        
        //有些商品拿不到秒杀价格，所以价格就是0，又因为拿不到价格真的为0的商品，所以做此处理
        if (commodity.price == 0.0f) {
            cell.killPriceLabel.text = @"暂未公布";
        }
        
        if (dict) {
            if ([@"YES" isEqualToString:[dict objectForKey:@"isAlert"]]) {
                commodity.isAlert = @"YES";
                [cell.linkOrAlertBtn setImage:[cell.linkOrAlertBtn.imageView.image tintColor:NAV_BACKGROUND_COLOR] forState:UIControlStateNormal];
            }
        }
    }
    
    [cell updateSurplusOrDetrusionTime];

    UINavigationController *nav = (UINavigationController *)[tableView inViewController];
    SuperViewController *superVC = (SuperViewController *)nav.topViewController;
    [superVC.timers addObject:cell.timer];

    return cell;
}

@end
