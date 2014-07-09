//
//  GrouponItemCell.m
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponItemCell.h"
#import "StarsView.h"

@implementation GrouponItemCell
@synthesize hotelId;
@synthesize hotelImageView;

- (void) dealloc{
    self.hotelId = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 酒店名
        hotelNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 5, 304, 18)];
        hotelNameLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        hotelNameLbl.textColor=RGBACOLOR(52, 52, 52, 1);
        hotelNameLbl.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:hotelNameLbl];
        [hotelNameLbl release];
        
        // 酒店图片
        hotelImageView	= [[UIImageView alloc] initWithFrame:CGRectMake(9, 31, 91, 80)];
        hotelImageView.clipsToBounds = YES;
        [self.contentView addSubview:hotelImageView];
        [hotelImageView release];
        
        //黑的一条填充
        UIImageView *grouponNumBg=[[UIImageView alloc] init];
        grouponNumBg.image=[UIImage noCacheImageNamed:@"grouponListCellImgBg.png"];
        grouponNumBg.alpha=0.6;
        grouponNumBg.frame=CGRectMake(0, hotelImageView.frame.size.height-15, hotelImageView.frame.size.width, 15);
        grouponNumBg.contentMode=UIViewContentModeScaleToFill;
        [hotelImageView addSubview:grouponNumBg];
        [grouponNumBg release];
        
        // 团购量
        grouponNumLbl = [[UILabel alloc] init];
        grouponNumLbl.frame=grouponNumBg.bounds;
		grouponNumLbl.backgroundColor	= [UIColor clearColor];
        grouponNumLbl.textAlignment=NSTextAlignmentLeft;
        grouponNumLbl.textColor = [UIColor whiteColor];
        grouponNumLbl.font = [UIFont systemFontOfSize:12.0f];
		grouponNumLbl.adjustsFontSizeToFitWidth = YES;
		grouponNumLbl.minimumFontSize	= 10.0f;
        [grouponNumBg addSubview:grouponNumLbl];
        [grouponNumLbl release];
        
        // 特价图标
        discountImgTmp = [[UIImageView alloc] initWithFrame:CGRectMake(110, 31, 40, 12)];
        discountImgTmp.image = [UIImage imageNamed:@"mobilePriceListIcon.png"];
        discountImgTmp.clipsToBounds = YES;
        discountImgTmp.contentMode = UIViewContentModeTopRight;
        [self.contentView addSubview:discountImgTmp];
        [discountImgTmp release];
        
        //星级
        starLbl = [[UILabel alloc] initWithFrame:CGRectMake(109, 54, 120, 15)];
		starLbl.backgroundColor	= [UIColor clearColor];
        starLbl.textAlignment=NSTextAlignmentLeft;
        starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        starLbl.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:starLbl];
        [starLbl release];
        
        // 地标
        poiLbl = [[UILabel alloc] initWithFrame:CGRectMake(109, 77, SCREEN_WIDTH-109-10, 15)];
        poiLbl.backgroundColor=[UIColor clearColor];
        poiLbl.font = [UIFont systemFontOfSize:12.0f];
        poiLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        poiLbl.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:poiLbl];
        [poiLbl release];
        
        //团购结构化数据
        grouponAddtionInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(109, 99, SCREEN_WIDTH-109-10, 15)];
		grouponAddtionInfoLbl.clipsToBounds		= NO;
		grouponAddtionInfoLbl.backgroundColor	= [UIColor clearColor];
        grouponAddtionInfoLbl.textAlignment=NSTextAlignmentLeft;
        grouponAddtionInfoLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        grouponAddtionInfoLbl.font = [UIFont systemFontOfSize:12.0f];
        //		grouponAddtionInfoLbl.adjustsFontSizeToFitWidth = YES;
        //		grouponAddtionInfoLbl.minimumFontSize	= 10.0f;
        [self.contentView addSubview:grouponAddtionInfoLbl];
        [grouponAddtionInfoLbl release];
        
        
        //团购卖价
        salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5-42, 120/2 - 10, 40, 20)];
        salePriceLbl.backgroundColor=[UIColor clearColor];
        salePriceLbl.font = [UIFont boldSystemFontOfSize:23.0f];
        salePriceLbl.adjustsFontSizeToFitWidth = YES;
        salePriceLbl.textAlignment = NSTextAlignmentLeft;
        salePriceLbl.minimumFontSize = 14.0f;
        salePriceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
        [self.contentView addSubview:salePriceLbl];
        [salePriceLbl release];
        
        UILabel *salMarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(salePriceLbl.frame.origin.x-3-8, salePriceLbl.frame.origin.y+3, 10, 20)];
        salMarkLbl.backgroundColor = [UIColor clearColor];
        salMarkLbl.text = @"¥";
        salMarkLbl.font = [UIFont systemFontOfSize:13.0f];
        salMarkLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        salMarkLbl.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:salMarkLbl];
        [salMarkLbl release];
        
        //原价符号
        orgPriceHintLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(205, 120/2 - 7, 30, 20)];
        orgPriceHintLabelTmp.textColor = RGBACOLOR(119, 119, 119, 1);
        orgPriceHintLabelTmp.font = [UIFont systemFontOfSize:12.0f];
        orgPriceHintLabelTmp.textAlignment = NSTextAlignmentLeft;
        orgPriceHintLabelTmp.text = @"¥";
        orgPriceHintLabelTmp.clipsToBounds=NO;
        orgPriceHintLabelTmp.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:orgPriceHintLabelTmp];
        [orgPriceHintLabelTmp release];
        
        // 原价
        orgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(217, 120/2 - 7 , 30 , 20)];
        orgPriceLabel.textColor = RGBACOLOR(119, 119, 119, 1);
        orgPriceLabel.font = [UIFont systemFontOfSize:13.0f];
        orgPriceLabel.textAlignment = NSTextAlignmentLeft;
        orgPriceLabel.adjustsFontSizeToFitWidth = YES;
        orgPriceLabel.minimumFontSize = 10.0f;
        orgPriceLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:orgPriceLabel];
        [orgPriceLabel release];
        
        //划价
        orgPriceLine = [[UIImageView alloc] initWithFrame:CGRectMake(-2, orgPriceLabel.frame.size.height/2.0, 48, 1)];
        orgPriceLine.image = [UIImage noCacheImageNamed:@"single_line.png"];
        [orgPriceHintLabelTmp addSubview:orgPriceLine];
        [orgPriceLine release];
        
        // 右箭头
        UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5, 120/2 - 4, 5, 9)];
        rightArrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [self.contentView addSubview:rightArrowImageView];
        [rightArrowImageView release];
        
        // 分割线
        UIImageView *splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        splitImageView.frame = CGRectMake(0, 120 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        splitImageView.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:splitImageView];
        [splitImageView release];
        
        return self;
        
        
    }
    return self;
}

//设置附加信息
-(void) setGrouponAddtionInfoLbl:(NSString *) desp
{
    if (STRINGHASVALUE(desp))
    {
        grouponAddtionInfoLbl.text=desp;
    }
    else
    {
        grouponAddtionInfoLbl.text=@"";
    }
}

- (void) setHotelImage:(UIImage *)image{
    hotelImageView.image = image;
}

- (void) setHotelName:(NSString *)hotelName{
    hotelNameLbl.text = hotelName;
}

- (void) setSalePrice:(NSString *)price{
    salePriceLbl.text = price;
}

-(void) setStarLbl:(int) starCode
{
    if (starCode<10) {
        starCode*=10;
    }
    
    starLbl.text=[PublicMethods getStar:starCode];
}

- (void) setGrouponNum:(NSString *)grouponNum
{
    grouponNumLbl.text = [NSString stringWithFormat:@" %@",grouponNum];
}

- (void) setOrgPrice:(NSString *)price{
    
    if (STRINGHASVALUE(price)) {
        orgPriceHintLabelTmp.hidden=NO;
    }
    else
    {
        orgPriceHintLabelTmp.hidden=YES;
    }
    
    orgPriceLabel.text = price;
    CGSize titleSize = [orgPriceLabel.text sizeWithFont:orgPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    if (STRINGHASVALUE(price)&&[price intValue] >=10000)
    {
        titleSize.width-=7;
    }
    orgPriceLine.frame=CGRectMake(orgPriceLine.frame.origin.x, orgPriceLine.frame.origin.y, 191-179+2*2+titleSize.width, orgPriceLine.frame.size.height);
}

- (void) setPoi:(NSString *)poi{
    poiLbl.text = poi;
}

-(void) setDiscountImgTmp:(BOOL) isDis
{
    discountImgTmp.hidden=!isDis;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        
        for (UIView *subview2 in subview.subviews) {
            
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                
                [subview bringSubviewToFront:subview2];
                
            }
        }
    }
}

@end
