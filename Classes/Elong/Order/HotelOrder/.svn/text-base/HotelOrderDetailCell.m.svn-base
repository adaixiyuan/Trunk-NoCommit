//
//  HotelOrderDetailCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderDetailCell.h"

@implementation HotelOrderDetailCell

- (void)dealloc
{
    [_keyLabel  release];
    [_valueLabel release];
    [_key1Label release];
    [_value1Label release];

    [_telPhoneBtn release];
    [_lookInvoiceFlowBtn release];
    [_bottomLineImgView release];
    [_topLineImgView release];
    
    [_goHotelBtn release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    _telPhoneBtn.hidden = YES;
    _lookInvoiceFlowBtn.hidden = YES;
    _goHotelBtn.hidden = YES;
    
    _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_bottomLineImgView];
}

//点击电话按钮
-(IBAction)clickTelPhoneBtn:(id)sender{
    if([_delegate respondsToSelector:@selector(clickOrderDetailCell_TelPhoneBtn:)]){
        [_delegate clickOrderDetailCell_TelPhoneBtn:_telPhoneBtn];
    }
}

//点击查看发票流程按钮
-(IBAction)clickLookInvoiceFlowBtn:(id)sender{
    if([_delegate respondsToSelector:@selector(clickOrderDetailCell_LookInvoiceFlowBtn:)]){
        [_delegate clickOrderDetailCell_LookInvoiceFlowBtn:_lookInvoiceFlowBtn];
    }
}

//点击带我去酒店
-(IBAction)clickGoHotelBtn:(id)sender{
    if([_delegate respondsToSelector:@selector(clickOrderDetailCell_GoHotelBtn:)]){
        [_delegate clickOrderDetailCell_GoHotelBtn:_goHotelBtn];
    }
}


@end
