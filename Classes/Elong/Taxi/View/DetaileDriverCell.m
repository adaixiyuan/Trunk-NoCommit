//
//  DetaileDriverCell.m
//  ElongClient
//
//  Created by nieyun on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DetaileDriverCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"

@implementation DetaileDriverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
     
    }
    return self;
}
- (void) awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.driverName.text = self.driverModel.driverName;
    self.driverNum.text = [NSString  stringWithFormat:@"%@",self.driverModel.taxiNo];
    self.driverTeleNum.text = self.driverModel.driverPhone;
//    [self.driverImage  setImageWithURL:[NSURL  URLWithString:self.driverModel.driverPhotoUrl]placeholderImage:[UIImage  noCacheImageNamed:@"elong-icon_siji.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_driverImage release];
    [_driverName release];
    [_driverNum release];
    [_driverTeleNum release];
    [_driverModel  release];
    [super dealloc];
}
- (IBAction)callDriver:(id)sender
{
  
   NSString  *phoneStr = [NSString  stringWithFormat:@"tel://%@",self.driverModel.driverPhone];
    NSLog(@"%@",phoneStr);
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:phoneStr]]) {
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        
        
    }else{
        if (self.cellType == DetaileDriverCellFromOrder) {
            UMENG_EVENT(UEvent_UserCenter_CarOrder_CallService)
        }else if(self.cellType == DetaileDriverCellFromSuccess){
            UMENG_EVENT(UEvent_Car_OrderSuccess_Call)
        }
    }
}


@end
