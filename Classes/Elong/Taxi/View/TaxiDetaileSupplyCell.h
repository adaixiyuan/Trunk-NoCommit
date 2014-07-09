//
//  TaxiDetaileOrderCell.h
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineCell.h"
#import "UIViewExt.h"
#import "TaxiSupply.h"
#import "TaxiListModel.h"
#import "TaxiDetaileModel.h"


@interface TaxiDetaileSupplyCell : LineCell

{
    
    
}
@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *dataLabel;
@property  (nonatomic,retain)  TaxiSupply  *model;
@property (retain, nonatomic) IBOutlet UIButton *partnerBt;
@property  (retain,nonatomic)  NSString  *userTime;
@property  (nonatomic,retain)  TaxiDetaileModel  *dModel;
@end
