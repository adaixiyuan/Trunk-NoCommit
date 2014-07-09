//
//  InterRoomCell.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterRoomCell.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface InterRoomCell ()

@property(nonatomic,retain) UIImageView *dashLine;      //分割线
@property(nonatomic,retain) UIImageView *promotionNoteImg;  //促销图
@property(nonatomic,retain) UILabel *promotionNoteLabel;        //促销文字提示
@property(nonatomic,retain) UIButton *bookingBtn;       //预订按钮

@property(nonatomic,retain) UIImageView *originPriceLine;   //划掉原价的线
@property(nonatomic,retain) UILabel *originPriceLabel;      //原价
@property(nonatomic,retain) UILabel *actualPriceLabel;      //实际价
@property(nonatomic,retain) UILabel *actualPriceNote;       //¥符号
@property(nonatomic,retain) UILabel *remainRoomNumLabel;    //剩余房间
@property(nonatomic,retain) UIImageView *arrowView;

@property(nonatomic,retain) UIImageView *cashDiscountIcon;
@property(nonatomic,retain) UILabel *cashDiscountLbl;
@property(nonatomic,retain) UIImageView *giftCardImgView;        //预付卡
@property(nonatomic,retain) UILabel *giftAmountLabel;       //预付卡金额


-(void)prepareRoomInfo;     //准备房间信息内容
-(void)prepareRoomPrice;        //准备房间价格信息以及预订按钮
-(void)bookTheRoom;     //点击预订按钮

@end

@implementation InterRoomCell
@synthesize delegate;
@synthesize cellHeight;
@synthesize dashLine;
@synthesize roomNameLabel,roomIconImg;
@synthesize breakfastLabel,smokeLabel,bedTypeLabel,netTypeLabel,originPriceLabel,actualPriceLabel,actualPriceNote,remainRoomNumLabel;
@synthesize promotionNoteImg,promotionNoteLabel;
@synthesize bookingBtn;
@synthesize originPriceLine;
@synthesize isAllowBooking;
@synthesize arrowView;
@synthesize cashDiscountIcon;
@synthesize cashDiscountLbl;

static int currentRoomIndex = 0;
+(int)currentSelectedRoomIndex{
    return currentRoomIndex;
}

+(void)setSelectedRoomIndex:(int)index{
    currentRoomIndex = index;
}

- (void)dealloc
{
    [dashLine release];
    [roomNameLabel release];
    [roomIconImg release];
    [breakfastLabel release];
    [smokeLabel release];
    [bedTypeLabel release];
    [netTypeLabel release];
    [originPriceLabel release];
    [actualPriceLabel release];
    [remainRoomNumLabel release];
    [actualPriceNote release];
    [promotionNoteImg release];
    [promotionNoteLabel release];
    [originPriceLine release];
    [arrowView release];
    self.cashDiscountLbl = nil;
    self.cashDiscountIcon = nil;
    self.giftCardImgView = nil;
    self.giftAmountLabel = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //dashLine 分割线
        if(!dashLine){
            dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, 150-1, 288, 1)];
        }
        self.dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.dashLine];
    
        [self prepareRoomInfo];//准备房间信息内容
        [self prepareRoomPrice]; //准备房间价格信息以及预订按钮
        
        if(!arrowView){
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(287, (150 - 12)/2, 8, 12)];
            arrowView.contentMode = UIViewContentModeCenter;
        }
        self.arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [self.contentView addSubview:self.arrowView];
    }
    return self;
}

//设置Cell高度
-(void)setCellHeight:(float)height{
    self.dashLine.frame = CGRectMake(0, height-0.5, SCREEN_WIDTH, 0.5);
    self.arrowView.frame = CGRectMake(SCREEN_WIDTH - 16, 0, 8, height);
}

#pragma mark - UI Methods
//准备房间信息内容
-(void)prepareRoomInfo{
    //房间名称
    if(!roomNameLabel){
        roomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 291, 40)];
    }
    self.roomNameLabel.backgroundColor = [UIColor clearColor];
    self.roomNameLabel.font = [UIFont systemFontOfSize:15];
    self.roomNameLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.roomNameLabel.numberOfLines = 2;
    self.roomNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.contentView addSubview:self.roomNameLabel];
    //房间Icon
    if(!roomIconImg){
        roomIconImg = [[RoundCornerView alloc] initWithFrame:CGRectMake(6, 44, 80, 80)];
        roomIconImg.imageRadius = 2.0f;
    }
    [self.contentView addSubview:self.roomIconImg];
    //吸烟房
    if(!smokeLabel){
        smokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 44, 200, 21)];
    }
    self.smokeLabel.backgroundColor = [UIColor clearColor];
    self.smokeLabel.font = [UIFont systemFontOfSize:11];
    self.smokeLabel.textColor = RGBACOLOR(102, 102, 102, 1);
    [self.contentView addSubview:self.smokeLabel];
    //网络
    if(!netTypeLabel){
        netTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 84, 200, 21)];
    }
    self.netTypeLabel.backgroundColor = [UIColor clearColor];
    self.netTypeLabel.font = [UIFont systemFontOfSize:11];
    self.netTypeLabel.textColor = RGBACOLOR(102, 102, 102, 1);
    [self.contentView addSubview:self.netTypeLabel];
    
    //早餐
    if(!breakfastLabel){
        breakfastLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 64, 200, 21)];
    }
    self.breakfastLabel.backgroundColor = [UIColor clearColor];
    self.breakfastLabel.font = [UIFont systemFontOfSize:11];
    self.breakfastLabel.textColor = RGBACOLOR(102, 102, 102, 1);
    [self.contentView addSubview:self.breakfastLabel];

    //床型
    if(!bedTypeLabel){
        bedTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 104, 200, 21)];
    }
    self.bedTypeLabel.backgroundColor = [UIColor clearColor];
    self.bedTypeLabel.font = [UIFont systemFontOfSize:11];
    self.bedTypeLabel.textColor = RGBACOLOR(102, 102, 102, 1);
    [self.contentView addSubview:self.bedTypeLabel];

    //促销图
    if(!promotionNoteImg){
        promotionNoteImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 131, 14, 14)];
    }
    self.promotionNoteImg.image = [UIImage noCacheImageNamed:@"promotion_ico.png"];
    [self.contentView addSubview:self.promotionNoteImg];
    //促销提示
    if(!promotionNoteLabel){
        promotionNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 129, 276, 18)];
    }
    self.promotionNoteLabel.backgroundColor = [UIColor clearColor];
    self.promotionNoteLabel.textColor = [UIColor colorWithRed:0 green:160.0/255.0 blue:64.0/255.0 alpha:1];
    self.promotionNoteLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:self.promotionNoteLabel];

    
}

 //准备房间价格信息以及预订按钮
-(void)prepareRoomPrice{
    //原价
    if(!originPriceLabel){
        originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 46, 55, 21)];
    }
    self.originPriceLabel.backgroundColor = [UIColor clearColor];
    self.originPriceLabel.textAlignment = NSTextAlignmentCenter;
    self.originPriceLabel.textColor = RGBACOLOR(184, 184, 184, 1);
    self.originPriceLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.originPriceLabel];
    
    //原价线
    if(!originPriceLine){
        originPriceLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, originPriceLabel.frame.size.height/2, originPriceLabel.frame.size.width - 16, 1)];
    }
    self.originPriceLine.image = [UIImage noCacheImageNamed:@"single_line.png"];
    [originPriceLabel addSubview:self.originPriceLine];
    

    //实际价格
    if(!actualPriceLabel){
        actualPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 26, 46 , 60, 20)];
    }
    self.actualPriceLabel.backgroundColor = [UIColor clearColor];
    self.actualPriceLabel.textAlignment = NSTextAlignmentRight;
    self.actualPriceLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.actualPriceLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    [self.contentView addSubview:self.actualPriceLabel];
    if(!actualPriceNote){
        actualPriceNote = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 20, 52, 10, 14)];
    }
    self.actualPriceNote.backgroundColor = [UIColor clearColor];
    self.actualPriceNote.textAlignment = NSTextAlignmentRight;
    self.actualPriceNote.font = [UIFont systemFontOfSize:12];
    self.actualPriceNote.textColor = RGBACOLOR(254, 75, 32, 1);
    self.actualPriceNote.text = @"¥";
    [self.contentView addSubview:self.actualPriceNote];
    
    
    // 返现
    self.cashDiscountIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 72, 14, 12)] autorelease];
    cashDiscountIcon.image = [UIImage noCacheImageNamed:@"fanxian_icon.png"];
    [self.contentView addSubview:cashDiscountIcon];
    
    self.cashDiscountLbl = [[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 26, 72, 60, 13)] autorelease];
    cashDiscountLbl.backgroundColor = [UIColor clearColor];
    cashDiscountLbl.textColor =  RGBACOLOR(254, 75, 32, 1);
    cashDiscountLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    cashDiscountLbl.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:cashDiscountLbl];
    
    //预付卡
    self.giftCardImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 72, 14, 12)] autorelease];
    _giftCardImgView.image = [UIImage noCacheImageNamed:@"giftcard_icon.png"];
    [self.contentView addSubview:_giftCardImgView];
    
    self.giftAmountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 26, 72, 60, 13)] autorelease];
    _giftAmountLabel.backgroundColor = [UIColor clearColor];
    _giftAmountLabel.textColor = RGBACOLOR(252, 152, 44, 1);
    _giftAmountLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _giftAmountLabel.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:_giftAmountLabel];
    
    //预订按钮
    if(!bookingBtn){
        bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [self.bookingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
    [self.bookingBtn setTitle:@"房满" forState:UIControlStateDisabled];
    [self.bookingBtn addTarget:self action:@selector(bookTheRoom) forControlEvents:UIControlEventTouchUpInside];
    self.bookingBtn.titleLabel.font	= FONT_B14;
    self.bookingBtn.frame			= CGRectMake(SCREEN_WIDTH - 56 - 26, 94, 56, 25);
    
    self.bookingBtn.exclusiveTouch = YES;

    UIButton *innerBookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    innerBookingBtn.exclusiveTouch  = YES;
    innerBookingBtn.frame = CGRectMake(SCREEN_WIDTH - 240/2, 0, 240/2, 220/2);
    [innerBookingBtn addTarget:self action:@selector(bookTheRoom) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:innerBookingBtn];
    
    [self.contentView addSubview:self.bookingBtn];
    
    //剩余房间提示
    if(!remainRoomNumLabel){
        remainRoomNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 104, 125, 21)];
    }
    self.remainRoomNumLabel.backgroundColor = [UIColor clearColor];
    self.remainRoomNumLabel.font = [UIFont systemFontOfSize:11];
    self.remainRoomNumLabel.textColor = RGBACOLOR(210, 70, 36, 1);
    self.remainRoomNumLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.remainRoomNumLabel];
    
}

//该房间是否允许预订
-(void)setIsAllowBooking:(BOOL)allowBooking{
    isAllowBooking = allowBooking;
    self.bookingBtn.enabled = isAllowBooking;
}

//默认UI设置，就是隐藏该隐藏的
-(void)defaultUISetting{
    self.promotionNoteImg.hidden = YES;     
    self.promotionNoteLabel.hidden = YES;
    self.originPriceLabel.hidden = YES;     
    self.originPriceLine.hidden = YES;      
    self.remainRoomNumLabel.hidden = YES;
    
    self.roomIconImg.hidden = NO;
    self.smokeLabel.frame = CGRectMake(95, 44, 200, 21);
    self.netTypeLabel.frame = CGRectMake(95, 84, 200, 21);
    self.breakfastLabel.frame = CGRectMake(95, 64, 200, 21);
    self.bedTypeLabel.frame = CGRectMake(95, 104, 200, 21);
    
}

//无房型图片设置
-(void)noneIconUISetting{
    self.roomIconImg.hidden = YES;
    self.smokeLabel.frame = CGRectMake(15, 44, 205, 21);
    self.netTypeLabel.frame = CGRectMake(15, 84, 205, 21);
    self.breakfastLabel.frame = CGRectMake(15, 64, 205, 21);
    self.bedTypeLabel.frame = CGRectMake(15, 104, 205, 21);
}

 //原价
-(void)setOriginPrice:(NSString *)originPrice{
    self.originPriceLabel.hidden = NO;
    self.originPriceLine.hidden = NO;
    self.originPriceLabel.text = originPrice;
}

// 返现
- (void) setDiscountPrice:(CGFloat)price{
    if (price > 0) {
        cashDiscountLbl.text = [NSString stringWithFormat:@"¥ %.0f", price];
        cashDiscountIcon.hidden = NO;
    }
    else {
        cashDiscountLbl.text = @"";
        cashDiscountIcon.hidden = YES;
    }
}

// 预付卡
-(void)setGiftCardPrice:(float)price{
    if (price > 0) {
        _giftAmountLabel.text = [NSString stringWithFormat:@"¥ %.0f", price];
        _giftCardImgView.hidden = NO;
    }
    else {
        _giftAmountLabel.text = @"";
        _giftCardImgView.hidden = YES;
    }
}


//折价 ，传入时，不用带入价格符号
-(void)setActualPrice:(NSString *)actualPrice{
    self.actualPriceLabel.text = actualPrice;
    if (actualPrice.length == 2) {
        actualPriceNote.frame = CGRectMake(SCREEN_WIDTH - 60 - 20 + 20, 52, 10, 14);
    }else if(actualPrice.length == 3){
        actualPriceNote.frame = CGRectMake(SCREEN_WIDTH - 60 - 20 + 10, 52, 10, 14);
    }else if (actualPrice.length == 4) {
        actualPriceNote.frame = CGRectMake(SCREEN_WIDTH - 60 - 20, 52, 10, 14);
    }else if (actualPrice.length == 5){
        actualPriceNote.frame = CGRectMake(SCREEN_WIDTH - 60 - 20 - 10, 52, 10, 14);
    }
}


//促销信息
-(void)setPromotionNote:(NSString *)promotionNote{
    self.promotionNoteImg.hidden = NO;
    self.promotionNoteLabel.hidden = NO;
    self.promotionNoteLabel.text = promotionNote;
}

//显示剩余房间
-(void)setRemainRoomNum:(int)num{
    self.remainRoomNumLabel.hidden = NO;
    self.remainRoomNumLabel.text = [NSString stringWithFormat:@"仅剩 %d 间",num];
}

#pragma mark -Action Methods
//点击预订按钮
-(void)bookTheRoom{
    if (!self.bookingBtn.enabled) {
        return;
    }
    
    [self.bookingBtn setHighlighted:NO];

    [InterRoomCell setSelectedRoomIndex:self.tag];  //记录预订房间的索引
    
    if([delegate respondsToSelector:@selector(bookingRoom)]){
        [delegate bookingRoom];
    }
}

@end
