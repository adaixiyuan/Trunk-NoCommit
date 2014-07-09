//
//  RentCarOrderCell.m
//  ElongClient
//
//  Created by licheng on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarOrderCell.h"

@implementation RentCarOrderCell

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
    UIImage *pressImg = [UIImage stretchableImageWithPath:@"common_btn_press.png"];
    self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:pressImg] autorelease];
    
    _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_bottomLineImgView];

}
//当cell改变都会调此方法 btn的背景色可以设在这里面
-(void)layoutSubviews{
    [super layoutSubviews];
    //设置删除按钮全部显示
    for (UIView *subview in self.subviews) {
        for (UIView *subview2 in subview.subviews) {
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                [subview bringSubviewToFront:subview2];
            }
        }
    }
    self.continuePayBtn.backgroundColor = RGBACOLOR(255, 165, 104, 1);
    
    NSString*title = [NSString stringWithFormat:@"%@%@-%@",self.rentOrderModel.cityName,self.rentOrderModel.productTypeName,self.rentOrderModel.carTypeName];
    self.rentCartitle.text = title;
    self.rentCarStartPlace.text = self.rentOrderModel.fromAddress;
    if (STRINGHASVALUE(self.rentOrderModel.toAddress)) {
        self.rentCarEndPlace.text = self.rentOrderModel.toAddress;
    }else{
        self.rentCarEndPlace.text = @"无";
    }
    self.userTime.text = self.rentOrderModel.useTime;
    
    self.orderStatus.text = self.rentOrderModel.orderStatusDesc;
    
    if ([@"1"isEqualToString:self.rentOrderModel.canContinuePay]) {  //可以继续支付
        self.continuePayBtn.hidden = NO;
    }else if([@"2"isEqualToString:self.rentOrderModel.canContinuePay]){  //不能继续支付
        self.continuePayBtn.hidden = YES;
    }
    
    if ([@"5" isEqualToString:self.rentOrderModel.orderStatus]) {
        self.orderStatus.textColor = RGBACOLOR(111, 111, 111, 1);  //灰色
    }else{
        self.orderStatus.textColor = RGBACOLOR(71, 159, 12, 1);  //绿色
    }
}

-(IBAction)continuePay:(id)sender{
 
    NSLog(@"aaaa");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(continuePay:)]) {
        [self.delegate continuePay:self];
    }
    
}

-(void)dealloc{
    
    setFree(_rentOrderModel);
    setFree(_userTime);
    setFree(_topLineImgView);
    setFree(_bottomLineImgView);
    setFree(_rentCarEndPlace);
    setFree(_rentCarStartPlace);
    setFree(_rentCartitle);
    setFree(_orderStatus);
    setFree(_continuePayBtn);
    
    
    [super dealloc];
}

@end
