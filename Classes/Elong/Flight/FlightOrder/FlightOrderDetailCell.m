//
//  FlightOrderDetailCell.m
//  ElongClient
//
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderDetailCell.h"
#import "FlightOrderDetail.h"
#import "FunctionUtils.h"
#import "FlightOrderHistoryDetailRestrictionViewController.h"

#define OrderRelated @"OrderRelated"
#define FlightRelated @"FlightRelated"

@implementation FlightOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    
    if (self.FlightDateAndAirline) {
        self.FlightDateAndAirline.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    }
    
    self.clipsToBounds = YES;
    
    _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_bottomLineImgView];
    
    if (self.passenger) {
        self.passenger.adjustsFontSizeToFitWidth = YES;
    }
    
    [_chooseSeatBtn setBackgroundImage:[UIImage imageNamed:@"hotelOderList_blueBtnBg_normal.png"] forState:UIControlStateNormal];
    [_chooseSeatBtn setBackgroundImage:[UIImage imageNamed:@"hotelOderList_blueBtnBg_selected.png"] forState:UIControlStateHighlighted];
}

- (IBAction)tapAndGoRuels:(id)sender {

    NSString *returnRegulate = self.airInfo.ReturnRegulate;
    NSString *changeRegulate = self.airInfo.ChangeRegulate;
    NSString *SignRule = self.airInfo.SignRule;
    if(returnRegulate.length==0){
        returnRegulate = @"无信息";
    }
    if(changeRegulate.length==0){
        changeRegulate = @"无信息";
    }
    if (SignRule.length==0) {
        SignRule = @"无信息";
    }
    
    FlightOrderHistoryDetailRestrictionViewController *restrictionInfo =[[FlightOrderHistoryDetailRestrictionViewController alloc]init];
    [restrictionInfo fillContentWithReturnContent:returnRegulate andChangeContent:changeRegulate andSignRule:SignRule];
    UINavigationController   *nav = ((UIViewController *)_delegate).navigationController;
    [nav pushViewController:restrictionInfo animated:YES];
    [restrictionInfo release];
    
}

- (IBAction)chooseSeatsAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(gotoTheChooseSeatsViewController)]) {
        [_delegate gotoTheChooseSeatsViewController];
    }
}
-(void)bindTheDisplayOrder:(FlightOrderDetail *)model{
    
        self.OrderNum.text = model.OrderNo;
        self.OrderTime.text = [TimeUtils displayDateWithNSDate:[TimeUtils parseJsonDate:model.CreateTime] formatter:@"yyyy-MM-dd"];
        self.OrderTotalMoney.text = [NSString stringWithFormat:@"%.2f",model.PriceInfo.OrderPrice];
        self.FlightMoney.text = [NSString stringWithFormat:@"￥%.2f",model.PriceInfo.TicketPrice];
        self.ServiceFee.text = [NSString stringWithFormat:@"￥%.2f",model.PriceInfo.ServicePrice];
        self.InsuranceMoney.text = [NSString stringWithFormat:@"￥%d",(int)model.PriceInfo.InsurancePrice];
        self.AirportFee.text = [NSString stringWithFormat:@"￥%d",(int)model.PriceInfo.TaxPrice];
    
    // 邮寄信息
    NSString *distributionPerson =  model.DistributionInfo.DistributionPerson;
    if (!STRINGHASVALUE(distributionPerson))
    {
        distributionPerson = @"";
    }
    NSString *distributionAddress = model.DistributionInfo.DistributionAddress;
    if (!STRINGHASVALUE(distributionAddress))
    {
        distributionAddress = @"";
    }
    NSString *distributionPostcode = model.DistributionInfo.DistributionPostcode;
    if (!STRINGHASVALUE(distributionPostcode))
    {
        distributionPostcode = @"";
    }
    NSString *distributionInfoText = [NSString stringWithFormat:@"%@/%@/%@",distributionPerson,distributionAddress,distributionPostcode];
    
   self.OrderPostAddress.text = distributionInfoText;
}

-(void)bindTheDisplayModelOfTicketsRelated:(TicketInfo *)ticketInfo andFlyType:(NSString *)type{

    AirLineInfo *info = [ticketInfo.AirLineInfos objectAtIndex:0];
    
    self.airInfo = info;
    
    
    NSString *startTime = [TimeUtils displayDateWithNSDate:[TimeUtils parseJsonDate:info.DepartDate] formatter:@"yyyy-MM-dd"];
    
    if (STRINGHASVALUE(type)) {
        self.TypeIcon.hidden = NO;
        self.FlightDateAndAirline.text = [[[NSString stringWithFormat:@"          %@",startTime] stringByAppendingString:info.AirCorpName] stringByAppendingString:info.FlightNumber];
    }else{
        self.TypeIcon.hidden = YES;
        self.FlightDateAndAirline.text = [[[NSString stringWithFormat:@"  %@",startTime] stringByAppendingString:info.AirCorpName] stringByAppendingString:info.FlightNumber];
    }
    self.FlightType.textColor = [UIColor whiteColor];
    self.FlightType.text = type;

    self.FlightStatus.text = ticketInfo.TicketStatusName;
    
    if([@"出票成功" isEqualToString:ticketInfo.TicketStatusName]){
        self.FlightStatus.textColor = RGBACOLOR(20, 157, 52, 1);
    }else{
        self.FlightStatus.textColor = [UIColor blackColor];
    }
    self.FlightStartTime.text = [TimeUtils displayDateWithNSDate:[TimeUtils parseJsonDate:info.DepartDate] formatter:@"HH:mm"];
    self.FlightStartAirport.text = info.DepartAirPort;
    self.FlightEndTime.text = [TimeUtils displayDateWithNSDate:[TimeUtils parseJsonDate:info.ArrivalDate] formatter:@"HH:mm"];
    self.FlightEndAirport.text = info.ArrivalAirPort;
    self.FlightCabin.text = info.Cabin;
}

//fix by lc
//isBackandForth 0 是单程 1是往返 passengerCount 订票人数
-(void)bindTheDisplayModelOfPassenger:(PassengerTiketInfo *)passenger isBackandForth:(BOOL)isBackandForth cellrow:(int)cellrow passengerCount:(int)passengerCount{
    
    self.PassengerName.text = passenger.PassengerInfo.Name;
    NSString *identifierType = [Utils getCertificateName:[passenger.PassengerInfo.CertificateType intValue]];
    //若是身份证，隐藏后四位
    NSString *num = passenger.PassengerInfo.CertificateNumber;
    
    if ([passenger.PassengerInfo.CertificateType intValue] ==0 && [passenger.PassengerInfo.CertificateNumber length] > 4)
    {
        num = [num stringByReplaceWithAsteriskFromIndex:[num length]-4];
    }
    self.IdentifierAndNum.text = [identifierType stringByAppendingFormat:@"/%@",num];
    
    
    //保险分数
    int  InsuranceCount = passenger.InsuranceInfo.InsuranceCount;
    self.HasInsurance.text = [NSString stringWithFormat:@"保险%d份",InsuranceCount];
    
    //退定按钮
    if (isBackandForth) {  //1是往返
        self.refund.hidden = YES;
        NSArray *tiketsArray=[passenger Tickets];
        TicketInfo *goTiketInfo=[tiketsArray safeObjectAtIndex:0];  //去程
        if (goTiketInfo!=nil) {
            if (goTiketInfo.isAllowRefund) {
                
                if (goTiketInfo.isAlreadyRefund) {  //暂时添加 解决在线退订点过的事件
                    [self currentBTN:self.refundgo isalreadyRefund:YES isfetch:YES currentTag:0];
                }else{
                    [self currentBTN:self.refundgo isalreadyRefund:NO isfetch:YES currentTag:0];
                }
//                self.refundgo.hidden = NO;
            }else{
                self.refundgo.hidden = YES;
            }
        }
        TicketInfo *backTiketInfo=[tiketsArray safeObjectAtIndex:1];
        if (backTiketInfo!=nil) {
            if (backTiketInfo.isAllowRefund) {
                
                if (backTiketInfo.isAlreadyRefund) {  //暂时添加 解决在线退订点过的事件
                    [self currentBTN:self.refundback isalreadyRefund:YES isfetch:YES currentTag:1];
                }else{
                    [self currentBTN:self.refundback isalreadyRefund:NO isfetch:YES currentTag:1];
                }
//                self.refundback.hidden = NO;
            }else{
                self.refundback.hidden = YES;
            }
        }
        
    }else{//0是单程
        self.refundback.hidden = YES;
        self.refundgo.hidden = YES;
        NSArray *tiketsArray=[passenger Tickets];
        TicketInfo *oneTiketInfo=[tiketsArray safeObjectAtIndex:0];
        if (oneTiketInfo!=nil) {
            if (oneTiketInfo.isAllowRefund) {
                
                if (oneTiketInfo.isAlreadyRefund) {  //暂时添加 解决在线退订点过的事件
                    [self currentBTN:self.refund isalreadyRefund:YES isfetch:NO currentTag:0];
                }else{
                    [self currentBTN:self.refund isalreadyRefund:NO isfetch:NO currentTag:0];
                }
                
//                self.refund.hidden = NO;
            }else{
                self.refund.hidden = YES;
            }
        }
    }

    //线
    if (passengerCount==1) {  //一个乘客
        self.topLineImgView.frame = CGRectMake(0, 0, 320, SCREEN_SCALE);
        self.bottomLineImgView.frame = CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320-80, SCREEN_SCALE);
    }else if (passengerCount>=1){ //大于一个乘客
        
        if (cellrow==0) {  //第一个
            self.topLineImgView.frame = CGRectMake(0, 0, 320, SCREEN_SCALE);
            self.bottomLineImgView.hidden =YES;
//            self.bottomLineImgView.frame = CGRectMake(80, self.bounds.size.height-SCREEN_SCALE, 320-80, SCREEN_SCALE);
        }else if (cellrow>=1&&cellrow<(passengerCount-1)){
            self.topLineImgView.frame = CGRectMake(80, 0, 320, SCREEN_SCALE);
//            self.bottomLineImgView.frame = CGRectMake(80, self.bounds.size.height-SCREEN_SCALE, 320-80, SCREEN_SCALE);
            self.bottomLineImgView.hidden =YES;
        }else if(cellrow==(passengerCount-1)){  //最后一个
            self.topLineImgView.frame = CGRectMake(80, 0, 320-80, SCREEN_SCALE);
//            self.bottomLineImgView.frame = CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE);
            self.bottomLineImgView.hidden =NO;
        }
        
    }else{
        
    }
}

//sender 当前按钮  是否已经申请退票 是否是往返 currentTag btn tag
-(void)currentBTN:(UIButton *)sender isalreadyRefund:(BOOL)isalreadyRefund isfetch:(BOOL)isfetch currentTag:(int)currentTag{
    
    if (isfetch) {  //往返
        
        if (currentTag==0) {  //去程
            
            if (isalreadyRefund) {  //已经退票了
                
                sender.enabled = NO;
                [sender setTitle:@"已申请去程退票" forState:UIControlStateNormal];
                sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                
            }else{  //没有退票
                sender.enabled = YES;
                [sender setTitle:@"申请去程退票" forState:UIControlStateNormal];
                sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
                [sender setBackgroundImage:[UIImage noCacheImageNamed:@"btn_billdetail_nomal.png"] forState:UIControlStateNormal];
            }
            
        }else if (currentTag==1){  //返程
            
            if (isalreadyRefund) {  //已经退票了
                
                sender.enabled = NO;
                [sender setTitle:@"已申请返程退票" forState:UIControlStateNormal];
                sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                
            }else{  //没有退票
                sender.enabled = YES;
                [sender setTitle:@"申请返程退票" forState:UIControlStateNormal];
                sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
                [sender setBackgroundImage:[UIImage noCacheImageNamed:@"btn_billdetail_nomal.png"] forState:UIControlStateNormal];
            }
            
            
        }
        
    }else{  //单程
        
        if (isalreadyRefund) {  //已经退票了
            
            sender.enabled = NO;
            [sender setTitle:@"已申请退票" forState:UIControlStateNormal];
            sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
            
        }else{  //没有退票
            sender.enabled = YES;
            [sender setTitle:@"申请退票" forState:UIControlStateNormal];
            sender.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [sender setBackgroundImage:[UIImage noCacheImageNamed:@"btn_billdetail_nomal.png"] forState:UIControlStateNormal];
        }
        
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_bottomLineImgView) {
        _bottomLineImgView.frame = CGRectMake(self.frame.origin.x, self.bounds.size.height-SCREEN_SCALE, self.frame.size.width, self.frame.size.height);
    }

}

#pragma mark -
#pragma mark 乘机人
//返程
//申请去程退票
-(IBAction)applygoTikets:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(orderDetailCellDelegate:refundgo:refundback:refund:actionBTN:)]) {
        [self.delegate orderDetailCellDelegate:self refundgo:YES refundback:NO refund:NO actionBTN:sender];
    }
    
}
//申请返程退票
-(IBAction)applybackTikets:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(orderDetailCellDelegate:refundgo:refundback:refund:actionBTN:)]) {
        [self.delegate orderDetailCellDelegate:self refundgo:NO refundback:YES refund:NO actionBTN:sender];
    }
    
}
//单程
//申请退票
-(IBAction)applysingelTikets:(id)sender{
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(orderDetailCellDelegate:refundgo:refundback:refund:actionBTN:)]) {
        [self.delegate orderDetailCellDelegate:self refundgo:NO refundback:NO refund:YES actionBTN:sender];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    setFree(_refund);
    setFree(_refundback);
    setFree(_refundgo);
    setFree(_topLineImgView);
    setFree(_bottomLineImgView);
    
    [_OrderPostAddress release];
    [_OrderNum release];
    [_OrderTime release];
    [_OrderTotalMoney release];
    [_FlightMoney release];
    [_InsuranceMoney release];
    [_AirportFee release];
    [_FlightType release];
    [_FlightDateAndAirline release];
    [_FlightStatus release];
    [_FlightStartTime release];
    [_FlightStartAirport release];
    [_FlightEndTime release];
    [_FlightEndAirport release];
    [_FlightCabin release];
    [_Ruels release];
    [_TypeIcon release];
    [_PassengerName release];
    [_IdentifierAndNum release];
    [_HasInsurance release];
    
    self.airInfo = nil;
    [_orderTip release];
    [_chooseSeatBtn release];
    [_activityIndicator release];
    [_passenger release];
    [_flight release];
    [_startToEnd release];
    [_seatStatus release];
    [_loadingView release];
    [super dealloc];
}
@end
