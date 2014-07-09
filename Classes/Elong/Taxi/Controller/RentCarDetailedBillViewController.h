//
//  RentCarDetailedBillViewController.h
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "RentCarOrderDetailBillModel.h"
@interface RentCarDetailedBillViewController : ElongBaseViewController

@property(nonatomic,retain)RentCarOrderDetailBillModel *detailBillModel;

@property(nonatomic,retain)IBOutlet UILabel *totoKiloLengthLabel;
@property(nonatomic,retain)IBOutlet UILabel *totoTimeLengthLabel;
@property (nonatomic,copy) NSString *orderStatus;
@property (nonatomic,copy) NSString *tipDes;
@end
