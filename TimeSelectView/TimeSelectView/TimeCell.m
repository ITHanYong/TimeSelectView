//
//  TimeCell.m
//  TimeSelectView
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TimeCell.h"
#import "TimeModel.h"
//颜色
#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TimeCell ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation TimeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 30, 40);
        label.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0xFFFFFF);
        [self.contentView addSubview:label];
        self.label = label;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setModel:(TimeModel *)model {
    _model = model;
    
    if ([model.status isEqual:@(-1)]) {//禁用
        self.label.text = @"禁用";
        self.label.backgroundColor = UIColorFromRGB(0xDCDCDC);
        
    }else if ([model.status isEqual:@(1)]){//已占用
        self.label.text = @"占用";
        self.label.backgroundColor = UIColorFromRGB(0xFFCB2C);
        
    }else if ([model.status isEqual:@(2)]){//预用
        self.label.text = @"已选";
        self.label.backgroundColor = UIColorFromRGB(0xFF3F63);
    }else if ([model.status isEqual:@(3)]){//固定使用
        self.label.text = @"已占";
        self.label.backgroundColor = UIColorFromRGB(0xFF3F63);
    }else{
        self.label.text = @"空闲";
        self.label.backgroundColor = UIColorFromRGB(0x2392FF);
    }
}

@end
