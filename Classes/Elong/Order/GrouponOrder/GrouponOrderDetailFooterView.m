//
//  GrouponOrderDetailFooterView.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderDetailFooterView.h"

@interface GrouponOrderDetailFooterView ()

//券有效信息
@property (retain, nonatomic) IBOutlet UIImageView *quanInfoBgImgView;
@property (retain, nonatomic) IBOutlet UIView *lookAllQuanView;
@property (retain, nonatomic) IBOutlet UIButton *lookAllQuanButton;


@property (retain, nonatomic) IBOutlet UIView *quanInfoView;
@property (retain, nonatomic) IBOutlet UILabel *invoiceTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *invoiceDespLabel;
@property (retain, nonatomic) IBOutlet UILabel *availableTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *quanOrderInfoLabel;


//支付信息
@property (retain, nonatomic) IBOutlet UIView *payInfoView;
@property (retain, nonatomic) IBOutlet UIImageView *payBgImgView;
@property (retain, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *payDespLabel;
@property (retain, nonatomic) IBOutlet UIButton *goPayDetailButton;
@property (retain, nonatomic) UIImageView *dashedImgView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,copy) GrouponPayflowBlock payflowBlock;
@property (nonatomic,copy) LookAllQuansBlock lookAllQuansBlock;

@property (assign,nonatomic) BOOL isShowAllQuans;
@property (assign, nonatomic) int remainedShowQuans;    //剩余要展示的券

@property (nonatomic,retain) GrouponOrderDetailRequest *orderDetailRequest;

-(IBAction)goPayflow:(id)sender;        //查看支付流程
-(IBAction)showAllQuan:(id)sender;  //查看所有券

@end

@implementation GrouponOrderDetailFooterView

- (void)dealloc
{
    [_payStatusLabel release];
    [_payMoneyLabel release];
    [_payDespLabel release];
    [_goPayDetailButton release];
    [_payInfoView release];
    [_payBgImgView release];
    [_quanInfoBgImgView release];
    [_lookAllQuanButton release];
    [_invoiceTitleLabel release];
    [_availableTimeLabel release];
    [_quanOrderInfoLabel release];
    [_invoiceDespLabel release];
    [_dashedImgView release];
    
    [_payflowBlock release];
    [_lookAllQuansBlock release];
    [_lookAllQuanView release];
    [_quanInfoView release];
    
    [_activityIndicatorView release];
    [_orderDetailRequest release];
    [super dealloc];
}


-(void)awakeFromNib{
    //设置去支付透明化按钮的背景图
    [_goPayDetailButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [_goPayDetailButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
        
    //quanBg
    [_quanInfoBgImgView setImage:[UIImage stretchableImageWithPath:@"grouponOrderDetail_cellBg.png"]];
    //bottomBg
    [_payBgImgView setImage:[UIImage stretchableImageWithPath:@"grouponOrderDetail_headerWhiteBg.png"]];

    _dashedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 308, SCREEN_SCALE)];
    _dashedImgView.image = [UIImage stretchableImageWithPath:@"grouponOrderDetail_seperateline.png"];
    [self.payInfoView addSubview:_dashedImgView];

    self.isShowAllQuans = NO;
    
    _orderDetailRequest = [[GrouponOrderDetailRequest alloc] initWithDelegate:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setGrouponOrder:(NSDictionary *)grouponOrder{
    NSArray *quans = [grouponOrder safeObjectForKey:QUANS_GROUPON];
    NSDictionary *firstQuan = [quans safeObjectAtIndex:0];
    
    self.availableTimeLabel.text = @"";
    if(DICTIONARYHASVALUE(firstQuan)){
        NSString *startTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTSTARTTIME_GROUPON] formatter:@"yyyy年M月d日"];
        NSString *endTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTENDTIME_GROUPON] formatter:@"yyyy年M月d日"];
        
        self.availableTimeLabel.text = [NSString stringWithFormat:@"%@ — %@",startTimeStr,endTimeStr];
    }

    NSMutableString *reservationText = [NSMutableString stringWithString:@""];
    NSDictionary *reservationInfo = [grouponOrder safeObjectForKey:@"Reservation"];
    int aheadDays = [[reservationInfo safeObjectForKey:@"AheadDays"] intValue];
    if(aheadDays>0){
        [reservationText appendFormat:@"请至少提前%d天预订",aheadDays];
    }else{
        [reservationText appendFormat:@"请提前预订"];
    }
    
    NSString *notApplicableDate = [reservationInfo safeObjectForKey:@"NotApplicableDate"];
    if(STRINGHASVALUE(notApplicableDate)){
        [reservationText appendFormat:@",%@券不可用",notApplicableDate];
    }
    
    self.quanOrderInfoLabel.text = reservationText;
    
    //计算预约信息高度
    CGSize quanOrderInfoSize = [self.quanOrderInfoLabel.text sizeWithFont:self.quanOrderInfoLabel.font constrainedToSize:CGSizeMake(self.quanOrderInfoLabel.frame.size.width, INT_MAX)];
    int height = quanOrderInfoSize.height>21?quanOrderInfoSize.height+8:21;
    CGRect quanOrderLabelFrame = self.quanOrderInfoLabel.frame;
    quanOrderLabelFrame.size.height = height;
    self.quanOrderInfoLabel.frame = quanOrderLabelFrame;
    
    //设置发票详情的高度
    int y = self.quanOrderInfoLabel.frame.origin.y + self.quanOrderInfoLabel.frame.size.height + 6;
    self.invoiceTitleLabel.frame = CGRectMake(15, y, 69, 21);
    self.invoiceDespLabel.frame = CGRectMake(85, y, 227, 21);
    
    //设置发票详情容器的高度
    CGRect quanInfoView_Frame = self.quanInfoView.frame;
    quanInfoView_Frame.size.height = self.invoiceDespLabel.frame.origin.y + self.invoiceDespLabel.frame.size.height + 9;
    self.quanInfoView.frame = quanInfoView_Frame;
    
    //设置黄色背景颜色
    self.quanInfoBgImgView.frame = CGRectMake(5, 0, 310, self.quanInfoView.frame.size.height+self.quanInfoView.frame.origin.y);
    CGRect payInfoView_Frame = self.payInfoView.frame;
    payInfoView_Frame.origin.y = self.quanInfoBgImgView.frame.origin.y+ self.quanInfoBgImgView.frame.size.height;
    self.payInfoView.frame = payInfoView_Frame;
    
    int invoiceMode = [[grouponOrder safeObjectForKey:@"InvoiceMode"] intValue];
    if(invoiceMode==0){
        self.invoiceDespLabel.text = @"本单由酒店开发票";
    }else{
        self.invoiceDespLabel.text = @"本单由艺龙旅行网开发票";
    }

    self.remainedShowQuans = quans.count-1;
    NSString *title = [NSString stringWithFormat:@" 展开剩余%d张券",self.remainedShowQuans];
    [self.lookAllQuanButton setTitle:title forState:UIControlStateNormal];
    if(self.remainedShowQuans==0){
        //如果剩余0张，则隐藏这个提示
        self.lookAllQuanView.hidden = YES;
        
        CGRect quanInfoViewFrame = self.quanInfoView.frame;
        quanInfoViewFrame.origin.y = self.quanInfoView.frame.origin.y - self.lookAllQuanView.frame.size.height;;
        self.quanInfoView.frame = quanInfoViewFrame;
        
        self.quanInfoBgImgView.frame = CGRectMake(5, 0, 310, self.quanInfoView.frame.size.height+self.quanInfoView.frame.origin.y);
        
        CGRect payInfoViewFrame = self.payInfoView.frame;
        payInfoViewFrame.origin.y = self.payInfoView.frame.origin.y - self.lookAllQuanView.frame.size.height;
        self.payInfoView.frame = payInfoViewFrame;
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.payInfoView.frame.origin.y + self.payInfoView.frame.size.height);
    
    
    int payStatus = [[grouponOrder safeObjectForKey:@"GrouponPayStatus"] intValue];
    self.payStatusLabel.text = [self getPayStatusDespByStatus:payStatus];
    self.payMoneyLabel.text  = [NSString stringWithFormat:@"%.1lf元",[[grouponOrder safeObjectForKey:@"TotalPrice"] doubleValue]];
    
    self.payDespLabel.text = @"";
    
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    long long tradeNo = [[grouponOrder safeObjectForKey:@"TradeNo"] longLongValue];
    if(tradeNo == 0){
        self.payDespLabel.text = @"暂无支付方式信息";
    }else{
        [_orderDetailRequest startRequestForGetPayDespByOrder:grouponOrder];
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
}

//获取支付状态描述
-(NSString *)getPayStatusDespByStatus:(int)status{
    NSString *statusDesp = @"";
    switch (status) {
        case 0:
            statusDesp = @"未支付";
            break;
        case 1:
            statusDesp = @"已支付";
            break;
        case 2:
            statusDesp = @"支付失败";
            break;
        case 3:
            statusDesp = @"未退款";
            break;
        case 4:
            statusDesp = @"已退款";
            break;
        default:
            break;
    }
    return statusDesp;
}

-(void)setPayflowBlock:(GrouponPayflowBlock)payflowBlock{
    [_payflowBlock release];
    _payflowBlock = [payflowBlock copy];
}

-(void)setLookAllQuansBlock:(LookAllQuansBlock)lookAllQuansBlock{
    [_lookAllQuansBlock release];
    _lookAllQuansBlock = [lookAllQuansBlock copy];
}

//查看支付流程
-(IBAction)goPayflow:(id)sender{
    self.payflowBlock();
}

//展开 收起//查看所有券
-(IBAction)showAllQuan:(id)sender{
    self.isShowAllQuans = !self.isShowAllQuans;
    if(self.isShowAllQuans){
        [self.lookAllQuanButton setTitle:@"                 收起" forState:UIControlStateNormal];
    }else{
        NSString *title = [NSString stringWithFormat:@" 展开剩余%d张券",self.remainedShowQuans];
        [self.lookAllQuanButton setTitle:title forState:UIControlStateNormal];
    }
    
    self.lookAllQuansBlock(self.isShowAllQuans);
}

#pragma mark - GrouponOrderRequest Delegate
-(void)executeGetPayDespResult:(NSDictionary *)result{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    NSArray *details = [result safeObjectForKey:@"details"];
    if(!ARRAYHASVALUE(details)){
        self.payDespLabel.text = @"暂无支付方式信息";
    }else{
        NSMutableString *payDespString = [NSMutableString stringWithString:@""];
        for(NSDictionary *detail in details){
            int type = [[detail safeObjectForKey:@"type"] intValue];
            double price = [[detail safeObjectForKey:@"price"] doubleValue];
            NSString *payType = @"";
            if(type==3001){
                payType = @"现金账户扣款";
            }else if(type==3002){
                payType = @"信用卡扣款";
            }else if(type==3003){
                payType = @"第三方支付扣款";
            }
            
            [payDespString appendFormat:@"%@%.1lf元,",payType,price];
        }
        
        NSString *payDespText = [payDespString substringToIndex:payDespString.length-1];
        self.payDespLabel.text = payDespText;
    }
}

-(void)executeGetPayDespFailed{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    self.payDespLabel.text = @"暂无支付方式信息";
}

@end
