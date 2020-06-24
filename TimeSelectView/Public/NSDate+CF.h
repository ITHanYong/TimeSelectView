//
//  NSDate+CF.h
//  CaiFuProHS
//
//  Created by HanYong on 2020/5/8.
//  Copyright © 2020 CaiFuZhengQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NSDateFormaterMode) {
    /** 日期格式：农历*/
    NSDateFormaterModeLunar,
    /** 日期格式：yyyy-MM-dd HH:mm:ss（标准格式）*/
    NSDateFormaterModeStandard,
    /** 日期格式：yyyy-MM-dd hh:mm:ss（12小时制）*/
    NSDateFormaterModeStandard12,
    /** 日期格式：yyyy-MM-dd HH:mm*/
    NSDateFormaterModeDemotion,
    /** 日期格式：yyyy-MM-dd hh:mm（12小时制）*/
    NSDateFormaterModeDemotion12,
    /** 日期格式：yyyy-MM-dd*/
    NSDateFormaterModeDayDefault,
    /** 日期格式：yyyy年MM月dd日*/
    NSDateFormaterModeDayAnother,
    /** 日期格式：HH:mm:ss*/
    NSDateFormaterModeTimeStandard,
    /** 日期格式：hh:mm:ss（12小时制）*/
    NSDateFormaterModeTimeStandard12,
    /** 日期格式：HH:mm*/
    NSDateFormaterModeTimeDemotion,
    /** 日期格式：hh:mm（12小时制）*/
    NSDateFormaterModeTimeDemotion12
};

typedef NS_ENUM(NSInteger, NSDateWeekMode) {
    /** 周一*/
    NSDateWeekModeMonday = 1,
    /** 周二*/
    NSDateWeekModeTuesday = 2,
    /** 周三*/
    NSDateWeekModeWednesday = 3,
    /** 周四*/
    NSDateWeekModeThursday = 4,
    /** 周五*/
    NSDateWeekModeFriday = 5,
    /** 周六*/
    NSDateWeekModeSaturday = 6,
    /** 周日*/
    NSDateWeekModeSunday = 7
};

typedef NS_ENUM(NSInteger, NSDateHourMode) {
    /** 24小时制*/
    NSDateHourMode24,
    /** 12小时制*/
    NSDateHourMode12
};

@interface NSDateFormatter (CF)

+ (NSDateFormatter *)dateFormaterWithMode:(NSDateFormaterMode)formaterMode;

@end

@interface NSDate (CF)

@property (nonatomic, strong) NSDictionary *lunarCalendar;
@property (nonatomic, strong) NSDateComponents *lunarComponents;
@property (nonatomic, copy)   NSString *lunarDate;          //年（农历）
@property (nonatomic, assign) BOOL leapMonth;               //润月
@property (nonatomic, copy)   NSString *lunarYear;          //年（农历）
@property (nonatomic, copy)   NSString *lunarMonth;         //月（农历）
@property (nonatomic, copy)   NSString *lunarDay;           //日（农历）

@property (nonatomic, assign) NSInteger year;               //年
@property (nonatomic, assign) NSInteger month;              //月
@property (nonatomic, assign) NSInteger day;                //日
@property (nonatomic, assign) NSInteger hour;               //时
@property (nonatomic, assign) NSInteger minute;             //分
@property (nonatomic, assign) NSInteger second;             //秒

@property (nonatomic, assign) NSDateWeekMode weekday;       //周几
@property (nonatomic, assign) NSInteger weekmonth;          //第几周（本月）
@property (nonatomic, assign) NSInteger weekyear;           //第几周（本年）
@property (nonatomic, copy)   NSString *weekStr;            //星期几

@property (nonatomic, copy)   NSString *yesterday;          //昨天
@property (nonatomic, copy)   NSString *tomorrow;           //明天
@property (nonatomic, copy)   NSString *dayAfterTomorrow;   //后天

@property (nonatomic, assign) BOOL isToday;                //是否是今天
@property (nonatomic, assign) BOOL isYesterday;            //是否是昨天


/// NSDate -> 格式化NSDate
/// @param formaterMode 日期格式
-(NSDate *)dateToDateWithFormaterMode:(NSDateFormaterMode)formaterMode;

/// NSDate -> 格式化NSDate
/// @param date 日期
/// @param formaterMode 日期格式
+(NSDate *)dateToDate:(NSDate *)date formaterMode:(NSDateFormaterMode)formaterMode;

/// 字符串 -> NSDate
/// @param string 日期
/// @param formaterMode 日期格式
+(NSDate *)stringToDate:(NSString *)string formaterMode:(NSDateFormaterMode)formaterMode;

/// NSDate -> 字符串
/// @param formaterMode 日期格式
-(NSString *)dateToStringWithFormaterMode:(NSDateFormaterMode)formaterMode;

/// NSDate -> 字符串
/// @param date 日期
/// @param formaterMode 日期格式
+(NSString *)dateToString:(NSDate *)date formaterMode:(NSDateFormaterMode)formaterMode;

/// 字符串 -> 字符串
/// @param originalDate 日期
/// @param formaterMode 日期格式
+(NSString *)regularDateString:(NSString *)originalDate formaterMode:(NSDateFormaterMode)formaterMode;

/// 判断是否为今天
/// @param date 日期
+ (BOOL)isTodayWithDate:(NSDate *)date;

/// 判断是否为昨天
/// @param date 日期
+ (BOOL)isYesterdayWithDate:(NSDate *)date;

/// 判断是否为昨天、今天、明天、后天……
/// @param date 日期
+ (NSInteger)dayWithDate:(NSDate *)date;

/// 时间显示规则（时:分、昨天、月:日）暂不考虑跨年
/// @param timeStr 时间（需要传入的时间格式 2017-06-14 14:18:54）
+(NSString *)inputTimeStr:(NSString *)timeStr;

/// 计算时长 天 - 小时 - 分
/// @param fromDate 开始时间
/// @param toDate 结束时间
/// @param dateModel 时间格式
+(NSString *)intervalSinceFromDate:(NSString *)fromDate toDate:(NSString *)toDate dateModel:(NSDateFormaterMode)dateModel;

/// 时间戳转日期
/// @param timestamp 时间戳
+(NSString *)timestampToDate:(NSString *)timestamp;

/// 日期对比（NSDate）
/// @param date1 日期一
/// @param date2 日期二
+ (int)compareOneDate:(NSDate *)date1 withAnotherDate:(NSDate *)date2;

/// 日期对比（NSString）
/// @param date1 日期一
/// @param date2 日期二
+ (int)compareOneDateString:(NSString *)date1 withAnotherDateString:(NSString *)date2;

/// 获取农历日期
/// @param date 日期
+(NSDictionary *)getChineseCalendarWithDate:(NSDate *)date;

/// 结束时间 - 开始时间 = 时间差（分钟）
/// @param startTime 开始时间
/// @param endTime 结束时间
+ (NSInteger)minuteStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/// 计算时间差
/// @param date 日期
/// @param minute 分钟
+ (NSString *)dateInterval:(NSDate *)date time:(NSInteger)minute;

/// 跳转到偏差时间点（秒）
/// @param time 时间
/// @param second 秒
+(NSDate *)getResultTime:(NSString *)time second:(NSInteger)second;

/// 获取当前时间戳  （以秒为单位）
+(NSString *)getNowTimeTimestamp;

/// 获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3;

/// 将本地日期字符串转为UTC日期字符串
/// @param localDate 本地日期格式:2013-08-03 12:53:51
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate;

/// 将UTC日期字符串转为本地时间字符串
/// @param utcDate 输入的UTC日期格式2013-08-03T04:53:51+0000
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

@end

NS_ASSUME_NONNULL_END
