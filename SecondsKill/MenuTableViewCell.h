//
//  MenuTableViewCell.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *leftMenuItem;
@property (nonatomic, weak) IBOutlet UIButton *rightMenuItem;
@property (nonatomic, weak) IBOutlet UIButton *centerMenuItem;

- (IBAction)buttonPressed:(UIButton *)btn;

@end
