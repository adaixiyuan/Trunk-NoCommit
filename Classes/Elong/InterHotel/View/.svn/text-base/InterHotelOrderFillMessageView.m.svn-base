//
//  InterHotelOrderFillMessageView.m
//  ElongClient
//
//  Created by 赵岩 on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderFillMessageView.h"

#define WIDTH SCREEN_WIDTH
#define DEFAULT_HEIGHT  (215)

@interface InterHotelOrderFillMessageView ()

@property (nonatomic ,retain) UILabel *priceL;
@property (nonatomic, retain) UILabel *priceR;
@property (nonatomic, retain) UILabel *taxL;
@property (nonatomic, retain) UILabel *taxR;
@property (nonatomic, retain) UILabel *priceTotal;
@property (nonatomic, retain) UILabel *priceSaveL;
@property (nonatomic, retain) UILabel *priceSave;
@property (nonatomic, retain) UILabel *priceSaveR;
@property (nonatomic, assign) NSUInteger posY;
@property (nonatomic, retain) UILabel *priceDiscount;
@property (nonatomic, retain) UILabel *priceDiscountTips;

@end

@implementation InterHotelOrderFillMessageView

- (void)dealloc
{
    [_contentView release];
    [_priceL release];
    [_priceR release];
    [_taxL release];
    [_taxR release];
    [_priceTotal release];
    [_priceSave release];
    self.priceDiscount = nil;
    self.priceDiscountTips = nil;
    self.discountTips = nil;
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, SCREEN_SCALE)];
        splitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [_contentView addSubview:splitView];
        [splitView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH - 32, 44)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        [_contentView addSubview:titleLabel];
        [titleLabel release];
        
        NSUInteger posY = 60;
        //房价
        UILabel *roomNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(16, posY, 90, 18)];
        roomNoteLB.backgroundColor = [UIColor clearColor];
        roomNoteLB.textColor = [UIColor blackColor];
        roomNoteLB.font = [UIFont systemFontOfSize:14];
        roomNoteLB.text = @"房费";
        roomNoteLB.textColor = RGBACOLOR(93, 93, 93, 1);
        [_contentView addSubview:roomNoteLB];
        [roomNoteLB release];
        
        
        
        UILabel *roomPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(100, posY, 200, 18)];
        roomPriceLB.backgroundColor = [UIColor clearColor];
        roomPriceLB.textColor = [UIColor colorWithRed:0.3882 green:0.3882 blue:0.3882 alpha:1.0];
        roomPriceLB.font = [UIFont systemFontOfSize:12];
        roomPriceLB.text = [NSString stringWithFormat:@"¥%.2f x %d晚 x %d间", _roomPrice, _nightCount, _roomCount];
        self.priceL = roomPriceLB;
        [_contentView addSubview:roomPriceLB];
        [roomPriceLB release];

        
        UILabel *roomPrice = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 96, posY, 80, 18)];
        roomPrice.backgroundColor = [UIColor clearColor];
        roomPrice.textColor =  RGBACOLOR(254, 75, 32, 1);
        roomPrice.font = [UIFont boldSystemFontOfSize:15];
        roomPrice.textAlignment = NSTextAlignmentRight;
        roomPrice.text = [NSString stringWithFormat:@"¥%.2f", _roomPrice*_nightCount*_roomCount];
        self.priceR = roomPrice;
        [_contentView addSubview:roomPrice];
        [roomPrice release];
        
        posY += 30;
        
        
        //税费
        UILabel *taxNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(16, posY, 90, 18)];
        taxNoteLB.backgroundColor = [UIColor clearColor];
        taxNoteLB.textColor = [UIColor blackColor];
        taxNoteLB.font = [UIFont systemFontOfSize:14];
        taxNoteLB.text = @"税&服务费";
        taxNoteLB.textColor = RGBACOLOR(93, 93, 93, 1);
        [_contentView addSubview:taxNoteLB];
        [taxNoteLB release];
        
        
        UILabel *taxFeeLB = [[UILabel alloc] initWithFrame:CGRectMake(100, posY, 286-71, 18)];
        taxFeeLB.backgroundColor = [UIColor clearColor];
        taxFeeLB.textColor = [UIColor colorWithRed:0.3882 green:0.3882 blue:0.3882 alpha:1.0];
        taxFeeLB.font = [UIFont systemFontOfSize:12];
        float price = _taxAndFee*_roomCount*_nightCount;
        taxFeeLB.text = [NSString stringWithFormat:@"¥%.2f x %d晚 x %d间",_taxAndFee,_nightCount,_roomCount];
        self.taxL = taxFeeLB;
        [_contentView addSubview:taxFeeLB];
        [taxFeeLB release];
        
        UILabel *taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 96, posY, 80, 18)];
        taxPrice.backgroundColor = [UIColor clearColor];
        taxPrice.textColor = RGBACOLOR(254, 75, 32, 1);
        taxPrice.font = [UIFont boldSystemFontOfSize:15];
        taxPrice.textAlignment = NSTextAlignmentRight;
        taxPrice.text = [NSString stringWithFormat:@"¥%.2f", price];
        self.taxR = taxPrice;
        [_contentView addSubview:taxPrice];
        [taxPrice release];
        
        posY += 30;
    
        
        UILabel *orderPriceNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(16, posY, 140, 18)];
        orderPriceNoteLB.backgroundColor = [UIColor clearColor];
        orderPriceNoteLB.textColor = [UIColor blackColor];
        orderPriceNoteLB.font = [UIFont systemFontOfSize:14];
        orderPriceNoteLB.text = @"总价(含税和服务费)";
        orderPriceNoteLB.textColor = RGBACOLOR(93, 93, 93, 1);
        [_contentView addSubview:orderPriceNoteLB];
        [orderPriceNoteLB release];
        
        UILabel *orderPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(61, posY, 80, 18)];
        orderPriceLB.backgroundColor = [UIColor clearColor];
        orderPriceLB.textColor = RGBACOLOR(254, 75, 32, 1);
        orderPriceLB.font = [UIFont boldSystemFontOfSize:15];
        orderPriceLB.text = [NSString stringWithFormat:@"¥%.2f", price+_roomPrice*_nightCount*_roomCount];
        CGSize orderSize  = [orderPriceLB.text sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(10000, 18) lineBreakMode:UILineBreakModeCharacterWrap];
        orderPriceLB.frame = CGRectMake(WIDTH - orderSize.width - 16, posY, orderSize.width, 18);
        self.priceTotal = orderPriceLB;
        [_contentView addSubview:orderPriceLB];
        [orderPriceLB release];
        
        
        posY += 30;
      
        
        // 返现
        self.priceDiscount = [[[UILabel alloc] initWithFrame:CGRectMake(16, posY, 140, 18)] autorelease];
        self.priceDiscount.backgroundColor = [UIColor clearColor];
        self.priceDiscount.textColor = RGBACOLOR(93, 93, 93, 1);
        self.priceDiscount.font = [UIFont systemFontOfSize:14];
        self.priceDiscount.text = @"返现金额";
        [_contentView addSubview:self.priceDiscount];
        
        self.priceDiscountTips = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 96, posY, 80, 18)] autorelease];
        self.priceDiscountTips.backgroundColor = [UIColor clearColor];
        self.priceDiscountTips.textColor = RGBACOLOR(254, 75, 32, 1);
        self.priceDiscountTips.font = [UIFont boldSystemFontOfSize:15];
        self.priceDiscountTips.textAlignment = NSTextAlignmentRight;
        self.priceDiscountTips.text = [NSString stringWithFormat:@"¥%.f",self.discount];
        [_contentView addSubview:self.priceDiscountTips];
        
        
        //节省费用提示
        self.posY = posY - 4;
        float saveFee = (_originalRoomCost-_roomPrice)*_nightCount*_roomPrice;
        if(saveFee>1.0 || self.discountTips){
            
            NSString *text = [NSString stringWithFormat:@"(已为您节省%.2f元)", saveFee];
            if (saveFee > 1.0) {
                text = [NSString stringWithFormat:@"(已为您节省%.2f元)", saveFee];
            }else if(self.discountTips){
                text = [NSString stringWithFormat:@"(%@)", self.discountTips];
            }
            UILabel *saveFeeLB1 = [[UILabel alloc] initWithFrame:CGRectMake(61+orderSize.width, _posY, 79, 18)];
            saveFeeLB1.backgroundColor = [UIColor clearColor];
            saveFeeLB1.textColor = [UIColor colorWithRed:0.3882 green:0.3882 blue:0.3882 alpha:1.0];
            saveFeeLB1.font = [UIFont systemFontOfSize:12];
            saveFeeLB1.text = text;
            CGSize saveSize1  = [saveFeeLB1.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(10000, 18) lineBreakMode:UILineBreakModeCharacterWrap];
            saveFeeLB1.frame = CGRectMake(WIDTH - saveSize1.width - 16, _posY, saveSize1.width, 18);
            self.priceSaveL = saveFeeLB1;
            [_contentView addSubview:saveFeeLB1];
            [saveFeeLB1 release];
            
            
        }
        
        [self addSubview:_contentView];
        
    }
    return self;
}

- (void)updateView
{
    self.priceL.text = [NSString stringWithFormat:@"¥%.2f x %d晚 x %d间", _roomPrice, _nightCount, _roomCount];;
    self.priceR.text = [NSString stringWithFormat:@"¥%.2f", _roomPrice*_nightCount*_roomCount];
    self.taxL.text = [NSString stringWithFormat:@"¥%.2f x %d晚 x %d间",_taxAndFee,_nightCount,_roomCount];
    float price = _taxAndFee*_roomCount*_nightCount;
    self.taxR.text = [NSString stringWithFormat:@"¥%.2f", price];
    self.priceTotal.text = [NSString stringWithFormat:@"¥%.2f", price+_roomPrice*_nightCount*_roomCount];
    CGSize orderSize  = [self.priceTotal.text sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(10000, 18) lineBreakMode:UILineBreakModeCharacterWrap];
    self.priceTotal.frame = CGRectMake(WIDTH - orderSize.width - 16, self.priceTotal.frame.origin.y, orderSize.width, 18);
    float saveFee = (_originalRoomCost - _roomPrice) * _nightCount * _roomCount;
    if(saveFee>1.0 || self.discountTips){
        NSString *text = [NSString stringWithFormat:@"(已为您节省%.2f元)", saveFee];
        if (saveFee > 1.0) {
            text = [NSString stringWithFormat:@"(已为您节省%.2f元)", saveFee];
        }else if(self.discountTips){
            text = [NSString stringWithFormat:@"(%@)", self.discountTips];
        }

        UILabel *saveFeeLB1 = [[UILabel alloc] initWithFrame:CGRectMake(61+orderSize.width, _posY, 79, 18)];
        saveFeeLB1.backgroundColor = [UIColor clearColor];
        saveFeeLB1.textColor = [UIColor colorWithRed:0.3882 green:0.3882 blue:0.3882 alpha:1.0];
        saveFeeLB1.font = [UIFont systemFontOfSize:12];
        saveFeeLB1.text = text;
        CGSize saveSize1  = [saveFeeLB1.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(10000, 18) lineBreakMode:UILineBreakModeCharacterWrap];
        saveFeeLB1.frame = CGRectMake(WIDTH - saveSize1.width - 16, _posY, saveSize1.width, 18);
        self.priceSaveL = saveFeeLB1;
        [_contentView addSubview:saveFeeLB1];
        [saveFeeLB1 release];
    }
    if (self.discount > 0) {
        self.priceDiscountTips.text = [NSString stringWithFormat:@"¥%.f",self.discount];
        self.priceDiscount.hidden = NO;
        self.priceDiscountTips.hidden = NO;
    }else{
        self.priceDiscountTips.hidden = YES;
        self.priceDiscount.hidden = YES;
    }
}



@end
