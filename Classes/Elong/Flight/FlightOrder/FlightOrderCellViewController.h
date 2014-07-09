//
//  FlightOrderCellViewController.h
//  ElongClient
//  机票订单cell
//  Created by WangHaibin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlightOrderCellViewController : UIViewController {
	IBOutlet UILabel *flightNumberLabel;
	IBOutlet UIImageView *flightNumberIcon;
	IBOutlet UILabel* departDateLabel;		//起飞日期，月，日
	IBOutlet UILabel *beginTimeLabel;		//起飞时间
	IBOutlet UILabel *arrivalTimeLabel;		//到达时间
	IBOutlet UILabel *beginAirportLabel;	//起飞
	IBOutlet UILabel *arriveAriportLabel;	//到达
	IBOutlet UILabel* stops_label;
}

@property (nonatomic ,retain)UILabel *flightNumberLabel;
@property (nonatomic, retain)UIImageView *flightNumberIcon;
@property (nonatomic, retain)UILabel *beginTimeLabel;
@property (nonatomic, retain)UILabel *arrivalTimeLabel;
@property (nonatomic, retain)UILabel *beginAirportLabel;
@property (nonatomic, retain)UILabel *arriveAriportLabel;
@property (nonatomic, retain)UILabel* departDateLabel;
@property (nonatomic, retain)UILabel* stops_label;


@end
