//
//  VDateTimeHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDateTimeHelper : NSObject

+ (NSDateComponents *)splitDate:(NSDate *)date;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (NSDate *)timeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

+ (NSDate *)dateAfterday:(NSInteger)afterDay;

+ (NSDateComponents *)dateBetween:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSInteger)daysInMonth:(NSDate *)date;

+ (NSInteger)daysInYear:(NSDate *)date;

//当前时间对应的周是当前年中的第几周
+ (NSInteger)weekOfYear:(NSDate *)date;

//当前时间对应的周是当前月中的第几周
+ (NSInteger)weekOfMonth:(NSDate *)date;

+ (NSDate *)formatStringToDate:(NSString *)date dateFormat:(NSString *)dateFormat;

+ (NSDate *)formatStringToDate:(NSString *)date;

+ (NSString *)formatDateToString:(NSDate *)date dateFormat:(NSString *)dateFormat;

+ (NSString *)formatDateToString:(NSDate *)date;

@end
