//
//  ComparePriceTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceTableViewCell.h"

@implementation ComparePriceTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.font = DEFAULT_FONT;
}

@end
