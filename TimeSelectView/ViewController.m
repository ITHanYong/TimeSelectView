//
//  ViewController.m
//  TimeSelectView
//
//  Created by HanYong on 2020/6/24.
//  Copyright © 2020 HanYong. All rights reserved.
//

#import "ViewController.h"
#import "TimeSelectView.h"

@interface ViewController ()

@property (nonatomic, strong) TimeSelectView *timeSelectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timeSelectView.frame = CGRectMake(0, 36.5, self.view.frame.size.width, 40 * 4 + 10 * 3 + 30);
    
    self.timeSelectView.reset = YES;
    //空闲时间
    self.timeSelectView.spareTime = @[
                                        @{@"start_time":@"09:00" ,@"end_time":@"17:59"}
                                    ];
    //禁用时间
    self.timeSelectView.forbiddenTime = @[
                                            @{@"start_time":@"00:00" ,@"end_time":@"08:59"},
                                            @{@"start_time":@"18:00" ,@"end_time":@"23:59"}
                                        ];
    //用户已占用时间
    self.timeSelectView.elapsedTime = @[@{@"start_time":@"13:00" ,@"end_time":@"13:29"}];
    //用于选择时间
    self.timeSelectView.selectTime = @"10:00-11:00";
    //固定占用时间
    //self.timeSelectView.fixationTime = @"09:00-09:29";
    
    [self.timeSelectView reloadView];
    
    self.timeSelectView.seletedBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
        NSLog(@"---%@----%@",startTime,endTime);
    };
    self.timeSelectView.extendMeetingTime = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
        NSLog(@"---%@----%@",startTime,endTime);
    };
}

-(TimeSelectView *)timeSelectView{
    if (!_timeSelectView) {
        _timeSelectView = [[TimeSelectView alloc] init];
        [self.view addSubview:_timeSelectView];
    }
    return _timeSelectView;
}


@end
