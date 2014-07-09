//
//  RateBarView.h
//  ElongClient
//  显示比例的条状图
//
//  Created by 赵 海波 on 12-12-26.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateBarView : UIView {
@private
    CGFloat rateValue;
}

@property (nonatomic,retain) UIColor *backColor;
@property (nonatomic,retain) UIColor *rateColor;
- (id)initWithFrame:(CGRect)frame Rate:(CGFloat)rate;

@end
