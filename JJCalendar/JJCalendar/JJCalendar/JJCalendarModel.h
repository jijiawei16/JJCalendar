//
//  JJCalendarModel.h
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCalendarModel : NSObject

/// 年
@property (nonatomic , assign , readonly) NSInteger year;
/// 月
@property (nonatomic , assign , readonly) NSInteger month;
/// 日
@property (nonatomic , assign , readonly) NSInteger day;
/// 日期
@property (nonatomic , copy , readonly) NSDate *date;
/// 是否被选中
@property (nonatomic , assign , readonly) BOOL isSelect;
/// 是否显示勾选状态
@property (nonatomic , assign , readonly) BOOL isTag;

/**
 * 模型赋值
 * @param dic 模型字典
 */
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
