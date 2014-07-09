//
//  GrouponDetailMapAddressCell.h
//  ElongClient
//  团购详情地图地址预约(单店)
//  Created by garin on 14-5-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponDetailAppointmentCellDelegate.h"

@interface GrouponDetailMapAddressCell : UITableViewCell
{
    UIView *bgImageView;
    UILabel *addressLabel;
    UILabel *poiTipsLbl;   //距您
    UILabel *distanceLabel;  //公里
    
    UIImageView *mapIcon;
    UIButton *appointmentBtn;
    
    UIImageView *splitView;
    UIImageView *downSplitView;
}

@property (nonatomic,assign) id<GrouponDetailAppointmentCellDelegate> delegate;

- (void) setAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
