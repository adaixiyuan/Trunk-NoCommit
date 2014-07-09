//
//  RentCarInfoCell.h
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//
//租车订单详情的  订单信息

#import "LineCell.h"
#import "RentOrderDetailModel.h"

@class RentCarInfoCell;
@protocol RentCarInfoCellDelegatge <NSObject>

-(void)checktheInfoCell:(RentCarInfoCell *)cell;
-(void)cancelActionInfoCell:(RentCarInfoCell *)cell;
@end

@interface RentCarInfoCell : LineCell
@property(nonatomic,retain)RentOrderDetailModel *orderDetailModel;
@property(nonatomic,retain)IBOutlet UILabel *payCountLabel;
@property(nonatomic,retain)IBOutlet UILabel *payStatusLabel;
@property(nonatomic,retain)IBOutlet UILabel *payNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *payDateLabel;
@property(nonatomic,retain)IBOutlet UILabel *payProvidertLabel;

@property(nonatomic,retain)IBOutlet UIButton *sendBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,assign)id delegate;
-(IBAction)callDetail:(id)sender;
-(IBAction)cancelAction:(id)sender;
@end
