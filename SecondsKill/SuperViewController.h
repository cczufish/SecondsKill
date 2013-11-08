//
//  SuperViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperViewController : UITableViewController

@property (nonatomic, assign) BOOL needPullRefresh;

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName;

@end
