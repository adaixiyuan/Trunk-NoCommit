//
//  TaxiPayViewController.h
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongBaseViewController.h"

@interface TaxiPayViewController :ElongBaseViewController<UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *taxiTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *startPosirionLabel;

@property (retain, nonatomic) IBOutlet UILabel *endPositionLabel;
@property (retain, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (retain,nonatomic) NSString  *orderId;
@property (retain,nonatomic)NSDictionary  *orderDic;
@end
