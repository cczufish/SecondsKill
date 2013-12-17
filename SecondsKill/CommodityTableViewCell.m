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
    btn.titleLabel.font = [UIFont fontWithName:FONT_NAME size:15];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [btn setImage:[[[UIImage imageNamed:imageName] imageWithNewSize:CGSizeMake(16, 16)] tintColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
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
                
                if ([notBeginVC.tableViewAdapter.commoditys count] == 0) {
                    [notBeginVC refresh];
                }
            }
            else {
                self.detrusionTimeLabel.text = self.commodity.detrusionTime;
            }
        }
    });
}

#pragma mark - IBAction

- (NSString *)shareText
{
    NSString *msg = @"";
    
    if (self.adapterType == CommodityAdapterTypeNotBegin) {
        //2天
        //3个多小时
        //15分钟  不要秒
        //只有秒   即刻开始秒杀
        NSString *info = [NSString stringWithFormat:@"还有。。。。开始秒杀"];
        
        if (self.commodity.price > 0) {
            info = [NSString stringWithFormat:@"只要%g元哟，%@",self.commodity.price,info];
        }
        msg = [NSString stringWithFormat:@"#秒杀惠# %@，%@，快来看看吧! %@",self.commodity.title, info, self.commodity.link];
    }
    else {
        NSString *info = [NSString stringWithFormat:@"只要%g元哟", self.commodity.price];
        
        if ([self.commodity.discount floatValue] < 7 && [self.commodity.discount floatValue] > 0) {
            info = [NSString stringWithFormat:@"只要%@折哟",self.commodity.discount];
        }
        msg = [NSString stringWithFormat:@"#秒杀惠# %@，%@，快来看看吧! %@",self.commodity.title, info, self.commodity.link];
    }

    return msg;
}

- (IBAction)share:(id)sender
{
    id vc = [self inViewController];
    
    [UMSocialSnsService presentSnsIconSheetView:vc appKey:UMENG_APPKEY shareText:[self shareText] shareImage:self.commodityImage shareToSnsNames:nil delegate:vc];
}

- (IBAction)up:(id)sender
{
    if (![@"YES" isEqualToString:self.commodity.isUp]) {
        if ([VNetworkHelper hasNetWork]) {
            [VAnimationHelper animationScaleAndRestore:self.upBtn.imageView];
            [self.upBtn setImage:[self.upBtn.imageView.image tintColor:NAV_BACKGROUND_COLOR] forState:UIControlStateNormal];
            
            //没有网时，数据会从本地加载，所以为了防止upBtn.title为空或空字符串时用户还要点此按钮，所以做此操作
            if (self.commodity.likingCount && ![@"" isEqualToString:self.commodity.likingCount]) {
               [self.upBtn setTitle:[NSString stringWithFormat:@"%d",[self.commodity.likingCount intValue] + 1] forState:UIControlStateNormal];
            }
            else {
                [self.upBtn setTitle:@"1" forState:UIControlStateNormal];
            }

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
        KillingViewController *killingVC = (KillingViewController *)vc;
        [killingVC showSortMenuView:nil];
    }
}

- (IBAction)linkOrAlert:(id)sender
{
    if (self.adapterType == CommodityAdapterTypeKilling) {
        UIViewController *vc = [self inViewController];
        VWebViewController *webVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"VWebViewController"];
        webVC.navigationItem.title = vc.tabTitle;

        webVC.commodity = self.commodity;
        webVC.adapterType = self.adapterType;
        webVC.linkAddress = self.commodity.link;
        webVC.shareImage = self.commodityImage;
        webVC.shareText = [self shareText];
        
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
