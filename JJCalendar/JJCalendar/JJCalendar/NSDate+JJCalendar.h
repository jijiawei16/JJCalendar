//
//  NSDate+JJCalendar.h
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JJCalendar)

/// 每月第一天的星期数
- (NSInteger)firstDay_weak;
/// 每月最后一天的星期数
- (NSInteger)lastDay_weak;
/// 当前日期的年份
- (NSInteger)currentYear;
/// 当前日期的月份
- (NSInteger)currentMonth;
/// 当前日期的星期数
- (NSInteger)currentWeak;
/// 当前日期
- (NSInteger)currentDay;
/// 当前月的天数
- (NSInteger)currentMonth_num;
/// 上一个月
- (NSDate *)lastMonth;
/// 下一个月
- (NSDate *)nextMonth;
///日期对比 0 在该日期之前 1 等于当前日期 2 在该日期之后
- (NSInteger)compareDay:(NSDate *)date;
/// 是否是今日
- (BOOL)isEqualDay:(NSDate *)date;
/// 是否早于今日
- (BOOL)isEarlyToDay:(NSDate *)date;
///str转date
+ (NSDate *)strToDate:(NSString *)str;
@end
