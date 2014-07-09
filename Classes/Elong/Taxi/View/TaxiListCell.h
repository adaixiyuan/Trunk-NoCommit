//
//  TaxiListCell.h
//  ElongClient
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaxiListModel.h"

#import "LineCell.h"
@interface TaxiListCell : LineCell
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *taxiLabel;

@property (retain, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property  (nonatomic,retain)  TaxiListModel  *model;
@property (retain, nonatomic) IBOutlet UILabel *startLabel;
@property (retain, nonatomic) IBOutlet UILabel *endLabel;
@end
