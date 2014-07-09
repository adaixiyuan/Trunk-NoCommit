//
//  FlightDetailCell.m
//  ElongClient
//
//  Created by 赵 海波 on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightDetailCell.h"

@implementation FlightDetailCell

+ (id)cellFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightDetailCell" owner:self options:nil];
    
    FlightDetailCell *cell = nil;
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[FlightDetailCell class]])
        {
            cell = (FlightDetailCell *)oneObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.ruleBtn.exclusiveTouch = YES;
            cell.orderBtn.exclusiveTouch = YES;
        }
    }
    
    return cell;
}


- (void)setHighlightSpaceTitle:(NSString *)title
{
    CGRect rect;
    int offX = 0;
    if (STRINGHASVALUE(title))
    {
        CGSize size = [title sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(150, 20)];
        
        _highlightLabel.text = title;
        rect = _highlightLabel.frame;
        rect.size.width = size.width + 12;
        _highlightLabel.frame = rect;
        
        offX = 5;
    }
    else
    {
        CGRect rect = _highlightLabel.frame;
        rect.size.width = 0;
        _highlightLabel.frame = rect;
        
        offX = 0;
    }
    
    rect = _typeNameLabel.frame;
    rect.origin.x = _highlightLabel.frame.origin.x + _highlightLabel.frame.size.width + offX;
    _typeNameLabel.frame = rect;
}


- (void)setSpaceTitle:(NSString *)title
{
    CGRect rect;
    int offX = 0;
    if (STRINGHASVALUE(title))
    {
        CGSize size = [title sizeWithFont:FONT_B17 constrainedToSize:CGSizeMake(160, 20)];
        
        _typeNameLabel.text = title;
        rect = _typeNameLabel.frame;
        rect.size.width = size.width + 2;
        _typeNameLabel.frame = rect;
        
        offX = 5;
    }
    else
    {
        CGRect rect = _typeNameLabel.frame;
        rect.size.width = 0;
        _typeNameLabel.frame = rect;
        
        offX = 0;
    }
    
    rect = _legislationIcon.frame;
    rect.origin.x = _typeNameLabel.frame.origin.x + _typeNameLabel.frame.size.width + offX;
    _legislationIcon.frame = rect;
}


- (void)setDiscountModel:(BOOL)isDiscount WithOriginPrice:(NSString *)originPrice
{
    if (isDiscount)
    {
        // 立减显示布局
        if (STRINGHASVALUE(originPrice))
        {
            // 有划价时不展示coupon
            _originPriceLabel.hidden = NO;
            _legislationIcon.hidden = NO;
            _originPriceLabel.text = [NSString stringWithFormat:@"¥  %@", originPrice];
            _priceLine.hidden = NO;
            
            CGSize size = [_originPriceLabel.text sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(200, 20)];
            CGRect rect = _priceLine.frame;
            rect.size.width = size.width + (_originView.frame.size.width - _originPriceLabel.frame.size.width) * 2;
            rect.origin.x = _originView.frame.size.width - rect.size.width;
            _priceLine.frame = rect;
            
            // 只隐藏coupon，不管恢复
            _couponLabel.hidden = YES;
            _couponIcon.hidden = YES;
        }
    }
    else
    {
        // 非立减显示布局
        _priceLine.hidden = YES;
        _originPriceLabel.hidden = YES;
        _legislationIcon.hidden = YES;
    }
}


- (void)setCouponValue:(NSString *)coupon
{
    if (STRINGHASVALUE(coupon) &&
        [coupon intValue] > 0)
    {
        _couponLabel.text = [NSString stringWithFormat:@"¥%@", coupon];
        
//        CGSize size = [_couponLabel.text sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(100, 20)];
//        rect = _couponLabel.frame;
//        rect.size.width = size.width + 2;
//        rect.origin.x = 263 - rect.size.width;
//        _couponLabel.frame = rect;
        _couponIcon.hidden = NO;
    }
    else
    {
        _couponLabel.text = @"";
        _couponIcon.hidden = YES;
    }
    
//    rect = _couponIcon.frame;
//    rect.origin.x = _couponLabel.frame.origin.x - offX - rect.size.width;
//    _couponIcon.frame = rect;
}


- (IBAction)clickOrderButton
{
    if ([_root respondsToSelector:@selector(clickOrderButtonAtIndex:)])
    {
        [_root clickOrderButtonAtIndex:_rowNum];
    }
}


- (IBAction)clickRuleButton
{
    if ([_root respondsToSelector:@selector(clickRuleButtonAtIndex:)])
    {
        [_root clickRuleButtonAtIndex:_rowNum];
    }
}

@end
