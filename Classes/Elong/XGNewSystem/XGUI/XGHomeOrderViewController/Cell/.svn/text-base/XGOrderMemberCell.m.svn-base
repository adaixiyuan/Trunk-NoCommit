//
//  XGOrderMemberCell.m
//  ElongClient
//
//  Created by 李程 on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGOrderMemberCell.h"
#import "XGOrderModel.h"
@implementation XGOrderMemberCell

- (void)awakeFromNib
{

    [self setBtnImage];
    
    self.backgroundColor = [UIColor whiteColor];
    UIImage *pressImg = [UIImage stretchableImageWithPath:@"common_btn_press.png"];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:pressImg];
    
    self.topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    self.topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:self.topLineImgView];
    
    self.bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    self.bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:self.bottomLineImgView];

}

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
}

-(void)setBtnImage{
    
    
    [self.othersBTN setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_normal.png"] forState:UIControlStateNormal];
    [self.othersBTN setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_selected.png"] forState:UIControlStateHighlighted];
    [self.othersBTN setTitleColor:RGBACOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
    self.othersBTN.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [self.gohotelBTN setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_normal.png"] forState:UIControlStateNormal];
    [self.gohotelBTN setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_selected.png"] forState:UIControlStateHighlighted];
    [self.gohotelBTN setTitleColor:RGBACOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
    self.gohotelBTN.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
}

//给cell赋值
-(void)setProperty:(XGOrderModel *)orderModel{
    
    
    
    NSString *hotelName = orderModel.HotelName;    //酒店名称
    NSString *roomTypeName =orderModel.RoomTypeName;  //房型名称
//    NSString *currency = [currentHotelOrder safeObjectForKey:@"Currency"];  //货币符号
    NSString *currencyMark = @"";
//    if ([currency isEqualToString:@"HKD"]) {
//        currencyMark = @"HK$";
//    }
//    else if ([currency isEqualToString:@"RMB"]) {
        currencyMark = @"¥";
//    }
    
    
    
    NSString *orderPrice = [NSString stringWithFormat:@"%.0f",[orderModel.SumPrice doubleValue]];  //订单价格
    
    NSString *arriveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[orderModel.ArriveDate longLongValue]];
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:arriveString formatter:@"M月d日"]; //到店日期
    
    
    NSString *departString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[orderModel.LeaveDate longLongValue]];
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:departString formatter:@"M月d日"];      //离店日期
    
    
    NSString *orderStatus = STRINGHASVALUE(orderModel.StateName)?orderModel.StateName:@"暂无状态"; //订单状态
    
    
    //订单颜色
    UIColor *orderStatusColor;
    if([@"等待确认" isEqualToString:orderStatus] || [@"等待支付" isEqualToString:orderStatus] || [@"等待担保" isEqualToString:orderStatus] || [@"担保失败" isEqualToString:orderStatus] || [@"支付失败" isEqualToString:orderStatus] || [@"酒店拒绝订单" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(250, 51, 26, 1);
    }else if([@"已经确认" isEqualToString:orderStatus] || [@"已经入住" isEqualToString:orderStatus] || [@"已经离店" isEqualToString:orderStatus] || [@"等待核实入住" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(24, 134, 37, 1);
    }else{
        orderStatusColor = RGBACOLOR(117, 117, 117, 1);
    }
    

    //承诺时间  保留时间
    NSString *promiseTimeTip = orderModel.Tip;
    
    self.hotelNameLabel.text = hotelName;  //就点名
    self.roomNameLabel.text = roomTypeName;  //房型
    
    if ([orderModel.PayType intValue]==1) {
        self.orderStatusLabel.text = @"";
    }else{  //现付
        self.orderStatusLabel.text = orderStatus;  //状态
    }
    
    
    self.orderStatusLabel.textColor = orderStatusColor; //状态颜色
    self.priceInfoLabel.text =  [NSString stringWithFormat:@"%@%@",currencyMark,orderPrice];//订单价格信息
    
    self.checkInDateLabel.text = [NSString stringWithFormat:@"入：%@",arriveDateStr];  //入店时间
    self.departureDateLabel.text = [NSString stringWithFormat:@"离：%@",departDateStr];   //离店时间
    
    self.orderPromptLabel.hidden = YES;    //订单承诺时间 默认隐藏
    if(STRINGHASVALUE(promiseTimeTip)){
        self.orderPromptLabel.hidden = NO;
        self.orderPromptLabel.text = promiseTimeTip;
    }
    
    self.gohotelBTN.hidden = YES;
    self.othersBTN.hidden = YES;
    //两个BTN的展示
     //右边按钮字典
    if (orderModel.RightButton!=nil) {
        NSString *desc = orderModel.RightButton.Desc;
        NSNumber *tagnum  = orderModel.RightButton.Type;
        if (STRINGHASVALUE(desc)&&tagnum!=nil) {
            self.gohotelBTN.hidden = NO;
            self.gohotelBTN.tag = [tagnum intValue];
            [self.gohotelBTN setTitle:desc forState:UIControlStateNormal];
        }
    }
     //下面的按钮字典
    if (orderModel.BelowButton!=nil) {
        NSString *desc = orderModel.BelowButton.Desc;
        NSNumber *tagnum = orderModel.BelowButton.Type;
        if (STRINGHASVALUE(desc)&&tagnum!=nil) {
            self.othersBTN.hidden = NO;
            self.othersBTN.tag = [tagnum intValue];
            [self.othersBTN setTitle:desc forState:UIControlStateNormal];
        }
    }
}




//    订单状态拥有的操作 0:带我去酒店,1:再次预订,2：催确认,3：去支付,4：去担保, 5：入住反馈,6：    拒绝原因, 7：继续住,8:失败原因, 9:订单进度, 10:修改/取消, 11:联系酒店,12:点评酒店
//button 执行事件
-(IBAction)duoToHotelActions:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
//    NSLog(@"sel==%d",self.currentIndex);
    //第一个参数是状态  第二个参数是cell的index
    self.btnCellACtion(btn.tag,self.currentIndex);
    
}



////根据状态显示对应的按钮
//-(void)executeShowBtnByActions:(NSArray *)actions{
//    //    订单状态拥有的操作 0:带我去酒店,1:再次预订,2：催确认,3：去支付,4：去担保, 5：入住反馈,6：    拒绝原因, 7：继续住,8:失败原因, 9:订单进度, 10:修改/取消, 11:联系酒店,12:点评酒店
//
//
//    self.gohotelBTN.hidden = YES;
//    self.othersBTN.hidden = YES;
//
//    NSDictionary *actDict=[actions safeObjectAtIndex:0];  //第一版本取第一个
//    int actionId=[[actDict safeObjectForKey:@"ActionId"] integerValue];
//    if (actionId==0) {  //右边 带我去酒店按钮
//        if (actDict!=nil&&[actDict allKeys]) {
//            self.gohotelBTN.tag = actionId;
//            [self.gohotelBTN setTitle:[actDict safeObjectForKey:@"ActionName"] forState:UIControlStateNormal];
//
//        }
//
//    }
//
//    if (actDict!=nil&&[actDict allKeys]) {  //左下边按钮
//        self.othersBTN.hidden = NO;
//        self.othersBTN.tag = actionId;
//        [self.othersBTN setTitle:[actDict safeObjectForKey:@"ActionName"] forState:UIControlStateNormal];
//
//    }
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
