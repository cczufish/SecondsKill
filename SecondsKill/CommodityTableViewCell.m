//
//  CommodityTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "CommodityTableViewCell.h"
#import "KillingViewController.h"
#import "NotBeginViewController.h"

@interface CommodityTableViewCell ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CommodityTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor =  RGBCOLOR(38.0f, 38.0f, 38.0f);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.font = DEFAULT_FONT;
    self.nameLabel.backgroundColor = [UIColor redColor];
    self.bottomView.layer.cornerRadius = 3;
    self.bottomView.layer.masksToBounds = YES;

    self.nameLabel.numberOfLines = 0;//自动换行
    self.pictureImg.contentMode = UIViewContentModeScaleAspectFit;//自适应图片宽高比例
    self.priceLabel.strikeThroughEnabled = YES;//删除线
    
    if (self.adapterType == CommodityAdapterTypeKilling) {
        self.alreadyOrderPB.type = YLProgressBarTypeFlat;
        self.alreadyOrderPB.progressTintColor = RGBCOLOR(255, 193, 0);
        self.alreadyOrderPB.hideStripes = YES;
        self.alreadyOrderPB.trackTintColor = [UIColor clearColor];
        self.alreadyOrderPB.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.alreadyOrderPB.layer.borderWidth = 1.0f;
        self.alreadyOrderPB.layer.cornerRadius = 2.0f;
        self.alreadyOrderPB.layer.masksToBounds = YES;
        self.alreadyOrderPB.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeTrack;
        self.alreadyOrderPB.indicatorTextLabel.textAlignment = NSTextAlignmentCenter;
        self.alreadyOrderPB.indicatorTextLabel.font = DEFAULT_FONT;
        self.alreadyOrderPB.indicatorTextLabel.textColor = [UIColor blackColor];

        [self setButtonStyle:self.linkOrAlertBtn imageName:@"icon_link.png"];
     }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        [self setButtonStyle:self.linkOrAlertBtn imageName:@"icon_bell_off.png"];
    }
    
    [self setButtonStyle:self.shareBtn imageName:@"icon_share.png"];
    [self setButtonStyle:self.upBtn imageName:@"icon_bell_off.png"];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateSurplusOrDetrusionTime) userInfo:nil repeats:YES];
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

- (void)updateSurplusOrDetrusionTime
{
    if (self.adapterType == CommodityAdapterTypeKilling) {
        if ([self.commodity.surplusTime isEqualToString:@"00:00:00"]) {
            self.surplusTipLabel.text = @"秒杀已经结束";
            self.surplusLabel.hidden = YES;
            self.alreadyOrderPB.hidden = YES;
            
            [self.timer invalidate];
        }
        else {
            self.surplusLabel.text = self.commodity.surplusTime;
        }
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        if ([self.commodity.detrusionTime isEqualToString:@"00:00:00"]) {
            self.detrusionTimeTipLabel.text = @"秒杀已经开始";
            self.detrusionTimeLabel.hidden = YES;
            
            [self.timer invalidate];
        }
        else {
            self.detrusionTimeLabel.text = self.commodity.detrusionTime;
        }
    }
}

#pragma mark - IBAction

- (IBAction)share:(id)sender
{
    id vc = self.viewController;
    
    if ([vc isKindOfClass:[KillingViewController class]]) {
        vc = (KillingViewController *) vc;
    }
    else if ([vc isKindOfClass:[NotBeginViewController class]]) {
        vc = (NotBeginViewController *) vc;
    }
    
    [UMSocialSnsService presentSnsIconSheetView:self.viewController
                                         appKey:UMENG_APPKEY
                                      shareText:@"好便宜啊，大家快来看！"
                                     shareImage:[UIImage imageNamed:@"icon_bell_on.png"]
                                shareToSnsNames:nil
                                       delegate:vc];
}

//upded这个数据需要通过本地存储的该商品数据与新拿来的商品数据pi配，如果是同一商品，那么由本地存储的uped数据判断该怎么处理，本地存储数据3天清一次缓存，只清3天前数据，前一、两天的不清。
- (IBAction)up:(id)sender
{
//    if (self.commodity.uped) {
//        [sender setImage:[[UIImage imageNamed:@"icon_bell_off.png"] imageWithNewSize:CGSizeMake(16, 16)] forState:UIControlStateNormal];
//        
//        int upCount = [self.upBtn.titleLabel.text intValue];
//        [sender setTitle:[NSString stringWithFormat:@"%d",--upCount] forState:UIControlStateNormal];
//    }
//    else {
//        [sender setImage:[[UIImage imageNamed:@"icon_bell_on.png"] imageWithNewSize:CGSizeMake(16, 16)] forState:UIControlStateNormal];
//        
//        int upCount = [self.upBtn.titleLabel.text intValue];
//        [sender setTitle:[NSString stringWithFormat:@"%d",++upCount] forState:UIControlStateNormal];
//    }
//    self.commodity.uped = !self.commodity.uped;
}

- (IBAction)linkOrAlert:(id)sender
{
    if (self.adapterType == CommodityAdapterTypeKilling) {
        UIViewController *vc = self.viewController;
        VWebViewController *webVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
        webVC.navigationItem.title = vc.tabTitle;

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
