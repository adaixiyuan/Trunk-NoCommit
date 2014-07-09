//
//  RentCarDriverInfoCell.m
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarDriverInfoCell.h"

@implementation RentCarDriverInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.driverName.text = self.orderDetailModel.driverName;
    self.driverCarNum.text = self.orderDetailModel.driverCarId;
    self.driverCarType.text = [NSString stringWithFormat:@"%@-%@",self.orderDetailModel.cartype,self.orderDetailModel.driverCarBrand];
    self.driverTeleNum.text = self.orderDetailModel.driverTel;
    [self.driverName sizeToFit];
    [self.driverCarNum setViewX:(self.driverName.right+3)];

}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (IBAction)callDriver:(id)sender{
    NSString *phoneStr = self.orderDetailModel.driverTel;
    if (STRINGHASVALUE(phoneStr)) {
        if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneStr]]]) {
            [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        }
    }
}

-(void)dealloc{
    setFree(_driverCarNum);
    setFree(_driverName);
    setFree(_driverTeleNum);
    setFree(_driverCarType);
    setFree(_driverImage);
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
