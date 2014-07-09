//
//  TrainOrderDetailTicketView.m
//  ElongClient
//
//  Created by chenggong on 13-11-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderDetailTicketView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TrainOrderDetailTicketView
@synthesize passengerName;
@synthesize trainSeat;
@synthesize certificate;

- (void)dealloc
{
    self.ticketState = nil;
    self.requestRefundButton = nil;
    
    [passengerName release];
    [trainSeat release];
    [certificate release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //Line
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 290, 1)];
        topLine.image = [UIImage imageNamed:@"trainOrder_dashedLine.png"];
        topLine.contentMode = UIViewContentModeScaleAspectFill;
        topLine.clipsToBounds = YES;
        [self addSubview:topLine];
        [topLine release];
        
        UILabel *ticketStateDes = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 85.0f, 25.0f)];
        ticketStateDes.text = @"车票状态:";
        ticketStateDes.backgroundColor = [UIColor clearColor];
        ticketStateDes.textColor = RGBACOLOR(102, 102, 102, 1);
        ticketStateDes.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:ticketStateDes];
        [ticketStateDes release];
        
        self.ticketState = [[[UILabel alloc] initWithFrame:CGRectMake(90, 10.0f, 200.0f, 25.0f)] autorelease];
        _ticketState.text = @"";
        _ticketState.backgroundColor = [UIColor clearColor];
        _ticketState.textColor = RGBACOLOR(102, 102, 102, 1);
        _ticketState.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_ticketState];

        passengerName = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 85, 25)];
        passengerName.backgroundColor = [UIColor clearColor];
        passengerName.textColor = RGBACOLOR(52, 52, 52, 1);
        passengerName.font = FONT_B15;
        [self addSubview:passengerName];
    
        trainSeat = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 150,25)];
        trainSeat.backgroundColor = [UIColor clearColor];
        trainSeat.textColor = RGBACOLOR(102, 102, 102, 1);
        trainSeat.font = FONT_15;
        [self addSubview:trainSeat];
        
        certificate = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 290, 25)];
        certificate.backgroundColor = [UIColor clearColor];
        certificate.textColor = RGBACOLOR(153, 153, 153, 1);
        certificate.font = FONT_12;
        [self addSubview:certificate];
        
        //申请退票
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tempButton.frame = CGRectMake(250.0f, 42, 60.0f, 20);
        self.requestRefundButton = tempButton;
        _requestRefundButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_requestRefundButton setTitle:@"申请退票" forState:UIControlStateNormal];
        [_requestRefundButton setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        [_requestRefundButton  setBackgroundColor:RGBACOLOR(193, 194, 194, 1)];
        [self addSubview:_requestRefundButton];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
