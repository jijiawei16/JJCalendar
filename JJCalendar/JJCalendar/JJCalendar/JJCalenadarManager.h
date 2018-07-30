//
//  JJCalenadarManager.h
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JJCalendarItem;

typedef enum{
    JJCalenadarManagerShowTypeCenter,// 居中显示
    JJCalenadarManagerShowTypeBottom,// 底部显示
}JJCalenadarManagerShowType;

typedef void(^JJCalenadarManagerComplete)(NSArray *times);
@interface JJCalenadarManager : NSObject

/// 选中的日期
@property (nonatomic , strong , readonly) NSArray *selects;
/// 创建的item
@property (nonatomic , strong , readonly) NSMutableArray<JJCalendarItem *> *items;
/// 多选模式下时间间隔选择最小值
@property (nonatomic , assign) NSInteger minNum;
/// 多选模式下时间选择间隔最大值,不设置为无限制
@property (nonatomic , assign) NSInteger maxNum;
/// 多选模式下提示信息
@property (nonatomic , strong) NSString *message;
/// 展示之后的月份数(默认展示当前月加之后12个月)
@property (nonatomic , assign) NSInteger monthNum;
/// 起始时间(默认今天)
@property (nonatomic , strong) NSDate *currentDate;

/**
 * 展示日历视图
 * @param selects 选中的日期(2018-01-03形式)
 * @param type 日历展示类型
 * @param complete 日历选择完成回调
 */
+ (void)showCalendarViewSelects:(NSArray *)selects type:(JJCalenadarManagerShowType)type complete:(JJCalenadarManagerComplete)complete;

/**
 * 获取日历管理者对象
 */
+ (instancetype)manager;

/**
 * 加入item名单
 */
+ (void)addCalendarItem:(JJCalendarItem *)item;

/**
 * 初始化item名单
 */
+ (void)cleanItems;
@end
