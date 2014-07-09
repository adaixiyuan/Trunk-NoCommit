//
//  HotelOrderListBigCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderListBigCell.h"

@implementation HotelOrderListBigCell

- (void)dealloc
{
    [_hotelNameLabel release];
    [_roomNameLabel release];
    [_checkInDateLabel release];
    [_departureDateLabel release];
    [_orderStatusLabel release];
    [_priceInfoLabel release];
    [_payTypeLabel release];
    [_backCashInfoLabel release];
    [_orderPromptLabel release];
    
//    [_confirmQuicklyBtn release];
//    [_goHotelBtn release];
//    [_orderFlowBtn release];
//    [_feedbackBtn release];
//    [_commentHotelBtn release];
//    [_againBookingBtn release];
//    [_modifyOrderBtn release];
//    [_continueCheckInBtn release];
//    [_telHotelBtn release];
//    [_cancelOrderBtn release];
    
    [_topLineImgView release];
    [_bottomLineImgView release];
    
    [_actionPositionDict release];
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

-(void)awakeFromNib{
    _actionPositionDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromCGRect(CGRectMake(228, 25, 72, 28)),@"0",NSStringFromCGRect(CGRectMake(7, 100, 80, 28)),@"1",NSStringFromCGRect(CGRectMake(107, 100, 80, 28)),@"2",NSStringFromCGRect(CGRectMake(207, 100, 80, 28)),@"3", nil];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //按钮不高亮
    for(UIButton *tmpBtn in self.contentView.subviews){
        tmpBtn.highlighted = NO;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    //按钮不高亮
    for(UIButton *tmpBtn in self.contentView.subviews){
        tmpBtn.highlighted = NO;
    }
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

//根据状态显示对应的按钮
-(void)executeShowBtnByActions:(NSArray *)actions{
//    订单状态拥有的操作 0:带我去酒店,1:再次预订,2：催确认,3：去支付,4：去担保, 5：入住反馈,6：    拒绝原因, 7：继续住,8:失败原因, 9:订单进度, 10:修改/取消, 11:联系酒店,12:点评酒店
    for(UIButton *tmpBtn in self.contentView.subviews){
        if(tmpBtn.tag>0){
            [tmpBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_normal.png"] forState:UIControlStateNormal];
            [tmpBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_grayBtnBg_selected.png"] forState:UIControlStateHighlighted];
            [tmpBtn setTitleColor:RGBACOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
            tmpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            
            if(tmpBtn.tag==101 || tmpBtn.tag==103 || tmpBtn.tag == 104 || tmpBtn.tag == 105 || tmpBtn.tag == 107 || tmpBtn.tag == 109){
                //去支付和区担保和催确认颜色 另行设置
                [tmpBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_blueBtnBg_normal.png"] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotelOderList_blueBtnBg_selected.png"] forState:UIControlStateHighlighted];

                [tmpBtn setTitleColor:RGBACOLOR(35, 119, 232, 1) forState:UIControlStateNormal];
            }
            
            tmpBtn.hidden = YES;
            [tmpBtn setExclusiveTouch:YES];
            int index = tmpBtn.tag -101;        //此处在xib中设置各个btn对应的tag
            for(NSDictionary *action in actions){
                int actionId = [[action safeObjectForKey:@"ActionId"] intValue];
                int positionId = [[action safeObjectForKey:@"Position"] intValue];
                
                if(actionId == index){
                    tmpBtn.hidden = NO;
                    CGRect frame = CGRectFromString([_actionPositionDict safeObjectForKey:[NSString stringWithFormat:@"%d",positionId]]);
                    tmpBtn.frame = frame;
                    break;
                }
            }
        }
    }
}

//点击相应的按钮，执行动作
-(void)executeBtnClick:(id)sender{
    UIButton *tmpBtn = (UIButton *)sender;
    switch (tmpBtn.tag) {
        case 101:
        {
            //带我去酒店
            if([_delegate respondsToSelector:@selector(clickGoHotelBtn:)]){
                [_delegate clickGoHotelBtn:self.tag];
            }
        }
            break;
        case 102:
        {
            //再次预订
            if([_delegate respondsToSelector:@selector(clickBookingAgainBtn:)]){
                [_delegate clickBookingAgainBtn:self.tag];
            }
        }
            break;
        case 103:
        {
            //加速确认
            if([_delegate respondsToSelector:@selector(clickConfirmQuicklyBtn:)]){
                [_delegate clickConfirmQuicklyBtn:self.tag];
            }
        }
            break;
        case 104:
        {
            //去支付
            if([_delegate respondsToSelector:@selector(clickGoPayOrVouchAgainBtn:)]){
                [_delegate clickGoPayOrVouchAgainBtn:self.tag];
            }
        }
            break;
        case 105:
        {
            //去担保
            if([_delegate respondsToSelector:@selector(clickGoPayOrVouchAgainBtn:)]){
                [_delegate clickGoPayOrVouchAgainBtn:self.tag];
            }
        }
            break;
        case 106:
        {
            //入住反馈
            if([_delegate respondsToSelector:@selector(clickGoFeedbackBtn:)]){
                [_delegate clickGoFeedbackBtn:self.tag];
            }
        }
            break;
        case 107:
        {
            //拒绝原因
            if([_delegate respondsToSelector:@selector(clickReviewRejectOrFailureSeasonBtn:)]){
                [_delegate clickReviewRejectOrFailureSeasonBtn:self.tag];
            }
        }
            break;
        case 108:
        {
            //继续入住
            if([_delegate respondsToSelector:@selector(clickBookingAgainBtn:)]){
                [_delegate clickBookingAgainBtn:self.tag];
            }
        }
            break;
        case 109:
        {
            //失败原因
            if([_delegate respondsToSelector:@selector(clickReviewRejectOrFailureSeasonBtn:)]){
                [_delegate clickReviewRejectOrFailureSeasonBtn:self.tag];
            }
        }
            break;
        case 110:
        {
            //订单进度
            if([_delegate respondsToSelector:@selector(clickOrderFlowBtn:)]){
                [_delegate clickOrderFlowBtn:self.tag];
            }
        }
            break;
        case 111:
        {
            //修改取消按钮
            if([_delegate respondsToSelector:@selector(clickModifyOrCancelBtn:)]){
                [_delegate clickModifyOrCancelBtn:self.tag];
            }
        }
            break;
        case 112:
        {
            //联系酒店
            if([_delegate respondsToSelector:@selector(clickTelHotelBtn:)]){
                [_delegate clickTelHotelBtn:self.tag];
            }

        }
            break;
        case 113:
        {
            //点评酒店
            if([_delegate respondsToSelector:@selector(clickCommentHotelBtn:)]){
                [_delegate clickCommentHotelBtn:self.tag];
            }

        }
            break;
        case 114:
        {
            //修改订单
            if([_delegate respondsToSelector:@selector(clickModifyOrderBtn:)]){
                [_delegate clickModifyOrderBtn:self.tag];
            }
        }
            break;
        case 115:
        {
            //取消订单
            if([_delegate respondsToSelector:@selector(clickCancelOrderBtn:)]){
                [_delegate clickCancelOrderBtn:self.tag];
            }
        }
            break;
        case 116:
        {
            //推荐预订
            if([_delegate respondsToSelector:@selector(clickRecommendBookingBtn:)]){
                [_delegate clickRecommendBookingBtn:self.tag];
            }
        }
            break;
        default:
            break;
    }
}

@end
