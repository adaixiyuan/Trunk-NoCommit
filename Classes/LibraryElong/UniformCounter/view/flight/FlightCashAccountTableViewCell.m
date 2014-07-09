//
//  FlightCashAccountTableViewCell.m
//  ElongClient
//
//  Created by 赵 海波 on 14-3-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightCashAccountTableViewCell.h"

@implementation FlightCashAccountTableViewCell

+ (id)cellFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightCashAccountTableViewCell" owner:self options:nil];
    
    FlightCashAccountTableViewCell *cell = nil;
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[FlightCashAccountTableViewCell class]])
        {
            cell = (FlightCashAccountTableViewCell *)oneObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isShowingDetail = NO;
        }
    }
    
    return cell;
}


- (IBAction)clickDetailBtn
{
    self.isShowingDetail = !_isShowingDetail;
    
    if (_isShowingDetail)
    {
        _arrowImgView.image = [UIImage noCacheImageNamed:@"arrow_up_big.png"];
    }
    else
    {
        _arrowImgView.image = [UIImage noCacheImageNamed:@"arrow_down_big.png"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FLIGHT_ORDER_DETAIL object:[NSNumber numberWithBool:_isShowingDetail]];
}

@end
