//
//  FlightOrderConfirmTableCell.m
//  ElongClient
//
//  Created by 赵 海波 on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderConfirmTableCell.h"
#import "Flight.h"
#import "FlightRulePopView.h"

@implementation FlightOrderConfirmTableCell


+ (id)cellFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightOrderConfirmTableCell" owner:self options:nil];
    
    FlightOrderConfirmTableCell *cell = nil;
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[FlightOrderConfirmTableCell class]])
        {
            cell = (FlightOrderConfirmTableCell *)oneObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isReturnFlight = NO;
        }
    }
    
    return cell;
}


- (void)awakeFromNib
{
    // 添加一条分割线
    [self.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(14, self.contentView.frame.size.height - SCREEN_SCALE, 320, SCREEN_SCALE)]];
}


- (IBAction)clickRuleButton
{
    Flight *flight = nil;
    
    if (_isReturnFlight)
    {
        // 如果是返程航班，显示返程退改签
        int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 &&
            [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil)
        {
			flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
        }
    }
    else
    {
        // 显示去程退改签
        int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
        if ([[FlightData getFArrayGo] count] > 0 &&
            [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil)
        {
            // 第一行
            flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
        }
    }
    
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    FlightRulePopView *popView = [[FlightRulePopView alloc] initWithReturnRegulation:flight.returnRule
                                                                    changeRegulation:flight.changeRule
                                                                            signRule:flight.signRule];
    [window addSubview:popView];
    [popView release];
    
    
    UMENG_EVENT(UEvent_Flight_FillOrder_InsuranceTips)
}

@end
