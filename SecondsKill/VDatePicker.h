//
//  VDatePicker.h
//  SecondsKill
//
//  Created by lijingcheng on 13-12-3.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VDatePickerDelegate <NSObject>

-(void)didCancelPicker;
-(void)didConfirmPicker:(NSString *)date;

@end

@interface VDatePicker : UIDatePicker

@property(nonatomic, assign) id<VDatePickerDelegate> delegate;

@end