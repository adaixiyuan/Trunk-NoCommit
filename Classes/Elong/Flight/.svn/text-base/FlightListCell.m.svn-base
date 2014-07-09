//
//  FlightListCell.m
//  ElongClient
//
//  Created by dengfang on 11-1-13.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightListCell.h"


@implementation FlightListCell
@synthesize priceLabel;
@synthesize discountLabel;
@synthesize airCorpLabel;
@synthesize flightNumLabel;
@synthesize departAirPortLabel;
@synthesize arrivalAirPortLabel;
@synthesize departTimeLabel;
@synthesize arrivalTimeLabel,airFlightType,FlightIcon,ticketpieceLabel,ticketlessLabel,ticketmoreLabel;
@synthesize stateLabel;
@synthesize tFlightIcon;
@synthesize tAirCorpLabel;
@synthesize tDepartAirPortLabel;
@synthesize tArrivalAirPortLabel;
@synthesize tFlightNumLabel;
@synthesize tAirFlightType;
@synthesize tDepartTimeLabel;
@synthesize tArrivalTimeLabel;
@synthesize dash;
@synthesize rightArrow;
@synthesize priceSign;
@synthesize tickNumTitleLabel;
@synthesize couponLabel;
@synthesize infoView;
@synthesize discountIcon;
@synthesize originPriceLabel;
@synthesize originView;
@synthesize priceLine;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
//        UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
//		b_view.backgroundColor = [UIColor clearColor];
//		selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		selectBtn.backgroundColor = [UIColor clearColor];
//		selectBtn.frame = CGRectMake(15, 0, 290, 78);
//		[selectBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
//		[b_view addSubview:selectBtn];
//		self.selectedBackgroundView = b_view;
//		[b_view release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTransitModel:(BOOL)animated {
    if (animated) {
        // 中转航班布局
//        stateLabel.frame = CGRectMake(233, 115, 60, 21);
        priceSign.frame = CGRectMake(213.0f, 16.0f, 21, 23);
        priceLabel.frame = CGRectMake(231.0f, 8.0f, 49.0f, 30.0f);
        discountLabel.frame = CGRectMake(210.0f, 32, 58, 20);
        couponLabel.frame = CGRectMake(238.0f, 55.0f, 50, 21);
        _couponIcon.frame = CGRectMake(228.0f, 59.0f, 14, 13);
        rightArrow.frame = CGRectMake(293, 62, 10, 15);
        dash.frame = CGRectMake(15, 147, 290, 1);
        tickNumTitleLabel.frame = CGRectMake(172, 116, 33, 21);
        ticketlessLabel.frame = CGRectMake(170.0f, 29.0f, 40.0f, 21);
        ticketpieceLabel.frame = CGRectMake(214, 116, 24, 21);
        ticketmoreLabel.frame = CGRectMake(200, 116, 40, 21);
        originView.frame = CGRectMake(221.0f, 32.0f, 63, 30);
        
        self.selectedBackgroundView.frame = CGRectMake(0, 0, 320, 148);
        selectBtn.frame = CGRectMake(15, 0, 290, 146);
    }
    else
    {
        // 非中转布局
//        stateLabel.frame = CGRectMake(15.0f, 115, 60, 21);
        priceSign.frame = CGRectMake(213.0f, 16.0f, 21, 23);
        priceLabel.frame = CGRectMake(231.0f, 8.0f, 49.0f, 30.0f);
        discountLabel.frame = CGRectMake(227.0f, 30.0f, 63, 20);
        couponLabel.frame = CGRectMake(240.0f, 50.0f, 50, 21);
        _couponIcon.frame = CGRectMake(238.0f, 54.0f, 14, 13);
        rightArrow.frame = CGRectMake(293, 32.0f, 10, 15);
        dash.frame = CGRectMake(15, 147, 290, 1);
        tickNumTitleLabel.frame = CGRectMake(172, 29.0f, 33, 21);
        ticketlessLabel.frame = CGRectMake(170.0f, 29.0f, 40.0f, 21);
        ticketpieceLabel.frame = CGRectMake(214, 29.0f, 24, 21);
        ticketmoreLabel.frame = CGRectMake(185.0f, 29.0f, 40, 21);
        originView.frame = CGRectMake(241.0f, 48.0f, 63, 30);
        
        self.selectedBackgroundView.frame = CGRectMake(0, 0, 320, 146);
        selectBtn.frame = CGRectMake(15, 0, 290, 146);
    }
}

- (void)setDiscountModel:(BOOL)animated WithOriginPrice:(NSString *)originPrice
{
    discountIcon.frame = CGRectMake(170, 13.0f, 40, 12);
    
    if (animated)
    {
        // 机票立减展示
        discountIcon.hidden = NO;
        
        if (STRINGHASVALUE(originPrice))
        {
            // 有划价时不展示coupon
            originView.hidden = NO;
            originPriceLabel.text = [NSString stringWithFormat:@"¥ %@", originPrice];
            CGRect rect = priceLine.frame;
            rect.size.width = originPriceLabel.text.length * 7 + 7;
            priceLine.frame = rect;
            
            // 这里只隐藏coupon信息，不恢复
            _couponIcon.hidden = YES;
            couponLabel.hidden = YES;
        }
        else
        {
           originView.hidden = YES; 
        }
        
        infoView.frame = CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height);
    }
    else
    {
        discountIcon.hidden = YES;
        originView.hidden = YES;
        
        infoView.frame = CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height);
    }
}


- (void)dealloc {
	[priceLabel release];
	[discountLabel release];
	[airCorpLabel release];
	[flightNumLabel release];
	[departAirPortLabel release];
	[arrivalAirPortLabel release];
	[departTimeLabel release];
	[arrivalTimeLabel release];
    [stateLabel release];
    [tFlightIcon release];
    [tAirCorpLabel release];
    [tDepartAirPortLabel release];
    [tArrivalAirPortLabel release];
    [tFlightNumLabel release];
    [tAirFlightType release];
    [tDepartTimeLabel release];
    [tArrivalTimeLabel release];
    [priceSign release];
    [rightArrow release];
    [dash release];
    [tickNumTitleLabel release];
    [couponLabel release];
    [infoView release];
    [discountIcon release];
    [originPriceLabel release];
    [originView release];
    [priceLine release];
    self.rmbLabel = nil;
    self.qiLabel = nil;
    self.airFlightType = nil;
    self.FlightIcon = nil;
    self.ticketlessLabel = nil;
    self.ticketmoreLabel = nil;
    self.ticketpieceLabel = nil;
    
    [super dealloc];
}
@end
