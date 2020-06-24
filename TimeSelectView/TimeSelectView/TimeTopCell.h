//
//  TimeTopCell.h
//  TimeSelectView
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"

@interface TimeTopCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) TimeModel *model;

@end

