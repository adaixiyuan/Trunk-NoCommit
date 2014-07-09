//
//  FlightOrderConfirmCell.h
//  ElongClient
//  机票确认页cell
//
//  Created by 赵 海波 on 13-2-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightOrderConfirmCell : UITableViewCell {
@private
    UILabel *arriveTitleLabel;
    UILabel *tLabel;
    UILabel *tTitleLabel;
    UILabel *pTitleLabel;
    UILabel *stopTitleLabel;
    UILabel *stopInfoLabel;
    
    BOOL isStopFlight;                  // 标志是否是经停航班
}

@property (nonatomic, retain) UIImageView *iconImgView;
@property (nonatomic, retain) UILabel *airlinesLabel;
@property (nonatomic, retain) UILabel *departTimeLabel;
@property (nonatomic, retain) UILabel *arrivalTimeLabel;
@property (nonatomic, retain) UILabel *planeTypeLabel;
@property (nonatomic, readonly) NSInteger cellTotalHeight;    // cell加上退改签的高度

@property (nonatomic, assign) BOOL hasReturned;
@property (nonatomic, retain) UILabel *flightTypeLabel;
@property (nonatomic, retain) UILabel *departureAirportLabel;
@property (nonatomic, retain) UILabel *arrivalAirportLabel;
@property (nonatomic, retain) UIView *whiteView;

- (void)setStopRelatedHidden:(BOOL)hidden;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier returned:(BOOL)returned;

- (void)setTerminal:(NSString *)terminalName;       // 设置航站楼
- (void)setStopInfo:(NSString *)stopInfo;           // 设置经停信息

@end

