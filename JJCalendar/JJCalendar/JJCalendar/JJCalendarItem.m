//
//  JJCalendarItem.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJCalendarItem.h"
#import "JJCalendarModel.h"
#import "NSDate+JJCalendar.h"
#import "UIButton+JJType.h"
#import "JJCalenadarManager.h"

@interface JJCalendarItem ()

/// 按钮点击回调
@property (nonatomic , copy) JJCalendarItemClick block;
@end
@implementation JJCalendarItem

- (instancetype)initWithFrame:(CGRect)frame touch:(JJCalendarItemClick)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        self.block = touch;
        self.selected = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:43/255.0 green:68/255.0 blue:50/255.0 alpha:1] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithRed:143/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)click:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.block(sender.selected, self);
}
- (void)setModel:(JJCalendarModel *)model
{
    _model = model;
    NSDate *current = _model.date;
    switch ([current compareDay:[JJCalenadarManager manager].currentDate]) {
        case 0:
            self.userInteractionEnabled = NO;
            [self setTitleColor:[UIColor colorWithRed:150/255.0 green:175/255.0 blue:174/255.0 alpha:1] forState:UIControlStateNormal];
            break;
        case 1:
            self.userInteractionEnabled = YES;
            self.layer.borderWidth = 1;
            self.layer.borderColor = [UIColor colorWithRed:131/255.0 green:148/255.0 blue:137/255.0 alpha:1].CGColor;
            break;
        case 2:
            self.userInteractionEnabled = YES;
            break;
            
        default:
            break;
    }
    if (_model.isSelect) {
        self.backgroundColor = [UIColor redColor];
        self.userInteractionEnabled = NO;
    }
    if (_model.isTag) {
        self.selected = YES;
    }
}
@end
