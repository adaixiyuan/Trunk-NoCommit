//
//  GrouponHistoryDetailCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponHistoryDetailCell.h"

@interface GrouponHistoryDetailCell ()

@property (retain, nonatomic) IBOutlet UIImageView *cellBgImgView;
@property (retain, nonatomic) IBOutlet UILabel *quanNoLabel;
@property (retain, nonatomic) IBOutlet UIButton *sendMsgButton;
@property (retain, nonatomic) IBOutlet UIButton *refundQuanButton;
@property (retain, nonatomic) IBOutlet UILabel *quanStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *passwordMarkLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusMarkLabel;

@property (nonatomic,copy) CancelQuanBlock cancelQuanBlock;
@property (nonatomic,copy) SendMessageBlck sendMessageBlock;

-(IBAction)cancelQuan:(id)sender;
-(IBAction)sendMessage:(id)sender;

@end

@implementation GrouponHistoryDetailCell

-(void)dealloc{
    [_passwordMarkLabel release];
    [_statusMarkLabel release];
    [_sendMsgButton release];
    [_refundQuanButton release];
    [_quanStatusLabel release];
    [_quanNoLabel release];
    [_cellBgImgView release];
    [_dashedlineImgView release];
    
    [_cancelQuanBlock release];
    [_sendMessageBlock release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    self.clipsToBounds = YES;

    [_sendMsgButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [_sendMsgButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    
    [_refundQuanButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_disable.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    
    //cell bg
    [_cellBgImgView setImage:[UIImage stretchableImageWithPath:@"grouponOrderDetail_cellBg.png"]];
    
    //dashedlineImgView
    _dashedlineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, self.bounds.size.height-SCREEN_SCALE, 308, SCREEN_SCALE)];
    _dashedlineImgView.image = [UIImage stretchableImageWithPath:@"grouponOrderDetail_dashedline.png"];
    [self addSubview:_dashedlineImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setQuanInfo:(NSDictionary *)quanDic canCancelCoupon:(BOOL)canCancelCoupon{


    self.quanNoLabel.text =  [quanDic safeObjectForKey:QUANCODE_GROUPON];
    int status = [[quanDic safeObjectForKey:STATUS] intValue];
    self.quanStatusLabel.text = [self getStatusDespByStatus:status];
    
    
    //默认隐藏掉退款提示
    self.passwordMarkLabel.hidden = YES;
    self.sendMsgButton.hidden = YES;
    self.refundQuanButton.hidden = YES;
    
    self.statusMarkLabel.frame = CGRectMake(15, 30, 69, 21);
    self.quanStatusLabel.frame = CGRectMake(85, 30, 166, 21);
    self.dashedlineImgView.frame = CGRectMake(6, 55-SCREEN_SCALE, 308, SCREEN_SCALE);
    
    //是否此券是否允许退券
    BOOL isRefundQuan = [[quanDic safeObjectForKey:ISALLOWREFUND] boolValue];
    if(isRefundQuan && canCancelCoupon){
        //如果能退款，再根据状态来处理
        if(status==0 || status == 2){
            //只有未使用和已过期情况下才会出现退券功能
            self.passwordMarkLabel.hidden = NO;
            self.sendMsgButton.hidden = NO;
            self.refundQuanButton.hidden = NO;
            self.statusMarkLabel.frame = CGRectMake(15, 56, 69, 21);
            self.quanStatusLabel.frame = CGRectMake(85, 56, 166, 21);
            self.dashedlineImgView.frame = CGRectMake(6, 80-SCREEN_SCALE, 308, SCREEN_SCALE);
        }
    }else{
        self.refundQuanButton.hidden = YES;
    }
    
}

//获取券状态描述
-(NSString *)getStatusDespByStatus:(int)status{
    NSString *statusDesp = @"";
    switch (status) {
        case -2:
            statusDesp = @"查无此券";
            break;
        case -1:
            statusDesp = @"待生效（暂不可用）";
            break;
        case 0:
            statusDesp = @"未使用";
            break;
        case 1:
            statusDesp = @"已使用";
            break;
        case 2:
            statusDesp = @"已过期";
            break;
        case 3:
            statusDesp = @"废除";
            break;
        case 4:
            statusDesp = @"全部";
            break;
        default:
            break;
    }
    return statusDesp;
}

-(void)setCancelQuanBlock:(CancelQuanBlock)cancelBlock{
    [_cancelQuanBlock release];
    _cancelQuanBlock = [cancelBlock copy];
}

-(void)setSendMessageBlck:(SendMessageBlck)sendMsgBlock{
    [_sendMessageBlock release];
    _sendMessageBlock = [sendMsgBlock copy];
}

-(IBAction)cancelQuan:(id)sender{
    self.cancelQuanBlock(self.tag-100);
}

-(IBAction)sendMessage:(id)sender{
    self.sendMessageBlock(self.tag - 100);
}

@end
