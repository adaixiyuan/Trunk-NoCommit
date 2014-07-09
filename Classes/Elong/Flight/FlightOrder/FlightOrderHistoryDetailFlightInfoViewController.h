//
//  FlightOrderHistoryDetailFlightInfoViewController.h
//  ElongClient
//  飞机信息
//  Created by WangHaibin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlightOrderHistoryDetailFlightInfoDelegate <NSObject>

-(void)reviewRule:(int)tag;

@end

@interface FlightOrderHistoryDetailFlightInfoViewController : UIViewController {
	//View2==============
	IBOutlet UILabel *airlinesLabel;        //航班
	IBOutlet UILabel *departTimeLabel;  //出发时间
	IBOutlet UILabel *arrivalTimeLabel;     //降落时间
	IBOutlet UILabel *ticketStateLabel;     //机票状态
	IBOutlet UILabel *stoplabel;        //经停提示
    IBOutlet UILabel *departStationLabel;       //出发站
    IBOutlet UILabel *arriveStationLabel;       //到达站
    IBOutlet UILabel *capinLabel;       //舱位
    IBOutlet UILabel *goOrBackTypeLabel;        //去返程类型
    IBOutlet UIImageView *goOrBackBg;       //去返程背景
}
@property (nonatomic,retain) IBOutlet UILabel *airlinesLabel;
@property (nonatomic,retain) IBOutlet UILabel *departTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *arrivalTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *ticketStateLabel;
@property (nonatomic,retain) IBOutlet UILabel *stoplabel;
@property (nonatomic,retain)  IBOutlet UILabel *departStationLabel;
@property (nonatomic,retain) IBOutlet UILabel *arriveStationLabel;
@property (nonatomic,retain)  IBOutlet UILabel *capinLabel;
@property (nonatomic,retain)  IBOutlet UILabel *goOrBackTypeLabel;        //去返程类型
@property (nonatomic,retain)  IBOutlet UIImageView *goOrBackBg;       //去返程背景

@property(nonatomic,assign) id<FlightOrderHistoryDetailFlightInfoDelegate> delegate;
-(IBAction)goRule:(id)sender;


@end
