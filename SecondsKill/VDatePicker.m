//
//  VDatePicker.m
//  SecondsKill
//
//  Created by lijingcheng on 13-12-3.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VDatePicker.h"

#define kToolBarHeight 44
#define kObservedFrame @"frame"

@interface VDatePicker()

@property (nonatomic, retain) UIToolbar *toolBar;

@end
/*
 -(void)didCancelPicker
 {
 [UIView animateWithDuration:0.3f animations:^{
 self.datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,  self.datePicker.frame.size.height);
 }];
 }
 
 -(void)didConfirmPicker:(NSString *)date
 {
 [UIView animateWithDuration:0.3f animations:^{
 self.datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,  self.datePicker.frame.size.height);
 } completion:^(BOOL finished) {
 [self.birthdayBtn setTitle:date forState:UIControlStateNormal];
 }];
 }
 */
@implementation VDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT + kToolBarHeight, self.frame.size.width, self.frame.size.height)];
    if (self) {
        [self addObserver:self forKeyPath:kObservedFrame options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kObservedFrame]) {
        [UIView animateWithDuration:0.3f animations:^{
            if ((self.superview.frame.size.height - self.frame.size.height) == self.frame.origin.y) {
                self.toolBar.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height-self.frame.size.height-kToolBarHeight, self.frame.size.width, kToolBarHeight);
            }
            else {
                self.toolBar.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-kToolBarHeight, self.frame.size.width, kToolBarHeight);
            }
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPicker:)];
    UIBarButtonItem *confirmBtn  = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmPicker:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *toolBarItems = [[NSArray alloc] initWithObjects:cancelBtn, flexibleSpace, confirmBtn, nil];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-kToolBarHeight, self.frame.size.width, kToolBarHeight)];
    _toolBar.barStyle = UIBarStyleBlack;
    _toolBar.items = toolBarItems;
    [self.superview addSubview:_toolBar];
}

-(void)cancelPicker:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelPicker)]) {
        [self.delegate didCancelPicker];
    }
}

-(void)confirmPicker:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConfirmPicker:)]) {
        [self.delegate didConfirmPicker:[VDateTimeHelper formatDateToString:self.date]];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kObservedFrame];
}

@end
