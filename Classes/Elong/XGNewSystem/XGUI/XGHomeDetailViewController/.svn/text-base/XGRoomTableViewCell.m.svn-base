//
//  XGRoomTableViewCell.m
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#import "XGRoomTableViewCell.h"
#import "DefineCommon.h"
#import "UIImageView+WebCache.h"

#import "AccountManager.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "LoginManager.h"
#import "XGSpecialProductDetailViewController.h"
#import "XGhomeOrderFillInViewController.h"

#import "UMengEventC2C.h"

#define ROOMTYPELOGIN @"ROOMTYPELOGIN"
#define ROOMTYPERSGISTER @"ROOMTYPERSGISTER"

//#define GOODSFAVORITEAFTERLOGIN @"GOODSFAVORITEAFTERLOGIN"  //登陆成功后发起的通知

@implementation XGRoomTableViewCell
@synthesize room=_room;
-(XGRoomStyle *)room
{
    if (_room ==nil) {
        _room =[[XGRoomStyle alloc] init];
    }
    return _room;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 105);
        
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
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_bottomLineImgView];
    
    // arrow
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(306,(110 - 9)/2, 5, 9)];
    arrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [self.contentView addSubview:arrowImageView];

}

// 酒店信息，酒店名、酒店图片、特惠信息
- (void) makeupHotelInfo{
    //酒店名
    self.hotelNameLbl = [[AttributedLabel alloc] initWithFrame:CGRectMake(11, 8, SCREEN_WIDTH - 20, 33)];
    [self.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
    self.hotelNameLbl.backgroundColor = [UIColor clearColor];
    self.hotelNameLbl.lineBreakMode = UILineBreakModeTailTruncation;
    self.hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.contentView addSubview:self.hotelNameLbl];
    
    
    // 酒店图片
    self.hotelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6+3, 30, 65 + 6, 65 + 6)];
    self.hotelImageView.layer.cornerRadius = 2.0f;
    self.hotelImageView.image= [UIImage imageNamed:@"bg_nohotelpic.png"];
    [self.contentView addSubview:self.hotelImageView];
    
}


// 酒店设施，早餐、宽带、楼层、面积、床型
- (void) makeupHotelFacilities{
    // 设施line0
    self.facilityLine0 = [[UILabel alloc] initWithFrame:CGRectMake(88, 32, 200, 14)];
    self.facilityLine0.font = [UIFont systemFontOfSize:11.0f];
    self.facilityLine0.textColor = RGBACOLOR(102, 102, 102, 1);
    self.facilityLine0.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.facilityLine0];
    
    // 设施line1
    self.facilityLine1 = [[UILabel alloc] initWithFrame:CGRectMake(88, 50, 200, 14)];
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
    [self.bookingBtn setTitle:@"预 订" forState:UIControlStateNormal];
    [self.bookingBtn addTarget:self action:@selector(booking) forControlEvents:UIControlEventTouchUpInside];
    
    self.bookingBtn.titleLabel.font	= FONT_B14;
    self.bookingBtn.frame			= CGRectMake(208.5, 65, 95, 35);
    self.bookingBtn.exclusiveTouch  = YES;
    [self.contentView addSubview:self.bookingBtn];
    
    // 预付图标
    self.prepayIcon = [[UIView alloc] initWithFrame:CGRectMake(210.5, 66, 18, 33)];
    self.prepayIcon.backgroundColor = [UIColor whiteColor];

    UILabel *upLable=[[UILabel alloc] initWithFrame:CGRectMake(0 , 0  , self.prepayIcon.width , 16.6)];
    upLable.textColor =  RGBACOLOR(235, 69, 24, 1);
    upLable.font = [UIFont boldSystemFontOfSize:13.0f];
    upLable.text = @"预";
    upLable.textAlignment =NSTextAlignmentCenter;
    upLable.backgroundColor =[UIColor clearColor];
    
    UILabel *downLable=[[UILabel alloc] initWithFrame:CGRectMake(0 , 16.5  , self.prepayIcon.width , 16.5)];
    downLable.textColor =  RGBACOLOR(235, 69, 24, 1);
    downLable.textAlignment =NSTextAlignmentCenter;
    downLable.font = [UIFont boldSystemFontOfSize:13.0f];
    downLable.text = @"付";
    downLable.backgroundColor =[UIColor clearColor];
    [self.prepayIcon  addSubview:upLable];
    [self.prepayIcon  addSubview:downLable];
    [self.contentView addSubview:self.prepayIcon];
    
    // 现价货币符号
    self.priceMarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(215, 15 + 20, 40, 18)];
    self.priceMarkLbl.opaque = YES;
    self.priceMarkLbl.backgroundColor = [UIColor whiteColor];
    self.priceMarkLbl.font = [UIFont systemFontOfSize:12.0f];
    self.priceMarkLbl.textColor = RGBACOLOR(108, 108, 108, 1);
    self.priceMarkLbl.adjustsFontSizeToFitWidth = YES;
    self.priceMarkLbl.text = @"¥";
    self.priceMarkLbl.minimumFontSize = 10.0f;
    [self.contentView addSubview:self.priceMarkLbl];
    self.priceMarkLbl.backgroundColor = [UIColor clearColor];
    self.priceMarkLbl.textAlignment = UITextAlignmentRight;
    
    // 现价
    self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(247, 14 + 18, 55, 20)];
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
//    self.discountPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(180, 34, 50, 17)];
//    self.discountPriceLbl.opaque = YES;
//    self.discountPriceLbl.textAlignment = UITextAlignmentCenter;
//    self.discountPriceLbl.backgroundColor = [UIColor clearColor];
//    self.discountPriceLbl.font = [UIFont systemFontOfSize:12.0f];
//    self.discountPriceLbl.textColor = [UIColor colorWithWhite:160.0f/255.0f alpha:1];
//    [self.contentView addSubview:self.discountPriceLbl];
//    
//    UIImageView *discountLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, self.discountPriceLbl.frame.size.width-16, 1)];
//    discountLine.image = [UIImage noCacheImageNamed:@"single_line.png"];
    //[self.discountPriceLbl addSubview:discountLine];

}


#pragma mark -- 触发的方法


-(void)booking{
    
    if (!self.bookingBtn.enabled) {
        return;
    }
    
    self.clickboockBlock(self.roomindex);
}


- (NSString *) renameFacility:(NSString *)facility{
    if ([facility isEqualToString:@"未知"]) {
        return @"";
    }
    if ([facility isEqualToString:@"无"]) {
        return @"";
    }
    return facility;
}

-(void)setValueByModelDictionary:(NSDictionary *)dict//设置Room信息
{
    self.roomDict =dict;
    [self.room convertObjectFromGievnDictionary:dict];
    
    // 酒店图片
    if ( STRINGHASVALUE(self.room.PicUrl)) {
        [self.hotelImageView setImageWithURL:[NSURL URLWithString:self.room.PicUrl] placeholderImage:[UIImage noCacheImageNamed:@"bg_nohotelpic.png"]];
    }else{
        self.hotelImageView.image = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
        
    }
    // 房型设施
    self.facilityLine0.text = @"";
    self.facilityLine1.text = @"";
    NSString *breakfastStr=@"",*networkStr=@"",*areaStr=@"",*floorStr = @"",*newBedStr = @"";
    
            // 早餐说明
    breakfastStr = self.room.breakfast;// [dic safeObjectForKey:@"Content"];        }
    // 宽带说明
    networkStr =self.room.network;//  [dic safeObjectForKey:@"Content"];
    // 面积说明
    areaStr = self.room.area;// [dic safeObjectForKey:@"Content"];
    floorStr =self.room.floor;// [floorStr stringByReplacingOccurrencesOfString:@"，" withString:@"/"];
    // 楼层说明
    // 床型说明
    NSArray *exclusiveArray = [NSArray arrayWithObjects:@"90",@"100",@"105",@"110",@"120",@"130",@"135",@"140",@"145",@"150",@"155",@"160",@"165",@"180",@"186",@"200",@"210",@"220",@"230",@"240",@"250",@"260",@"270",@"280",@"cm",@"*",@"(",@")",@"（",@"）", nil];
    NSString *bedStr = self.room.bed;// [dic safeObjectForKey:@"Content"];
    newBedStr =  bedStr;
    for (NSString *str in exclusiveArray) {
        newBedStr = [newBedStr stringByReplacingOccurrencesOfString:str withString:@""];
    }
            //可入住人数
    //    personnumStr = self.room.personnum;
    //        //房间类型
    //    roomtype =self.room.roomtype;
    
    // 酒店名
    NSString *formerText = [self.room getRoomTypeFormerTextByAdditionInfoList];
    NSString *roomTypeTips = [self.room roomTypeTips];// [self roomTypeTips:guestType];
    
    self.hotelNameLbl.text = @"";
    if (![roomTypeTips isEqualToString:@""]) {
        self.hotelNameLbl.text = [NSString stringWithFormat:@"%@ %@",formerText,roomTypeTips];
        [self.hotelNameLbl setColor: RGBACOLOR(153, 153, 153, 1) fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:formerText.length];
        [self.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:12.0f] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }else{
        self.hotelNameLbl.text = formerText;
        [self.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:self.hotelNameLbl.text.length];
        [self.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:self.hotelNameLbl.text.length];
    }
    
    self.facilityLine0.text = [NSString stringWithFormat:@"%@  %@  %@",[self renameFacility:breakfastStr],[self renameFacility:newBedStr],[self renameFacility:networkStr]];
    self.facilityLine1.text = [NSString stringWithFormat:@"%@  %@",[self renameFacility:areaStr],[self renameFacility:floorStr]];
    
    
    // 返现和立减，预付显示
    if ([self.room.PayType intValue] == 0) {  //到店付
        self.prepayIcon.hidden = YES;
    }
    else {  //预付
        self.prepayIcon.hidden = NO;
    }
    
    //都是人民币
    self.priceMarkLbl.text=CURRENCY_RMBMARK;
    //取汇率
    //    float exchangeRate=[[room safeObjectForKey:@"ExchangeRate"] floatValue];
    
    // 现价
    //    float avgPrice=[[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
    //    cell.priceLbl.text = [NSString stringWithFormat:@"%.f",exchangeRate>0?avgPrice*exchangeRate:avgPrice];
    
    float finalPrice = [self.room.FinalPrice floatValue];
    self.priceLbl.text = [NSString stringWithFormat:@"%.0f",finalPrice];
    
    
    if (self.priceLbl.text.length == 1) {
        self.priceMarkLbl.frame = CGRectMake(215 + 30, 15 + 20, 40, 18);
    }else if (self.priceLbl.text.length == 2) {
        self.priceMarkLbl.frame = CGRectMake(215 + 20, 15 + 20, 40, 18);
    }else if(self.priceLbl.text.length == 3){
        self.priceMarkLbl.frame = CGRectMake(215 + 10, 15 + 20, 40, 18);
    }else if(self.priceLbl.text.length == 4){
        self.priceMarkLbl.frame = CGRectMake(215, 15 + 20, 40, 18);
    }else if(self.priceLbl.text.length == 5){
        self.priceMarkLbl.frame = CGRectMake(215 - 10, 15 + 20, 40, 18);
    }else if (self.priceLbl.text.length ==6 ){
        self.priceMarkLbl.frame = CGRectMake(215 - 15, 15 + 20, 40, 18);
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
