//
//  ViewController.m
//  JJCalendar
//
//  Created by 16 on 2018/7/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JJCalenadarManager.h"
#import "NSDate+JJCalendar.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [JJCalenadarManager showCalendarViewSelects:@[@"2018-07-31",@"2018-08-11",@"2018-08-15"] type:JJCalenadarManagerShowTypeCenter complete:^(NSArray *times) {
        NSLog(@"%@",times);
    }];
    [JJCalenadarManager manager].minNum = 4;
    [JJCalenadarManager manager].monthNum = 3;
    [JJCalenadarManager manager].currentDate = [NSDate strToDate:@"2018-09-12"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
