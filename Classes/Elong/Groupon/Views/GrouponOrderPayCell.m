//
//  GrouponOrderPayCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponOrderPayCell.h"

@implementation GrouponOrderPayCell
@synthesize alipayHidden = _alipayHidden;
@synthesize cashaccountHidden = _cashaccountHidden;
@synthesize alipayChecked = _alipayChecked;
@synthesize creditCardChecked = _creditCardChecked;
@synthesize cashaccountChecked = _cashaccountChecked;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *stretchImg = [UIImage noCacheImageNamed:@"groupon_cell_normal.png"];
        UIImage *newImg = [stretchImg stretchableImageWithLeftCapWidth:14
                                                          topCapHeight:14];
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 308, 160)];
        [self.contentView addSubview:bgImageView];
        bgImageView.image = newImg;
        [bgImageView release];
        bgImageView.clipsToBounds = YES;
        bgImageView.userInteractionEnabled = YES;
        
        
        // 支付方式
        UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 40)];
        priceTipsLbl.textColor = [UIColor blackColor];
        priceTipsLbl.backgroundColor = [UIColor clearColor];
        priceTipsLbl.font = [UIFont systemFontOfSize:16.0f];
        [bgImageView addSubview:priceTipsLbl];
        [priceTipsLbl release];
        priceTipsLbl.text = @"支付方式";
        
        // 分割线
        UIImageView *splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"groupon_detail_line.png"]];
        [bgImageView addSubview:splitImageView];
        splitImageView.frame = CGRectMake(0, 40, bgImageView.frame.size.width, .55);
        [splitImageView release];

        
        // 支付宝
        alipayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, bgImageView.frame.size.width, 41)];
        [bgImageView addSubview:alipayView];
        [alipayView release];
        
        UIImageView *alipayIconView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + 15, 0, 33, 40)];
        alipayIconView.contentMode = UIViewContentModeCenter;
        alipayIconView.image = [UIImage noCacheImageNamed:@"groupon_order_aplipay.png"];
        [alipayView addSubview:alipayIconView];
        [alipayIconView release];
        
        UILabel *alipayTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, 0, 200, 40)];
        alipayTitleLbl.font = [UIFont systemFontOfSize:16.0f];
        alipayTitleLbl.textColor = [UIColor blackColor];
        alipayTitleLbl.backgroundColor = [UIColor clearColor];
        [alipayView addSubview:alipayTitleLbl];
        [alipayTitleLbl release];
        alipayTitleLbl.text = @"支付宝支付";
        
        
        UILabel *alipayTitleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 200, 40)];
        alipayTitleLbl2.font = [UIFont systemFontOfSize:12.0f];
        alipayTitleLbl2.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1];
        alipayTitleLbl2.backgroundColor = [UIColor clearColor];
        [alipayView addSubview:alipayTitleLbl2];
        [alipayTitleLbl2 release];
        alipayTitleLbl2.text = @"(支持银联储蓄卡)";
        
        
        alipayRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        [alipayRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        alipayRadio.adjustsImageWhenHighlighted = NO;
        alipayRadio.frame = CGRectMake(0, 0, 308, 40);
        alipayRadio.imageEdgeInsets = UIEdgeInsetsMake(0, -242-20, 0, 0);
        [alipayView addSubview:alipayRadio];
        [alipayRadio addTarget:self action:@selector(alipayRadioClick:) forControlEvents:UIControlEventTouchUpInside];
        
        splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"groupon_detail_line.png"]];
        [alipayView addSubview:splitImageView];
        splitImageView.frame = CGRectMake(0, 40, bgImageView.frame.size.width, .55);
        [splitImageView release];
        
        // 信用卡
        creditCardView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bgImageView.frame.size.width, 41)];
        [bgImageView addSubview:creditCardView];
        [creditCardView release];
        
        
        UIImageView *creditCardIconView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + 15, 0, 33, 40)];
        creditCardIconView.contentMode = UIViewContentModeCenter;
        creditCardIconView.image = [UIImage noCacheImageNamed:@"groupon_order_creditecard.png"];
        [creditCardView addSubview:creditCardIconView];
        [creditCardIconView release];
        
        UILabel *creditCardTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, 0, 200, 40)];
        creditCardTitleLbl.font = [UIFont systemFontOfSize:16.0f];
        creditCardTitleLbl.textColor = [UIColor blackColor];
        creditCardTitleLbl.backgroundColor = [UIColor clearColor];
        [creditCardView addSubview:creditCardTitleLbl];
        [creditCardTitleLbl release];
        creditCardTitleLbl.text = @"信用卡支付";
        
        
        creditCardRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        [creditCardRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        creditCardRadio.adjustsImageWhenHighlighted = NO;
        creditCardRadio.frame = CGRectMake(0, 0, 308, 40);
        creditCardRadio.imageEdgeInsets = UIEdgeInsetsMake(0, -242-20, 0, 0);
        [creditCardView addSubview:creditCardRadio];
        [creditCardRadio addTarget:self action:@selector(creditCardRadioClick:) forControlEvents:UIControlEventTouchUpInside];
        
        splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"groupon_detail_line.png"]];
        [creditCardView addSubview:splitImageView];
        splitImageView.frame = CGRectMake(0, 40, bgImageView.frame.size.width, .55);
        [splitImageView release];
        
        // 现金账户
        cashAccountView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, bgImageView.frame.size.width, 40)];
        [bgImageView addSubview:cashAccountView];
        [cashAccountView release];
        
        UILabel *cashAccountLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bgImageView.frame.size.width - 30, 40)];
        cashAccountLbl.font = [UIFont systemFontOfSize:16.0f];
        cashAccountLbl.backgroundColor = [UIColor clearColor];
        [cashAccountView addSubview:cashAccountLbl];
        [cashAccountLbl release];
        cashAccountLbl.text = @"使用现金账户支付";
        
        cashAccountSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 90, 6, 20, 20)];
        [cashAccountView addSubview:cashAccountSwitch];
        [cashAccountSwitch release];
        [cashAccountSwitch addTarget:self action:@selector(cashAccountSwitchClick:) forControlEvents:UIControlEventValueChanged];

    }
    return self;
}

- (void) alipayRadioClick:(id)sender{
    self.alipayChecked = YES;
    if ([self.delegate respondsToSelector:@selector(orderPayCell:selectPayType:)]) {
        [delegate orderPayCell:self selectPayType:GrouponAlipay];
    }
}

- (void) creditCardRadioClick:(id)sender{
    self.creditCardChecked = YES;
    if ([self.delegate respondsToSelector:@selector(orderPayCell:selectPayType:)]) {
        [delegate orderPayCell:self selectPayType:GrouponCreditCard];
    }
}

- (void) cashAccountSwitchClick:(id)sender{
    if (cashAccountSwitch.on) {
        self.alipayHidden = YES;
    }else{
        self.alipayHidden = NO;
    }
    _cashaccountChecked = cashAccountSwitch.on;
    
    if ([self.delegate respondsToSelector:@selector(orderPayCell:cashAccount:)]) {
        [delegate orderPayCell:self cashAccount:cashAccountSwitch.on];
    }
}

- (void) setCashaccountChecked:(BOOL)cashaccountChecked{
    _cashaccountChecked = cashaccountChecked;
    if (cashaccountChecked) {
        cashAccountSwitch.on = YES;
    }else{
        cashAccountSwitch.on = NO;
    }
}

- (void) setAlipayChecked:(BOOL) checked{
    _alipayChecked = checked;
    _creditCardChecked = !checked;
    if (checked) {
        [alipayRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
        [creditCardRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
    }else{
        [alipayRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        [creditCardRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
    }
}

- (void) setCreditCardChecked:(BOOL) checked{
    _creditCardChecked = checked;
    _alipayChecked = !checked;
    if (checked) {
        [alipayRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        [creditCardRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
    }else{
        [alipayRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
        [creditCardRadio setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
    }
}

- (void) setAlipayHidden:(BOOL)alipayHidden{
    _alipayHidden = alipayHidden;
    if (alipayHidden) {
        alipayView.hidden = YES;
        creditCardView.frame = CGRectMake(0, 40, bgImageView.frame.size.width, 41);
        if (_cashaccountHidden) {
            cashAccountView.hidden = YES;
            bgImageView.frame = CGRectMake(6, 0, 308, 80);
        }else{
            cashAccountView.hidden = NO;
            bgImageView.frame = CGRectMake(6, 0, 308, 120);
            cashAccountView.frame = CGRectMake(0, 80, bgImageView.frame.size.width, 40);
        }
        
    }else{
        alipayView.hidden = NO;
        creditCardView.frame = CGRectMake(0, 40, bgImageView.frame.size.width, 41);
        alipayView.frame = CGRectMake(0, 80, bgImageView.frame.size.width, 41);
        if (_cashaccountHidden) {
            cashAccountView.hidden = YES;
            bgImageView.frame = CGRectMake(6, 0, 308, 120);
        }else{
            cashAccountView.hidden = NO;
            bgImageView.frame = CGRectMake(6, 0, 308, 160);
            cashAccountView.frame = CGRectMake(0, 120, bgImageView.frame.size.width, 40);
        }
    }
}

- (void) setCashaccountHidden:(BOOL)cashaccountHidden{
    _cashaccountHidden = cashaccountHidden;
    if (cashaccountHidden) {
        cashAccountView.hidden = YES;
        if(_alipayHidden){
            bgImageView.frame = CGRectMake(6, 0, 308, 80);
        }else{
            bgImageView.frame = CGRectMake(6, 0, 308, 120);
        }
    }else{
        cashAccountView.hidden = NO;
        if (_alipayHidden) {
            bgImageView.frame = CGRectMake(6, 0, 308, 120);
            cashAccountView.frame = CGRectMake(0, 80, bgImageView.frame.size.width, 40);
        }else{
            bgImageView.frame = CGRectMake(6, 0, 308, 160);
            cashAccountView.frame = CGRectMake(0, 120, bgImageView.frame.size.width, 40);
        }
    }
}

@end
