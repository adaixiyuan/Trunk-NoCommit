//
//  DetaileDriverCell.h
//  ElongClient
//
//  Created by nieyun on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaxiResponseInfo.h"
#import "LineCell.h"

typedef enum {
    DetaileDriverCellFromOrder,
    DetaileDriverCellFromSuccess
}DetaileDriverCellType;

@interface DetaileDriverCell :LineCell
@property (retain, nonatomic) IBOutlet UIImageView *driverImage;
@property (retain, nonatomic) IBOutlet UILabel *driverName;
@property (retain, nonatomic) IBOutlet UILabel *driverNum;
@property (retain, nonatomic) IBOutlet UILabel *driverTeleNum;
@property (retain,nonatomic) TaxiResponseInfo  *driverModel;
@property (assign) DetaileDriverCellType cellType;

- (IBAction)callDriver:(id)sender;
@end
