//
//  TaxiDetaileOrderCell.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiDetaileSupplyCell.h"
#import "PublicMethods.h"

@implementation TaxiDetaileSupplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.stateLabel.textColor = [UIColor colorWithRed:0.136 green:0.551 blue:0.213 alpha:1.000];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.partnerBt  addTarget:self action:@selector(callPartner) forControlEvents:UIControlEventTouchUpInside];
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    if ([self.model.partnerName  isEqualToString:@"滴滴"] || [self.model.partnerName  isEqualToString:@"嘀嘀"] ) {
        [self.partnerBt  setImage:[UIImage  imageNamed:@"diditaxi"] forState:UIControlStateNormal];
    }else
        [self.partnerBt  setImage:[UIImage  imageNamed:@"kuaiditaxi"] forState:UIControlStateNormal];
    self.stateLabel.text  = self.dModel.orderStatusDesc;
    self.orderNumLabel.text = self.dModel.orderId;
    self.orderNumLabel.adjustsFontSizeToFitWidth = YES;
    self.dataLabel.text = self.dModel.orderTime;
    
}

- (void) callPartner
{
    NSString  *phoneStr = [NSString  stringWithFormat:@"tel://%@",self.model.partnerKfTel];
    NSLog(@"%@",phoneStr);
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:phoneStr]]) {
        //[showAlertTitle:CANT_TEL_TIP Message:nil]
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
    }else{
        UMENG_EVENT(UEvent_UserCenter_CarOrder_CallDriver)
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
 
    [_model release];
    [_stateLabel release];
    [_orderNumLabel release];
    [_dataLabel release];
    [_partnerBt release];
    [_dModel release];
    [super dealloc];
}
@end
