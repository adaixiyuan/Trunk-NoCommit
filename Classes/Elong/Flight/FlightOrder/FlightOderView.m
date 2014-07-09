//
//  FlightOderView.m
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOderView.h"
#import "UIImageView+WebCache.h"

@implementation FlightOderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

 -(void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)setModel:(AirlineInfoModel *)model
{
    if (_model !=  model)
    {
        [_model  release];
        _model = [model  retain];
    }

    [self.flightNumPic setImage:[UIImage imageNamed:[Utils getAirCorpPicName:self.model.AirCorpName]]];
      
    self.flightNumLabel.text =self.model.FlightNumber;
    
    NSString *arrivalTimeString = [TimeUtils displayDateWithJsonDate:self.model.ArrivalDate formatter:@"yyyy-MM-dd HH:mm"];
    
    NSString *departTimeString =  [TimeUtils displayDateWithJsonDate:self.model.DepartDate formatter:@"yyyy-MM-dd HH:mm"];
    
    self.flightDateLabel.text = [arrivalTimeString substringToIndex:10];
    
    self.startTime.text = [departTimeString substringFromIndex:11];
    
    if ([[arrivalTimeString substringToIndex:10] isEqualToString:[departTimeString substringToIndex:10]]) {
        self.arriveTime.text = [arrivalTimeString substringFromIndex:11];
    }
    else {
       self.arriveTime.text =[NSString stringWithFormat:@"次日%@",[arrivalTimeString substringFromIndex:11]];
    }
   
    NSString *arrivelAirportString = self.model.ArrivalAirPort;
    NSString *departAirportString = self.model.DepartAirPort;
     self.flightStartLabel.text = departAirportString;
    self.flightArriveLabel.text =arrivelAirportString;
    
}

- (void)dealloc
{
   [_flightNumLabel  release];
    [_flightDateLabel  release];
    [_flightArriveLabel  release];
    [_flightStartLabel  release];
    [_startTime  release];
   [_arriveTime  release ];
   [_priceLabel  release];
    [_model  release];
    [super dealloc];
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
