//
//  TimeSelectView.m
//  TimeSelectView
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TimeSelectView.h"
#import "TimeCell.h"
#import "TimeTopCell.h"
#import "TimeModel.h"
#import "NSDate+CF.h"

//颜色
#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕尺寸
#define SCREENH                             [UIScreen mainScreen].bounds.size.height
#define SCREENW                             [UIScreen mainScreen].bounds.size.width

@interface TimeSelectView () <UICollectionViewDataSource, UICollectionViewDelegate>  {
    NSInteger _firstItem;
    NSInteger _lastItem;
    NSInteger _extendFirstItem;
    NSInteger _extendLastItem;
    
    NSArray *_segmentTimeArray;
    NSString *_timeString;
}

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;//总数据源

@property (nonatomic, strong) NSMutableArray *elapsedArray;//占用数据源

@property (nonatomic, strong) NSMutableArray *forbiddenArray;//禁用数据源

@property (nonatomic, strong) NSMutableArray *spareArray;//空闲数据源

@property (nonatomic, assign) BOOL isExtend;//是否是延长时间

@end

@implementation TimeSelectView

static NSString * const topIdentifier = @"TimeTopCell";
static NSString * const reuseIdentifier = @"TimeCell";
static NSString * const headerReuseID = @"TimeHeaderID";



- (instancetype)init
{
    self = [super init];
    if (self) {
        _firstItem = -1;
        _lastItem = -1;
        
        _segmentTimeArray = [self timeIntervalArrayWithStartTime:@"00:00" endTime:@"23:59"];
        //NSLog(@"----%@",_segmentTimeArray);
        
        for (int i = 0; i < _segmentTimeArray.count; i++) {
            TimeModel *model = [[TimeModel alloc] init];
            model.segmentTime = _segmentTimeArray[i];
            [self.dataArray addObject:model];
        }
        
        [self addSubview:self.collectionView];
        
        NSDate *date = [NSDate date];
        
        //设置起始位置
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:date.hour*4 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        
        
    }
    return self;
}

-(void)setReset:(BOOL)reset{
    
    if (reset) {
        for (TimeModel *model in self.dataArray) {
            model.status = @(0);
        }
        
        _firstItem = -1;
        _lastItem = -1;
        
        [self reloadView];
    }
}

//占用时间
-(void)setElapsedTime:(NSArray *)elapsedTime{
    _elapsedTime = elapsedTime;
    
    [self.elapsedArray removeAllObjects];
    
    for (NSDictionary *dict in elapsedTime) {
        
        [self.elapsedArray addObjectsFromArray: [self timeIntervalArrayWithStartTime:dict[@"start_time"] endTime:dict[@"end_time"]]];
    }
    
    //NSLog(@"appointArray - %@",self.appointArray)
    
    for (NSString *time in self.elapsedArray) {
        
        NSInteger index = [_segmentTimeArray indexOfObject:time];
        
        if (index<self.dataArray.count) {
            TimeModel *model = self.dataArray[index];
            model.status = @(1);
        }
        //NSLog(@"占用 - %@",time);
    }
}

//禁止时间
-(void)setForbiddenTime:(NSArray *)forbiddenTime{
    _forbiddenTime = forbiddenTime;
    
    [self.forbiddenArray removeAllObjects];
    
    for (NSDictionary *dict in forbiddenTime) {
        //禁止时间 开始时间取小 结束时间取大   如果结束时间为整点则减一分钟
        
        NSString *start;
        NSArray *startArr = [dict[@"start_time"] componentsSeparatedByString:@":"];
        
        if ([startArr[1] integerValue] < 15) {
            start = [NSString stringWithFormat:@"%@:00",startArr[0]];
        }else if ([startArr[1] integerValue] < 30 && [startArr[1] integerValue] >= 15) {
            start = [NSString stringWithFormat:@"%@:15",startArr[0]];
        }else if ([startArr[1] integerValue] < 45 && [startArr[1] integerValue] >= 30) {
            start = [NSString stringWithFormat:@"%@:30",startArr[0]];
        }else{
            start = [NSString stringWithFormat:@"%@:45",startArr[0]];
        }
        
        NSString *end;
        NSArray *endArr = [dict[@"end_time"] componentsSeparatedByString:@":"];
        
        if ([endArr[1] integerValue] == 0) {
            end = [NSString stringWithFormat:@"%02ld:00",[endArr[0] integerValue]-1];
        }else if ([endArr[1] integerValue] <= 15 && [endArr[1] integerValue] > 0) {
            end = [NSString stringWithFormat:@"%@:15",endArr[0]];
        }else if ([endArr[1] integerValue] <= 30 && [endArr[1] integerValue] > 15) {
            end = [NSString stringWithFormat:@"%@:30",endArr[0]];
        }else if ([endArr[1] integerValue] <= 45 && [endArr[1] integerValue] > 30) {
            end = [NSString stringWithFormat:@"%@:45",endArr[0]];
        }else{
            
            if ([endArr[0] integerValue] == 23) {
                end = [NSString stringWithFormat:@"%@:59",endArr[0]];
            }else{
                end = [NSString stringWithFormat:@"%02ld:00",[endArr[0] integerValue]+1];
            }
            
        }
        
        [self.forbiddenArray addObjectsFromArray: [self timeIntervalArrayWithStartTime:start endTime:end]];
    }
    
    //NSLog(@"forbiddenArray - %@",self.forbiddenArray)
    
    for (NSString *time in self.forbiddenArray) {
        
        NSInteger index = [_segmentTimeArray indexOfObject:time];
        
        if (index<self.dataArray.count) {
            TimeModel *model = self.dataArray[index];
            
            model.status = @(-1);
        }
        
        //NSLog(@"禁用 - %@",time);
    }
    
}

//空闲时间
-(void)setSpareTime:(NSArray *)spareTime{
    _spareTime = spareTime;
    
    [self.spareArray removeAllObjects];
    
    for (NSDictionary *dict in spareTime) {
        
        //空闲时间 开始时间取大 : 结束时间取小
        
        NSString *start;
        NSArray *startArr = [dict[@"start_time"] componentsSeparatedByString:@":"];
        
        //取大
        if ([startArr[1] integerValue] <= 15 && [startArr[1] integerValue] > 0) {
            start = [NSString stringWithFormat:@"%@:15",startArr[0]];
        }else if ([startArr[1] integerValue] <= 30 && [startArr[1] integerValue] > 15) {
            start = [NSString stringWithFormat:@"%@:30",startArr[0]];
        }else if ([startArr[1] integerValue] <= 45 && [startArr[1] integerValue] > 30) {
            start = [NSString stringWithFormat:@"%@:45",startArr[0]];
        }else if ([startArr[1] integerValue] <= 59 && [startArr[1] integerValue] > 45) {
            start = [NSString stringWithFormat:@"%02ld:00",[startArr[0] integerValue]+1];
        }
        
        NSString *end;
        NSArray *endArr = [dict[@"end_time"] componentsSeparatedByString:@":"];
        
        //取小
        if ([endArr[1] integerValue] < 15) {
            end = [NSString stringWithFormat:@"%@:00",endArr[0]];
        }else if ([endArr[1] integerValue] < 30 && [endArr[1] integerValue] >= 15) {
            end = [NSString stringWithFormat:@"%@:15",endArr[0]];
        }else if ([endArr[1] integerValue] < 45 && [endArr[1] integerValue] >= 30) {
            end = [NSString stringWithFormat:@"%@:30",endArr[0]];
        }else{
            end = [NSString stringWithFormat:@"%@:45",endArr[0]];
        }
        
        [self.spareArray addObjectsFromArray: [self timeIntervalArrayWithStartTime:start endTime:end]];
    }
    
    //NSLog(@"spareArray - %@",self.spareArray)
    
    for (NSString *time in self.spareArray) {
        
        NSInteger index = [_segmentTimeArray indexOfObject:time];
        
        if (index<self.dataArray.count) {
            TimeModel *model = self.dataArray[index];
            
            model.status = @(0);
        }
        
        //NSLog(@"空闲 - %@",time);
    }
    
}

-(void)setSelectTime:(NSString *)selectTime{
    
    _selectTime = selectTime;
    
    if (selectTime.length>0) {
        NSArray *time = [selectTime componentsSeparatedByString:@"-"];
        NSArray *useArray = [self timeIntervalArrayWithStartTime:time[0] endTime:time[1]];
        
        _firstItem = [_segmentTimeArray indexOfObject:useArray[0]];
        _lastItem = [_segmentTimeArray indexOfObject:useArray[useArray.count - 1]];
        
        for (NSString *time in useArray) {
            
            NSInteger index = [_segmentTimeArray indexOfObject:time];
            
            if (index<self.dataArray.count) {
                TimeModel *model = self.dataArray[index];
                
                model.status = @(2);
            }
        }
    }
}

-(void)setFixationTime:(NSString *)fixationTime{
    _fixationTime = fixationTime;
    
    if (fixationTime.length>0) {
        NSArray *time = [fixationTime componentsSeparatedByString:@"-"];
        NSArray *useArray = [self timeIntervalArrayWithStartTime:time[0] endTime:time[1]];
        
        _firstItem = [_segmentTimeArray indexOfObject:useArray[useArray.count - 1]];
        _lastItem = [_segmentTimeArray indexOfObject:useArray[useArray.count - 1]];
        
        for (NSString *time in useArray) {
            
            NSInteger index = [_segmentTimeArray indexOfObject:time];
            
            if (index<self.dataArray.count) {
                TimeModel *model = self.dataArray[index];
                
                model.status = @(3);
            }
        }
        
        self.isExtend = YES;
    }
}

-(void)reloadView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSString *)today {
    NSDateFormatter *dateFormatter = [self dateFormatter:@"yyyy-MM-dd"];
    
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return nowDate;
}

#pragma mark - ------------ DataSource && Delegate -------------
//// headerView的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//    return CGSizeMake(SCREEN_W, 50);
//}

// section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// cell代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 4 == 0) {
        TimeTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeTopCell" forIndexPath:indexPath];
        cell.title = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        TimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
        cell.title = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
}

// 点击代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isExtend) {
        [self didSelectExtendItemAtIndexPath:indexPath];
    }else{
        [self didSelectItemAtIndexPath:indexPath];
    }
}


// 点击代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断点击的cell是否是可用时间
    TimeModel *model = self.dataArray[indexPath.row];
    if ([model.status isEqual:@(-1)] || [model.status isEqual:@(1)]) {
        return;
    }
    
    if (_firstItem == -1  && _lastItem == -1) {//没有选中
        model.status = @(2);
        _firstItem = indexPath.row;
        [self.collectionView reloadData];
    }else if (_firstItem == -1){//开始时间没选
        
    }else if (_lastItem == -1){//只选择了开始时间
        
        if (_firstItem == indexPath.row) {//再次点击开始时间
            _firstItem = -1;
            model.status = @(0);
        }else {
            _lastItem = indexPath.row;
            
            //始终维持 firstItem < lastItem
            if (_firstItem > _lastItem) {
                NSInteger term = _firstItem;
                _firstItem = _lastItem;
                _lastItem = term;
            }
            
            //判断（起始时间 - 终止时间）内 的时间是否全部可用
            if (![self isAllTimeCanBeUse:_firstItem end:_lastItem]) {
                return;
            }
            
            [self setItemSelected:indexPath];
        }
        
        [self.collectionView reloadData];
        
    }else {
        
        //始终维持 firstItem < lastItem
        if (_firstItem > _lastItem) {
            NSInteger term = _firstItem;
            _firstItem = _lastItem;
            _lastItem = term;
        }
        
        if (indexPath.row > _firstItem) {//
            
            if (indexPath.row > _lastItem) {
                _lastItem = indexPath.row;
            }else{
                _lastItem = indexPath.row - 1;
            }
            
            //判断（起始时间 - 终止时间）内 的时间是否全部可用
            if (![self isAllTimeCanBeUse:_firstItem end:_lastItem]) {
                return;
            }
            
            [self setItemSelected:indexPath];
            [self.collectionView reloadData];
            
        }else if (indexPath.row < _firstItem){
            _firstItem = indexPath.row;
            
            //判断（起始时间 - 终止时间）内 的时间是否全部可用
            if (![self isAllTimeCanBeUse:_firstItem end:_lastItem]) {
                return;
            }
            
            [self setItemSelected:indexPath];
            [self.collectionView reloadData];
            
        }else {
            model.status = @(0);
            _firstItem = -1;
            _lastItem = -1;
            for (TimeModel *timeModel in self.dataArray) {
                if (![timeModel.status isEqual:@(-1)]&&![timeModel.status isEqual:@(1)]) {
                    timeModel.status = @(0);
                }
            }
            
            [self.collectionView reloadData];
            //            return;
        }
    }
    
    if (_lastItem != -1 && _firstItem != -1) {
        if (self.seletedBlock) {
            BOOL isBigger = _lastItem > _firstItem;
            TimeModel *startModel = self.dataArray[isBigger ? _firstItem : _lastItem];
            TimeModel *endModel = self.dataArray[isBigger ? _lastItem: _firstItem];
            
            NSString *endSeg;
            NSString *end = endModel.segmentTime;
            NSArray *endArr = [end componentsSeparatedByString:@":"];
            if ([endArr[1] isEqualToString:@"45"]) {
                endSeg = [NSString stringWithFormat:@"%@:59",endArr[0]];
            }else{
                endSeg = [NSString stringWithFormat:@"%@:%02ld",endArr[0],[endArr[1] integerValue]+15];
            }
            
            //回传 开始时间 - 结束时间
            self.seletedBlock(startModel.segmentTime, endSeg);
        }
        
    }else if (_lastItem == -1 && _firstItem != -1){
        
        if (self.seletedBlock) {
            
            TimeModel *startModel = self.dataArray[_firstItem];
            
            NSLog(@"%@",startModel.segmentTime);
            NSString *endSeg;
            NSString *start = startModel.segmentTime;
            NSArray *startArr = [start componentsSeparatedByString:@":"];
            
            if ([startArr[1] isEqualToString:@"45"]) {
                endSeg = [NSString stringWithFormat:@"%@:59",startArr[0]];
            }else{
                endSeg = [NSString stringWithFormat:@"%@:%02ld",startArr[0],[startArr[1] integerValue]+15];
            }
            
            //回传 开始时间 - 结束时间
            self.seletedBlock(startModel.segmentTime, endSeg);
        }
        
    }else if (_lastItem != -1 && _firstItem == -1){
        
        if (self.seletedBlock) {
            TimeModel *lastModel = self.dataArray[_lastItem];
            
            NSLog(@"%@",lastModel.segmentTime);
            NSString *endSeg;
            NSString *start = lastModel.segmentTime;
            NSArray *startArr = [start componentsSeparatedByString:@":"];
            
            if ([startArr[1] isEqualToString:@"45"]) {
                endSeg = [NSString stringWithFormat:@"%@:59",startArr[0]];
            }else{
                endSeg = [NSString stringWithFormat:@"%@:%02ld",startArr[0],[startArr[1] integerValue]+15];
            }
            
            //回传 开始时间 - 结束时间
            self.seletedBlock(lastModel.segmentTime, endSeg);
        }
    }else{
        if (self.seletedBlock) {
            //回传 开始时间 - 结束时间
            self.seletedBlock(@"", @"");
        }
    }
}

// 点击代理方法
- (void)didSelectExtendItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断点击的cell是否是可用时间
    TimeModel *model = self.dataArray[indexPath.row];
    if ([model.status isEqual:@(-1)] || [model.status isEqual:@(1)] || [model.status isEqual:@(3)]) {
        return;
    }
    
    if (indexPath.row > _lastItem) {
        
        if (_extendFirstItem == indexPath.row) {
            _extendFirstItem = -1;
            _extendLastItem = -1;
            
            for (TimeModel *timeModel in self.dataArray) {
                if ((![timeModel.status isEqual:@(-1)]) && (![timeModel.status isEqual:@(1)]) && (![timeModel.status isEqual:@(3)])) {
                    timeModel.status = @(0);
                }
            }
            
            [self.collectionView reloadData];
            if (self.extendMeetingTime) {
                self.extendMeetingTime(@"", @"");
            }
        }else{
            
            if (_extendLastItem < indexPath.row) {
                //判断选中的时间与lastItem时间 内 的时间是否全部可用
                if (![self isExtendAllTimeCanBeUse:_lastItem + 1 end:indexPath.row]) {
                    return;
                }
                
                _extendFirstItem = _lastItem + 1;
                _extendLastItem = indexPath.row;
                
            }else{
                
                //判断选中的时间与lastItem时间 内 的时间是否全部可用
                if (![self isExtendAllTimeCanBeUse:_lastItem + 1 end:indexPath.row - 1]) {
                    return;
                }
                
                _extendFirstItem = _lastItem + 1;
                _extendLastItem = indexPath.row - 1;
            }
            
            BOOL isBigger = _extendLastItem > _extendFirstItem;
            TimeModel *startModel = self.dataArray[isBigger ? _extendFirstItem : _extendLastItem];
            TimeModel *endModel = self.dataArray[isBigger ? _extendLastItem: _extendFirstItem];
            
            NSString *endSeg;
            NSString *end = endModel.segmentTime;
            NSArray *endArr = [end componentsSeparatedByString:@":"];
            if ([endArr[1] isEqualToString:@"45"]) {
                endSeg = [NSString stringWithFormat:@"%@:59",endArr[0]];
            }else{
                endSeg = [NSString stringWithFormat:@"%@:%02ld",endArr[0],[endArr[1] integerValue]+15];
            }
            
            [self setExtendItemSelected:indexPath];
            [self.collectionView reloadData];
            
            if (self.extendMeetingTime) {
                //回传 开始时间 - 结束时间
                self.extendMeetingTime(startModel.segmentTime, endSeg);
            }
        }
    }
}


#pragma mark - 判断时间段内是否都可用
-(BOOL)isAllTimeCanBeUse:(NSInteger)start end:(NSInteger )end{
    
    for (NSInteger i = start; i < end+1; i++) {
        TimeModel *model = self.dataArray[i];
        
        if (!([model.status isEqual:@(0)] || [model.status isEqual:@(2)])) {
            
            NSLog(@"选择时间段内包含不可选时间");
            
            for (NSInteger j = start; j < end + 1; j ++) {
                TimeModel *model = self.dataArray[j];
                if ([model.status isEqual:@(2)]) {
                    model.status = @(0);
                }
            }
            
            _firstItem = -1;
            _lastItem =  -1;
            [self.collectionView reloadData];
            if (self.seletedBlock) {
                self.seletedBlock(@"", @"");
            }
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 判断时间段内是否都可用
-(BOOL)isExtendAllTimeCanBeUse:(NSInteger)start end:(NSInteger )end{
    
    for (NSInteger i = start; i < end+1; i++) {
        TimeModel *model = self.dataArray[i];
        
        if (!([model.status isEqual:@(0)] || [model.status isEqual:@(2)] || [model.status isEqual:@(3)])) {
            
            NSLog(@"选择时间段内包含不可选时间");
            
            for (NSInteger j = start; j < end + 1; j ++) {
                TimeModel *model = self.dataArray[j];
                if ([model.status isEqual:@(2)]) {
                    model.status = @(0);
                }
            }
            
            _extendLastItem = -1;
            [self.collectionView reloadData];
            if (self.extendMeetingTime) {
                self.extendMeetingTime(@"", @"");
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)setItemSelected:(NSIndexPath *)indexPath {
    
    //    BOOL isBigger = _lastItem > _firstItem;
    for (TimeModel *timeModel in self.dataArray) {
        if (![timeModel.status isEqual:@(-1)]&&![timeModel.status isEqual:@(1)]) {
            timeModel.status = @(0);
        }
    }
    NSArray *subArray = [self.dataArray subarrayWithRange:NSMakeRange(_firstItem, labs(_lastItem - _firstItem) + 1)];
    NSString *startTime = [[_timeString componentsSeparatedByString:@"-"] firstObject];
    
    for (TimeModel *timeModel in subArray) {
        if ([timeModel.segmentTime isEqualToString:startTime]) {
            //            _lastItem = -1;
            return;
        }
        timeModel.status = @(2);
    }
}

- (void)setExtendItemSelected:(NSIndexPath *)indexPath {
    
    //    BOOL isBigger = _lastItem > _firstItem;
    for (TimeModel *timeModel in self.dataArray) {
        if ((![timeModel.status isEqual:@(-1)])&&(![timeModel.status isEqual:@(1)])&&(![timeModel.status isEqual:@(3)])) {
            timeModel.status = @(0);
        }
    }
    NSArray *subArray = [self.dataArray subarrayWithRange:NSMakeRange(_extendFirstItem, labs(_extendLastItem - _extendFirstItem) + 1)];
    NSString *startTime = [[_timeString componentsSeparatedByString:@"-"] firstObject];
    
    for (TimeModel *timeModel in subArray) {
        if ([timeModel.segmentTime isEqualToString:startTime]) {
            return;
        }
        timeModel.status = @(2);
    }
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item % 4 == 0) {
        return CGSizeMake(30, 70);
    }else{
        return CGSizeMake(30,40);
    }
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 19;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (NSArray *)theTimeArray {
    NSMutableArray *timeArray = [NSMutableArray array];
    for (int i = 8; i < 23; i ++) {
        [timeArray addObject: [NSString stringWithFormat:@"%02d:00",i]];
    }
    return timeArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(18.5, 0, SCREENW - 18.5 * 2, 40 * 4 + 10 * 3 + 30);
}

- (NSInteger)indexOfTime:(NSArray *)array {
    NSDateFormatter *dateFormatter = [self dateFormatter:@"HH:mm"];
    
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *nowTime = [self timeCarryWithString:nowDate];
    
    NSInteger index = -1;
    for (int i = 0; i < array.count; i ++) {
        NSString *timeString = array[i];
        if ([timeString isEqualToString:nowTime]) {
            index = [array indexOfObject:timeString];
        }
    }
    return index;
}

//返回时间间隔为15分钟的数组
- (NSArray *)timeIntervalArrayWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSMutableArray *timeArray = [NSMutableArray array];
    //    NSString *stringFormat = @"yyyy-MM-dd HH:mm";
    
    NSDateFormatter *dateFormatter = [self dateFormatter:@"yyyy-MM-dd HH:mm"];//[[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:stringFormat];
    
    //创建了两个日期对象
    NSDate *date1 = [dateFormatter dateFromString:[NSString stringWithFormat:@"2018-10-10 %@",startTime]];
    NSDate *date2 = [dateFormatter dateFromString:[NSString stringWithFormat:@"2018-10-10 %@",endTime]];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    
    //int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)%3600/60;
    
    //得到当前的时间
    //设置时间间隔（秒）
    for (int i = 0; i < hours*4 + ceil((minute)/15.0); i ++) {
        NSTimeInterval time2 = 15 * i * 60;//一年的秒数
        //（-：表示向前的时间间隔），如果没有，则表示向后的时间间隔）
        NSDate * lastYear = [date1 dateByAddingTimeInterval:time2];
        //转化为字符串
        NSString * startDate = [dateFormatter stringFromDate:lastYear];
        NSString *lastString = [startDate substringWithRange:NSMakeRange(11, 5)];
        [timeArray addObject:lastString];
    }
    return [timeArray copy];
}

- (NSDateFormatter *)dateFormatter:(NSString *)stringFormat {
    //    NSString *stringFormat = @"yyyy-MM-dd HH:mm";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:stringFormat];
    return dateFormatter;
}

//时间进位   如果是13就进位为15
- (NSString *)timeCarryWithString:(NSString *)timeString {
    NSArray *strings = [timeString componentsSeparatedByString:@":"];
    NSInteger prefix = [[strings firstObject] integerValue];
    NSInteger suffix = [[strings lastObject] integerValue];
    
    if (suffix < 15) {
        suffix = 15;
    }else if (suffix < 30) {
        suffix = 30;
    }else if (suffix < 45) {
        suffix = 45;
    }else {
        prefix += 1;
        suffix = 0;
    }
    NSString *lastString = [NSString stringWithFormat:@"%02ld:%02ld",prefix,suffix];
    return lastString;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //设置布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(18.5, 0, SCREENW - 18.5 * 2, 40 * 4 + 10 * 3 + 30) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //    _collectionView.contentSize = CGSizeMake(1000, 400);
        
        [_collectionView registerClass:[TimeTopCell class] forCellWithReuseIdentifier:topIdentifier];
        [_collectionView registerClass:[TimeCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

-(NSMutableArray *)elapsedArray{
    if (!_elapsedArray) {
        _elapsedArray = [NSMutableArray array];
    }
    return _elapsedArray;
}

-(NSMutableArray *)forbiddenArray{
    if (!_forbiddenArray) {
        _forbiddenArray = [NSMutableArray array];
    }
    return _forbiddenArray;
}

-(NSMutableArray *)spareArray{
    if (!_spareArray) {
        _spareArray = [NSMutableArray array];
    }
    return _spareArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
