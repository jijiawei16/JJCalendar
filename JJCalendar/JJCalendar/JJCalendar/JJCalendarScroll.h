//
//  JJCalendarScroll.h
//  JJCalendar
//
//  Created by 16 on 2018/7/30.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJCalendarItem;

@protocol JJCalendarScrollDelegate<NSObject>

/**
 * cell上面item被选中
 * @param item 被选中的item
 * @param select 选中的状态
 */
- (void)JJCalendarScrollDidselectItem:(JJCalendarItem *)item select:(BOOL)select;

/**
 * 改变标题的代理方法
 * @param title 标题名字
 */
- (void)JJCalendarScrollChangeTitle:(NSString *)title;
@end
@interface JJCalendarScroll : UIScrollView

/// 代理
@property (nonatomic , weak) id<JJCalendarScrollDelegate>jj_dalegate;
/// 数据源
@property (nonatomic , strong) NSArray *items;
@end
