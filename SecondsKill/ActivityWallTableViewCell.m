//
//  ActivityWallTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ActivityWallTableViewCell.h"

@implementation ActivityWallTableViewCell

- (void)awakeFromNib
{
    self.nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.font = DEFAULT_FONT;
}

@end
