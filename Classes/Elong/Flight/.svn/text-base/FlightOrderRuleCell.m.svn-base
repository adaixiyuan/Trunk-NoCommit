//
//  FlightOrderRuleCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-2-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightOrderRuleCell.h"

#define FLIGHT_ORDER_LEBEL_WIDTH 280

@implementation FlightOrderRuleCell

@synthesize cellTotalHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(15, 0, 290, 1)]];
        
        UILabel *returnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 91, 22)];
        returnTitleLabel.backgroundColor    = [UIColor clearColor];
        returnTitleLabel.text               = @"退票规定：";
        returnTitleLabel.textColor          = [UIColor blackColor];
        returnTitleLabel.font               = FONT_16;
        [self addSubview:returnTitleLabel];
        [returnTitleLabel release];
        
        returnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 91, 22)];
        returnLabel.backgroundColor = [UIColor clearColor];
        returnLabel.textColor       = [UIColor blackColor];
        returnLabel.font            = FONT_12;
        returnLabel.numberOfLines   = 0;
        [self addSubview:returnLabel];
        [returnLabel release];
        
        changeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 37, 91, 22)];
        changeTitleLabel.backgroundColor    = [UIColor clearColor];
        changeTitleLabel.text               = @"改签规定：";
        changeTitleLabel.textColor          = [UIColor blackColor];
        changeTitleLabel.font               = FONT_16;
        [self addSubview:changeTitleLabel];
        [changeTitleLabel release];
        
        changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 48, 280, 20)];
        changeLabel.backgroundColor = [UIColor clearColor];
        changeLabel.textColor       = [UIColor blackColor];
        changeLabel.font            = FONT_12;
        changeLabel.numberOfLines   = 0;
        [self addSubview:changeLabel];
        [changeLabel release];
        
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)setReturnRule:(NSString *)rRule changeRule:(NSString *)cRule {
    if ([rRule isKindOfClass:[NSString class]] || [cRule isKindOfClass:[NSString class]]) {
        returnLabel.text = rRule;
        changeLabel.text = cRule;
        
        returnLabel.frame = CGRectMake(returnLabel.frame.origin.x,
                                       returnLabel.frame.origin.y,
                                       FLIGHT_ORDER_LEBEL_WIDTH,
                                       [self getRuleLineHeight:returnLabel.text componentWidth:FLIGHT_ORDER_LEBEL_WIDTH]);
        changeTitleLabel.frame = CGRectMake(changeTitleLabel.frame.origin.x,
                                            returnLabel.frame.origin.y + returnLabel.frame.size.height + 8,
                                            changeTitleLabel.frame.size.width,
                                            changeTitleLabel.frame.size.height);
        changeLabel.frame = CGRectMake(changeLabel.frame.origin.x,
                                       changeTitleLabel.frame.origin.y + changeTitleLabel.frame.size.height - 2,
                                       FLIGHT_ORDER_LEBEL_WIDTH,
                                       [self getRuleLineHeight:changeLabel.text componentWidth:FLIGHT_ORDER_LEBEL_WIDTH]);
        
        int offY = changeLabel.frame.origin.y + changeLabel.frame.size.height;
       
        // 在下方加虚线分割
        //[self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(15, offY + 5, 290, 1)]];
        
        cellTotalHeight = offY + 6;
    }
}


- (int)getRuleLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
	componentWidth -= 10;
	UIFont *font = FONT_12;
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT)];
	height += (size.height +5);
	if (height < 20) {
		height = 20;
	}
	return height;
}


@end
