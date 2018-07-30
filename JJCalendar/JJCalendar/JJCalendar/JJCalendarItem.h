//
//  JJCalendarItem.h
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJCalendarModel;
@class JJCalendarItem;

typedef void(^JJCalendarItemClick)(BOOL select, JJCalendarItem *item);
@interface JJCalendarItem : UIButton

///日历数据模型
@property (nonatomic , strong) JJCalendarModel *model;

/**
 * 创建日历单元按钮
 * @param touch 按钮点击回调
 */
- (instancetype)initWithFrame:(CGRect)frame touch:(JJCalendarItemClick)touch;
@end
