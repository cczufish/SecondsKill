//
//  ActivityWallViewController.m
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "ActivityWallViewController.h"

@interface ActivityWallViewController ()

@end

@implementation ActivityWallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealController.recognizesPanningOnFrontView = YES;
    
    [MobClick beginLogPageView:@"\"活动墙\"界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.revealController.recognizesPanningOnFrontView = NO;
    
    [MobClick endLogPageView:@"\"活动墙\"界面"];
}

#pragma mark - AKTabBarController need

- (NSString *)tabImageName
{
    return @"icon_calendar_normal.png";
}

- (NSString *)tabTitle
{
    return @"活动墙";
}

@end
