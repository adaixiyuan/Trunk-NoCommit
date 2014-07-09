//
//  GrouponOrderDetailHeaderView.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderDetailHeaderView.h"

@interface GrouponOrderDetailHeaderView ()

//订单信息
@property (retain, nonatomic) IBOutlet UIImageView *headerBgImgView;
@property (retain, nonatomic) IBOutlet UIButton *againBookingButton;
@property (retain, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (retain, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (retain, nonatomic) IBOutlet UIButton *againPayButton;
@property (retain, nonatomic) UIImageView *dashedImgView;

@property (nonatomic,copy) GoGrouponDetailBlock goGrouponDetailBlock;
@property (nonatomic,copy) GrouponOrderAgainPayBlock againPayBlock;

- (IBAction)goGrouponDetail:(id)sender;
-(IBAction)againPayGrouponOrder:(id)sender;

@end

@implementation GrouponOrderDetailHeaderView

- (void)dealloc
{
    [_hotelNameLabel release];
    [_orderNoLabel release];
    [_telphoneLabel release];
    [_againBookingButton release];
    [_againPayButton release];
    [_headerBgImgView release];
    [_dashedImgView release];
    [_goGrouponDetailBlock release];
    [_againPayBlock release];
    [super dealloc];
}


-(void)awakeFromNib{
    //设置againPayBtn的背景图
    [_againPayButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [_againPayButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    //设置againBookingBtn
    [_againBookingButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    
    //topBg
    [_headerBgImgView setImage:[UIImage stretchableImageWithPath:@"grouponOrderDetail_headerWhiteBg.png"]];
    
    _dashedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, self.bounds.size.height-SCREEN_SCALE, 308, SCREEN_SCALE)];
    _dashedImgView.image = [UIImage stretchableImageWithPath:@"grouponOrderDetail_seperateline.png"];
    [self addSubview:_dashedImgView];
    
}


-(void)setGrouponOrder:(NSDictionary *)grouponOrder{
    self.hotelNameLabel.text = [grouponOrder safeObjectForKey:PRODNAME_GROUPON];
    self.orderNoLabel.text = [NSString stringWithFormat:@"%d",[[grouponOrder safeObjectForKey:ORDERID_GROUPON] intValue]];
    self.telphoneLabel.text = [grouponOrder safeObjectForKey:MOBILE];
    BOOL isAllowContinuePay = [[grouponOrder safeObjectForKey:ISALLOWCONTINUEPAY] boolValue];
    self.againPayButton.hidden = !isAllowContinuePay;
}

-(void)setGoGrouponDetailBlock:(GoGrouponDetailBlock)goDetailBlock{
    [_goGrouponDetailBlock release];
    _goGrouponDetailBlock = [goDetailBlock copy];
}

-(void)setGrouponOrderAgainPayBlock:(GrouponOrderAgainPayBlock)againPayBlock{
    [_againPayBlock release];
    _againPayBlock = [againPayBlock copy];
}

-(IBAction)goGrouponDetail:(id)sender{
    self.goGrouponDetailBlock();
}

-(IBAction)againPayGrouponOrder:(id)sender{
    self.againPayBlock();
}



@end
