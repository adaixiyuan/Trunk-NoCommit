//
//  ScenicOrderHeaderCell.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicOrderHeaderCell.h"
#import "ScenicUtils.h"
#import "UIView+(Size).h"
#import "ScenicDetail.h"

@implementation ScenicOrderHeaderCell

- (void)awakeFromNib
{
    [self adjustTheBtnLineWithHeight];
}
- (IBAction)tapBtnMethord:(id)sender {
    if (!_arrowImage.hidden) {
        UIImage *up = [UIImage imageNamed:@"packing_arrow_up.png"];
        UIImage *down = [UIImage imageNamed:@"packing_arrow_down.png"];
        CGFloat height;
        show = !show;
        if (!show) {
            height = 30;
            _arrowImage.image = down;
        }else{
           height = [ScenicUtils getTheStringHeight:_ticketInro.text FontSize:12 Width:_ticketInro.frame.size.width];
            _arrowImage.image = up;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(ajustTheHeaderCellHeight:andFlag:)]) {
            [_delegate ajustTheHeaderCellHeight:height andFlag:show];
        }
    }
}

-(void)adjustTheBtnLineWithHeight{
    
    UIImageView *top = (UIImageView *)[self viewWithTag:1001];
    if (!top) {
        top = [UIImageView graySeparatorWithFrame:CGRectMake(0, _tapBtn.frame.origin.y-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        top.tag = 1001;
        [self addSubview:top];
    }
   
    UIImageView *bottom = (UIImageView *)[self viewWithTag:1002];
    if (bottom) {
        [bottom removeFromSuperview];
        bottom = nil;
    }
    bottom = [UIImageView graySeparatorWithFrame:CGRectMake(0, _tapBtn.frame.origin.y+_tapBtn.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    bottom.tag = 1002;
    [self addSubview:bottom];
}

-(void)setPriceDetail:(ScenicPrice *)priceDetail andHeight:(CGFloat)height andFlag:(BOOL)yes{
    
    show = yes;
    self.ticketName.text = priceDetail.ticketName;
    self.payType.text = priceDetail.pMode;
    self.ticketInro.text = priceDetail.remark;
    
    UIImage *up = [UIImage imageNamed:@"packing_arrow_up.png"];
    UIImage *down = [UIImage imageNamed:@"packing_arrow_down.png"];
    
    CGFloat con_height = [ScenicUtils getTheStringHeight:priceDetail.remark FontSize:12 Width:_ticketInro.frame.size.width];
    if (con_height>30) {
        _arrowImage.hidden = NO;
        if (yes) {
            _arrowImage.image = up;
        }else{
            _arrowImage.image = down;
        }        
    }else{
        _arrowImage.hidden = YES;
    }
    
    CGRect frame_info = _ticketInro.frame;
    frame_info.size.height = (yes)?con_height:30;
    _ticketInro.frame = frame_info;
    
    CGRect frame_btn = _tapBtn.frame;
    frame_btn.size.height = (yes)?con_height+14:44;
    _tapBtn.frame = frame_btn;
    
    [self adjustTheBtnLineWithHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_ticketName release];
    [_payType release];
    [_ticketInro release];
    [_tapBtn release];
    [_arrowImage release];
    [super dealloc];
}
@end
