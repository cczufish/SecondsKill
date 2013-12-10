//
//  SuperViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

typedef enum {
    RefreshTableViewModePullDown = 0,
    RefreshTableViewModePullUp,
    RefreshTableViewModeNone
} RefreshTableViewMode;

typedef enum {
    SortTableViewTypeTime = 0,
    SortTableViewTypeDiscount
} SortTableViewType;

typedef void (^RefreshTableViewCallBack)(NSMutableArray *datas);

@interface SuperViewController : UITableViewController<UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *timers;

@property (nonatomic, assign) BOOL canRefreshTableView;

@property (nonatomic, assign) int pageNO;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, strong) NSMutableDictionary *params;

- (UIViewController *)currentViewController;

- (void)showMenuViewController;

- (void)refreshTableView:(RefreshTableViewMode)refreshMode callBack:(RefreshTableViewCallBack)callBack;

//下拉刷新
- (void)pullDownRefresh;

//上拉刷新
- (void)pullUpRefresh;

- (void)endRefresh:(NSString *)msg style:(ALAlertBannerStyle)style refreshMode:(RefreshTableViewMode)refreshMode;

@end
