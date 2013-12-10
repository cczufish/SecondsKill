//
//  ComparePriceTableViewCell.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ComparePriceTableViewCell.h"
#import "ComparePriceViewController.h"

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
    //必须调用super....否则cell不响应事件
    [super touchesBegan:touches withEvent:event];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
