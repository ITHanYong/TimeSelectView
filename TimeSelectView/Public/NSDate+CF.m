//
//  NSDate+CF.m
//  CaiFuProHS
//
//  Created by HanYong on 2020/5/8.
//  Copyright © 2020 CaiFuZhengQuan. All rights reserved.
//

#define Chinese_Years @[@"甲子",@"乙丑",@"丙寅",@"丁卯",@"戊辰",@"己巳",@"庚午",@"辛未",@"壬申",@"癸酉",@"甲戌",@"乙亥",@"丙子",@"丁丑",@"戊寅",@"己卯",@"庚辰",@"辛己",@"壬午",@"癸未",@"甲申",@"乙酉",@"丙戌",@"丁亥",@"戊子",@"己丑",@"庚寅",@"辛卯",@"壬辰",@"癸巳",@"甲午",@"乙未",@"丙申",@"丁酉",@"戊戌",@"己亥",@"庚子",@"辛丑",@"壬寅",@"癸丑",@"甲辰",@"乙巳",@"丙午",@"丁未",@"戊申",@"己酉",@"庚戌",@"辛亥",@"壬子",@"癸丑",@"甲寅",@"乙卯",@"丙辰",@"丁巳",@"戊午",@"己未",@"庚申",@"辛酉",@"壬戌",@"癸亥"]

#define Chinese_Months @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]

#define Chinese_Days @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

#import "NSDate+CF.h"

@implementation NSDateFormatter (CF)

+ (NSDateFormatter *)dateFormaterWithMode:(NSDateFormaterMode)formaterMode {
    NSString *stringFormat = @"";
    
    switch (formaterMode) {
        case NSDateFormaterModeLunar:
            
            break;
        case NSDateFormaterModeStandard:
            stringFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
        case NSDateFormaterModeStandard12:
            stringFormat = @"yyyy-MM-dd hh:mm:ss";
            break;
        case NSDateFormaterModeDemotion:
            stringFormat = @"yyyy-MM-dd HH:mm";
            break;
        case NSDateFormaterModeDemotion12:
            stringFormat = @"yyyy-MM-dd hh:mm";
            break;
        case NSDateFormaterModeDayDefault:
            stringFormat = @"yyyy-MM-dd";
            break;
        case NSDateFormaterModeDayAnother:
            stringFormat = @"yyyy年MM月dd日";
            break;
        case NSDateFormaterModeTimeStandard:
            stringFormat = @"HH:mm:ss";
            break;
        case NSDateFormaterModeTimeStandard12:
            stringFormat = @"hh:mm:ss";
            break;
        case NSDateFormaterModeTimeDemotion:
            stringFormat = @"HH:mm";
            break;
        case NSDateFormaterModeTimeDemotion12:
            stringFormat = @"hh:mm";
            break;
        default:
            stringFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:stringFormat];
    return dateFormat;
}

@end

@interface NSDate ()

@property (nonatomic, strong) NSArray *chineseYears;

@end

@implementation NSDate (CF)

-(NSArray *)chineseYears{
    return @[];
}

#pragma mark  - 年
-(NSInteger)year{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

#pragma mark - 月
-(NSInteger)month{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

#pragma mark - 日
-(NSInteger)day{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

#pragma mark - 时
-(NSInteger)hour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

#pragma mark - 分
-(NSInteger)minute{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

#pragma mark - 秒
-(NSInteger)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}

#pragma mark - 昨天
-(NSString *)yesterday{
    return [self getResultDay:-1];
}

#pragma mark - 明天
-(NSString *)tomorrow{
    return [self getResultDay:1];
}

#pragma mark - 后天
-(NSString *)dayAfterTomorrow{
    return [self getResultDay:2];
}

#pragma mark - 当前日期day + com = 新日期
-(NSString *)getResultDay:(NSInteger)com{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    [nowCmps setDay:([nowCmps day] + com)];
    
    NSDate *resultDate = [calendar dateFromComponents:nowCmps];
    
    return [NSDate dateToString:resultDate formaterMode:NSDateFormaterModeDayDefault];
}

#pragma mark - 当前日期 + second秒 = 新日期
+(NSDate *)getResultTime:(NSString *)time second:(NSInteger)second {
    
    NSDate *date = [NSDate stringToDate:time formaterMode:NSDateFormaterModeStandard];
    NSDate *newDate = [NSDate dateWithTimeInterval:second sinceDate:date];
    return newDate;
}

#pragma mark - 根据date获取 - 周几
-(NSDateWeekMode)weekday{
    //起始值 1-周日, 2-周一, 3-周二, 4-周三, 5-周四, 6-周五, 7-周六
    //改变值 7-周日, 1-周一, 2-周二, 3-周三, 4-周四, 5-周五, 6-周六
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    switch (components.weekday) {
        case 1:return  NSDateWeekModeSunday;     //周日;
        case 2:return  NSDateWeekModeMonday;     //周一;
        case 3:return  NSDateWeekModeTuesday;    //周二;
        case 4:return  NSDateWeekModeWednesday;  //周三;
        case 5:return  NSDateWeekModeThursday;   //周四;
        case 6:return  NSDateWeekModeFriday;     //周五;
        case 7:return  NSDateWeekModeSaturday;   //周六;
        default: return  0; //星期;
    }
}

#pragma mark - 周几 ： 星期几
-(NSString *)weekStr{
    switch (self.weekday) {
        case NSDateWeekModeMonday:      return @"星期一";
        case NSDateWeekModeTuesday:     return @"星期二";
        case NSDateWeekModeWednesday:   return @"星期三";
        case NSDateWeekModeThursday:    return @"星期四";
        case NSDateWeekModeFriday:      return @"星期五";
        case NSDateWeekModeSaturday:    return @"星期六";
        case NSDateWeekModeSunday:      return @"星期日";
        default: return @"星期";
    }
}

#pragma mark - 根据date获取 - 本月第几周
-(NSInteger)weekmonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    return components.weekOfMonth;
}

#pragma mark - 根据date获取 - 本年第几周
-(NSInteger)weekyear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    return components.weekOfYear;
}

#pragma mark - 字符串 -> NSDate
+(NSDate *)stringToDate:(NSString *)string formaterMode:(NSDateFormaterMode)formaterMode{
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    return [formater dateFromString:string];
}

#pragma mark - NSDate -> 字符串
-(NSString *)dateToStringWithFormaterMode:(NSDateFormaterMode)formaterMode{
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    return [formater stringFromDate:self];
}

#pragma mark - NSDate -> 字符串
+(NSString *)dateToString:(NSDate *)date formaterMode:(NSDateFormaterMode)formaterMode{
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    return [formater stringFromDate:date];
}

#pragma mark - 字符串 -> 字符串   获取指定格式的日期字符串
+(NSString *)regularDateString:(NSString *)originalDate formaterMode:(NSDateFormaterMode)formaterMode{
    
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    
    //将日期设置为标准格式
    NSDateFormatter *originalFormater = [NSDateFormatter dateFormaterWithMode:NSDateFormaterModeStandard];
    NSDate *date = [originalFormater dateFromString:originalDate];
    //获取指定格式的日期字符串
    NSString *newDate = [formater stringFromDate:date];
    return newDate;
}

/// NSDate -> 格式化NSDate
/// @param formaterMode 日期格式
-(NSDate *)dateToDateWithFormaterMode:(NSDateFormaterMode)formaterMode{
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    NSString *selfStr = [formater stringFromDate:self];
    return [formater dateFromString:selfStr];
}

#pragma mark - NSDate -> 格式化NSDate
+(NSDate *)dateToDate:(NSDate *)date formaterMode:(NSDateFormaterMode)formaterMode{
    
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    NSString *selfStr = [formater stringFromDate:date];
    return [formater dateFromString:selfStr];
}

#pragma mark - 判断是否为今天
-(BOOL)isToday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

#pragma mark - 判断是否为今天
+ (BOOL)isTodayWithDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

#pragma mark - 判断是否为昨天
- (BOOL)isYesterday{
    
    /*
     * 将日期格式化为 年-月-日 类型
     * 计算格式化后的时间差是否为一天
     */
    
    //获取格式化当前日期
    NSDate *nowDate = [NSDate dateToDate:[NSDate date] formaterMode:NSDateFormaterModeDayDefault];

    //获取格式化目标日期
    NSDate *selfDate = [self dateToDateWithFormaterMode:NSDateFormaterModeDayDefault];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得nowDate和selfDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

#pragma mark - 判断是否为昨天
+ (BOOL)isYesterdayWithDate:(NSDate *)date{
    
    /*
     * 将日期格式化为 年-月-日 类型
     * 计算格式化后的时间差是否为一天
     */
    
    //获取格式化当前日期
    NSDate *nowDate = [self dateToDate:[NSDate date] formaterMode:NSDateFormaterModeDayDefault];

    //获取格式化目标日期
    NSDate *selfDate = [self dateToDate:date formaterMode:NSDateFormaterModeDayDefault];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得nowDate和selfDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

#pragma mark - 判断是否为昨天、今天、明天、后天……
+ (NSInteger)dayWithDate:(NSDate *)date{
    
    /*
     * 将日期格式化为 年-月-日 类型
     * 计算格式化后的时间差是否为一天
     */
    
    //获取格式化当前日期
    NSDate *nowDate = [self dateToDate:[NSDate date] formaterMode:NSDateFormaterModeDayDefault];
    
    //获取格式化目标日期
    NSDate *selfDate = [self dateToDate:date formaterMode:NSDateFormaterModeDayDefault];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得nowDate和selfDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:nowDate toDate:selfDate options:0];
    
    return cmps.day;
}

/*
 * 需要传入的时间格式 2017-06-14 14:18:54    暂不考虑跨年
 * 时间显示规则
 * 当天       时:分
 * 前一天      昨天
 * 其余       月:日
 */
#pragma mark - 时间显示规则
+(NSString *)inputTimeStr:(NSString *)timeStr{
    
    //目标日期
    NSDate *sinceDate = [self stringToDate:timeStr formaterMode:NSDateFormaterModeStandard];
    
    if ([self isTodayWithDate:sinceDate]) {
        //今天 - 时:分
        return [NSString stringWithFormat:@"%.2ld:%.2ld",sinceDate.hour,sinceDate.minute];
    }else if([self isYesterdayWithDate:sinceDate]){
        //昨天 - 昨天
        return [NSString stringWithFormat:@"昨天"];
    }else{
        //昨天以前 - 月:日
        return [NSString stringWithFormat:@"%.2ld月%.2ld日",sinceDate.month,sinceDate.day];
    }
}

#pragma mark - 计算时长 天 - 小时 - 分
+(NSString *)intervalSinceFromDate:(NSString *)fromDate toDate:(NSString *)toDate dateModel:(NSDateFormaterMode)dateModel{
    
    NSString *timeString=@"";
    
    NSDateFormatter *format=[NSDateFormatter dateFormaterWithMode:dateModel ? : NSDateFormaterModeDemotion];
    
    //获取开始时间
    NSDate *fromdate=[format dateFromString:fromDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *startDate = [fromdate dateByAddingTimeInterval: frominterval];
    
    //获取结束时间
    NSDate *todate = [format dateFromString:toDate];
    NSTimeZone *tozone = [NSTimeZone systemTimeZone];
    NSInteger tointerval = [tozone secondsFromGMTForDate:todate];
    NSDate *endDate = [todate dateByAddingTimeInterval:tointerval];
    
    //计算时长
    double intervalTime = [startDate timeIntervalSinceReferenceDate] - [endDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    
    //秒差
    //NSInteger iSeconds =  lTime % 60;//秒
    //一小时内的分差
    NSInteger iMinutes = (lTime / 60) % 60;//分
    //一天内的小时差
    NSInteger iHours = labs(lTime/60/60) - labs(lTime/60/60/24) * 24;//时
    //天数差
    NSInteger iDays = labs(lTime/60/60/24);//天
    //NSInteger iMonth =lTime/60/60/24/12;//月
    //NSInteger iYears = lTime/60/60/24/384;
    
    if (iDays>0) {
        //大于一天
        timeString=[NSString stringWithFormat:@"%ld天%ld小时%ld分", iDays, iHours, iMinutes];
    }else{
        //小于一天
        if (iHours>0) {
            //大于1小时
            timeString=[NSString stringWithFormat:@"%ld时%ld分",iHours, iMinutes];
        }else{
            //小于1小时
            timeString=[NSString stringWithFormat:@"%ld分",iMinutes];
        }
    }
    
    return timeString;
}

#pragma mark - 时间戳转日期   10位
+(NSString *)timestampToDate:(NSString *)timestamp{
    
    // 13位时间戳
    NSInteger tamp = [timestamp integerValue];
    if (timestamp.length == 13) {
        tamp = tamp/1000;
    }
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = tamp;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark - 日期对比（NSDate）
+ (int)compareOneDate:(NSDate *)date1 withAnotherDate:(NSDate *)date2
{
    NSDate *dateA = [NSDate dateToDate:date1 formaterMode:NSDateFormaterModeStandard];
    NSDate *dateB = [NSDate dateToDate:date2 formaterMode:NSDateFormaterModeStandard];
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        NSLog(@"%@  %@",dateB,dateA);
        return 1;
    }
    else if (result == NSOrderedAscending){
        NSLog(@"%@  %@",dateA,dateB);
        return -1;
    }
    NSLog(@"%@:%@ are the same",dateA,dateB);
    return 0;
}

#pragma mark - 日期对比（NSString）
+(int)compareOneDateString:(NSString *)date1 withAnotherDateString:(NSString *)date2{
    
    NSString *date1Str = [NSDate regularDateString:date1 formaterMode:NSDateFormaterModeStandard];
    NSString *date2Str = [NSDate regularDateString:date2 formaterMode:NSDateFormaterModeStandard];
    
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:NSDateFormaterModeStandard];
    NSDate *dateA = [formater dateFromString:date1Str];
    NSDate *dateB = [formater dateFromString:date2Str];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        NSLog(@"%@  %@",dateB,dateA);
        return 1;
    }
    else if (result == NSOrderedAscending){
        NSLog(@"%@  %@",dateA,dateB);
        return -1;
    }
    NSLog(@"%@:%@ are the same",dateA,dateB);
    return 0;
}

-(NSDateComponents *)lunarComponents{
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    return localeComp;
}

#pragma mark - 获取农历（字典）
-(NSDictionary *)lunarCalendar{
    NSDictionary *dict = @{@"year":self.lunarYear,@"month":self.lunarMonth,@"day":self.lunarDay,@"leapMonth":@(self.leapMonth)};
    return dict;
}

#pragma mark - 获取农历日期
-(NSString *)lunarDate{
    return [NSString stringWithFormat:@"%@年%@%@%@",self.lunarYear,self.leapMonth ? @"润":@"",self.lunarMonth,self.lunarDay];
}

#pragma mark - 获取农历 - 年
-(NSString *)lunarYear{
    return [Chinese_Years objectAtIndex:self.lunarComponents.year-1];
}

#pragma mark - 获取农历 - 月
-(NSString *)lunarMonth{
    return [Chinese_Months objectAtIndex:self.lunarComponents.month-1];
}

#pragma mark - 获取农历 - 日
-(NSString *)lunarDay{
    return [Chinese_Days objectAtIndex:self.lunarComponents.day-1];
}

#pragma mark - 获取农历 - 闰月
-(BOOL)leapMonth{
    return self.lunarComponents.leapMonth;
}

#pragma mark - 获取农历日期
+(NSDictionary *)getChineseCalendarWithDate:(NSDate *)date{
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *year = [Chinese_Years objectAtIndex:localeComp.year-1];
    NSString *month = [Chinese_Months objectAtIndex:localeComp.month-1];
    NSString *day = [Chinese_Days objectAtIndex:localeComp.day-1];
    BOOL leapMonth = localeComp.leapMonth;//是否润月
    NSDictionary *dict = @{@"year":year,@"month":month,@"day":day,@"leapMonth":@(leapMonth)};
    
    return dict;
}

#pragma mark - 结束时间 - 开始时间 = 时间差（分钟）
+ (NSInteger)minuteStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"HH:mm"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    int minute = (int)value / 60;
   
    return minute;
}

#pragma mark - 计算时间差
+ (NSString *)dateInterval:(NSDate *)date time:(NSInteger)minute{
    //当前时间n分钟后
//    NSDate *locaDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compents = [[NSDateComponents alloc] init];
    [compents  setMinute:minute];
    NSDate *minDate = [calendar dateByAddingComponents:compents toDate:date ? : [NSDate date] options:0];
    NSDateFormatter *originalFormater = [NSDateFormatter dateFormaterWithMode:NSDateFormaterModeStandard];
    NSString *startTime = [originalFormater stringFromDate:minDate];
    return startTime;
}

#pragma mark - 获取当前时间戳  （以秒为单位）
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - 获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

#pragma mark - 将本地日期字符串转为UTC日期字符串
//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    
    return dateString;
}

#pragma mark - 将UTC日期字符串转为本地时间字符串
//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    
    return dateString;
}


#pragma mark - set
-(void)setSecond:(NSInteger)second{}
-(void)setYear:(NSInteger)year{}
-(void)setMonth:(NSInteger)month{}
-(void)setDay:(NSInteger)day{}
-(void)setHour:(NSInteger)hour{}
-(void)setMinute:(NSInteger)minute{}
-(void)setWeekmonth:(NSInteger)weekmonth{}
-(void)setWeekyear:(NSInteger)weekyear{}
-(void)setWeekday:(NSDateWeekMode)weekday{}
-(void)setYesterday:(NSString *)yesterday{}
-(void)setTomorrow:(NSString *)tomorrow{}
-(void)setWeekStr:(NSString *)weekStr{}
-(void)setDayAfterTomorrow:(NSString *)dayAfterTomorrow{}
-(void)setIsToday:(BOOL)isToday{}
-(void)setLunarDay:(NSString *)lunarDay{}
-(void)setLunarDate:(NSString *)lunarDate{}
-(void)setLunarYear:(NSString *)lunarYear{}
-(void)setLunarMonth:(NSString *)lunarMonth{}
-(void)setLunarCalendar:(NSDictionary *)lunarCalendar{}
-(void)setLunarComponents:(NSDateComponents *)lunarComponents{}
-(void)setLeapMonth:(BOOL)leapMonth{}
@end
