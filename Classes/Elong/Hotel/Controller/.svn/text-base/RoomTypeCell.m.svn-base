//
//  RoomTypeCell.m
//  ElongClient
//
//  Created by bin xing on 11-1-11.
//  Copyright 2011 DP. All rights reserved.
//

#import "RoomTypeCell.h"
#import "DefineHotelResp.h"
#import "IconAndTextView.h"
#import "HotelDefine.h"
#import "HotelPostManager.h"

static NSString *const KEY		= @"Key";
static NSString *const CONTENT	= @"Content";
static NSString *const roomKeys[8] = {
	@"breakfast",
	@"bed",
	@"network",
	@"area",
	@"floor",
    @"other",
    @"personnum",
    @"roomtype"
};

#define GETCOUPON 40013

#define kBreakfarstIconFrame_V		CGRectMake(146 - 4, 10, 82, 25)
#define kNetIconFrame_V				CGRectMake(232 - 4, 10, 82, 25)
#define kAreaIconFrame_V			CGRectMake(146 - 4, 35, 82, 25)
#define kFloorIconFrame_V			CGRectMake(232 - 4, 35, 82, 25)
#define kBedIconFrame_V				CGRectMake(146 - 4, 60, 168, 25)
// 上四下一布局
//#define kBreakfarstIconFrame_H		CGRectMake(10, 4, 75, 20)
//#define kNetIconFrame_H				CGRectMake(89, 4, 75, 20)
//#define kAreaIconFrame_H			CGRectMake(168, 4, 75, 20)
//#define kFloorIconFrame_H			CGRectMake(247, 4, 75, 20)
//#define kBedIconFrame_H				CGRectMake(10, 23, 300, 20)

#define kBreakfarstIconFrame_H		CGRectMake(25 - 4, 4, 95, 25)
#define kNetIconFrame_H				CGRectMake(125 - 4, 4, 95, 25)
#define kAreaIconFrame_H			CGRectMake(225 - 4, 4, 90, 25)
#define kFloorIconFrame_H			CGRectMake(25 - 4, 29, 95, 25)
#define kBedIconFrame_H				CGRectMake(125 - 4, 29, 190, 25)

@implementation RoomTypeCell

@synthesize discountImg;
@synthesize separatorLine;
@synthesize roomTypeNameLabel;
@synthesize roomPriceLabel;
@synthesize bookbtn;
@synthesize couponbtn;
@synthesize description;
@synthesize roomindex;
@synthesize roomMarkLabel;			
@synthesize discountPriceLabel;		
@synthesize discountMarkLabel;
@synthesize lineView;
@synthesize backView;
@synthesize roomImg;
@synthesize DragonVIPImg;
@synthesize prepayIcon;
@synthesize remainroomstockLabel;
@synthesize countNO;
@synthesize bottomShadow;
@synthesize giftBtn;
@synthesize timelimitImg;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [sevenDaysUtil cancel];
    SFRelease(sevenDaysUtil);
    
	self.lineView = nil;
	self.roomMarkLabel = nil;
	self.discountPriceLabel = nil;
	self.discountMarkLabel = nil;
	self.discountImg = nil;
	self.backView = nil;
	self.roomImg = nil;
	self.separatorLine = nil;
    self.prepayIcon = nil;
    self.remainroomstockLabel = nil;
    self.DragonVIPImg = nil;
    self.countNO = nil;
    self.bottomShadow = nil;
    self.roomTypeNameLabel = nil;
    self.roomPriceLabel = nil;
    self.couponbtn = nil;
    self.description = nil;
    self.giftBtn = nil;
    self.giftMoreBtn = nil;
    self.timelimitImg = nil;
	
	[breakfarstView release];
	[bedView release];
	[netView release];
	[areaView release];
	[floorView release];
    [giftLbl release];
    
	
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        self.clipsToBounds = YES;
        
        UIImageView *cbgView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageWithPath:@"hoteldetail_cell_middle.png"]];
        cbgView.frame = CGRectMake(6, 0, SCREEN_WIDTH - 12, 360);
        [self.contentView addSubview:cbgView];
        [cbgView release];
        
        // 背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1 + 6, 0, 306, 159)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView release];
        
        // 房型
        self.roomTypeNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(99 + 6, 9, 180, 20)] autorelease];
        roomTypeNameLabel.opaque = YES;
        roomTypeNameLabel.backgroundColor = [UIColor whiteColor];
        roomTypeNameLabel.font = [UIFont systemFontOfSize:16.0f];
        roomTypeNameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:roomTypeNameLabel];
        
        // 现价货币符号
        self.roomMarkLabel = [[[UILabel alloc] initWithFrame:CGRectMake(14 + 6, 16, 25, 18)] autorelease];
        roomMarkLabel.opaque = YES;
        roomMarkLabel.backgroundColor = [UIColor whiteColor];
        roomMarkLabel.font = [UIFont systemFontOfSize:16.0f];
        roomMarkLabel.textColor = [UIColor colorWithWhite:99.0/255.0f alpha:1];
        roomMarkLabel.adjustsFontSizeToFitWidth = YES;
        roomMarkLabel.minimumFontSize = 10.0f;
        [self.contentView addSubview:roomMarkLabel];
        
        // 原价货币符号
        self.discountMarkLabel = [[[UILabel alloc] initWithFrame:CGRectMake(21 + 6, 39, 22, 15)] autorelease];
        self.discountMarkLabel.opaque = YES;
        self.discountMarkLabel.backgroundColor = [UIColor whiteColor];
        self.discountMarkLabel.font = [UIFont systemFontOfSize:15.0f];
        self.discountMarkLabel.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1];
        self.discountMarkLabel.adjustsFontSizeToFitWidth = YES;
        self.discountMarkLabel.minimumFontSize = 10.0f;
        [self.contentView addSubview:discountMarkLabel];
        
        // 现价
        self.roomPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(42 + 6, 14, 55, 20)] autorelease];
        self.roomPriceLabel.opaque = YES;
        self.roomPriceLabel.backgroundColor = [UIColor whiteColor];
        self.roomPriceLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.roomPriceLabel.adjustsFontSizeToFitWidth = YES;
        self.roomPriceLabel.minimumFontSize = 16;
        self.roomPriceLabel.textColor = [UIColor colorWithRed:1.0f green:128.0/255.0f blue:0 alpha:1];
        [self.contentView addSubview:roomPriceLabel];
        
        // 原价
        self.discountPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(43 + 6, 37, 50, 17)] autorelease];
        self.discountPriceLabel.opaque = YES;
        self.discountPriceLabel.backgroundColor = [UIColor whiteColor];
        self.discountPriceLabel.font = [UIFont systemFontOfSize:17.0f];
        self.discountPriceLabel.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1];
        [self.contentView addSubview:discountPriceLabel];
        
        // 返现
        self.couponbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.couponbtn setBackgroundImage:[UIImage noCacheImageNamed:@"money_back_ico.png"] forState:UIControlStateNormal];
        [self.couponbtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        self.couponbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [self.couponbtn setTitleColor:[UIColor colorWithRed:1.0f green:84.0/255.0f blue:0 alpha:1] forState:UIControlStateNormal];
        self.couponbtn.frame = CGRectMake(124, 40, 61, 16);
        [self.contentView addSubview:self.couponbtn];
        self.couponbtn.adjustsImageWhenHighlighted = NO;
        self.couponbtn.userInteractionEnabled = NO;
        
        // 礼品
        self.giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.giftBtn setImage:[UIImage noCacheImageNamed:@"hoteldetail_gift.png"] forState:UIControlStateNormal];
        self.giftBtn.frame = CGRectMake(84, 40, 61, 16);
        [self.contentView addSubview:self.giftBtn];
        self.giftBtn.adjustsImageWhenHighlighted = NO;
        self.giftBtn.userInteractionEnabled = NO;
        
        
        // 删除线
        self.lineView = [[[UIView alloc] initWithFrame:CGRectMake(44 + 6, 46, 14, 1)] autorelease];
        self.lineView.backgroundColor = [UIColor colorWithWhite:153.0/255.0f alpha:1];
        self.lineView.opaque = YES;
        [self.contentView addSubview:self.lineView];
        
        // 分割线
        self.separatorLine = [[[UIImageView alloc] initWithFrame:CGRectMake(2 + 6, 67, SCREEN_WIDTH - 16, 1)] autorelease];
        self.separatorLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.separatorLine];

        
        // 龙萃图标
        self.DragonVIPImg = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 55, 16)] autorelease];
        self.DragonVIPImg.image = [UIImage noCacheImageNamed:@"mobilePriceVipIconFlag.png"];
        self.DragonVIPImg.clipsToBounds = YES;
        self.DragonVIPImg.contentMode = UIViewContentModeTopRight;
        [self.contentView addSubview:self.DragonVIPImg];
        
        // 特价图标
        self.discountImg = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 55, 16)] autorelease];
        self.discountImg.image = [UIImage noCacheImageNamed:@"mobilePriceListIconFlag.png"];
        self.discountImg.clipsToBounds = YES;
        self.discountImg.contentMode = UIViewContentModeTopRight;
        [self.contentView addSubview:self.discountImg];
        
        // 限时抢
        self.timelimitImg = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 55, 16)] autorelease];
        self.timelimitImg.backgroundColor = [UIColor whiteColor];
        
        self.timelimitImg.image = [UIImage noCacheImageNamed:@"timelimitPriceListIconFlag.png"];
        [self.contentView addSubview:self.timelimitImg];
        
        // 详情背景
        self.backView = [[[UIView alloc] initWithFrame:CGRectMake(1 + 6, 68, SCREEN_WIDTH - 14, 91)] autorelease];
        self.backView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
        self.backView.opaque = YES;
        self.backView.clipsToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        self.roomImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 131, 92)] autorelease];
        [self.backView addSubview:self.roomImg];
        
        UIImageView *topShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)];
        topShadowView.image = [UIImage noCacheImageNamed:@"top_shadow.png"];
        [self.backView addSubview:topShadowView];
        [topShadowView release];
        
        self.bottomShadow = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 79, 320, 12)] autorelease];
        self.bottomShadow.image = [UIImage noCacheImageNamed:@"bottom_shadow.png"];
        [self.backView addSubview:self.bottomShadow];
        
        // 预付图标
        self.prepayIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(191 + 6, 36, 36, 23)] autorelease];
        self.prepayIcon.image = [UIImage noCacheImageNamed:@"prepayIco.png"];
        [self.contentView addSubview:self.prepayIcon];
        
        // 剩余房量
        self.remainroomstockLabel = [[[UILabel alloc] initWithFrame:CGRectMake(237 + 6, 54, 66, 12)] autorelease];
        self.remainroomstockLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        self.remainroomstockLabel.textAlignment = UITextAlignmentCenter;
        self.remainroomstockLabel.textColor = [UIColor colorWithRed:217.0/255.0f green:2.0/255.0f blue:2.0/255.0f alpha:1];
        [self.contentView addSubview:self.remainroomstockLabel];
        self.remainroomstockLabel.hidden = YES;
        
        // 礼品更多
        self.giftMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView insertSubview:self.giftMoreBtn atIndex:0];
        [self.giftMoreBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [self.giftMoreBtn setTitle:@"更多  " forState:UIControlStateNormal];
        //self.giftMoreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
        self.giftMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(-2, 34, 0, 0);
        [self.giftMoreBtn setImage:[UIImage noCacheImageNamed:@"hotel_giftmore_arrow.png"] forState:UIControlStateNormal];
        [self.giftMoreBtn setTitleColor:[UIColor colorWithWhite:67.0/255.0f alpha:1] forState:UIControlStateNormal];
        [self.giftMoreBtn setTitleColor:[UIColor colorWithWhite:37.0/255.0f alpha:1] forState:UIControlStateHighlighted];
        [self.giftMoreBtn addTarget:self action:@selector(giftMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        bookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
		bookbtn.adjustsImageWhenDisabled = NO;
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn.png"] forState:UIControlStateNormal];
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn_press.png"] forState:UIControlStateHighlighted];
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateDisabled];
		[bookbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[bookbtn setTitle:@"预 订" forState:UIControlStateNormal];
		[bookbtn setTitle:@"房 满" forState:UIControlStateDisabled];
		[bookbtn addTarget:self action:@selector(booking) forControlEvents:UIControlEventTouchUpInside];
		
		bookbtn.titleLabel.font	= FONT_B14;
		bookbtn.frame			= CGRectMake(237 + 6, 35, 66, 25);
		
		[self addSubview:bookbtn];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		bookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
		bookbtn.adjustsImageWhenDisabled = NO;
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn.png"] forState:UIControlStateNormal];
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn_press.png"] forState:UIControlStateHighlighted];
		[bookbtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateDisabled];
		[bookbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[bookbtn setTitle:@"预 订" forState:UIControlStateNormal];
		[bookbtn setTitle:@"房 满" forState:UIControlStateDisabled];
		[bookbtn addTarget:self action:@selector(booking) forControlEvents:UIControlEventTouchUpInside];
		
		bookbtn.titleLabel.font	= FONT_B14;
		bookbtn.frame			= CGRectMake(237, 35, 66, 25);
		
		[self addSubview:bookbtn];
        
    
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageWithPath:@"hoteldetail_cell_middle.png"]];
        self.backgroundView = bgView;
        [bgView release];
        
        
	}
	
	return self;
}


- (void) setRoomTypeName:(NSString *)name breakfastNum:(NSInteger)num{
    // 暂时隐藏
    roomTypeNameLabel.text = name;
    return;
    
    
    if (!breakfastBtn) {
        // 房型加入早餐图标
        breakfastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        breakfastBtn.frame = CGRectMake(0, 0, 40, roomTypeNameLabel.frame.size.height);
        [breakfastBtn.titleLabel setFont:roomTypeNameLabel.font];
        [breakfastBtn setTitleColor:roomTypeNameLabel.textColor forState:UIControlStateNormal];
        breakfastBtn.adjustsImageWhenDisabled = NO;
        breakfastBtn.adjustsImageWhenHighlighted = NO;
        breakfastBtn.enabled = NO;
        [breakfastBtn setImage:[UIImage noCacheImageNamed:@"breakfast_s_ico.png"] forState:UIControlStateNormal];
        [roomTypeNameLabel addSubview:breakfastBtn];
    }
    
    if (num == 0) {
        roomTypeNameLabel.text = name;
        breakfastBtn.hidden = YES;
    }else{
        breakfastBtn.hidden = NO;
        CGSize nameSize = [name sizeWithFont:roomTypeNameLabel.font];
        nameSize.width = nameSize.width + 4;
        if (nameSize.width > 170) {
            nameSize.width = nameSize.width - 2;
        }
        
        breakfastBtn.frame = CGRectMake(nameSize.width, 0, 34, breakfastBtn.frame.size.height);
        if (nameSize.width > 180) {
            [breakfastBtn setTitle:@"..." forState:UIControlStateNormal];
        }else{
            [breakfastBtn setTitle:[NSString stringWithFormat:@"×%d",num] forState:UIControlStateNormal];
        }
        
        roomTypeNameLabel.text = name;
    }
}

- (void) popCloseBtnClick:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        popView.alpha = 0;
        popMarkView.alpha = 0;
        popView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [popView removeFromSuperview];
        popView = nil;
        [popMarkView removeFromSuperview];
        popMarkView = nil;
    }];
}

- (void) giftBooking:(id)sender{
    [self popCloseBtnClick:sender];
    [self booking];
}

- (void) giftMoreBtnClick:(id)sender{
    

    popView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 286, 203)];
    popView.clipsToBounds = NO;
    popView.backgroundColor = [UIColor clearColor];
    popView.userInteractionEnabled = YES;
    popView.image = [UIImage stretchableImageWithPath:@"hotel_gift_bg.png"];
    
    // 艺龙送礼
    UILabel *titleLbl = [[UILabel  alloc] initWithFrame:CGRectMake(120, 16, 100, 20)];
    titleLbl.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLbl.textColor = [UIColor colorWithWhite:48.0/255.0f alpha:1];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = @"艺龙送礼";
    [popView addSubview:titleLbl];
    [titleLbl release];
    
    // 送礼内容
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(24, 50, popView.frame.size.width - 24 * 2, popView.frame.size.height - 50 - 70)];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.textColor = [UIColor colorWithWhite:83.0/255.0f alpha:1];
    tipsLbl.backgroundColor = [UIColor clearColor];
    tipsLbl.text = giftLbl.text;
    tipsLbl.lineBreakMode = NSLineBreakByCharWrapping;
    tipsLbl.numberOfLines = 0;
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [popView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(popView.frame.size.width - 40-4, -20+4, 60, 60);
    [closeBtn addTarget:self action:@selector(popCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [popView addSubview:tipsLbl];
    [tipsLbl release];
    
        
    CGSize giftSize =  CGSizeMake(tipsLbl.frame.size.width, 10000);
    CGSize newGiftSize = [giftLbl.text sizeWithFont:tipsLbl.font constrainedToSize:giftSize lineBreakMode:NSLineBreakByCharWrapping];
    
    if (newGiftSize.height > tipsLbl.frame.size.height) {
        tipsLbl.frame = CGRectMake(tipsLbl.frame.origin.x, tipsLbl.frame.origin.y, tipsLbl.frame.size.width, newGiftSize.height);
        popView.frame = CGRectMake(0, 0, popView.frame.size.width, newGiftSize.height + 50 + 70);
    }
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    popMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    popMarkView.backgroundColor = [UIColor blackColor];
    popMarkView.alpha = 0.0;
    [appDelegate.window addSubview:popMarkView];
    [popMarkView release];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popCloseBtnClick:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [popMarkView addGestureRecognizer:singleTap];
    [singleTap release];

    
    [appDelegate.window addSubview:popView];
    [popView release];
    popView.alpha = 0;
    popView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    
    // 预定按钮
    UIButton *bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bookingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
    [bookingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [bookingBtn addTarget:self action:@selector(giftBooking:) forControlEvents:UIControlEventTouchUpInside];
    bookingBtn.frame = CGRectMake(191, popView.frame.size.height - 53, 85, 40);
    [popView addSubview:bookingBtn];
    if (bookbtn.enabled) {
        bookingBtn.enabled = YES;
    }else{
        bookingBtn.enabled = NO;
        [bookingBtn setTitle:@"房满" forState:UIControlStateNormal];
    }
    
    
    // 现价
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(110, popView.frame.size.height - 53, 88, 40)];
    priceLbl.opaque = YES;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    priceLbl.adjustsFontSizeToFitWidth = YES;
    priceLbl.minimumFontSize = 16;
    priceLbl.textColor = [UIColor whiteColor];
    [popView addSubview:priceLbl];
    [priceLbl release];
    priceLbl.text = [NSString stringWithFormat:@"%@%@",self.roomMarkLabel.text,self.roomPriceLabel.text];
    
    
    if (!self.discountPriceLabel.hidden && self.discountPriceLabel.text && ![self.discountPriceLabel.text isEqualToString:@""]) {
        // 原价
        UILabel *discountPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(30, popView.frame.size.height - 54, 60, 40)];
        discountPriceLbl.opaque = YES;
        discountPriceLbl.backgroundColor = [UIColor clearColor];
        discountPriceLbl.font = [UIFont systemFontOfSize:17.0f];
        discountPriceLbl.textAlignment = UITextAlignmentCenter;
        discountPriceLbl.textColor = [UIColor colorWithRed:134/255.0 green:72/255.0 blue:0 alpha:1];
        [popView addSubview:discountPriceLbl];
        [discountPriceLbl release];
        discountPriceLbl.text = [NSString stringWithFormat:@"%@%@",self.discountMarkLabel.text,self.discountPriceLabel.text];
        
        
        // 删除线
        UIView *discountLine = [[UIView alloc] initWithFrame:CGRectMake(30,popView.frame.size.height - 54 + 20, 60, 1)];
        discountLine.backgroundColor = [UIColor colorWithRed:134/255.0 green:72/255.0 blue:0 alpha:1];
        [popView addSubview:discountLine];
        [discountLine release];
    }else{
        priceLbl.frame = CGRectMake(70, popView.frame.size.height - 53, 88, 40);
    }

    popView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 animations:^{
        popView.transform = CGAffineTransformIdentity;
        popView.alpha = 1;
        popMarkView.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)adjustBackView:(BOOL)hasImage giftDes:(NSString *)gift {
    
	self.backView.frame = CGRectMake(1 + 6, 68, 320 - 14, 91);
	bottomShadow.frame	= CGRectMake(0, 79, 320, 12);
	
	if (hasImage) {
		self.roomImg.hidden = NO;
		//self.backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"big_cell_bg.png"]];
	}
	else {
		self.roomImg.hidden = YES;
		CGRect rect = self.backView.frame;
		rect.size.height -= 33;
		self.backView.frame = rect;
		//self.backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_cell_bg.png"]];
		
		bottomShadow.frame = CGRectOffset(bottomShadow.frame, 0, -33);
	}
    
    if (gift && ![gift isEqualToString:@""]) {
        gift = [gift stringByReplacingOccurrencesOfString: @"\r" withString:@""];
        gift = [gift stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        gift = [NSString stringWithFormat:@"礼:%@",gift];
        self.giftBtn.hidden = NO;
        self.couponbtn.frame = CGRectMake(124, 40, 61, 16);
        giftLbl.hidden = NO;
        if (!giftLbl) {
            giftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,100,200,0)];
            giftLbl.backgroundColor	= [UIColor clearColor];
            giftLbl.text				= gift;
            giftLbl.textColor			= [UIColor darkGrayColor];
            giftLbl.font				= FONT_10;
            giftLbl.numberOfLines		= 2;
            giftLbl.lineBreakMode       = NSLineBreakByTruncatingTail;
            [self.backView insertSubview:giftLbl atIndex:0];
            giftLbl.userInteractionEnabled = YES;
            
            giftMoreBtnOther = [UIButton buttonWithType:UIButtonTypeCustom];
            giftMoreBtnOther.frame = giftLbl.bounds;
            [giftLbl addSubview:giftMoreBtnOther];
            [giftMoreBtnOther addTarget:self action:@selector(giftMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            bottomShadow.frame = CGRectOffset(bottomShadow.frame, 0, 28);//newGiftSize.height+ 10);
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, self.backView.frame.size.height +  28);//newGiftSize.height + 10);
        }else{
            
            giftLbl.text = gift;
            
            bottomShadow.frame = CGRectOffset(bottomShadow.frame, 0, 28);//newGiftSize.height+ 10);
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, self.backView.frame.size.height +  28);//newGiftSize.height+ 10);
        }
        CGSize giftSize = CGSizeMake(320 - 24, 1000);
        CGSize newGiftSize =  [gift sizeWithFont:FONT_11 constrainedToSize:giftSize lineBreakMode:NSLineBreakByCharWrapping];
        if (newGiftSize.height > 30) {
            self.giftMoreBtn.hidden = NO;
            if (hasImage) {
                giftLbl.frame = CGRectMake(5,94-4,320 - 55,30);
                self.giftMoreBtn.frame = CGRectMake(320 - 36 - 20 , 104 - 9, 40, 20);
            }else{
                giftLbl.frame = CGRectMake(5,56-4,320 - 55,30);
                self.giftMoreBtn.frame = CGRectMake(320 - 36 - 20, 66 - 9, 40, 20);
            }
        }else{
            self.giftMoreBtn.hidden = YES;
            if (hasImage) {
                giftLbl.frame = CGRectMake(5,94-4,320 - 10 - 14,30);
                self.giftMoreBtn.frame = CGRectMake(320 - 36 - 20, 104 - 9, 40, 20);
            }else{
                giftLbl.frame = CGRectMake(5,56-4,320 - 10 - 14,30);
                self.giftMoreBtn.frame = CGRectMake(320 - 36 - 20, 66 - 9, 40, 20);
            }
        }
    }else{
        self.giftBtn.hidden = YES;
        self.giftMoreBtn.hidden = YES;
        self.couponbtn.frame = CGRectMake(102, 40, 61, 16);
        
        if (giftLbl) {
            giftLbl.hidden = YES;
        }
    }
    
    giftMoreBtnOther.frame = giftLbl.bounds;
    giftMoreBtnOther.hidden = self.giftMoreBtn.hidden;
}


- (void)makeRoomIconsByData:(NSArray *)datas HaveImage:(BOOL)haveImage{
    
	for (NSDictionary *dic in datas) {
		
		if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[0]]) {
			// 早餐说明
			if (!breakfarstView) {
				breakfarstView = [[IconAndTextView alloc] initWithFrame:haveImage ? kBreakfarstIconFrame_V : kBreakfarstIconFrame_H
																iconPath:@"breakfarst_ico.png"
															 textContent:[dic safeObjectForKey:CONTENT]];
                breakfarstView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                breakfarstView.textLabel.backgroundColor =  [UIColor colorWithWhite:240.0/255.0f alpha:1];
                breakfarstView.opaque = YES;
				[self.backView insertSubview:breakfarstView atIndex:0];
                
			}
			else {
				CGRect rect = haveImage ? kBreakfarstIconFrame_V : kBreakfarstIconFrame_H;
				[breakfarstView reSetFrame:rect];
				breakfarstView.textLabel.text = [dic safeObjectForKey:CONTENT];
			}
            
		}
		else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[2]]) {
			// 宽带说明
			if (!netView) {
				netView = [[IconAndTextView alloc] initWithFrame:haveImage ? kNetIconFrame_V : kNetIconFrame_H
															   iconPath:@"net_ico.png"
															textContent:[dic safeObjectForKey:CONTENT]];

                netView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                netView.textLabel.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                netView.opaque = YES;
				[self.backView insertSubview:netView atIndex:0];
			}
			else {
				CGRect rect = haveImage ? kNetIconFrame_V : kNetIconFrame_H;
				[netView reSetFrame:rect];
				netView.textLabel.text = [dic safeObjectForKey:CONTENT];
			}
		}
		else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[3]]) {
			// 面积说明
			if (!areaView) {
				areaView = [[IconAndTextView alloc] initWithFrame:haveImage ? kAreaIconFrame_V : kAreaIconFrame_H
															   iconPath:@"area_ico.png"
															textContent:[dic safeObjectForKey:CONTENT]];
                
                areaView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                areaView.textLabel.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                areaView.opaque = YES;
				[self.backView insertSubview:areaView atIndex:0];
			}
			else {
				CGRect rect = haveImage ? kAreaIconFrame_V : kAreaIconFrame_H;
				[areaView reSetFrame:rect];
				areaView.textLabel.text = [dic safeObjectForKey:CONTENT];
			}
		}
		else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[4]]) {
			// 楼层说明
			if (!floorView) {
				floorView = [[IconAndTextView alloc] initWithFrame:haveImage ? kFloorIconFrame_V : kFloorIconFrame_H
														  iconPath:@"floor_ico.png"
													   textContent:[dic safeObjectForKey:CONTENT]];

                floorView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                floorView.textLabel.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                floorView.opaque = YES;
				[self.backView insertSubview:floorView atIndex:0];
			}
			else {
				CGRect rect = haveImage ? kFloorIconFrame_V : kFloorIconFrame_H;
				[floorView reSetFrame:rect];
				floorView.textLabel.text = [dic safeObjectForKey:CONTENT];
			}
		}
		else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[1]]) {
			// 床型说明
			if (!bedView) {
				bedView = [[IconAndTextView alloc] initWithFrame:haveImage ? kBedIconFrame_V : kBedIconFrame_H
														iconPath:@"bed_ico.png"
													 textContent:[dic safeObjectForKey:CONTENT]];

                bedView.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                bedView.textLabel.backgroundColor = [UIColor colorWithWhite:240.0/255.0f alpha:1];
                bedView.opaque = YES;
				[self.backView insertSubview:bedView atIndex:0];
			}
			else {
				CGRect rect = haveImage ? kBedIconFrame_V : kBedIconFrame_H;
				[bedView reSetFrame:rect];
				bedView.textLabel.text = [dic safeObjectForKey:CONTENT];
			}
		}
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




- (IBAction)booking {
    UMENG_EVENT(UEvent_Hotel_Detail_Booking)
    
	BOOL islogin = [[AccountManager instanse] isLogin];
	[RoomType setCurrentRoomIndex:roomindex];
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:roomindex];
	[[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD_IsCustomerNameEn]
								  forKey:RespHD_IsCustomerNameEn];				// 判断是否需要用户必须选择英文用户名
    [[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD__HotelCoupon_DI]
								  forKey:RespHD__HotelCoupon_DI];				// 优惠券返现

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
            m_netstate = GETCOUPON;
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


-(void)loginsuccess
{
    fromloginsuccess = YES;
}


-(void)registersuccess
{
    m_netstate = GETCOUPON;
    JCoupon *coupon = [MyElongPostManager coupon];
    [[MyElongPostManager coupon] clearBuildData];
    [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
}

-(void)deleteloginvc
{
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
    if (countNO) {
        //fillhotelOrder.SevenDaysString = countNO;
    }
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
    [[Coupon activedcoupons] removeAllObjects];
    [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
    //    [Login jump2fillorder];
    
    // 推入订单填写页面
    [self goHotelFillOrderPage];
}


@end
