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
#import "UIViewController+AKTabBarController.h"

@interface CommodityTableViewCell ()

@end

@implementation CommodityTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor =  RGBCOLOR(38.0f, 38.0f, 38.0f);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.font = DEFAULT_FONT;
    
    self.bottomView.layer.cornerRadius = 3;
    self.bottomView.layer.masksToBounds = YES;

    self.nameLabel.numberOfLines = 0;//自动换行
    self.pictureImg.contentMode = UIViewContentModeScaleAspectFit;//自适应图片宽高比例
    self.priceLabel.strikeThroughEnabled = YES;//删除线

    [self setButtonStyle:self.shareBtn imageName:@"icon_share.png"];
    [self setButtonStyle:self.upBtn imageName:@"icon_up.png"];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateSurplusOrDetrusionTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName
{
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btn.titleLabel.font = DEFAULT_FONT;
    
    if(btn.titleLabel.frame.size.width < 50.0f) {
        if (btn.titleLabel.frame.size.width < 30.0f) {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 50.0)];
        }
        else {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 30.0)];
        }
    }
    else {
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
    }
    
    [btn setImage:[[UIImage imageNamed:imageName] imageWithNewSize:CGSizeMake(18, 18)] forState:UIControlStateNormal];
}

- (void)updateSurplusOrDetrusionTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.adapterType == CommodityAdapterTypeKilling) {
            if ([self.commodity.surplusTime isEqualToString:@"00:00:00"]) {
                self.surplusTipLabel.text = @"秒杀已经结束";
                self.surplusLabel.hidden = YES;
                self.alreadyOrderPB.hidden = YES;
            }
            else {
                self.surplusLabel.text = self.commodity.surplusTime;
                self.surplusTipLabel.text = @"剩余时间：";
                self.surplusLabel.hidden = NO;
                self.alreadyOrderPB.hidden = NO;
            }
        }
        else if (self.adapterType == CommodityAdapterTypeNotBegin) {
            if ([self.commodity.detrusionTime isEqualToString:@"00:00:00"]) {
                NotBeginViewController *notBeginVC = (NotBeginViewController *)[self inViewController];
                [notBeginVC.tableViewAdapter.commoditys removeObject:self.commodity];
                [self.tableView reloadData];
            }
            else {
                self.detrusionTimeLabel.text = self.commodity.detrusionTime;
            }
        }
    });
}

#pragma mark - IBAction

- (IBAction)share:(id)sender
{
    id vc = [self inViewController];

    [UMSocialSnsService presentSnsIconSheetView:vc appKey:UMENG_APPKEY shareText:[NSString stringWithFormat:@"%@ %@",UM_SHARED_TEXT,self.commodity.link] shareImage:UM_SHARED_IMAGE shareToSnsNames:nil delegate:vc];
}

- (IBAction)up:(id)sender
{
    if (![@"YES" isEqualToString:self.commodity.isUp]) {
        if ([VNetworkHelper hasNetWork]) {
            [VAnimationHelper animationScaleAndRestore:self.upBtn.imageView];
            [self.upBtn setImage:[self.upBtn.imageView.image tintColor:NAV_BACKGROUND_COLOR] forState:UIControlStateNormal];
            [self.upBtn setTitle:[NSString stringWithFormat:@"%d",[self.commodity.likingCount intValue] + 1] forState:UIControlStateNormal];
            
            self.commodity.isUp = @"YES";
            [VDataBaseHelper update:self.commodity];

            VRequestHelper *requestHelper = [[VRequestHelper alloc] initWithURI:[NSString stringWithFormat:@"users/me/like/%@",self.commodity.itemID] httpMethod:@"POST"];
            [requestHelper requestWithCompletionBlock:nil];
        }
        else {
            [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [self inViewController];
    if ([vc isKindOfClass:[KillingViewController class]]) {
       [((KillingViewController *)vc).sortMenu close];
    }
}

- (IBAction)linkOrAlert:(id)sender
{
    if (self.adapterType == CommodityAdapterTypeKilling) {
        UIViewController *vc = [self inViewController];
        VWebViewController *webVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
        webVC.navigationItem.title = vc.tabTitle;

        webVC.linkAddress = self.commodity.link;
        [webVC setHidesBottomBarWhenPushed:YES];
        [vc.navigationController pushViewController:webVC animated:YES];
    }
    else if (self.adapterType == CommodityAdapterTypeNotBegin) {
        if ([VNetworkHelper hasNetWork]) {
            [VAnimationHelper animationScaleAndRestore:self.linkOrAlertBtn.imageView];
 
            VRequestHelper *requestHelper = nil;
            
            if ([@"YES" isEqualToString:self.commodity.isAlert]) {
                [self.linkOrAlertBtn setImage:[self.linkOrAlertBtn.imageView.image tintColor:[UIColor blackColor]] forState:UIControlStateNormal];
                self.commodity.isAlert = @"NO";

                requestHelper = [[VRequestHelper alloc] initWithURI:[NSString stringWithFormat:@"users/me/disalert/%@",self.commodity.itemID] httpMethod:@"DELETE"];
            }
            else {
                [self.linkOrAlertBtn setImage:[self.linkOrAlertBtn.imageView.image tintColor:NAV_BACKGROUND_COLOR] forState:UIControlStateNormal];
                self.commodity.isAlert = @"YES";
                
                requestHelper = [[VRequestHelper alloc] initWithURI:[NSString stringWithFormat:@"users/me/alert/%@",self.commodity.itemID] httpMethod:@"POST"];
            }
            
            [VDataBaseHelper update:self.commodity];

            [requestHelper requestWithCompletionBlock:nil];
        }
        else {
            [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
        }
    }
}

@end
