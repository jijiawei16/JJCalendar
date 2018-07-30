//
//  JJCalendarModel.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJCalendarModel.h"

@implementation JJCalendarModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
