//
//  RentFlightCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentFlightCell.h"
#import "RentFlight.h"

#define TEXTCOLOR RGBACOLOR(52, 52, 52, 1)
#define COLOR108 RGBACOLOR(108, 108, 108, 1)

@implementation RentFlightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)bindTheDisplayModel:(RentFlight *)aFlight{

//    NSString *airlinePicName = [Utils getAirCorpPicName:aFlight.airlineSimpleName];
//    self.airLineIcon.image = [UIImage imageNamed:airlinePicName];
    self.airLineName.text = aFlight.airlineSimpleName;
    self.startAirport.text = [aFlight.srcName stringByAppendingString:aFlight.srcterm];
    self.endAirport.text = [aFlight.destName stringByAppendingString:aFlight.destterm];
    self.startCity.text = aFlight.srcCity;
    self.endCity.text = aFlight.destCity;
    self.startTime.text = aFlight.arriveTime;
    self.endTime.text = aFlight.departTime;
    self.flightNum.text = aFlight.flight;
}


-(void)awakeFromNib{
    [self.airLineName setTextColor:COLOR108];
    [self.flightNum setTextColor:[UIColor blackColor]];
    [self.startAirport setTextColor:COLOR108];
    [self.endAirport setTextColor:COLOR108];
    [self.startCity setTextColor:COLOR108];
    [self.endCity setTextColor:COLOR108];
    [self.startTime setTextColor:TEXTCOLOR];
    [self.endTime setTextColor:TEXTCOLOR];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    setFree(_airLineIcon);
    setFree(_airLineName);
    setFree(_flightNum);
    setFree(_startAirport);
    setFree(_endAirport);
    setFree(_startCity);
    setFree(_endCity);
    setFree(_startTime);
    setFree(_endTime);

    [super dealloc];
}
@end
