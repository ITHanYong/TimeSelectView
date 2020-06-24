//
//  TimeSelectView.h
//  TimeSelectView
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedTime)(NSString *startTime,NSString *endTime);
typedef void(^ExtendMeetingTime)(NSString *startTime,NSString *endTime);

@interface TimeSelectView : UIView

@property (nonatomic, copy) SelectedTime seletedBlock;//普通选择时间

@property (nonatomic, copy) ExtendMeetingTime extendMeetingTime;//延长时间（选择时间）

@property (nonatomic, strong) NSArray *elapsedTime;//已预约时间 - 被占用的时间段

@property (nonatomic, strong) NSArray *forbiddenTime;//禁用时间

@property (nonatomic, strong) NSArray *spareTime;//空闲时间

@property (nonatomic, copy) NSString *selectTime;//用户选择的时间

@property (nonatomic, copy) NSString *fixationTime;//用户已选固定时间

@property (nonatomic, copy) NSString *currentDate;//当前日期

@property (nonatomic, assign) BOOL reset;//重置

-(void)reloadView;

@end

NS_ASSUME_NONNULL_END
