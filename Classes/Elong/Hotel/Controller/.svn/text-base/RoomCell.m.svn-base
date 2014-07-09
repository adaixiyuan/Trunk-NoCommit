//
//  RoomCell.m
//  ElongClient
//
//  Created by Dawn on 13-9-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RoomCell.h"
#import "DefineHotelResp.h"
#import "IconAndTextView.h"
#import "HotelDefine.h"
#import "HotelPostManager.h"
#import <QuartzCore/QuartzCore.h>

#define ROOMSEVENDAY  40012

@implementation RoomCell

- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.hotelImageView = nil;
    self.hotelNameLbl = nil;
    self.facilityLine0 = nil;
    self.facilityLine1 = nil;
    self.cashDiscountView = nil;
    self.cashDiscountLbl = nil;
    self.roomLeaveLbl = nil;
    self.bookingBtn = nil;
    self.separatorLine = nil;
    self.countNO = nil;
    self.prepayIcon = nil;
    self.priceMarkLbl = nil;
    self.priceLbl = nil;
    self.discountPriceLbl = nil;
    self.cancelRuleLbl=nil;
    self.grouponNumBg=nil;
    self.specialView = nil;
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景
        [self makeupBackground];
        
        // 酒店信息，酒店名、酒店图片、特惠信息
        [self makeupHotelInfo];
            
        // 酒店设施，早餐、宽带、楼层、面积、床型
        [self makeupHotelFacilities];
        
        // 礼品、返现、剩余房量、价格、原价、预定按钮
        [self makeupPriceRelated];
    }
    return self;
}

// 背景
- (void)makeupBackground{
    // 背景
    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
    self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 分割线
    self.separatorLine = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 110 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
    self.separatorLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [self.contentView addSubview:self.separatorLine];
    
    // arrow
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(306,(110 - 9)/2, 5, 9)];
    arrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView release];
}

// 酒店信息，酒店名、酒店图片、特惠信息
- (void) makeupHotelInfo{
    //酒店名
    self.hotelNameLbl = [[[AttributedLabel alloc] initWithFrame:CGRectMake(11, 8, SCREEN_WIDTH - 20, 33)] autorelease];
    self.hotelNameLbl.backgroundColor = [UIColor clearColor];
    self.hotelNameLbl.lineBreakMode = UILineBreakModeTailTruncation;
    self.hotelNameLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    self.hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.contentView addSubview:self.hotelNameLbl];
    
    // 酒店图片
    self.hotelImageView = [[[RoundCornerView alloc] initWithFrame:CGRectMake(6+3, 30, 65 + 6, 65 + 6)] autorelease];
    self.hotelImageView.imageRadius = 2.0f;
    [self.contentView addSubview:self.hotelImageView];
    
    //取消规则，先屏蔽，误删
//    //黑的一条填充
//    self.grouponNumBg=[[[UIImageView alloc] init] autorelease];
//    self.grouponNumBg.image=[UIImage noCacheImageNamed:@"grouponListCellImgBg.png"];
//    self.grouponNumBg.alpha=0.6;
//    self.grouponNumBg.frame=CGRectMake(3, self.hotelImageView.frame.size.height-18, self.hotelImageView.frame.size.width-6, 15);
//    self.grouponNumBg.contentMode=UIViewContentModeScaleToFill;
//    [self.hotelImageView addSubview:self.grouponNumBg];
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.grouponNumBg.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.grouponNumBg.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.grouponNumBg.layer.mask = maskLayer;
//    [maskLayer release];
//    
//    //取消规则
//    self.cancelRuleLbl = [[[UILabel alloc] init] autorelease];
//    self.cancelRuleLbl.frame=self.grouponNumBg.bounds;
//    self.cancelRuleLbl.backgroundColor	= [UIColor clearColor];
//    self.cancelRuleLbl.textAlignment=NSTextAlignmentCenter;
//    self.cancelRuleLbl.textColor = [UIColor whiteColor];
//    self.cancelRuleLbl.font = [UIFont systemFontOfSize:12.0f];
//    self.cancelRuleLbl.adjustsFontSizeToFitWidth = YES;
//    self.cancelRuleLbl.minimumFontSize	= 10.0f;
//    [self.grouponNumBg addSubview:self.cancelRuleLbl];
    
    // 特惠信息
    self.specialView = [[[SpecialRoomTypeView alloc] initWithFrame:CGRectMake(88, 33, 160, 12)] autorelease];
    self.specialView.scrollEnabled = NO;
    [self.contentView addSubview:self.specialView];
}

// 酒店设施，早餐、宽带、楼层、面积、床型
- (void) makeupHotelFacilities{
    // 设施line0
    self.facilityLine0 = [[[UILabel alloc] initWithFrame:CGRectMake(88, 52, 200, 14)] autorelease];
    self.facilityLine0.font = [UIFont systemFontOfSize:11.0f];
    self.facilityLine0.textColor = RGBACOLOR(102, 102, 102, 1);
    self.facilityLine0.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.facilityLine0];
    
    // 设施line1
    self.facilityLine1 = [[[UILabel alloc] initWithFrame:CGRectMake(88, 70, 200, 14)] autorelease];
    self.facilityLine1.font = [UIFont systemFontOfSize:11.0f];
    self.facilityLine1.textColor = RGBACOLOR(102, 102, 102, 1);
    self.facilityLine1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.facilityLine1];
}

// 礼品、返现、剩余房量、价格、原价、预定按钮
- (void) makeupPriceRelated{
    // 预定按钮
    self.bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_disable.png"] forState:UIControlStateDisabled];
    
    
    [self.bookingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bookingBtn setTitleColor:RGBACOLOR(93, 93, 93, 1) forState:UIControlStateDisabled];
    [self.bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
    [self.bookingBtn setTitle:@"满房" forState:UIControlStateDisabled];
    [self.bookingBtn addTarget:self action:@selector(booking) forControlEvents:UIControlEventTouchUpInside];
    
    self.bookingBtn.titleLabel.font	= FONT_B14;
    self.bookingBtn.frame			= CGRectMake(245, 73, 56, 25);
    self.bookingBtn.exclusiveTouch  = YES;
    
    UIButton *innerBookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    innerBookingBtn.exclusiveTouch  = YES;
    innerBookingBtn.frame = CGRectMake(SCREEN_WIDTH - 240/2, 0, 240/2, 220/2);
    [innerBookingBtn addTarget:self action:@selector(booking) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:innerBookingBtn];
    
    [self.contentView addSubview:self.bookingBtn];

    // 剩余房量
    self.roomLeaveLbl = [[[UILabel alloc] initWithFrame:CGRectMake(88, 87, 66, 12)] autorelease];
    self.roomLeaveLbl.font = [UIFont boldSystemFontOfSize:11.0f];
    self.roomLeaveLbl.textAlignment = UITextAlignmentLeft;
    self.roomLeaveLbl.textColor = [UIColor colorWithRed:210.0/255.0f green:70.0/255.0f blue:36.0/255.0f alpha:1];
    [self.contentView addSubview:self.roomLeaveLbl];
    self.roomLeaveLbl.hidden = YES;
    
    // 返现
    self.cashDiscountView = [[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 74 + 5, 56, 61, 16)] autorelease];
    [self.contentView addSubview:self.cashDiscountView];
    
    self.cashDiscountLbl = [[[UILabel alloc] initWithFrame:CGRectMake(245, 56, 55, 16)] autorelease];
    self.cashDiscountLbl.font = [UIFont systemFontOfSize:12.0f];
    self.cashDiscountLbl.textColor =  [UIColor colorWithRed:254.0f green:75.0/255.0f blue:32.0f/255.0f alpha:1];
    self.cashDiscountLbl.textAlignment = UITextAlignmentRight;
    self.cashDiscountLbl.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.cashDiscountLbl];
   
    
    // 预付图标
    self.prepayIcon = [[[UILabel alloc] initWithFrame:CGRectMake(210, 74, 36, 23)] autorelease];
    self.prepayIcon.textColor =  RGBACOLOR(235, 69, 24, 1);
    self.prepayIcon.font = [UIFont boldSystemFontOfSize:13.0f];
    self.prepayIcon.backgroundColor = [UIColor clearColor];
    self.prepayIcon.text = @"预付";
    [self.contentView addSubview:self.prepayIcon];

    
    // 现价货币符号
    self.priceMarkLbl = [[[UILabel alloc] initWithFrame:CGRectMake(215, 15 + 20, 40, 18)] autorelease];
    self.priceMarkLbl.opaque = YES;
    self.priceMarkLbl.backgroundColor = [UIColor whiteColor];
    self.priceMarkLbl.font = [UIFont systemFontOfSize:12.0f];
    self.priceMarkLbl.textColor = RGBACOLOR(108, 108, 108, 1);
    self.priceMarkLbl.adjustsFontSizeToFitWidth = YES;
    self.priceMarkLbl.minimumFontSize = 10.0f;
    [self.contentView addSubview:self.priceMarkLbl];
    self.priceMarkLbl.backgroundColor = [UIColor clearColor];
    self.priceMarkLbl.textAlignment = UITextAlignmentRight;
    
    // 现价
    self.priceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(247, 14 + 18, 55, 20)] autorelease];
    self.priceLbl.opaque = YES;
    self.priceLbl.backgroundColor = [UIColor whiteColor];
    self.priceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    self.priceLbl.adjustsFontSizeToFitWidth = YES;
    self.priceLbl.minimumFontSize = 16;
    self.priceLbl.textColor = [UIColor colorWithRed:254.0f green:75.0/255.0f blue:32.0f/255.0f alpha:1];
    [self.contentView addSubview:self.priceLbl];
    self.priceLbl.backgroundColor = [UIColor clearColor];
    self.priceLbl.textAlignment = UITextAlignmentRight;
    
    // 原价
    self.discountPriceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(180, 34, 50, 17)] autorelease];
    self.discountPriceLbl.opaque = YES;
    self.discountPriceLbl.textAlignment = UITextAlignmentCenter;
    self.discountPriceLbl.backgroundColor = [UIColor clearColor];
    self.discountPriceLbl.font = [UIFont systemFontOfSize:12.0f];
    self.discountPriceLbl.textColor = [UIColor colorWithWhite:160.0f/255.0f alpha:1];
    [self.contentView addSubview:self.discountPriceLbl];
    
    UIImageView *discountLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, self.discountPriceLbl.frame.size.width-16, 1)];
    discountLine.image = [UIImage noCacheImageNamed:@"single_line.png"];
    [self.discountPriceLbl addSubview:discountLine];
    [discountLine release];
}


- (void)booking {
    if (!self.bookingBtn.enabled) {
        return;
    }
	BOOL islogin = [[AccountManager instanse] isLogin];
	[RoomType setCurrentRoomIndex:self.roomindex];
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:self.roomindex];
	[[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD_IsCustomerNameEn]
                                                forKey:RespHD_IsCustomerNameEn];				// 判断是否需要用户必须选择英文用户名
    [[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD__HotelCoupon_DI]
                                                forKey:RespHD__HotelCoupon_DI];				// 优惠券返现
    
    // 预订的房型
    [[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD__RoomTypeName_S]
                                                forKey:ExSelectRoomType];
    
    // 设置预付参数
    if ([[room safeObjectForKey:@"PayType"] intValue] == 1) {
        [RoomType setIsPrepay:YES];
    }
    else {
        [RoomType setIsPrepay:NO];
    }
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginsuccess) name:ROOMTYPELOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registersuccess) name:ROOMTYPERSGISTER object:nil];
	if (islogin) {
        
        if ([[Coupon activedcoupons] count] == 0) {
            // 预加载失败时，重新请求coupon
            JCoupon *coupon = [MyElongPostManager coupon];
            [[MyElongPostManager coupon] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
        }
        else {
            // 直接进入填写订单页面
            [self goHotelFillOrderPage];
        }
	}
	else {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillHotelOrder_];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
	}
}

-(void)loginsuccess{
    fromloginsuccess = YES;
}

-(void)registersuccess{
    JCoupon *coupon = [MyElongPostManager coupon];
    [[MyElongPostManager coupon] clearBuildData];
    [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
}

-(void)deleteloginvc{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    for (UIViewController *controller in appDelegate.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginManager class]]) {
            [controller.navigationController popViewControllerAnimated:NO];
        }
    }
}


- (void)goHotelFillOrderPage {
    // 进入酒店订单填写页面
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
    
    fillhotelOrder.isSkipLogin = fromloginsuccess;
    [delegate.navigationController pushViewController:fillhotelOrder animated:YES];
    [fillhotelOrder release];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    NSLog(@"%@",root);
    if (m_netstate == ROOMSEVENDAY) {
        
	}
    else {
        [[Coupon activedcoupons] removeAllObjects];
        [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        //    [Login jump2fillorder];
        
        // 推入订单填写页面
        [self goHotelFillOrderPage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
