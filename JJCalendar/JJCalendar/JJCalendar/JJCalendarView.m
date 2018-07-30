//
//  JJCalendarView.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJCalendarView.h"
#import "NSDate+JJCalendar.h"
#import "JJCalendarScroll.h"
#import "JJCalendarItem.h"
#import "JJCalendarModel.h"
#import "JJCalenadarManager.h"
#import "UIButton+JJType.h"

#define margin_w 15
#define sw self.frame.size.width
#define weak(obj)   __weak typeof(obj) weakSelf = obj
#define strong(obj) __strong typeof(weakSelf) obj = weakSelf
#define scale(x) x*[UIScreen mainScreen].bounds.size.width/375
#define SH [UIScreen mainScreen].bounds.size.height
#define SW [UIScreen mainScreen].bounds.size.width
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface JJCalendarView ()<JJCalendarScrollDelegate>

/// 展示style
@property (nonatomic , assign) JJCalenadarViewStyle style;
/// 完成回调
@property (nonatomic , copy) JJCalendarViewComplete complete;
/// 背景遮罩
@property (nonatomic , strong) UIButton *backGround;
/// 头部视图
@property (nonatomic , strong) UIView *header;
/// 取消
@property (nonatomic , strong) UIButton *cancel;
/// 确认
@property (nonatomic , strong) UIButton *sure;
/// 切换选择模式
@property (nonatomic , strong) UIButton *exchange;
/// 上一个月
@property (nonatomic , strong) UIButton *lastMonth;
/// 下一个月
@property (nonatomic , strong) UIButton *nextMonth;
/// 起始时间
@property (nonatomic , strong) UILabel *start;
/// 结束时间
@property (nonatomic , strong) UILabel *end;
/// 展示当前年月
@property (nonatomic , strong) UILabel *title;
/// 展示星期
@property (nonatomic , strong) UIView *weaks;
/// 日历展示视图
@property (nonatomic , strong) UIView *calendar;
/// 当前日期
@property (nonatomic , strong) NSDate *currentDate;
/// 展示scroll
@property (nonatomic , strong) JJCalendarScroll *scroll;
/// 当前选中的item(单选模式下)
@property (nonatomic , strong) JJCalendarItem *currentItem;
/// 选中的开始item(多选模式下)
@property (nonatomic , strong) JJCalendarItem *startItem;
/// 选中的结束item(多选模式下)
@property (nonatomic , strong) JJCalendarItem *endItem;
/// 是否选择结束
@property (nonatomic , assign) BOOL endSelect;
/// 选中的数组
@property (nonatomic , strong) NSMutableArray *selects;
@end
@implementation JJCalendarView

- (instancetype)initWithStyle:(JJCalenadarViewStyle)style complete:(JJCalendarViewComplete)complete
{
    self = [super init];
    if (self) {
        
        self.style = style;
        self.complete = complete;
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:248/255.0 blue:255/255.0 alpha:1];
        self.endSelect = NO;
        ///添加kvo
        [self addObserver:self forKeyPath:@"endSelect" options:NSKeyValueObservingOptionNew context:nil];
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加背景遮罩
    self.backGround = [[UIButton alloc] initWithFrame:window.bounds];
    _backGround.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_backGround addTarget:self action:@selector(hiddenCalendar) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backGround];
    
    // 设置日历尺寸
    CGRect frame = CGRectZero;
    if (_style == JJCalenadarViewStyleBottom) {
        
        CGFloat bottom = 0;
        if (iPhoneX) bottom = 34;
        CGFloat height = scale(150)+(SW-scale(30))*6/7+20;
        frame = CGRectMake(0, SH-height-bottom, SW, height+bottom);
        self.frame = CGRectMake(0, SH, SW, height+bottom);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }else {
        CGFloat height = scale(150)+((SW-60)-scale(30))*6/7+20;
        frame = CGRectMake(30, (SH-height)/2, SW-60, height);
        self.frame = frame;
    }

    [window addSubview:self];
    
    // 设置日历子控件尺寸
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw, scale(50))];
    _header.backgroundColor = [UIColor whiteColor];
    [self addSubview:_header];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, scale(65), sw, scale(20))];
    _title.text = @"时间";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:18];
    _title.font = [UIFont boldSystemFontOfSize:18];
    _title.textColor = [UIColor blackColor];
    [self addSubview:_title];
    
    self.lastMonth = [[UIButton alloc] initWithFrame:CGRectMake(scale(margin_w), _title.frame.origin.y, scale(20), scale(20))];
    [_lastMonth setImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [_lastMonth addTarget:self action:@selector(showLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lastMonth];
    
    self.nextMonth = [[UIButton alloc] initWithFrame:CGRectMake(sw-(scale(margin_w+20)), _title.frame.origin.y, scale(20), scale(20))];
    [_nextMonth setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [_nextMonth addTarget:self action:@selector(showNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextMonth];
    
    self.start = [[UILabel alloc] initWithFrame:CGRectMake(scale(margin_w), scale(50), scale(50), scale(50))];
    _start.numberOfLines = 2;
    _start.text = @"开始\n时间";
    _start.textColor = [UIColor blackColor];
    _start.textAlignment = NSTextAlignmentCenter;
    _start.hidden = YES;
    [self addSubview:_start];
    
    self.end = [[UILabel alloc] initWithFrame:CGRectMake(sw-(scale(margin_w+50)), scale(50), scale(50), scale(50))];
    _end.numberOfLines = 2;
    _end.text = @"结束\n时间";
    _end.textColor = [UIColor blackColor];
    _end.textAlignment = NSTextAlignmentCenter;
    _end.hidden = YES;
    [self addSubview:_end];
    
    self.weaks = [[UIView alloc] initWithFrame:CGRectMake(scale(margin_w), scale(100), sw-scale(margin_w*2), scale(50))];
    _weaks.backgroundColor = [UIColor clearColor];
    [self addSubview:_weaks];
    
    self.calendar = [[UIView alloc] initWithFrame:CGRectMake(scale(margin_w), scale(150), sw-scale(margin_w*2), (sw-scale(margin_w*2))*6/7)];
    [self addSubview:_calendar];
    
    self.scroll = [[JJCalendarScroll alloc] initWithFrame:_calendar.bounds];
    _scroll.jj_dalegate = self;
    
    [self showHeader];
    [self showWeaks];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}
- (void)showHeader
{
    self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(scale(margin_w), scale(15), scale(20), scale(20))];
    [_cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(hiddenCalendar) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:_cancel];
    
    self.exchange = [[UIButton alloc] initWithFrame:CGRectMake(scale(margin_w+80), 0, sw-scale((margin_w+80)*2), scale(50))];
    [_exchange setTitle:@"单选模式" forState:UIControlStateNormal];
    [_exchange setImage:[UIImage imageNamed:@"exchange"] forState:UIControlStateNormal];
    [_exchange layoutButtonWithEdgeInsetsStyle:JJButtonEdgeInsetsStyleRight imageTitleSpace:scale(5)];
    [_exchange setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_exchange addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:_exchange];
    
    self.sure = [[UIButton alloc] initWithFrame:CGRectMake(sw-(scale(margin_w+20)), scale(15), scale(20), scale(20))];
    [_sure setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [_sure addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:_sure];
}
- (void)showWeaks
{
    NSArray *titles = @[@"SUN",@"MON",@"TUE",@"WED",@"THE",@"FRI",@"SAT"];
    CGFloat w = _weaks.frame.size.width/7;
    for (NSInteger i = 0; i<7; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i%7*w, 0, w, scale(50))];
        lab.text = titles[i];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
        lab.font = [UIFont boldSystemFontOfSize:16];
        [_weaks addSubview:lab];
    }
    UIView *cut = [[UIView alloc] initWithFrame:CGRectMake(0, _weaks.frame.size.height-1, _weaks.frame.size.width, 1)];
    cut.backgroundColor = [UIColor colorWithRed:197/255.0 green:194/255.0 blue:195/255.0 alpha:1];
    [_weaks addSubview:cut];
}
#pragma mark 展示日历视图
- (void)showDate:(NSDate *)date
{
    self.currentDate = date;
    [self reloadTitle];
    [self reloadCalendar];
}
#pragma mark 按钮点击方法
- (void)hiddenCalendar
{
    if (self.style == JJCalenadarViewStyleCenter) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.backGround removeFromSuperview];
            [self removeFromSuperview];
        }];
    }else {
        
        [self.backGround removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, SH, SW, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
- (void)exchange:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"单选模式"]) {
        [sender setTitle:@"多选模式" forState:UIControlStateNormal];
        [self reloadCalendarScroll];
        _start.hidden = NO;
        _end.hidden = NO;
        _lastMonth.hidden = YES;
        _nextMonth.hidden = YES;
        _endSelect = NO;
    }else {
        [sender setTitle:@"单选模式" forState:UIControlStateNormal];
        [self reloadCalendar];
        [self reloadTitle];
        _start.hidden = YES;
        _end.hidden = YES;
        _lastMonth.hidden = NO;
        _nextMonth.hidden = NO;
        _endSelect = NO;
    }
}
- (void)sure:(UIButton *)sender
{
    if ([_exchange.titleLabel.text isEqualToString:@"单选模式"]) {
        self.complete(@[_currentItem.model.date]);
    }else {
        NSMutableArray *dates = [NSMutableArray array];
        for (NSInteger i = 0; i < _selects.count; i++) {
            JJCalendarItem *item = _selects[i];
            [dates addObject:item.model.date];
        }
        self.complete(dates);
    }
    [self hiddenCalendar];
}
- (void)showLastMonth:(UIButton *)sender
{
    self.currentDate = [self.currentDate lastMonth];
    [self showDate:self.currentDate];
    [self reloadTitle];
}
- (void)showNextMonth:(UIButton *)sender
{
    self.currentDate = [self.currentDate nextMonth];
    [self showDate:self.currentDate];
    [self reloadTitle];
}
#pragma mark 刷新展示视图
- (void)reloadTitle
{
    self.title.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[self.currentDate currentYear],(long)[self.currentDate currentMonth]];
}
- (void)reloadCalendar
{
    [self.calendar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [UIView animateWithDuration:0.5 animations:^{
        
        NSInteger firstDay = [self.currentDate firstDay_weak];
        NSInteger monthNum = [self.currentDate currentMonth_num];
        NSInteger year = [self.currentDate currentYear];
        NSInteger month = [self.currentDate currentMonth];
        NSLog(@"%ld==============%ld",(long)year,(long)month);
        CGFloat w = _calendar.frame.size.width/7;
        for (NSInteger i = 0; i<42; i++) {
            
            if (i < firstDay) continue;
            if (i >= firstDay+monthNum) continue;
            
            NSInteger day = i-firstDay+1;
            weak(self);
            JJCalendarItem *item = [[JJCalendarItem alloc] initWithFrame:CGRectMake((i%7)*w, (i/7)*w, w, w) touch:^(BOOL select, JJCalendarItem *item) {
                strong(self);
                self.currentItem.selected = NO;
                self.currentItem = item;
                self.currentItem.selected = YES;
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
            [_calendar addSubview:item];
        }
    }];
}
- (void)reloadCalendarScroll
{
    // 每一次都要先初始化item数组
    [JJCalenadarManager cleanItems];
    _title.text = @"";
    [_calendar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDate *cur_date = [NSDate new];
    NSMutableArray *dateAry = [NSMutableArray arrayWithObject:cur_date];
    for (NSInteger i = 0; i<[JJCalenadarManager manager].monthNum; i++) {
        NSDate *date = [cur_date nextMonth];
        cur_date = date;
        [dateAry addObject:cur_date];
    }
    [_calendar addSubview:_scroll];
    _scroll.items = dateAry;
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
- (void)JJCalendarScrollChangeTitle:(NSString *)title
{
    self.title.text = title;
}
- (void)JJCalendarScrollDidselectItem:(JJCalendarItem *)item select:(BOOL)select
{
    // 判断多选逻辑
    if (_endSelect) {
        
        if (item == _endItem) {// 判断是否再次点击了结束时间,如果点击了结束时间,取消结束时间的选择
            _endItem = nil;
            self.endSelect = NO;
        }else {// 如果选择其他的item,重新选择时间区域
            _startItem.selected = NO;
            _startItem = item;
            _startItem.selected = YES;
            _endItem.selected = NO;
            _endItem = nil;
            self.endSelect = NO;
        }
    }else {
        
        if (item == _startItem) {// 是否又点击了开始item,如果点击了开始item,取消开始item的选择
            _startItem = nil;
            self.endSelect = NO;
        }else if (!_startItem) {// 是否选择了开始item,如果没有选择,设置开始item
            _startItem = item;
            self.endSelect = NO;
        }else if (!_endItem) {// 是否选择了结束item,如果没有选择该item
            if (![_startItem.model.date isEarlyToDay:item.model.date]) {// 判断后选时间是否早于开始item,如果比开始item早,则交换开始item和结束item,保证开始item小于结束item
                _endItem = _startItem;
                _startItem = item;
            }else {// 如果该item大于开始时间,设置结束item为该item
                _endItem = item;
            }
            if ([self determineSelects]) {
                self.endSelect = YES;
            }
        }
    }
    
    // 设置开始时间和结束时间标题
    if (self.startItem) {
        _start.text = [NSString stringWithFormat:@"%ld\n%02ld/%02ld",(long)_startItem.model.year,(long)_startItem.model.month,(long)_startItem.model.day];
    }else {
        _start.text = @"开始\n时间";
    }
    if (self.endItem) {
        _end.text = [NSString stringWithFormat:@"%ld\n%02ld/%02ld",(long)_endItem.model.year,(long)_endItem.model.month,(long)_endItem.model.day];
    }else {
        _end.text = @"结束\n时间";
    }
}

- (void)cleanSelects
{
    [_selects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JJCalendarItem *item = (JJCalendarItem *)obj;
        if (item.model.year==_startItem.model.year&&item.model.month==_startItem.model.month&&item.model.day==_startItem.model.day) {
            item.selected = YES;
        }else {
            item.selected = NO;
        }
    }];
    _selects = [NSMutableArray array];
}
- (void)showSelects
{
    [_selects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JJCalendarItem *item = (JJCalendarItem *)obj;
        item.selected = YES;
    }];
}
- (BOOL)determineSelects
{
    BOOL begin = NO;
    NSArray *items = [JJCalenadarManager manager].items;
    _selects = [NSMutableArray array];
    for (NSInteger i = 0; i<items.count; i++) {
        
        JJCalendarItem *item = items[i];
        NSLog(@"======%ld-%ld-%ld",(long)item.model.year,(long)item.model.month,(long)item.model.day);
        if (item == _startItem) begin = YES;
        if (item == _endItem) {
            [_selects addObject:item];
            begin = NO;
        }
        if (begin) {
            if (item.model.isSelect) {
                _selects = [NSMutableArray array];
                _endItem.selected = NO;
                _endItem = nil;
                [JJCalenadarManager manager].message = @"该时间段期间有时间不符合";
                return NO;
            }
            [_selects addObject:item];
        }
    }
    
    // 判断是否符合标准
    NSInteger min = [JJCalenadarManager manager].minNum;
    NSInteger max = [JJCalenadarManager manager].maxNum;
    if (_selects.count < min) {
        _selects = [NSMutableArray array];
        _endItem.selected = NO;
        _endItem = nil;
        [JJCalenadarManager manager].message = [NSString stringWithFormat:@"时间间隔不能小于%ld",min];
        return NO;
    }
    if (_selects.count > max) {
        _selects = [NSMutableArray array];
        _endItem.selected = NO;
        _endItem = nil;
        [JJCalenadarManager manager].message = [NSString stringWithFormat:@"时间间隔不能大于%ld",max];
        return NO;
    }
    return YES;
}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"endSelect"]) {
        if (!_endSelect) {
            [self cleanSelects];
        }else {
            [self showSelects];
        }
    }
}
#pragma mark 设置默认值
- (NSDate *)startDate
{
    if (_startDate == nil) {
        _startDate = [NSDate new];
    }
    return _startDate;
}
@end
