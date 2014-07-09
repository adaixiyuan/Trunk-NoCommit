//
//  RoomDetailView.m
//  ElongClient
//
//  Created by Dawn on 13-9-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RoomDetailView.h"

#define kCellDetailHeight         (SCREEN_HEIGHT-120)

@interface RoomDetailView()
@property (nonatomic,retain) UILabel *giftLbl;
@property (nonatomic,retain) UILabel *otherLbl;
@end

@implementation RoomDetailView
- (void) dealloc{
    self.hotelImageView = nil;
    self.hotelNameLbl = nil;
    self.breakfastLbl = nil;
    self.networkLbl = nil;
    self.areaLbl = nil;
    self.floorLbl = nil;
    self.bedLbl = nil;
    self.priceLbl = nil;
    self.cashDiscountLbl = nil;
    self.giftLbl = nil;
    self.otherLbl = nil;
    self.bookingBtn = nil;
    self.cancelTypeLbl = nil;
    self.hotelRoomTipsLbl = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = kCellDetailHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        // 背景，圆角
        bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView release];
        bgView.clipsToBounds = YES;
        
        // 滚动区域
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        [bgView addSubview:scrollView];
        scrollView.backgroundColor = [UIColor whiteColor];
        [scrollView release];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        
        // 酒店图片
        self.hotelImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 180)] autorelease];
        self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.hotelImageView.backgroundColor = RGBACOLOR(207, 207, 207, 1);
        [scrollView addSubview:self.hotelImageView];
        self.hotelImageView.clipsToBounds = YES;
        
        // 酒店名
        self.hotelNameLbl = [[[AttributedLabel alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 8, frame.size.width - 20, 35) wrapped:YES] autorelease];
        [scrollView addSubview:self.hotelNameLbl];
        self.hotelNameLbl.backgroundColor = [UIColor clearColor];
        
        // 取消类型
        self.cancelTypeLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 40, frame.size.width - 20, 20)] autorelease];
        self.cancelTypeLbl.font = [UIFont systemFontOfSize:12.0f];
        self.cancelTypeLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.cancelTypeLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.cancelTypeLbl];
        
        // 早餐
        self.breakfastLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10 + 12 + 10, self.hotelImageView.frame.size.height + 65, (frame.size.width - 71)/3, 17)] autorelease];
        self.breakfastLbl.font = [UIFont systemFontOfSize:12.0f];
        self.breakfastLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.breakfastLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.breakfastLbl];
        
        UIImageView *breakfastIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 65, 17, 17)];
        breakfastIcon.image =[UIImage noCacheImageNamed:@"breakfarst_ico.png"];
        breakfastIcon.contentMode = UIViewContentModeCenter;
        [scrollView addSubview:breakfastIcon];
        [breakfastIcon release];
        
        // 宽带
        self.networkLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10 + 14  * 2 + 10 + (frame.size.width - 71)/3,self.hotelImageView.frame.size.height + 65, (frame.size.width - 71)/3, 17)] autorelease];
        self.networkLbl.font = [UIFont systemFontOfSize:12.0f];
        self.networkLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.networkLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.networkLbl];
        
        UIImageView *networkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 17 + (frame.size.width - 71)/3, self.hotelImageView.frame.size.height + 65, 17, 17)];
        networkIcon.image = [UIImage noCacheImageNamed:@"net_ico.png"];
        networkIcon.contentMode = UIViewContentModeCenter;
        [scrollView addSubview:networkIcon];
        [networkIcon release];
        
        
        // 楼层
        self.floorLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10 + 15 * 3 + 10 + 2 * (frame.size.width - 71)/3 - 6, self.hotelImageView.frame.size.height + 65, (frame.size.width - 71)/3 + 10, 17)] autorelease];
        self.floorLbl.font = [UIFont systemFontOfSize:12.0f];
        self.floorLbl.minimumFontSize = 8;
        self.floorLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.floorLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.floorLbl];
        
        UIImageView *floorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 17 * 2 + 2*(frame.size.width - 71)/3 - 6, self.hotelImageView.frame.size.height + 65, 17, 17)];
        floorIcon.image = [UIImage noCacheImageNamed:@"floor_ico.png"];
        floorIcon.contentMode = UIViewContentModeCenter;
        [scrollView addSubview:floorIcon];
        [floorIcon release];
        
        // 面积
        self.areaLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10 + 12 + 10, self.hotelImageView.frame.size.height + 89, (frame.size.width - 71)/3, 17)] autorelease];
        self.areaLbl.font = [UIFont systemFontOfSize:12.0f];
        self.areaLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.areaLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.areaLbl];
        UIImageView *areaIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 89, 17, 17)];
        areaIcon.image = [UIImage noCacheImageNamed:@"area_ico.png"];
        areaIcon.contentMode = UIViewContentModeCenter;
        [scrollView addSubview:areaIcon];
        [areaIcon release];
        
        // 床型
        self.bedLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10 + 14 * 2 + 10 + (frame.size.width - 71)/3,self.hotelImageView.frame.size.height + 89, 2 * (frame.size.width - 71)/3+10, 17 * 2)] autorelease];
        self.bedLbl.font = [UIFont systemFontOfSize:12.0f];
        self.bedLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        self.bedLbl.numberOfLines = 0;
        self.bedLbl.textColor = RGBACOLOR(84, 84, 84, 1);
        self.bedLbl.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:self.bedLbl];
        UIImageView *bedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 17 + (frame.size.width - 71)/3, self.hotelImageView.frame.size.height + 89, 17, 17)];
        bedIcon.image = [UIImage noCacheImageNamed:@"bed_ico.png"];
        bedIcon.contentMode = UIViewContentModeCenter;
        [scrollView addSubview:bedIcon];
        [bedIcon release];
        
        // 底部栏
        bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
        bottomBar.backgroundColor = RGBACOLOR(62, 62, 62, 1);
        [bgView addSubview:bottomBar];
        [bottomBar release];
        bottomBar.userInteractionEnabled = YES;
        
        // 价格
        self.priceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 50)] autorelease];
        self.priceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
        self.priceLbl.textColor = [UIColor whiteColor];
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textAlignment = UITextAlignmentLeft;
        [bottomBar addSubview:self.priceLbl];
        
        // 返现
        self.cashDiscountLbl = [[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 80, 50)] autorelease];
        self.cashDiscountLbl.font = [UIFont boldSystemFontOfSize:12.0f];
        self.cashDiscountLbl.textColor = [UIColor whiteColor];
        self.cashDiscountLbl.backgroundColor = [UIColor clearColor];
        self.cashDiscountLbl.textAlignment = UITextAlignmentLeft;
        [bottomBar addSubview:self.cashDiscountLbl];
        
        // 预订
        self.bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bookingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
        [self.bookingBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
        [self.bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
        [bottomBar addSubview:self.bookingBtn];
        self.bookingBtn.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2 - 10, 50);
    }
    return self;
}

- (void) layoutSubviews{
    //    bgView.frame = self.bounds;
    //    scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 44);
    //    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
    //    bottomBar.frame = CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44);
}

- (void) setGift:(NSString *)gift{
    if (gift && gift.length) {
        
    }else{
        return;
    }
    
    
    
    // 送礼
    self.giftLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 120, self.frame.size.width - 20, 0)] autorelease];
    self.giftLbl.textColor = RGBACOLOR(84, 84, 84, 1);
    self.giftLbl.font = [UIFont systemFontOfSize:12.0f];
    [scrollView addSubview:self.giftLbl];
    self.giftLbl.numberOfLines = 0;
    self.giftLbl.backgroundColor = [UIColor clearColor];
    self.giftLbl.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *giftDes = [NSString stringWithFormat:@".。%@",gift];
    CGSize size = CGSizeMake(self.giftLbl.frame.size.width, 10000);
    CGSize newSize = [giftDes sizeWithFont:self.giftLbl.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.giftLbl.frame = CGRectMake(self.giftLbl.frame.origin.x, self.giftLbl.frame.origin.y, self.giftLbl.frame.size.width, newSize.height);
    self.giftLbl.text = giftDes;
    
    if (newSize.height + 120 + self.hotelImageView.frame.size.height > scrollView.contentSize.height) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, newSize.height + 120 + self.hotelImageView.frame.size.height + 10);
    }
    
    // 礼品
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setImage:[UIImage noCacheImageNamed:@"hoteldetail_gift.png"] forState:UIControlStateNormal];
    giftBtn.frame = CGRectMake(10, self.hotelImageView.frame.size.height + 120+1, 17*0.8, 16*0.8);
    [scrollView addSubview:giftBtn];
    giftBtn.adjustsImageWhenHighlighted = NO;
    giftBtn.userInteractionEnabled = NO;
}

- (void) setOtherInfo:(NSString *)other_{
    NSString *other = [other_ stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (other && other.length) {
        if ([other isEqualToString:@"未知"]) {
            return;
        }
    }else{
        return;
    }
    
    // 礼品
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn setImage:[UIImage noCacheImageNamed:@"hoteldetail_other.png"] forState:UIControlStateNormal];
    if (self.giftLbl) {
        otherBtn.frame = CGRectMake(10, self.hotelImageView.frame.size.height + 120 + self.giftLbl.frame.size.height + 10 + 1, 32 * 0.8,16 * 0.8);
    }else{
        otherBtn.frame = CGRectMake(10, self.hotelImageView.frame.size.height + 120+ 1, 32 * 0.8, 16 * 0.8);
    }
    
    [scrollView addSubview:otherBtn];
    otherBtn.adjustsImageWhenHighlighted = NO;
    otherBtn.userInteractionEnabled = NO;
    
    // 送礼
    self.otherLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 120, self.frame.size.width - 20, 0)] autorelease];
    if (self.giftLbl) {
        self.otherLbl.frame = CGRectMake(10, self.hotelImageView.frame.size.height + 120 + self.giftLbl.frame.size.height + 10, self.frame.size.width - 20, 0);
    }
    self.otherLbl.textColor = RGBACOLOR(84, 84, 84, 1);
    self.otherLbl.backgroundColor = [UIColor clearColor];
    self.otherLbl.font = [UIFont systemFontOfSize:12.0f];
    [scrollView addSubview:self.otherLbl];
    self.otherLbl.numberOfLines = 0;
    self.otherLbl.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *otherDes = [NSString stringWithFormat:@".....。%@",other];
    CGSize size = CGSizeMake(self.otherLbl.frame.size.width, 10000);
    CGSize newSize = [otherDes sizeWithFont:self.otherLbl.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.otherLbl.frame = CGRectMake(self.otherLbl.frame.origin.x, self.otherLbl.frame.origin.y, self.otherLbl.frame.size.width, newSize.height);
    self.otherLbl.text = otherDes;
    
    [scrollView bringSubviewToFront:otherBtn];
    
    if (self.otherLbl.frame.origin.y + self.otherLbl.frame.size.height > scrollView.contentSize.height) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, self.otherLbl.frame.origin.y + self.otherLbl.frame.size.height + 20);
    }
}

- (void)setRoomTips:(NSString *)roomTips
{
    if (self.otherLbl) {
        // 客人类型描述
        self.hotelRoomTipsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.otherLbl.frame.size.height + self.otherLbl.frame.origin.y, self.frame.size.width - 20, 0)] autorelease];
    }
    else if (self.giftLbl) {
        self.hotelRoomTipsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.giftLbl.frame.size.height + self.giftLbl.frame.origin.y, self.frame.size.width - 20, 0)] autorelease];
    }
    else {
        self.hotelRoomTipsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.hotelImageView.frame.size.height + 120, self.frame.size.width - 20, 0)] autorelease];
    }
    
    self.hotelRoomTipsLbl.textColor = RGBACOLOR(84, 84, 84, 1);
    self.hotelRoomTipsLbl.backgroundColor = [UIColor clearColor];
    self.hotelRoomTipsLbl.font = [UIFont systemFontOfSize:12.0f];
    [scrollView addSubview:self.hotelRoomTipsLbl];
    self.hotelRoomTipsLbl.numberOfLines = 0;
    self.hotelRoomTipsLbl.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = CGSizeMake(self.hotelRoomTipsLbl.frame.size.width, 10000);
    CGSize newSize = [roomTips sizeWithFont:self.hotelRoomTipsLbl.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.hotelRoomTipsLbl.frame = CGRectMake(self.hotelRoomTipsLbl.frame.origin.x, self.hotelRoomTipsLbl.frame.origin.y, self.hotelRoomTipsLbl.frame.size.width, newSize.height);
    self.hotelRoomTipsLbl.text = roomTips;
    
    if (self.hotelRoomTipsLbl.frame.origin.y + self.hotelRoomTipsLbl.frame.size.height > scrollView.contentSize.height) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, self.hotelRoomTipsLbl.frame.origin.y + self.hotelRoomTipsLbl.frame.size.height + 20);
    }
}

@end
