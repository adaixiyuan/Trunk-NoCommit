//
//  FlightDetail.h
//  ElongClient
//  机票详情页面
//  Created by dengfang on 11-1-24.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "FlightPostManager.h"
#import "ElongURL.h"

@class FlightMoreRule;
@class PlaneInfo;

@interface FlightDetail : ElongBaseViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIImageView *airlinesIconImageView;
    IBOutlet UIImageView *dashLine;
    IBOutlet UIView *transInfoView;
    
	IBOutlet UILabel *airlinesLabel;
	IBOutlet UILabel *departcityLabel;
	IBOutlet UILabel *arrivecityLabel;
	IBOutlet UILabel *departTimeLabel;
	IBOutlet UILabel *arrivalTimeLabel;
	IBOutlet UILabel *departTimehourLabel;
	IBOutlet UILabel *arriveTimehourLabel;
	IBOutlet UILabel *gateLabel;
	IBOutlet UILabel *arrivegateLabel;
	IBOutlet UILabel *planeTypeLabel;
    IBOutlet UILabel *transAirportLabel;
    IBOutlet UILabel *transTimeLabel;
    IBOutlet UILabel *transDepartTimeLabel;
    IBOutlet UILabel *departTitleLabel;
    IBOutlet UILabel *arriveTitleLabel;
    IBOutlet UILabel *stopInfoLabel;            // 显示经停信息
	
	IBOutlet UIButton *planeInfoButton;

	int m_iState;
	
	IBOutlet UIView *bg1View;
	NSMutableArray* siteArray;//飞机舱位的全部数据
	FlightMoreRule* flightrule; //改签和退票规则，
    NSMutableArray* m_srollDataArray; //滚动控件的数据
	
	BOOL gotPlaneIntro;			// 是否已得到过机型介绍得数据
    NSString *visitType;
    HttpUtil *transportUtil;    // 经停信息请求
    HttpUtil *couponUtil;       // 消费券金额请求
    int parentvcselectedindex;
    
    UILabel *airportlabel;
    UILabel *timelabel;
    NSArray *stopInfos;               // 纪录经停信息
    
    UIView *jingtingbackview;
    IBOutlet UITableView *detaiTable;     // 舱位列表
    IBOutlet UIView *viewOneHourHint;           // 一小时飞人提示界面
    IBOutlet UIImageView *bottomLine;           // 分隔线
}

@property (nonatomic,retain) IBOutlet UIButton *planeInfoButton; //飞机信息按钮
@property (nonatomic,assign) int parentvcselectedindex;
@property (nonatomic,assign) BOOL isSelect51Book;   // 选择是否51产品
@property (nonatomic,assign) BOOL isOneHour;        // 是否一小时飞人

- (IBAction)planeInfoButtonPressed; //飞机信息
- (void)clickOrderButtonAtIndex:(NSInteger)index;   // 点击订单预订按钮
- (void)clickRuleButtonAtIndex:(NSInteger)index;    // 点击退改签规则按钮
- (void)requestStopInfo; //请求中转信息

@end
