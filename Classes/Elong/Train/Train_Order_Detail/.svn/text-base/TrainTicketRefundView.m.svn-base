//
//  TrainTicketRefundView.m
//  ElongClient
//
//  Created by chenggong on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainTicketRefundView.h"
#import <QuartzCore/QuartzCore.h>
#import "TrainOrderDetailViewController.h"

@implementation TrainTicketRefundView

- (void)dealloc
{
    self.trainOrderDetailViewController = nil;
    self.markView = nil;
    self.ticketInfoView = nil;
    self.closeButton = nil;
    self.noticeLabel = nil;
    self.trainNumLabel = nil;
    self.daStation = nil;
    self.daDate = nil;
    self.seatNumLabel = nil;
    self.passengerDynamicLabel = nil;
    self.refundLabel = nil;
    self.feeLabel = nil;
    
    [super dealloc];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchedView = [touch view];
    if([touchedView isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithViewController:(TrainOrderDetailViewController *)viewController frame:(CGRect)frame
{
    self.trainOrderDetailViewController = viewController;
//    self = [super initWithFrame:frame];
    if (self = [super init]) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        // markview
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
        _markView.backgroundColor = [UIColor whiteColor];
        _markView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        [window addSubview:_markView];
        
        // Ticket info view.
        self.ticketInfoView = [[[UIView alloc] initWithFrame:frame] autorelease];
        _ticketInfoView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        _ticketInfoView.alpha = 0.0f;
        
        // Title.
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, 120.0f, 20.0f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.text = @"退票申请";
        [_ticketInfoView addSubview:titleLabel];
        [titleLabel release];
    
        // Ticket.
        UIView *ticketView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, frame.size.width, 145)];
        ticketView.backgroundColor = [UIColor whiteColor];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, frame.size.width, SCREEN_SCALE)]];
        
        UILabel *ticketNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        ticketNoteLabel.backgroundColor = [UIColor clearColor];
        ticketNoteLabel.textColor = [UIColor darkGrayColor];
        ticketNoteLabel.font = FONT_13;
        ticketNoteLabel.text = @"车票信息：";
        [ticketView addSubview:ticketNoteLabel];
        [ticketNoteLabel release];
        
        // Train number.
        UILabel *trainNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 10.0f, 50.0f, 20)];
        trainNumLabel.backgroundColor = [UIColor clearColor];
        trainNumLabel.font = FONT_13;
        trainNumLabel.text = @"";
        [ticketView addSubview:trainNumLabel];
        self.trainNumLabel = trainNumLabel;
        [trainNumLabel release];
        
        // Departure and arrival station.
        UILabel *daStation = [[UILabel alloc] initWithFrame:CGRectMake(140, 10.0f, frame.size.width-130-10, 20)];
        daStation.backgroundColor = [UIColor clearColor];
        daStation.font = FONT_13;
        daStation.text = @"";//[NSString stringWithFormat:@"(%@ - %@)", @"北京南站", @"上海虹桥"];
        [ticketView addSubview:daStation];
        self.daStation = daStation;
        [daStation release];
        
        // Departure and arrival date.
        UILabel *daDate = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 30.0f, frame.size.width-90-10, 20)];
        daDate.backgroundColor = [UIColor clearColor];
        daDate.font = FONT_13;
        daDate.text = [NSString stringWithFormat:@"%@ - %@", @"", @""];
        [ticketView addSubview:daDate];
        self.daDate = daDate;
        [daDate release];
        
        // Seat number.
        UILabel *seatNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 50, frame.size.width-90-10, 20)];
        seatNumLabel.backgroundColor = [UIColor clearColor];
        seatNumLabel.font = FONT_13;
        seatNumLabel.textColor = RGBACOLOR(77, 166, 90, 1);
        seatNumLabel.text = @"";
        [ticketView addSubview:seatNumLabel];
        self.seatNumLabel = seatNumLabel;
        [seatNumLabel release];
        
        // Refund money description.
        UILabel *refundNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 80, 20)];
        refundNoteLabel.backgroundColor = [UIColor clearColor];
        refundNoteLabel.textColor = [UIColor darkGrayColor];
        refundNoteLabel.font = FONT_13;
        refundNoteLabel.text = @"可退金额：";
        [ticketView addSubview:refundNoteLabel];
        [refundNoteLabel release];
        
        UILabel *refundMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 71, 10, 20)];
        refundMarkLabel.backgroundColor = [UIColor clearColor];
        refundMarkLabel.textColor = RGBACOLOR(254, 75, 32, 1);
        refundMarkLabel.font = FONT_11;
        refundMarkLabel.text = @"￥";
        [ticketView addSubview:refundMarkLabel];
        [refundMarkLabel release];
        
        UILabel *refundLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 20)];
        refundLabel.backgroundColor = [UIColor clearColor];
        refundLabel.font = FONT_13;
        refundLabel.textColor = RGBACOLOR(254, 75, 32, 1);
        refundLabel.text = @"";
        self.refundLabel = refundLabel;
        [ticketView addSubview:refundLabel];
        [refundLabel release];
        
        UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, frame.size.width-160-10, 20)];
        feeLabel.backgroundColor = [UIColor clearColor];
        feeLabel.font = FONT_13;
        feeLabel.textColor = [UIColor darkGrayColor];
        feeLabel.text = @"";
        [ticketView addSubview:feeLabel];
        self.feeLabel = feeLabel;
        [feeLabel release];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(10, 95 - SCREEN_SCALE, frame.size.width-10, SCREEN_SCALE)]];
        
        // Passenger static label.
        UILabel *assengerStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 100, 80, 20.0f)];
        assengerStaticLabel.backgroundColor = [UIColor clearColor];
        assengerStaticLabel.font = FONT_13;
        assengerStaticLabel.textColor = [UIColor darkGrayColor];
        assengerStaticLabel.text = @"乘      客:";
        [ticketView addSubview:assengerStaticLabel];
        [assengerStaticLabel release];
        
        // Passenger dynamic label.
        UILabel *passengerDynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, frame.size.width-90-10, 20.0f)];
        passengerDynamicLabel.backgroundColor = [UIColor clearColor];
        passengerDynamicLabel.font = FONT_13;
        passengerDynamicLabel.text = @"";
        [ticketView addSubview:passengerDynamicLabel];
        self.passengerDynamicLabel = passengerDynamicLabel;
        [passengerDynamicLabel release];
        
        // Identify card.
        UILabel *identifyCard = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, frame.size.width-90-10, 20.0f)];
        identifyCard.backgroundColor = [UIColor clearColor];
        identifyCard.font = FONT_10;
        identifyCard.textColor = [UIColor darkGrayColor];
        identifyCard.text = @"";
        [ticketView addSubview:identifyCard];
        self.identifyCard = identifyCard;
        [identifyCard release];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 145- SCREEN_SCALE, frame.size.width, SCREEN_SCALE)]];
        
        [_ticketInfoView addSubview:ticketView];
        [ticketView release];
        
        // Notice.
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 200, frame.size.width-20, frame.size.height-60-10-200)];
        noticeLabel.backgroundColor = [UIColor clearColor];
        noticeLabel.font = FONT_10;
        noticeLabel.numberOfLines = 0;
        noticeLabel.textColor = [UIColor darkGrayColor];
        noticeLabel.lineBreakMode = UILineBreakModeCharacterWrap;
//        noticeLabel.text = @"1. 按照铁路部规定，退票手续费收取：票面乘车站开车时间前48小时以上的按票价5%计，24小时以上、不足48小时的按票价10%计，不足24小时的按票价20%计。          2.退票成功后，将向您注册时提供的手机号发送退票成功信息，请稍后查询，最终退款以铁路局实退为准。            3.退款到帐时间约为3-20个工作日。";
        noticeLabel.textAlignment = UITextAlignmentLeft;
        noticeLabel.numberOfLines = 0;
        self.noticeLabel = noticeLabel;
        [_ticketInfoView addSubview:noticeLabel];
        [noticeLabel release];
        
        // confirm refund button.
        UIButton *confirmRefundButton = [UIButton yellowWhitebuttonWithTitle:@"确认退票"
                                                                      Target:self
                                                                      Action:@selector(confirmRefund:)
                                                                       Frame:CGRectMake(frame.size.width/2-70, frame.size.height-60, 140, 40)];
        [_ticketInfoView addSubview:confirmRefundButton];
        
        [_markView addSubview:_ticketInfoView];
        
        
        // 附加
        // 关闭按钮
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [window addSubview:_closeButton];
        [_closeButton addTarget:self action:@selector(closeTicketRefundView:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.alpha = 0.0;
        _closeButton.frame = CGRectMake(frame.size.width + 25.0f - 57.0f / 2, frame.origin.y - 28.0f, 57.0f, 57.0f);
        [_markView addSubview:_closeButton];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        [_markView addGestureRecognizer:singleTap];
        [singleTap release];
        
        // 动画开始整
        [UIView animateWithDuration:0.3f animations:^{
            _ticketInfoView.alpha = 1.0f;
            _closeButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

- (void)closeTicketRefundView:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        _ticketInfoView.alpha = 0.0f;
        _closeButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_markView removeFromSuperview];
        [(TrainOrderDetailViewController *)_trainOrderDetailViewController releaseTicketRefundView];
    }];
}

- (void)detailMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self closeTicketRefundView:nil];
}

- (void)confirmRefund:(id)sender
{
    [(TrainOrderDetailViewController *)_trainOrderDetailViewController confirmRefund];
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
