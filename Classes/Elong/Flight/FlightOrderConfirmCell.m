//
//  FlightOrderConfirmCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-2-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightOrderConfirmCell.h"
#import "FillFlightOrder.h"
#import "FlightDataDefine.h"
#import "Utils.h"

#define FIXEDHEIGHT 133
#define kSingleTripCellHeight  (34.0f + 88.0f)
#define kRoundTripCellHeight   (28.0f + 88.0f)

@implementation FlightOrderConfirmCell

@synthesize iconImgView;
@synthesize airlinesLabel;
@synthesize departTimeLabel;
@synthesize arrivalTimeLabel;
@synthesize planeTypeLabel;
@synthesize cellTotalHeight;


- (void)dealloc {
    self.flightTypeLabel = nil;
    self.whiteView = nil;
    self.departureAirportLabel = nil;
    self.arrivalAirportLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier returned:(BOOL)returned
{
    self.hasReturned = returned;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (_hasReturned) {
            cellTotalHeight = kRoundTripCellHeight;
        }
        else {
            cellTotalHeight = kSingleTripCellHeight;
        }
        
        self.backgroundColor = [UIColor clearColor];
        if (_hasReturned) {
            iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 28.0f)];
        }
        else {
            iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, 22.0f, 22.0f)];
        }
        [self addSubview:iconImgView];
        [iconImgView release];
        
        if (_hasReturned) {
            airlinesLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0f, 3.0f, 200.0f, 23.0f)];
        }
        else {
            airlinesLabel = [[UILabel alloc] initWithFrame:CGRectMake(34.0f, 0.0f, 200.0f, 34.0f)];
        }
        airlinesLabel.backgroundColor   = [UIColor clearColor];
        airlinesLabel.textColor         = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:1.0f];
        airlinesLabel.font              = [UIFont fontWithName:@"HelveticaNeue" size:16.0];;
        airlinesLabel.minimumFontSize   = 10;
        airlinesLabel.textAlignment = NSTextAlignmentLeft;
        airlinesLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:airlinesLabel];
        [airlinesLabel release];
        
        UILabel *tempLabel;
        if (_hasReturned) {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(315.0f - 122.0f, 3.0f, 122.0f, CGRectGetHeight(airlinesLabel.frame))];
        }
        else {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(315.0f - 122.0f, 0.0f, 122.0f, CGRectGetHeight(airlinesLabel.frame))];
        }
        
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.textColor = [UIColor colorWithRed:52.0f / 255 green:52.0f / 255 blue:52.0f / 255 alpha:1.0f];
        tempLabel.font = FONT_14;
        tempLabel.textAlignment = NSTextAlignmentRight;
        self.flightTypeLabel = tempLabel;
        [self addSubview:tempLabel];
        [tempLabel release];
        
        // White color background.
        UIView *whiteColorBackground;
        if (_hasReturned) {
            whiteColorBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 28.0f, 320.0f, 88.0f)];
        }
        else {
            whiteColorBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 34.0f, 320.0f, 88.0f)];
        }
        
        whiteColorBackground.backgroundColor = [UIColor whiteColor];
        self.whiteView = whiteColorBackground;
        [self addSubview:whiteColorBackground];
        [whiteColorBackground release];
        
        
        UILabel *departTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 12.0f, 70.0f, 22.0f)];
        departTitleLabel.backgroundColor    = [UIColor clearColor];
        departTitleLabel.text               = @"起飞时间: ";
        departTitleLabel.textAlignment = NSTextAlignmentLeft;
        departTitleLabel.textColor          = [UIColor colorWithRed:52.0f / 255 green:52.0f / 255 blue:52.0f / 255 alpha:1.0f];
        departTitleLabel.font               = FONT_14;
        [_whiteView addSubview:departTitleLabel];
        

        departTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(departTitleLabel.frame) + CGRectGetWidth(departTitleLabel.frame), 12.0f, 100.0f, 22.0f)];
        departTimeLabel.backgroundColor    = [UIColor clearColor];
        departTimeLabel.textColor          = [UIColor blackColor];
        departTimeLabel.font               = FONT_B16;
        departTimeLabel.minimumFontSize    = 12;
        departTimeLabel.adjustsFontSizeToFitWidth = YES;
        [_whiteView addSubview:departTimeLabel];
        
        tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(departTimeLabel.frame) + CGRectGetWidth(departTimeLabel.frame), 12.0f, 100.0f, 22.0f)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.font = FONT_15;
        tempLabel.textColor = [UIColor colorWithRed:52.0f / 255 green:52.0f / 255 blue:52.0f / 255 alpha:1.0f];
        self.departureAirportLabel = tempLabel;
        [_whiteView addSubview:_departureAirportLabel];
        [tempLabel release];
        
        [departTitleLabel release];
        [departTimeLabel release];
        
        arriveTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 34.0f, 70.0f, 22.0f)];
        arriveTitleLabel.backgroundColor    = [UIColor clearColor];
        arriveTitleLabel.text               = @"降落时间: ";
        arriveTitleLabel.textAlignment = NSTextAlignmentLeft;
        arriveTitleLabel.textColor          = [UIColor colorWithRed:93.0f / 255 green:93.0f / 255 blue:93.0f / 255 alpha:1.0f];
        arriveTitleLabel.font               = FONT_14;
        [_whiteView addSubview:arriveTitleLabel];
        [arriveTitleLabel release];
        
        arrivalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(arriveTitleLabel.frame) + CGRectGetWidth(arriveTitleLabel.frame), CGRectGetMinY(arriveTitleLabel.frame), 100.0f, 22.0f)];
        arrivalTimeLabel.backgroundColor    = [UIColor clearColor];
        arrivalTimeLabel.textColor          = [UIColor blackColor];
        arrivalTimeLabel.font               = FONT_B16;
        arrivalTimeLabel.adjustsFontSizeToFitWidth = YES;
        arrivalTimeLabel.minimumFontSize    = 12;
        [_whiteView addSubview:arrivalTimeLabel];
        [arrivalTimeLabel release];
        
        tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(arrivalTimeLabel.frame) + CGRectGetWidth(arrivalTimeLabel.frame), CGRectGetMinY(arrivalTimeLabel.frame), 100.0f, 22.0f)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.font = FONT_15;
        tempLabel.textColor = [UIColor colorWithRed:52.0f / 255 green:52.0f / 255 blue:52.0f / 255 alpha:1.0f];
        self.arrivalAirportLabel = tempLabel;
        [_whiteView addSubview:_arrivalAirportLabel];
        [tempLabel release];
        
        // 经停信息
        stopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, CGRectGetHeight(arriveTitleLabel.frame) + CGRectGetMinY(arriveTitleLabel.frame), 70.0f, 22.0f)];
        stopTitleLabel.backgroundColor    = [UIColor clearColor];
        stopTitleLabel.text               = @"经   停:";
        stopTitleLabel.textColor          = COLOR_NAV_TITLE;
        stopTitleLabel.font               = FONT_14;
        [_whiteView addSubview:stopTitleLabel];
        [stopTitleLabel release];
        
        stopInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(stopTitleLabel.frame) + CGRectGetWidth(stopTitleLabel.frame), CGRectGetHeight(stopTitleLabel.frame), 224, 22.0f)];
        stopInfoLabel.backgroundColor    = [UIColor clearColor];
        stopInfoLabel.textColor          = COLOR_NAV_TITLE;
        stopInfoLabel.font               = FONT_B16;
        stopInfoLabel.adjustsFontSizeToFitWidth = YES;
        stopInfoLabel.minimumFontSize    = 12;
        [_whiteView addSubview:stopInfoLabel];
        [stopInfoLabel release];
//
//        tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 82, 54, 22)];
//        tTitleLabel.backgroundColor    = [UIColor clearColor];
//        tTitleLabel.text               = @"登   机:";
//        tTitleLabel.textColor          = [UIColor blackColor];
//        tTitleLabel.font               = FONT_16;
//        [self addSubview:tTitleLabel];
//        [tTitleLabel release];
//        
//        tLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 82, 224, 22)];
//        tLabel.backgroundColor    = [UIColor clearColor];
//        tLabel.textColor          = [UIColor blackColor];
//        tLabel.font               = FONT_B16;
//        tLabel.adjustsFontSizeToFitWidth = YES;
//        tLabel.minimumFontSize    = 12;
//        [self addSubview:tLabel];
//        [tLabel release];
//        
//        pTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 103, 54, 22)];
//        pTitleLabel.backgroundColor    = [UIColor clearColor];
//        pTitleLabel.text               = @"机   型:";
//        pTitleLabel.textColor          = [UIColor blackColor];
//        pTitleLabel.font               = FONT_16;
//        [self addSubview:pTitleLabel];
//        [pTitleLabel release];
//        
//        planeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 103, 224, 22)];
//        planeTypeLabel.backgroundColor    = [UIColor clearColor];
//        planeTypeLabel.textColor          = [UIColor blackColor];
//        planeTypeLabel.font               = FONT_B16;
//        planeTypeLabel.adjustsFontSizeToFitWidth = YES;
//        planeTypeLabel.minimumFontSize    = 12;
//        [self addSubview:planeTypeLabel];
//        [planeTypeLabel release];
        
        UIImageView *cellLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0, 320.0f, SCREEN_SCALE)];
        cellLineView.image = [UIImage imageNamed:@"dashed.png"];
        [_whiteView addSubview:cellLineView];
        [cellLineView release];
        
        cellLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(_whiteView.frame) - SCREEN_SCALE, 320.0f, SCREEN_SCALE)];
        cellLineView.image = [UIImage imageNamed:@"dashed.png"];
        [_whiteView addSubview:cellLineView];
        [cellLineView release];
//        
        self.clipsToBounds = YES;
        isStopFlight = NO;
    }
    
    return self;
}

- (void)setStopRelatedHidden:(BOOL)hidden
{
    stopTitleLabel.hidden = hidden;
    stopInfoLabel.hidden = hidden;
}


- (void)setTerminal:(NSString *)terminalName {
    if (STRINGHASVALUE(terminalName)) {
        tLabel.text = terminalName;
        tTitleLabel.hidden = NO;
        
        if (isStopFlight) {
            // 经停有航站楼布局
            arriveTitleLabel.frame  = CGRectMake(41, 81, 54, 22);
            arrivalTimeLabel.frame  = CGRectMake(103, 81, 224, 22);
            tTitleLabel.frame       = CGRectMake(41, 103, 54, 22);
            tLabel.frame            = CGRectMake(103, 103, 224, 22);
            pTitleLabel.frame       = CGRectMake(41, 124, 54, 22);
            planeTypeLabel.frame    = CGRectMake(103, 124, 224, 22);
            
            cellTotalHeight = FIXEDHEIGHT + 21;
        }
        else {
            // 无经停有航站楼布局
            arriveTitleLabel.frame  = CGRectMake(41, 60, 54, 22);
            arrivalTimeLabel.frame  = CGRectMake(103, 60, 224, 22);
            tTitleLabel.frame       = CGRectMake(41, 81, 54, 22);
            tLabel.frame            = CGRectMake(103, 81, 224, 22);
            pTitleLabel.frame       = CGRectMake(41, 103, 54, 22);
            planeTypeLabel.frame    = CGRectMake(103, 103, 224, 22);
            
            cellTotalHeight = FIXEDHEIGHT;
        }
    }
    else {
        tLabel.text = @"";
        tTitleLabel.hidden = YES;
        
        if (isStopFlight) {
            // 经停无航站楼布局
            arriveTitleLabel.frame  = CGRectMake(41, 81, 54, 22);
            arrivalTimeLabel.frame  = CGRectMake(103, 81, 224, 22);
            pTitleLabel.frame       = CGRectMake(41, 103, 54, 22);
            planeTypeLabel.frame    = CGRectMake(103, 103, 224, 22);
            
            cellTotalHeight = FIXEDHEIGHT;
        }
        else {
            // 无经停无航站楼布局
            arriveTitleLabel.frame  = CGRectMake(41, 60, 54, 22);
            arrivalTimeLabel.frame  = CGRectMake(103, 60, 224, 22);
            pTitleLabel.frame       = CGRectMake(41, 81, 54, 22);
            planeTypeLabel.frame    = CGRectMake(103, 81, 224, 22);
            
            cellTotalHeight = FIXEDHEIGHT - 21;
        }
    }
}


- (void)setStopInfo:(NSString *)stopInfo {
    if (STRINGHASVALUE(stopInfo)) {
        if ([stopInfo hasPrefix:@"null"] || [stopInfo hasPrefix:@"(null)"]) {
            stopInfoLabel.text = @"--";
        }
        else {
            stopInfoLabel.text = stopInfo;
        }
        
        isStopFlight = YES;
        stopInfoLabel.hidden = NO;
        stopTitleLabel.hidden = NO;
    }
    else {
        isStopFlight = NO;
        stopInfoLabel.hidden = YES;
        stopTitleLabel.hidden = YES;
    }
}

@end
