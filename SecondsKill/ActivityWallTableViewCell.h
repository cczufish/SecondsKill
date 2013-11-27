//
//  ActivityWallTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWallTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *createTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sourceImg;

@end
