//
//  TimeCell.h
//  TimeSelectView
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TimeModel;

@interface TimeCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) TimeModel *model;

@end

NS_ASSUME_NONNULL_END
