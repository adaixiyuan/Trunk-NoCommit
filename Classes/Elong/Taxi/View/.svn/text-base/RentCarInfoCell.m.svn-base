//
//  RentCarInfoCell.m
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#define NOTIFICATIONHIDEBILLBTN @"NOTIFICATIONHIDEBILLBTN"  //取消订单按钮显示
#import "RentCarInfoCell.h"

@implementation RentCarInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fixbtnvisible) name:NOTIFICATIONHIDEBILLBTN object:nil];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.payCountLabel.text = [NSString stringWithFormat:@"%@",self.orderDetailModel.chargeAmount];
    self.payStatusLabel.text = self.orderDetailModel.orderStatusDesc;
    self.payNumLabel.text = self.orderDetailModel.orderId;
    self.payDateLabel.text = self.orderDetailModel.orderTime;
    self.payProvidertLabel.text = self.orderDetailModel.merchant;
    
    
    NSString *visible=self.orderDetailModel.isBillVisible;  // 是否显示账单详情
    NSString *cancel=self.orderDetailModel.canCancel;  //是否可以取消订单
    
    if ([@"1" isEqualToString:visible]) {  //异常情况显示只显示账单详情或者都是1的时候  靓智 14.3.25
        //显示账单详情
        self.cancelBtn.hidden = YES;
        self.sendBtn.hidden = NO;
    }else if ([@"1" isEqualToString:cancel]){
        //显示取消订单
        self.cancelBtn.hidden = NO;
        self.sendBtn.hidden = YES;
    }else{
        self.cancelBtn.hidden = YES;
        self.sendBtn.hidden = YES;
    }
    
    if ([@"5" isEqualToString:self.orderDetailModel.orderStatus]) {
        self.payStatusLabel.textColor =RGBACOLOR(111, 111, 111, 1);  //灰色
    }else{
        self.payStatusLabel.textColor = RGBACOLOR(20, 157, 52, 1);  //绿色
    }
}
//查看详情
-(IBAction)callDetail:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(checktheInfoCell:)]) {
        [self.delegate checktheInfoCell:self];
    }
}

-(IBAction)cancelAction:(id)sender{
 
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cancelActionInfoCell:)]) {
        [self.delegate cancelActionInfoCell:self];
    }
    
}
//notification hidden btn
-(void)fixbtnvisible{
    
    self.cancelBtn.hidden = YES;
    self.payStatusLabel.text = @"已取消";
    self.payStatusLabel.textColor = RGBACOLOR(111, 111, 111, 1);
}


-(void)dealloc{
    self.payCountLabel = nil;
    self.payStatusLabel = nil;
    self.payDateLabel = nil;
    self.payNumLabel = nil;
    self.payProvidertLabel = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
