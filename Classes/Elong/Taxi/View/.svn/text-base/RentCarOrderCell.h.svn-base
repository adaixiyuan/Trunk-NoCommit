//
//  RentCarOrderCell.h
//  ElongClient
//
//  Created by licheng on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@class RentCarOrderCell;
@protocol RentCarOrderCell_Delegate <NSObject>

-(void)continuePay:(RentCarOrderCell *)sender;

@end


@interface RentCarOrderCell : UITableViewCell

@property(nonatomic,assign)id<RentCarOrderCell_Delegate> delegate;

@property(nonatomic,retain)RentOrderModel *rentOrderModel;

@property(nonatomic,retain)UIImageView * topLineImgView;

@property(nonatomic,retain)UIImageView * bottomLineImgView;

@property(nonatomic,retain) IBOutlet UILabel *rentCartitle;

@property(nonatomic,retain) IBOutlet UILabel *userTime;

@property(nonatomic,retain) IBOutlet UILabel *rentCarStartPlace;
@property(nonatomic,retain) IBOutlet UILabel *rentCarEndPlace;

@property(nonatomic,retain) IBOutlet UILabel *orderStatus;

@property(nonatomic,retain) IBOutlet UIButton *continuePayBtn;

-(IBAction)continuePay:(id)sender;

@end


