//
//  SuperViewController.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-29.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RefreshTableViewModePullDown = 0,
    RefreshTableViewModePullUp
} RefreshTableViewMode;

typedef void (^RefreshTableViewCallBack)(NSMutableArray *datas);

@interface SuperViewController : UITableViewController<UMSocialUIDelegate>

@property (nonatomic, assign) BOOL canRefreshTableView;
@property (nonatomic, assign) BOOL canShowMenuViewController;

@property (nonatomic, assign) int pageNO;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, strong) NSMutableDictionary *params;

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName;

- (UIViewController *)currentViewController;

- (void)showMenuViewController;

- (void)refreshTableView:(RefreshTableViewMode)refreshMode callBack:(RefreshTableViewCallBack)callBack;

@end
