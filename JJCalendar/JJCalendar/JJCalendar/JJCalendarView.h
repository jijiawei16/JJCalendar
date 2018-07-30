//
//  JJCalendarView.h
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    JJCalenadarViewStyleCenter,// 居中显示
    JJCalenadarViewStyleBottom,// 底部显示
}JJCalenadarViewStyle;

typedef void(^JJCalendarViewComplete)(NSArray *dates);
@interface JJCalendarView : UIView

///开始日期
@property (nonatomic , strong) NSDate *startDate;
///截止日期
@property (nonatomic , strong) NSDate *endDate;

/**
 * 展示某一个日期的日历
 * @param date 当前日期
 */
- (void)showDate:(NSDate *)date;

/**
 * 初始化日历控件
 * @param style 日历展示类型
 * @param complete 日历选择完成回调
 */
- (instancetype)initWithStyle:(JJCalenadarViewStyle)style complete:(JJCalendarViewComplete)complete;
@end
