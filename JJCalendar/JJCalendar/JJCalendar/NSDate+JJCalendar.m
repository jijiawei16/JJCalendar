//
//  NSDate+JJCalendar.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "NSDate+JJCalendar.h"
#import <objc/runtime.h>

@interface NSDate ()

@property (nonatomic , strong) NSCalendar *calendar;
@end
@implementation NSDate (JJCalendar)

///获取时间容器
- (NSDateComponents *)components:(NSDate *)date {
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    components.timeZone = [NSTimeZone localTimeZone];
    return components;
}

- (NSInteger)firstDay_weak
{
    NSDateComponents *components = [self components:self];
    components.day = 1;
    NSDate *date = [self.calendar dateFromComponents:components];
    components = [self components:date];
    NSArray *weaks = @[@-1,@0,@1,@2,@3,@4,@5,@6];
    return [weaks[components.weekday] integerValue];
}
- (NSInteger)lastDay_weak
{
    NSDateComponents *components = [self components:self];
    components.day = 0;
    components.month += 1;
    NSDate *date = [self.calendar dateFromComponents:components];
    components = [self components:date];
    NSInteger week = components.weekday;
    return week - 1;
}
- (NSInteger)currentMonth_num
{
    NSRange days = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}
- (NSInteger)currentYear
{
    NSDateComponents *components = [self components:self];
    return components.year;
}
- (NSInteger)currentMonth
{
    NSDateComponents *components = [self components:self];
    return components.month;
}
- (NSInteger)currentWeak
{
    NSDateComponents *components = [self components:self];
    return components.weekday-1;
}
- (NSInteger)currentDay
{
    NSDateComponents *components = [self components:self];
    return components.day;
}
- (NSDate *)lastMonth
{
    NSDateComponents *components = [self components:self];
    components.month -= 1;
    components.day = 2;
    return [self.calendar dateFromComponents:components];
}
- (NSDate *)nextMonth
{
    NSDateComponents *components = [self components:self];
    components.month += 1;
    components.day = 2;
    return [self.calendar dateFromComponents:components];
}
- (NSInteger)compareDay:(NSDate *)date
{
    NSString *str1 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[self currentYear],(long)[self currentMonth],(long)[self currentDay]];
    NSString *str2 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[date currentYear],(long)[date currentMonth],(long)[date currentDay]];
    if ([str1 compare:str2] == NSOrderedSame) {
        return 1;
    }else if ([str1 compare:str2] == NSOrderedAscending) {
        return 0;
    }else {
        return 2;
    }
}
- (BOOL)isEqualDay:(NSDate *)date
{
    NSString *str1 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[self currentYear],(long)[self currentMonth],(long)[self currentDay]];
    NSString *str2 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[date currentYear],(long)[date currentMonth],(long)[date currentDay]];
    if ([str1 compare:str2] == NSOrderedSame) {
        return YES;
    }
    return NO;
}
- (BOOL)isEarlyToDay:(NSDate *)date
{
    NSString *str1 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[self currentYear],(long)[self currentMonth],(long)[self currentDay]];
    NSString *str2 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[date currentYear],(long)[date currentMonth],(long)[date currentDay]];
    if ([str1 compare:str2] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
+ (NSDate *)strToDate:(NSString *)str
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:str];
    return date;
}
#pragma mark 利用runtime添加一个日历属性
- (NSCalendar *)calendar
{
    NSCalendar *calendar = objc_getAssociatedObject(self, _cmd);
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.locale = [NSLocale currentLocale];
        objc_setAssociatedObject(self, @selector(calendar), calendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return calendar;
}
- (void)setCalendar:(NSCalendar *)calendar
{
    objc_setAssociatedObject(self, @selector(calendar), calendar, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
