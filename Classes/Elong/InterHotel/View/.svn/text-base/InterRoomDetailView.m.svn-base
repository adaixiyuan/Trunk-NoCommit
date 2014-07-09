//
//  InterRoomDetailView.m
//  ElongClient
//
//  Created by Ivan.xu on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterRoomDetailView.h"
#import "InterHotelDetailCtrl.h"
#import "UIImageView+WebCache.h"
#import "InterFillOrderCtrl.h"
#import "AccountManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Coupon.h"

@interface InterRoomDetailView ()

@property(nonatomic) int currentRoomIndex;
@property(nonatomic,retain) UIImageView *roomBigImg;
@property(nonatomic,retain) NSMutableData *imageData;
@property(nonatomic,retain) UIView *serviceView;
@property(nonatomic,retain) UIView *introduceView;


@property(nonatomic,retain) UILabel *actualPriceLB;
@property(nonatomic,retain) UILabel *promoPriceLB;
@property(nonatomic,retain) UIImageView *lineImg;

-(void)closeThePage;    //关闭本页
-(void)bookRoom;    //预订

@end

@implementation InterRoomDetailView
@synthesize currentRoomIndex;
@synthesize delegate;
@synthesize roomBigImg;
@synthesize imageData;
@synthesize serviceView;
@synthesize introduceView;

@synthesize actualPriceLB,promoPriceLB;
@synthesize lineImg;

- (void)dealloc
{
    [roomBigImg release];
    [imageData release];
    [serviceView release];
    [introduceView release];
    
    [actualPriceLB release];
    [promoPriceLB release];
    [lineImg release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithRoomIndex:(int)index withFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.currentRoomIndex = index;
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:index];
        
        //大图
        NSString *imageUrl = @"";
        NSArray *images = [roomInfo safeObjectForKey:@"Images"];
        if(ARRAYHASVALUE(images)){
            for(NSDictionary *imageInfo in images){
                int size = [[imageInfo safeObjectForKey:@"Size"] intValue];
                if(size==1){
                    imageUrl = [imageInfo safeObjectForKey:@"Url"];
                }
            }
        }
        
        //房型名字
        NSString *roomName = @"";
        roomName  = [roomInfo safeObjectForKey:@"RoomName"];
        
        //设施
        NSMutableArray *roomAmenityGroup = [NSMutableArray array];

        //简介
        NSString *roomSummary = @"";
        
        NSString *roomTypeId = [roomInfo safeObjectForKey:@"RoomTypeID"];
        NSArray *roomDetailInfoArr = [[InterHotelDetailCtrl detail] safeObjectForKey:@"RoomsInfo"];
        if(ARRAYHASVALUE(roomDetailInfoArr)&&STRINGHASVALUE(roomTypeId)){
            for(NSDictionary *roomDetail in roomDetailInfoArr){
                NSString *tmpRTId = [roomDetail safeObjectForKey:@"RoomCode"];
                if([roomTypeId isEqualToString:tmpRTId]){
                    roomSummary  = [roomDetail safeObjectForKey:@"Summary"];        //简介
                    //设施
                    NSDictionary *roomAmenity = [roomDetail safeObjectForKey:@"RoomAmenityGroup"];
                    if(DICTIONARYHASVALUE(roomAmenity)){
                        NSArray *items = [roomAmenity safeObjectForKey:@"Items"];
                        for(NSDictionary *tmpDic in items){
                            NSString *amenity = [tmpDic safeObjectForKey:@"Amenity"];
                            [roomAmenityGroup addObject:amenity];
                        }
                    }
                    break;
                }
            }
        }
        //处理房型介绍数据
        if(!STRINGHASVALUE(roomSummary)){
            roomSummary = @"暂无房型介绍";
        }
        
        CFShow(roomAmenityGroup);
        self.backgroundColor = [UIColor clearColor];
        //Bg
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        bg.backgroundColor = [UIColor blackColor];
        bg.userInteractionEnabled = YES;
        bg.alpha = 0.85;
        [self addSubview:bg];
        [bg release];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePage)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [bg addGestureRecognizer:singleTap];
        [singleTap release];

        //ContentView
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, SCREEN_HEIGHT-120)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView release];
        contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        //Close Btn
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeThePage) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(271 - 2, 31 + 2, 57, 57);
        [self addSubview:closeBtn];
        
        //MainScrollView
        UIScrollView *mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, SCREEN_HEIGHT-120-50)];
        mainScroll.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:mainScroll];
        [mainScroll release];
        
        //房型大图
        if(!roomBigImg){
            roomBigImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 0)];
        }
        self.roomBigImg.contentMode = UIViewContentModeScaleAspectFill;
        self.roomBigImg.clipsToBounds = YES;
        [mainScroll addSubview:roomBigImg];
        
        if(!imageData){
            imageData = [[NSMutableData alloc] init];
        }
        
        if(STRINGHASVALUE(imageUrl)){
            //有大图
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//            UIImage *image = [UIImage imageWithData:imageData];
//            self.roomBigImg.image = image;
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] delegate:self];
            [connection start];
            
//            [self.roomBigImg setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            self.roomBigImg.frame = CGRectMake(0, 0, 280, 170);
            [self.roomBigImg startLoadingByStyle:UIActivityIndicatorViewStyleGray];
        }else{
            self.roomBigImg.frame = CGRectMake(0, 0, 280, 0);
        }
        
        //送预付卡  显示说明
        float giftCardAmount = 0;
        if(ARRAYHASVALUE([roomInfo safeObjectForKey:@"RateInfos"])){
            NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] objectAtIndex:0];
            giftCardAmount = [[priceInfo safeObjectForKey:@"GiftCardAmount"] floatValue];
        }
        
        int offY = self.roomBigImg.frame.size.height;
        if(giftCardAmount>0){
            UIView *giftCardView = [[UIView alloc] initWithFrame:CGRectMake(0, self.roomBigImg.frame.size.height, 280, 0)];
            [mainScroll addSubview:giftCardView];
            [giftCardView release];
            //add GiftCard Icon
            UIImageView *giftCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 14, 12)];
            giftCardIcon.image = [UIImage noCacheImageNamed:@"giftcard_icon.png"];
            [giftCardView addSubview:giftCardIcon];
            [giftCardIcon release];
            
            NSString *giftCardDesp = [NSString stringWithFormat:@"预订此房型，每张订单送%.f元艺龙礼品卡！结账后3个工作日内艺龙会将礼品卡卡号和密码发送短信给您，可以到艺龙账户充值使用。",giftCardAmount];
            CGSize giftCardLbSize = [giftCardDesp sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(250, INT_MAX)];
            //add GiftCardLabel
            UILabel *giftCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 250, giftCardLbSize.height)];
            giftCardLabel.backgroundColor = [UIColor clearColor];
            giftCardLabel.numberOfLines = 0;
            giftCardLabel.font = FONT_12;
            giftCardLabel.text = giftCardDesp;
            giftCardLabel.textColor = [UIColor grayColor];
            [giftCardView addSubview:giftCardLabel];
            [giftCardLabel release];
            
            giftCardView.frame = CGRectMake(0, self.roomBigImg.frame.size.height, 280, 10+giftCardLbSize.height+10);
            [giftCardView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 18+giftCardLbSize.height, 280, SCREEN_SCALE)]];
//            mainScroll.contentSize = CGSizeMake(280, giftCardView.frame.origin.y+giftCardView.frame.size.height);
            offY = self.roomBigImg.frame.size.height + 20 +giftCardLbSize.height;
        }
        
        //房型设施
        if(!serviceView){
            serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, offY, 280, 0)];
        }
        serviceView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
        [mainScroll addSubview:self.serviceView];
        
        //房间名称
        UILabel *roomNameLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 270, 0)];
        roomNameLB.backgroundColor = [UIColor clearColor];
        roomNameLB.textColor = [UIColor blackColor];
        roomNameLB.font = [UIFont boldSystemFontOfSize:15];
        roomNameLB.numberOfLines = 0;
        roomNameLB.lineBreakMode = UILineBreakModeTailTruncation;
        roomNameLB.text = roomName;
        CGSize roomSize = [roomNameLB.text sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(270, 10000) lineBreakMode:UILineBreakModeTailTruncation];
        roomNameLB.frame = CGRectMake(5, 10, 270, roomSize.height);
        [serviceView addSubview:roomNameLB];
        [roomNameLB release];
        
        if(ARRAYHASVALUE(roomAmenityGroup)){
            int height = 26;
            for(int i=0; i<roomAmenityGroup.count;i++){
                int y = i/2;
                int x = i%2;
                
                UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(7+x*140, 10+roomSize.height+y*height, 10, height)];
                note.backgroundColor=[UIColor clearColor];
                note.font=[UIFont systemFontOfSize:12];
                note.textColor = [UIColor darkGrayColor];
                note.text = @"•";
                [serviceView addSubview:note];
                [note release];
                
                UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(13+x*140, 10+roomSize.height+y*height, 120, height)];
                lb1.backgroundColor=[UIColor clearColor];
                lb1.textColor = [UIColor darkGrayColor];
                lb1.text = [NSString stringWithFormat:@"%@",[roomAmenityGroup safeObjectAtIndex:i]];
                lb1.numberOfLines = 2;
                lb1.lineBreakMode = UILineBreakModeTailTruncation;
                [serviceView addSubview:lb1];
                CGFloat actualFontSize;
                [lb1.text sizeWithFont:[UIFont systemFontOfSize:13] minFontSize:11 actualFontSize:&actualFontSize forWidth:120 lineBreakMode:UILineBreakModeTailTruncation];
                lb1.font = [UIFont systemFontOfSize:actualFontSize];
                [lb1 release];
                
            }
            int totalHeight = (roomAmenityGroup.count/2+roomAmenityGroup.count%2) *height;
            serviceView.frame = CGRectMake(0, offY, 280, totalHeight+10+roomSize.height);
            
            //虚线
            UIImageView *dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, serviceView.frame.size.height- SCREEN_SCALE, 280, SCREEN_SCALE)];
            dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [serviceView addSubview:dashLine];
            [dashLine release];
        }else{
            serviceView.frame = CGRectMake(0, offY, 280, 10+roomSize.height);
        }

        //房型介绍
        if(!introduceView){
            introduceView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceView.frame.origin.y+serviceView.frame.size.height, 280, 100)];
        }
        [mainScroll addSubview:self.introduceView];
        
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 270, 20)];
        noteLabel.backgroundColor = [UIColor clearColor];
        noteLabel.font = [UIFont boldSystemFontOfSize:15];
        noteLabel.text = @"房型介绍：";
        noteLabel.textColor = [UIColor blackColor];
        [introduceView addSubview:noteLabel];
        [noteLabel release];
        
        UILabel *introuduceLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 270, 20)];
        introuduceLB.backgroundColor = [UIColor clearColor];
        introuduceLB.textColor = [UIColor darkGrayColor];
        introuduceLB.font = [UIFont systemFontOfSize:12];
        introuduceLB.numberOfLines = 0;
        introuduceLB.lineBreakMode = UILineBreakModeTailTruncation;
        introuduceLB.text = roomSummary;
        CGSize introduceSize =  [introuduceLB.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(270, 10000) lineBreakMode:UILineBreakModeTailTruncation];
        introuduceLB.frame = CGRectMake(5, 35, 270, introduceSize.height);
        [introduceView addSubview:introuduceLB];
        [introuduceLB release];
        
        introduceView.frame = CGRectMake(0, serviceView.frame.origin.y+serviceView.frame.size.height, 280, 30+introduceSize.height+10);
        mainScroll.contentSize = CGSizeMake(280, serviceView.frame.origin.y+serviceView.frame.size.height+35+introduceSize.height+10);
        
        //FooterView
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-120-50, 280, 50)];
        footerView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
        [contentView addSubview:footerView];
        [footerView release];
        
        NSString *originPriceStr = @"";
        NSArray *rateInfos = [roomInfo safeObjectForKey:@"RateInfos"];
        NSString *actualPriceStr = @"¥ 0";
        if(ARRAYHASVALUE(rateInfos)){
            NSDictionary *priceInfo = [rateInfos safeObjectAtIndex:0];
            //注意，传给后台和Mis时则不使用字段ElongViewAvgRate，而传入后台的是总价和原价
            float actualPrice_f = [[priceInfo safeObjectForKey:@"ElongViewAvgRate"] floatValue];
            float originPrice_f = [[priceInfo safeObjectForKey:@"ActualAvgRate"] floatValue];
            
            actualPriceStr = [NSString stringWithFormat:@"¥ %.f",actualPrice_f];
            if(floor(originPrice_f) >floor(actualPrice_f)){
                originPriceStr =[NSString stringWithFormat:@"¥ %.f",originPrice_f];        //原价
            }
        }
        
        if(!actualPriceLB){
            actualPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, 50)];
        }
        self.actualPriceLB.backgroundColor = [UIColor clearColor];
        self.actualPriceLB.textColor = [UIColor lightGrayColor];
        self.actualPriceLB.textAlignment = NSTextAlignmentCenter;
        self.actualPriceLB.font = [UIFont systemFontOfSize:18];
        [footerView addSubview:self.actualPriceLB];
        self.actualPriceLB.text = originPriceStr;
        CGSize actualSize = [self.actualPriceLB.text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(10000, 40) lineBreakMode:UILineBreakModeCharacterWrap];
        self.actualPriceLB.frame = CGRectMake(5, 0, actualSize.width, 50);
        
        if(!lineImg){
            lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.actualPriceLB.frame.size.height/2, self.actualPriceLB.frame.size.width, 1)];
        }
        self.lineImg.backgroundColor =  [UIColor lightGrayColor];
        [footerView addSubview:self.lineImg];
        self.lineImg.hidden = YES;
        if(STRINGHASVALUE(originPriceStr)){
            self.lineImg.hidden = NO;
        }
        
        if(!promoPriceLB){
            promoPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
        }
        self.promoPriceLB.backgroundColor = [UIColor clearColor];
        self.promoPriceLB.textColor = [UIColor whiteColor];
        self.promoPriceLB.textAlignment = NSTextAlignmentCenter;
        self.promoPriceLB.font = [UIFont boldSystemFontOfSize:25];
        [footerView addSubview:self.promoPriceLB];
        self.promoPriceLB.text = actualPriceStr;
        CGSize pomoSize = [self.promoPriceLB.text sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:CGSizeMake(10000, 40) lineBreakMode:UILineBreakModeCharacterWrap];
        self.promoPriceLB.frame = CGRectMake(actualSize.width+10, 0, pomoSize.width, 50);
        
        
        //返现和预付卡
        // 返现
        int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
        // 返现需要处理消费券
        if (promotionTag == 3) {
            float discount = 0;
            if(ARRAYHASVALUE(rateInfos)){
                NSDictionary *priceInfo = [rateInfos safeObjectAtIndex:0];
                discount = [[priceInfo safeObjectForKey:@"DiscountTotal"] floatValue];
            }
            // 消费券限制
            NSArray *coupons = [Coupon activedcoupons];
            float totalValue = 0.0f;
            if (ARRAYHASVALUE(coupons)) {
                totalValue = [[coupons safeObjectAtIndex:0] intValue];
            }
            if (discount > totalValue) {
                discount = totalValue;
            }
            float realDiscount = discount;
            
            UILabel *cashDiscountLbl = [[[UILabel alloc] initWithFrame:CGRectMake(100,0, 60, 50)] autorelease];
            cashDiscountLbl.backgroundColor = [UIColor clearColor];
            cashDiscountLbl.textColor = [UIColor whiteColor];
            cashDiscountLbl.font = [UIFont boldSystemFontOfSize:12.0f];
            cashDiscountLbl.textAlignment = UITextAlignmentCenter;
            [footerView addSubview:cashDiscountLbl];
            
            if (realDiscount > 0) {
                cashDiscountLbl.text = [NSString stringWithFormat:@"返 ¥%.f",realDiscount];
            }else{
                cashDiscountLbl.font = [UIFont systemFontOfSize:12.0f];
                cashDiscountLbl.text = [NSString stringWithFormat:@"无法返现"];
            }
        }else if (promotionTag == 4) {
            float giftcardAmount = 0;
            if(ARRAYHASVALUE(rateInfos)){
                NSDictionary *priceInfo = [rateInfos safeObjectAtIndex:0];
                giftcardAmount = [[priceInfo safeObjectForKey:@"GiftCardAmount"] floatValue];
            }
            
            UILabel *giftcardLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100,0, 60, 50)] autorelease];
            giftcardLabel.backgroundColor = [UIColor clearColor];
            giftcardLabel.textColor = [UIColor whiteColor];
            giftcardLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            giftcardLabel.textAlignment = UITextAlignmentCenter;
            [footerView addSubview:giftcardLabel];
            
            if (giftcardAmount > 0) {
                giftcardLabel.text = [NSString stringWithFormat:@"送 ¥%.f",giftcardAmount];
            }else{
                giftcardLabel.font = [UIFont systemFontOfSize:12.0f];
                giftcardLabel.text = [NSString stringWithFormat:@"无法送礼品卡"];
            }
        }
        
        
       
         
         // 预订
        UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bookBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [bookBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
        [bookBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
        [bookBtn setTitle:@"预订" forState:UIControlStateNormal];
        [footerView addSubview:bookBtn];
        bookBtn.frame = CGRectMake(footerView.frame.size.width - 120, 0, 110, 50);
        [bookBtn addTarget:self action:@selector(bookRoom) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Action Methods

//关闭本页
-(void)closeThePage{
    [UIView beginAnimations:@"EaseOut" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.alpha = 0.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

 //预订
-(void)bookRoom{
    [InterRoomCell setSelectedRoomIndex:self.currentRoomIndex];  //记录预订房间的索引
    
    if([delegate respondsToSelector:@selector(bookRoomFromDetailView)]){
        [delegate bookRoomFromDetailView];
    }
    [self closeThePage];
}


#pragma mark - NSUrlCOnnection Data Delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.roomBigImg endLoading];
    UIImage *image = [[UIImage alloc] initWithData:self.imageData];
    [self.roomBigImg setImage:image];
    [image release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.roomBigImg endLoading];

}

@end
