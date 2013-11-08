//
//  SimpleCommodityTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-6.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "SimpleCommodityTableViewCell.h"

@implementation SimpleCommodityTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.sourceImg.layer.cornerRadius = 3;
    self.sourceImg.layer.masksToBounds = YES;
    
    self.nameLabel.numberOfLines = 0;//自动换行
}

@end
