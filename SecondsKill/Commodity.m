//
//  Commodity.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-22.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "Commodity.h"

@implementation Commodity

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSString *)surplusTime
{
    return [self calculateSurplusTime:[self.end_t doubleValue]];
}

- (NSString *)detrusionTime
{
    return [self calculateSurplusTime:[self.start_t doubleValue]];
}

//计算出来的剩余时间 ＝ 结束时间/开始时间 － 当前时间
- (NSString *)calculateSurplusTime:(double)targetTime
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:targetTime/1000];
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *comp = [VDateTimeHelper dateBetween:currentDate toDate:targetDate];
    
    if (comp.day <= 0 && comp.hour <= 0 && comp.minute <= 0 && comp.second <= 0) {
        return @"00:00:00";
    }
    else {
        NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setHour:comp.hour];
        [dateComponents setMinute:comp.minute];
        [dateComponents setSecond:comp.second];
        
        NSString *format = @"HH:mm:ss";
        
        if (comp.day > 0) {
            [dateComponents setDay:comp.day];
            format = @"dd天 HH:mm:ss";
        }
        
        NSDate *date = [greCalendar dateFromComponents:dateComponents];
        
        return [VDateTimeHelper formatDateToString:date dateFormat:format];
    }
}

@end