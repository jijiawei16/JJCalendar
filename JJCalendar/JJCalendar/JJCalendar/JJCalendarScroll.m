//
//  JJCalendarScroll.m
//  JJCalendar
//
//  Created by 16 on 2018/7/30.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJCalendarScroll.h"
#import "NSDate+JJCalendar.h"
#import "JJCalendarItem.h"
#import "JJCalendarModel.h"
#import "JJCalenadarManager.h"

#define weak(obj)   __weak typeof(obj) weakSelf = obj
#define strong(obj) __strong typeof(weakSelf) obj = weakSelf
@interface JJCalendarScroll ()<UIScrollViewDelegate>

/// 当前展示标题
@property (nonatomic , strong) NSString *currentTitle;
@property (nonatomic , assign) CGFloat current_y;
@end
@implementation JJCalendarScroll

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:248/255.0 blue:255/255.0 alpha:1];
        self.delegate = self;
        self.current_y = 0;
        self.currentTitle = @"";
    }
    return self;
}
#pragma mark 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger y = scrollView.contentOffset.y;
    NSInteger w = self.frame.size.width;
    NSInteger h = y%w;
    if (h > self.frame.size.width/7) {
        NSInteger section = scrollView.contentOffset.y/self.frame.size.width;
        NSDate *date = self.items[section];
        self.currentTitle = [NSString stringWithFormat:@"%ld年%ld月",(long)[date currentYear],(long)[date currentMonth]];
        if ([self.jj_dalegate respondsToSelector:@selector(JJCalendarScrollChangeTitle:)]) {
            [self.jj_dalegate JJCalendarScrollChangeTitle:_currentTitle];
        }
    }
}
- (NSDate *)strToDate:(NSString *)str
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}
- (void)JJCalendarCellDidselectItem:(JJCalendarItem *)item select:(BOOL)select
{
    if ([self.jj_dalegate respondsToSelector:@selector(JJCalendarScrollDidselectItem:select:)]) {
        [self.jj_dalegate JJCalendarScrollDidselectItem:item select:select];
    }
}
#pragma mark 设置数据源
- (void)setItems:(NSArray *)items
{
    _items = items;
    self.contentSize = CGSizeMake(0, self.frame.size.width*items.count);
    self.contentOffset = CGPointMake(0, 0);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = self.frame.size.width/7;
    for (NSInteger j = 0; j < items.count; j++) {
        
        NSDate *date = items[j];
        NSInteger firstDay = [date firstDay_weak];
        NSInteger monthNum = [date currentMonth_num];
        NSInteger year = [date currentYear];
        NSInteger month = [date currentMonth];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width*j, self.frame.size.width, w)];
        title.backgroundColor = [UIColor colorWithRed:250/255.0 green:248/255.0 blue:255/255.0 alpha:1];
        title.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[date currentYear],(long)[date currentMonth]];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        for (NSInteger i = 0; i<42; i++) {
            
            if (i < firstDay) continue;
            if (i >= firstDay+monthNum) continue;
            
            NSInteger day = i-firstDay+1;
            weak(self);
            JJCalendarItem *item = [[JJCalendarItem alloc] initWithFrame:CGRectMake((i%7)*w, (i/7)*w+j*self.frame.size.width+w, w, w) touch:^(BOOL select, JJCalendarItem *item) {
                strong(self);
                if ([self.jj_dalegate respondsToSelector:@selector(JJCalendarScrollDidselectItem:select:)]) {
                    [self.jj_dalegate JJCalendarScrollDidselectItem:item select:select];
                }
            }];
            [item setTitle:[NSString stringWithFormat:@"%ld",day] forState:UIControlStateNormal];
            NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)month,(long)day];
            NSDate *itemDate = [NSDate strToDate:dateStr];
            
            NSDictionary *dic = @{@"year":@(year),
                                  @"month":@(month),
                                  @"day":@(day),
                                  @"date":itemDate,
                                  @"isSelect":@([self isContainInSelects:dateStr])};
            item.model = [JJCalendarModel modelWithDict:dic];
            [self addSubview:item];
            [JJCalenadarManager addCalendarItem:item];
        }
    }
}
- (BOOL)isContainInSelects:(NSString *)str
{
    for (NSInteger i = 0; i<[JJCalenadarManager manager].selects.count; i++) {
        NSString *string = [JJCalenadarManager manager].selects[i];
        if ([string isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
@end
