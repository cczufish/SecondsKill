//
//  CommodityTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "StrikeThroughLabel.h"

@implementation StrikeThroughLabel

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];

    if (_strikeThroughEnabled) {
        CGSize textSize = [self.text sizeWithFont:self.font];
        CGFloat strikeWidth = textSize.width;
       
        CGFloat x = 0;
        if (self.textAlignment == NSTextAlignmentRight) {
            x = rect.size.width - strikeWidth;
        }
        else if(self.textAlignment == NSTextAlignmentCenter) {
            x = rect.size.width/2 - strikeWidth/2;
        }

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, CGRectMake(x, rect.size.height/2, strikeWidth, 1));
    }
}

@end
