//
//  ActivityWallTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-18.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWallTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;//商品名称
@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel;//开始时间
@property (nonatomic, weak) IBOutlet UIImageView *sourceImg;//商品来源

@end
