//
//  FlightFillOrderCell.m
//  ElongClient
//
//  Created by 赵 海波 on 14-1-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightFillOrderCell.h"

@implementation FlightFillOrderCell

+ (id)cellFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightFillOrderCell" owner:self options:nil];
    
    FlightFillOrderCell *cell = nil;
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[FlightFillOrderCell class]])
        {
            cell = (FlightFillOrderCell *)oneObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

@end
