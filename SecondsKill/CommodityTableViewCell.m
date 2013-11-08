//
//  CommodityTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "CommodityTableViewCell.h"

#define kDateFormat @"HH:mm:ss"
#define kNullTime @"00:00:00"

@interface CommodityTableViewCell ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CommodityTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor =  RGB(38.0f, 38.0f, 38.0f);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bottomView.layer.cornerRadius = 1;
    self.bottomView.layer.masksToBounds = YES;
    
    self.sourceImg.layer.cornerRadius = 3;
    self.sourceImg.layer.masksToBounds = YES;

    self.nameLabel.numberOfLines = 0;//自动换行
    self.pictureImg.contentMode = UIViewContentModeScaleAspectFit;//自适应图片宽高比例
    self.priceLabel.strikeThroughEnabled = YES;//删除线
    
    [self setButtonStyle:self.shareBtn imageName:@"icon_share.png"];
    [self setButtonStyle:self.upBtn imageName:@"btn_hui.png"];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeSurplusTime) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName
{
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 30.0)];
    [btn setImage:[[UIImage imageNamed:imageName] imageWithNewSize:CGSizeMake(16, 16)] forState:UIControlStateNormal];
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
}

- (void)changeSurplusTime
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:kDateFormat];
    
    if (self.adapterType == CommodityAdapterTypeKilling) {
        if (![self.surplusTipLabel.text isEqualToString:@"已被秒杀空了"]) {
            NSDate *date = [fmt dateFromString:self.surplusLabel.text];
            NSDate *newdate = [date dateByAddingTimeInterval:-1.0f];
            
            self.surplusLabel.text = [fmt stringFromDate:newdate];
            self.commodity.surplus = [fmt stringFromDate:newdate];
            
            if ([self.commodity.surplus isEqualToString:kNullTime]) {
                self.surplusTipLabel.text = @"已被秒杀空了";
                self.surplusLabel.hidden = YES;
                self.commodity.surplus = self.surplusLabel.text;
            }
        }
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        if (![self.detrusionTimeTipLabel.text isEqualToString:@"可以开始秒杀了"]) {
            NSDate *date = [fmt dateFromString:self.detrusionTimeLabel.text];
            NSDate *newdate = [date dateByAddingTimeInterval:-1.0f];
            
            self.detrusionTimeLabel.text = [fmt stringFromDate:newdate];
            self.commodity.detrusionTime = [fmt stringFromDate:newdate];
            
            if ([self.commodity.detrusionTime isEqualToString:kNullTime]) {
                self.detrusionTimeTipLabel.text = @"可以开始秒杀了";
                self.detrusionTimeLabel.hidden = YES;
                self.commodity.detrusionTime = self.detrusionTimeLabel.text;
            }
        }
    }
}

- (IBAction)share:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"share" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)up:(id)sender
{
    int upCount = [self.upBtn.titleLabel.text intValue];
    [self.upBtn setTitle:[NSString stringWithFormat:@"%d",++upCount] forState:UIControlStateNormal];
}

- (IBAction)linkOrAlert:(id)sender
{
    if (self.adapterType == CommodityAdapterTypeKilling) {
        UIViewController *vc = self.viewController;
        VWebViewController *webVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
        webVC.navigationItem.title = vc.navigationItem.title;
        webVC.linkAddress = self.commodity.link;
        [webVC setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:webVC animated:YES];
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"秒杀提醒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
