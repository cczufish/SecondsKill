//
//  VDateTimeHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "VDateTimeHelper.h"

#define kDateTimeFormat @"yyyy-MM-dd HH:mm:ss"

@implementation VDateTimeHelper

+ (NSDateComponents *)splitDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit;
    
    // NSWeekdayCalendarUnit: Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5, Saturday:6
    return [greCalendar components:unitFlags fromDate:date];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:year];
    [dateComponents setMonth:month];
    [dateComponents setYear:day];

    return [greCalendar dateFromComponents:dateComponents];
}

+ (NSDate *)timeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    
    return [greCalendar dateFromComponents:dateComponents];
}

+ (NSDate *)dateAfterday:(NSInteger)afterDay
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:afterDay];

    return [greCalendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
}

+ (NSDateComponents *)dateBetween:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    return [greCalendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
}

+ (NSInteger)daysInMonth:(NSDate *)date
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
}

+ (NSInteger)daysInYear:(NSDate *)date
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]].length;
}

+ (NSInteger)weekOfYear:(NSDate *)date
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfYearCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
}

+ (NSInteger)weekOfMonth:(NSDate *)date
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
}

+ (NSDate *)formatStringToDate:(NSString *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:dateFormat];
    return [fmt dateFromString:date];
}

+ (NSDate *)formatStringToDate:(NSString *)date
{
    return [self formatStringToDate:date dateFormat:kDateTimeFormat];
}

+ (NSString *)formatDateToString:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:dateFormat];
    return [fmt stringFromDate:date];
}

+ (NSString *)formatDateToString:(NSDate *)date
{
    return [self formatDateToString:date dateFormat:kDateTimeFormat];
}

@end
