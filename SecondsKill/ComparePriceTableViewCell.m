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
    self.nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.font = DEFAULT_FONT;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[self.view endEditing:YES];
}

@end
