//
//  JJCalenadarManager.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJCalenadarManager.h"
#import "JJCalendarView.h"
#import "JJCalendarModel.h"
#import "JJCalendarItem.h"

#define SH [UIScreen mainScreen].bounds.size.height
#define SW [UIScreen mainScreen].bounds.size.width
#define scale(x) x*[UIScreen mainScreen].bounds.size.width/375
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface JJCalenadarManager ()

/// 选中的日期
@property (nonatomic , strong , readwrite) NSArray *selects;
/// items数组
@property (nonatomic , strong) NSMutableArray<JJCalendarItem *> *items;
/// 选择完成回调
@property (nonatomic , copy) JJCalenadarManagerComplete complete;
/// 日历视图
@property (nonatomic , strong) JJCalendarView *calendar;
@end
@implementation JJCalenadarManager

static JJCalenadarManager *instance;
#pragma mark 创建视频单例,防止播放器用其他方式创建
+ (void)initialize{
    [JJCalenadarManager manager];
}
+ (instancetype)manager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JJCalenadarManager alloc]init];
        instance.minNum = 2;
        instance.maxNum = 1000000000000;
        instance.monthNum = 12;
        instance.currentDate = [NSDate new];
    });
    return instance;
}
+ (instancetype)alloc
{
    if (instance) {
        NSException *exception = [NSException exceptionWithName:@"JJCalenadarManager" reason:@"JJCalenadarManager是一个单例!" userInfo:nil];
        [exception raise];
    }
    return [super alloc];
}
- (id)copy
{
    return self;
}
- (id)mutableCopy
{
    return self;
}
#pragma mark 管理多选模式下创建好的item名单
+ (void)addCalendarItem:(JJCalendarItem *)item
{
    [instance.items addObject:item];
}
+(void)cleanItems
{
    instance.items = [NSMutableArray array];
}
#pragma mark 展示日历视图
+ (void)showCalendarViewSelects:(NSArray *)selects type:(JJCalenadarManagerShowType)type complete:(JJCalenadarManagerComplete)complete
{
    instance.complete = complete;
    instance.selects = selects;
    JJCalenadarViewStyle style = JJCalenadarViewStyleBottom;
    if (type == JJCalenadarManagerShowTypeCenter) {
        style = JJCalenadarViewStyleCenter;
    }
    instance.calendar = [[JJCalendarView alloc] initWithStyle:style complete:^(NSArray *dates) {
        
        instance.complete(dates);
    }];
    [instance.calendar showDate:[NSDate new]];
}

@end
