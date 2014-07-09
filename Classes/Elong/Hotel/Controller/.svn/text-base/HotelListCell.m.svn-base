//
//  HotelListCell.m
//  ElongClient
//
//  Created by Dawn on 13-12-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelListCell.h"
#import "HotelListMode.h"



@interface HotelListCell(){
    struct{
        bool haveImage;
        bool haveAction;
        bool recommend;
        float cellHeight;
        float actionWidth;
    }_cellFlag;
}
@end

@implementation HotelListCell


- (void) dealloc{
    self.hotelNameLbl = nil;
    self.hotelImageView = nil;
    self.wifiImageView = nil;
    self.parkImageView = nil;
    self.promotionImageView = nil;
    self.vipImageView = nil;
    self.starLbl = nil;
    self.commentLbl = nil;
    self.addressLbl = nil;
    self.priceMarkLbl = nil;
    self.priceLbl = nil;
    self.backImageView = nil;
    self.backPriceLbl = nil;
    self.originalPriceLbl = nil;
    self.priceEndLbl = nil;
    self.fullyBookedLbl = nil;
    self.indexPath = nil;
    self.recommendLbl = nil;
    self.referencePriceLbl=nil;
    self.delegate = nil;
    self.dataSource = nil;
    self.actionDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier haveImage:image haveAction:NO];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier haveImage:image haveAction:haveAction recommend:NO];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction recommend:(BOOL)recommend{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellFlag.haveImage = image;
        _cellFlag.haveAction = haveAction;
        _cellFlag.recommend = recommend;
        _cellFlag.cellHeight = 95;
        _cellFlag.actionWidth = 228;
        self.recommend = recommend;
        
        if (self.recommend) {
            _cellFlag.cellHeight = 95 + 40;
        }else{
            _cellFlag.cellHeight = 95;
        }
        
        if (!IOSVersion_5) {
            _cellFlag.haveAction = NO;
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 &&
            [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        {
            if ([[[UIDevice currentDevice] systemVersion] compare:@"5.1.0"] == NSOrderedAscending ||
                [[[UIDevice currentDevice] systemVersion] compare:@"5.1.0"] == NSOrderedSame
                )
            {
                _cellFlag.haveAction = NO;
            }
        }
        
        UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellFlag.cellHeight)];
        frontView.backgroundColor = [UIColor whiteColor];
        
        if (_cellFlag.haveAction) {
            // 背面隐藏功能按钮
            backView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _cellFlag.actionWidth, 0, _cellFlag.actionWidth, _cellFlag.cellHeight)];
            backView.backgroundColor  = [UIColor whiteColor];
            [self.contentView addSubview:backView];
            backView.userInteractionEnabled = YES;
            [backView release];
            
            
            // 功能模块
            navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:navBtn];
            navBtn.frame = CGRectMake(0, 0, _cellFlag.actionWidth/3, backView.frame.size.height);
            [navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [navBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [navBtn setImage:[UIImage noCacheImageNamed:@"slide_nav.png"] forState:UIControlStateNormal];
            [navBtn setImage:[UIImage noCacheImageNamed:@"slide_nav_h.png"] forState:UIControlStateSelected];
            [navBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun2.png"] forState:UIControlStateNormal];
            [navBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun2_h.png"] forState:UIControlStateSelected];
            [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:shareBtn];
            shareBtn.frame = CGRectMake(_cellFlag.actionWidth/3, 0, _cellFlag.actionWidth/3, backView.frame.size.height);
            [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [shareBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [shareBtn setImage:[UIImage noCacheImageNamed:@"slide_share.png"] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage noCacheImageNamed:@"slide_share_h.png"] forState:UIControlStateSelected];
            [shareBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun1.png"] forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun1_h.png"] forState:UIControlStateSelected];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:favBtn];
            favBtn.frame = CGRectMake(2 * _cellFlag.actionWidth/3, 0, _cellFlag.actionWidth/3, backView.frame.size.height);
            [favBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [favBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [favBtn setImage:[UIImage noCacheImageNamed:@"slide_fav.png"] forState:UIControlStateNormal];
            [favBtn setImage:[UIImage noCacheImageNamed:@"slide_fav_h.png"] forState:UIControlStateSelected];
            [favBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun0.png"] forState:UIControlStateNormal];
            [favBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun0_h.png"] forState:UIControlStateSelected];
            [favBtn addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            // cell 内容
            scrollContenView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellFlag.cellHeight)];
            scrollContenView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:scrollContenView];
            scrollContenView.contentSize = CGSizeMake(backView.frame.size.width + frontView.frame.size.width , _cellFlag.cellHeight);
            scrollContenView.delegate = self;
            [scrollContenView release];
            scrollContenView.contentOffset = CGPointMake(0, 0);
            scrollContenView.showsHorizontalScrollIndicator = NO;
            if (IOSVersion_5) {
                scrollContenView.scrollEnabled = YES;
            }else{
                scrollContenView.scrollEnabled = NO;
            }
            
            
            UITapGestureRecognizer *singTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleAction:)];
            singTapGesture.numberOfTapsRequired = 1;
            singTapGesture.numberOfTouchesRequired = 1;
            [scrollContenView addGestureRecognizer:singTapGesture];
            singTapGesture.delegate = self;
            [singTapGesture release];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
            [scrollContenView addGestureRecognizer:longPressGesture];
            longPressGesture.minimumPressDuration = 0.2;
            longPressGesture.delegate = self;
            [longPressGesture release];
            
            [scrollContenView addSubview:frontView];
            [frontView release];
            frontView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellFlag.cellHeight);
        }else{
            frontView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellFlag.cellHeight);
            [self.contentView addSubview:frontView];
            [frontView release];
        }
        
        
        // 酒店图片
        if (_cellFlag.haveImage) {
            self.hotelImageView = [[[RoundCornerView alloc] initWithFrame:CGRectMake(6, 6, 75 + 6, 75 + 6)] autorelease];
            self.hotelImageView.imageRadius = 2.0f;
            [frontView addSubview:self.hotelImageView];
            self.hotelImageView.userInteractionEnabled = NO;
        }else{
            self.hotelImageView = nil;
        }
        
        // 酒店名
        self.hotelNameLbl = [[[UILabel alloc] initWithFrame:CGRectMake(95, 9, SCREEN_WIDTH - 95 - 10, 20)] autorelease];
        self.hotelNameLbl.font = [UIFont boldSystemFontOfSize:16.0f];
        self.hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        [frontView addSubview:self.hotelNameLbl];
        if (!_cellFlag.haveImage) {
            self.hotelNameLbl.frame = CGRectMake(10, 9, SCREEN_WIDTH - 40, 20);
        }
        
        // wifi
        self.wifiImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(94, 33, 15, 11)] autorelease];
        self.wifiImageView.image  = [UIImage noCacheImageNamed:@"hotellist_wifi.png"];
        self.wifiImageView.contentMode = UIViewContentModeCenter;
        [frontView addSubview:self.wifiImageView];
        if (!_cellFlag.haveImage) {
            self.wifiImageView.frame = CGRectMake(10, 33, 15, 11);
        }
        
        // park
        self.parkImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(94 + 16, 33, 15, 11)] autorelease];
        self.parkImageView.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
        self.parkImageView.contentMode = UIViewContentModeCenter;
        [frontView addSubview:self.parkImageView];
        if (!_cellFlag.haveImage) {
            self.parkImageView.frame = CGRectMake(10 + 16, 33, 15, 11);
        }
        
        // 促销信息
        self.promotionImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(124, 33, 40, 12)] autorelease];
        self.promotionImageView.image = nil;
        self.promotionImageView.contentMode = UIViewContentModeLeft;
        [frontView addSubview:self.promotionImageView];
        if (!_cellFlag.haveImage) {
            self.promotionImageView.frame = CGRectMake(40, 33, 40, 12);
        }
        
        // 龙萃信息
        self.vipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(167, 33, 40, 12)] autorelease];
        self.vipImageView.image = nil;
        self.vipImageView.contentMode = UIViewContentModeLeft;
        [frontView addSubview:self.vipImageView];
        if (!_cellFlag.haveImage) {
            self.vipImageView.frame = CGRectMake(84, 33, 40, 12);
        }
        
        // 星级
        self.starLbl = [[[UILabel alloc] initWithFrame:CGRectMake(95, 52, 200, 14)] autorelease];
        self.starLbl.font = [UIFont systemFontOfSize:12];
        self.starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.starLbl.backgroundColor = [UIColor clearColor];
        [frontView addSubview:self.starLbl];
        if (!_cellFlag.haveImage) {
            self.starLbl.frame = CGRectMake(10, 53, 100, 14);
        }
        
        // 评论
        self.commentLbl = [[[UILabel alloc] initWithFrame:CGRectMake(123, 52, 65, 14)] autorelease];
        self.commentLbl.font = [UIFont systemFontOfSize:12.0f];
        self.commentLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.commentLbl.backgroundColor = [UIColor clearColor];
        [frontView addSubview:self.commentLbl];
        if (!_cellFlag.haveImage) {
            self.commentLbl.frame = CGRectMake(40, 53, 65, 14);
        }
        
        // 区域或地址
        self.addressLbl = [[[UILabel alloc] initWithFrame:CGRectMake(95, 70, 220, 14)] autorelease];
        self.addressLbl.font = [UIFont systemFontOfSize:12.0f];
        self.addressLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        [frontView addSubview:self.addressLbl];
        if (!_cellFlag.haveImage) {
            self.addressLbl.frame = CGRectMake(10, 70, SCREEN_WIDTH - 20, 14);
        }
        
        
        // 价格符号
        self.priceMarkLbl = [[[UILabel alloc] initWithFrame:CGRectMake(209, 36, 25, 14)] autorelease];
        self.priceMarkLbl.font = [UIFont systemFontOfSize:12.0f];
        self.priceMarkLbl.minimumFontSize = 10.0f;
        self.priceMarkLbl.backgroundColor = [UIColor clearColor];
        self.priceMarkLbl.adjustsFontSizeToFitWidth = YES;
        self.priceMarkLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.priceMarkLbl.textAlignment = UITextAlignmentRight;
        [frontView addSubview:self.priceMarkLbl];
        
        // 价格
        self.priceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(236, 28, 53, 24)] autorelease];
        self.priceLbl.font = [UIFont boldSystemFontOfSize:23.0f];
        self.priceLbl.minimumFontSize = 14.0f;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.adjustsFontSizeToFitWidth = YES;
        self.priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
        self.priceLbl.textAlignment = UITextAlignmentRight;
        [frontView addSubview:self.priceLbl];
        
        self.referencePriceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(300-52, 47, 53, 24)] autorelease];
        self.referencePriceLbl.font = [UIFont systemFontOfSize:12.0f];
        self.referencePriceLbl.backgroundColor = [UIColor clearColor];
        self.referencePriceLbl.backgroundColor = [UIColor clearColor];
        self.referencePriceLbl.adjustsFontSizeToFitWidth = YES;
        self.referencePriceLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.referencePriceLbl.textAlignment = NSTextAlignmentRight;
        self.referencePriceLbl.text=@"参考价格";
        [frontView addSubview:self.referencePriceLbl];
        self.referencePriceLbl.hidden = YES;
        
        // 起
        self.priceEndLbl = [[[UILabel alloc] initWithFrame:CGRectMake(290, 35, 14, 14)] autorelease];
        self.priceEndLbl.font = [UIFont systemFontOfSize:12.0f];
        self.priceEndLbl.backgroundColor = [UIColor clearColor];
        self.priceEndLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.priceEndLbl.text = @"起";
        [frontView addSubview:self.priceEndLbl];
        
        // 满房
        self.fullyBookedLbl =  [[[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, _cellFlag.cellHeight)] autorelease];
        self.fullyBookedLbl.hidden = YES;
        self.fullyBookedLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.fullyBookedLbl.text = @"满房";
        self.fullyBookedLbl.textAlignment = UITextAlignmentRight;
        self.fullyBookedLbl.backgroundColor = [UIColor clearColor];
        self.fullyBookedLbl.textAlignment = UITextAlignmentCenter;
        [frontView addSubview:self.fullyBookedLbl];
        
        // 返现图标
        self.backImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(260, 53, 14, 12)] autorelease];
        self.backImageView.image = [UIImage noCacheImageNamed:@"fanxian_icon.png"];
        [frontView addSubview:self.backImageView];
        
        // 返现价格
        self.backPriceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(275, 54, 35, 12)] autorelease];
        self.backPriceLbl.font = [UIFont systemFontOfSize:10.0f];
        self.backPriceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
        [frontView addSubview:self.backPriceLbl];
        
        // 原价
        self.originalPriceLbl = [[[UILabel alloc] initWithFrame:CGRectMake(250, 72, 50, 14)] autorelease];
        self.originalPriceLbl.font = [UIFont systemFontOfSize:12.0f];
        self.originalPriceLbl.textColor = RGBACOLOR(119, 119, 119, 1);
        self.originalPriceLbl.backgroundColor = [UIColor clearColor];
        [frontView addSubview:self.originalPriceLbl];
        self.originalPriceLbl.textAlignment = UITextAlignmentCenter;
        UIImageView *strickoutView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 6, self.originalPriceLbl.frame.size.width-4, 1)] autorelease];
        strickoutView.image = [UIImage noCacheImageNamed:@"price_line_bg.png"];
        [self.originalPriceLbl addSubview:strickoutView];
        
        // 箭头
        UIImageView *arrowImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(305, 0, 5, _cellFlag.cellHeight)] autorelease];
        arrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        arrowImageView.contentMode = UIViewContentModeCenter;
        [frontView addSubview:arrowImageView];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        self.backgroundColor = [UIColor whiteColor];
        
        // 分割线
        _dashView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, _cellFlag.cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        _dashView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:_dashView];
        
        // 推荐理由
        if (_cellFlag.recommend) {
            self.recommendLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, _cellFlag.cellHeight - 26, SCREEN_WIDTH - 20, 20)] autorelease];
            self.recommendLbl.font = [UIFont systemFontOfSize:14.0f];
            self.recommendLbl.numberOfLines = 1;
            self.recommendLbl.lineBreakMode = UILineBreakModeTailTruncation;
            self.recommendLbl.textColor = RGBACOLOR(52, 150, 80, 1);
            [frontView addSubview:self.recommendLbl];
            
            RoundCornerView *psgView = [[[RoundCornerView alloc] initWithFrame:CGRectMake(6, 6 + 20, 75 + 6, 75 + 6)] autorelease];
            psgView.imageRadius = 2.0f;
            psgView.image = [UIImage noCacheImageNamed:@"psg_recommend.png"];
            [frontView addSubview:psgView];
            
            self.hotelNameLbl.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 20);
            
            self.hotelImageView.frame = CGRectMake(6 + 10 + 75, 6 + 20, 75 + 6, 75 + 6);
            
            
            float moveY = 20;
            // 价格符号
            self.priceMarkLbl.frame = CGRectMake(209, 36 + moveY, 25, 14);
            
            
            // 价格
            self.priceLbl.frame = CGRectMake(236, 28 + moveY, 53, 24);
            
            // 起
            self.priceEndLbl.frame = CGRectMake(290, 35 + moveY, 14, 14);
            
            // 返现图标
            self.backImageView.frame = CGRectMake(260, 53 + moveY, 14, 12);
            
            // 返现价格
            self.backPriceLbl.frame = CGRectMake(275, 54 + moveY, 35, 12);
            
            // 原价
            self.originalPriceLbl.frame = CGRectMake(250, 72 + moveY, 50, 14);
            
            
            
            // wifi
            self.wifiImageView.frame = CGRectMake(178, 33, 15, 11);
            if (!_cellFlag.haveImage) {
                self.wifiImageView.frame = CGRectMake(94, 33, 15, 11);
            }
            
            // park
            self.parkImageView.frame = CGRectMake(178 + 16, 33, 15, 11);
            if (!_cellFlag.haveImage) {
                self.parkImageView.frame = CGRectMake(94 + 16, 33, 15, 11);
            }
            
            // star
            self.starLbl.frame = CGRectMake(178, 52, 200, 14);
            if (!_cellFlag.haveImage) {
                self.starLbl.frame = CGRectMake(94, 52, 200, 14);
            }
            
            // comment
            self.commentLbl.frame = CGRectMake(178, 71, 65, 14);
            if (!_cellFlag.haveImage) {
                self.commentLbl.frame = CGRectMake(94, 71, 65, 14);
            }
            
            // address
            self.addressLbl.frame = CGRectMake(178, 90, SCREEN_WIDTH - 178 - 5, 14);
            if (!_cellFlag.haveImage) {
                self.addressLbl.frame = CGRectMake(94, 90, SCREEN_WIDTH - 178 - 5, 14);
            }
            
            [self.promotionImageView removeFromSuperview];
            self.promotionImageView = nil;
            
            [self.vipImageView removeFromSuperview];
            self.vipImageView = nil;
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark Layout

// layout
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

#pragma mark -
#pragma mark Public Methods

// 刷新cell
- (void) reloadCell{
    if ([self.dataSource respondsToSelector:@selector(hotelListCellFillData:)]) {
        [self.dataSource hotelListCellFillData:self];
    }
}

- (void) resetPromotionFrame{
    // no wifi & no park
    if (!self.wifiImageView.image) {
        if (_cellFlag.haveImage) {
            self.promotionImageView.frame = CGRectMake(124 - 28, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(167 - 28, 33, 40, 12);
        }else{
            self.promotionImageView.frame = CGRectMake(40 - 30, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(84 - 30, 33, 40, 12);
        }
    }else if(!self.parkImageView.image){
        if (_cellFlag.haveImage) {
            self.promotionImageView.frame = CGRectMake(124 - 30 + 16, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(167 - 30 + 16, 33, 40, 12);
        }else{
            self.promotionImageView.frame = CGRectMake(40 - 30 + 16, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(84 - 30 + 16, 33, 40, 12);
        }
    }else{
        if (_cellFlag.haveImage) {
            self.promotionImageView.frame = CGRectMake(124, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(167, 33, 40, 12);
        }else{
            self.promotionImageView.frame = CGRectMake(40, 33, 40, 12);
            self.vipImageView.frame = CGRectMake(84, 33, 40, 12);
        }
    }
}

// 设置酒店价格
- (void) setPrice:(NSInteger)price{
    float moveY = self.recommend?20:0;
    if (price < 10) {
        self.priceMarkLbl.frame = CGRectMake(209+34, 36 + moveY, 25, 14);
    }else if (price<100) {
        self.priceMarkLbl.frame = CGRectMake(209+20, 36 + moveY, 25, 14);
    }else if(price < 1000){
        self.priceMarkLbl.frame = CGRectMake(209+10, 36 + moveY, 25, 14);
    }else if(price < 10000){
        self.priceMarkLbl.frame = CGRectMake(209, 36 + moveY, 25, 14);
    }else{
        self.priceMarkLbl.frame = CGRectMake(209 - 10, 36 + moveY, 25, 14);
    }
    self.priceLbl.text = [NSString stringWithFormat:@"%d",price];
}

// 设置星级
- (void) setStar:(NSInteger)level{
    self.starLbl.text = [PublicMethods getStar:level];
}

- (void) setStarFromHouse:(NSInteger)level{
    self.starLbl.text = [PublicMethods getHouseStar:level];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void) setAction:(BOOL)action{
    [self setAction:action animated:YES];
}

- (void) setAction:(BOOL)action animated:(BOOL)animated{
    _action = action;
    if (_action) {
        [scrollContenView setContentOffset:CGPointMake(_cellFlag.actionWidth, 0) animated:animated];
    }else{
        [scrollContenView setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}

#pragma mark-
#pragma mark UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    backView.hidden = NO;
    if (self.indexPath) {
        if ([self.delegate respondsToSelector:@selector(hotelListCellDidDeselected:)]) {
            [self.delegate hotelListCellDidDeselected:self];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.x <= -0.01 && self.action) {
        targetContentOffset->x = 0;
        _action = NO;
    }else if(velocity.x >= 0.01 && !self.action){
        targetContentOffset->x = _cellFlag.actionWidth;
        _action = YES;
    }else if(velocity.x != 0){
        if (self.action) {
            targetContentOffset->x = _cellFlag.actionWidth;
        }else{
            targetContentOffset->x = 0;
        }
    }else{
        if (scrollView.contentOffset.x < 60 && !self.action) {
            self.action = NO;
        }else if(scrollView.contentOffset.x < _cellFlag.actionWidth && !self.action){
            self.action = YES;
        }else if (scrollView.contentOffset.x > _cellFlag.actionWidth - 60 && self.action){
            self.action = YES;
        }else if (scrollView.contentOffset.x > 0 && self.action){
            self.action = NO;
        }
    }
}

#pragma mark -
#pragma mark Gesture

// 单击手势
- (void) handleSingleAction:(UITapGestureRecognizer *)regonizer{
    if([HotelListConfig share].singleTap){
        return;
    }
    [HotelListConfig share].singleTap = YES;
    
    CGPoint position = [regonizer locationInView:regonizer.view];
    if (position.x < SCREEN_WIDTH) {
        if (self.action) {
            self.action = NO;
        }else{
            backView.hidden = YES;
            // select
            if ([self.delegate respondsToSelector:@selector(hotelListCellDidSelected:)]) {
                [self.delegate hotelListCellDidSelected:self];
            }
            // action
            if ([self.delegate respondsToSelector:@selector(hotelListCellDidAction:)]) {
                [self.delegate hotelListCellDidAction:self];
            }
        }
    }else{
        // 导航、分享、收藏 触发
        position.x = position.x - SCREEN_WIDTH;
        if (position.x > 0 && position.x < _cellFlag.actionWidth/3) {
            [navBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [navBtn setSelected:YES];
            [navBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }else if (position.x > _cellFlag.actionWidth/3 && position.x < _cellFlag.actionWidth * 2/3) {
            [shareBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [shareBtn setSelected:YES];
            [shareBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }else if(position.x > _cellFlag.actionWidth * 2/3 && position.x < _cellFlag.actionWidth){
            [favBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [favBtn setSelected:YES];
            [favBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }
        [self setAction:NO animated:YES];
    }
    
    [self performSelector:@selector(setSingleTapEnabled) withObject:nil afterDelay:0.1];
}

// 长按手势
- (void) handleLongPressAction:(UILongPressGestureRecognizer *)regonizer{
    if (self.action) {
        return;
    }
    if([HotelListConfig share].singleTap){
        return;
    }
    [HotelListConfig share].singleTap = YES;
    
    if (regonizer.state == UIGestureRecognizerStateBegan) {
        backView.hidden = YES;
        // select
        if ([self.delegate respondsToSelector:@selector(hotelListCellDidSelected:)]) {
            [self.delegate hotelListCellDidSelected:self];
        }
    }else if(regonizer.state == UIGestureRecognizerStateEnded
             || regonizer.state == UIGestureRecognizerStateFailed
             || regonizer.state == UIGestureRecognizerStateCancelled){
        if (backView.hidden) {
            // action
            if ([self.delegate respondsToSelector:@selector(hotelListCellDidAction:)]) {
                [self.delegate hotelListCellDidAction:self];
            }
        }
    }else if(regonizer.state == UIGestureRecognizerStateChanged){
        // deselect
        if ([self.delegate respondsToSelector:@selector(hotelListCellDidDeselected:)]) {
            [self.delegate hotelListCellDidDeselected:self];
        }
        backView.hidden = NO;
    }
    
    [self performSelector:@selector(setSingleTapEnabled) withObject:nil afterDelay:0.1];
}


// 访问锁
- (void) setSingleTapEnabled{
    [HotelListConfig share].singleTap = NO;
}



#pragma mark -
#pragma mark 功能模块

/******* 收藏 *******/
- (void)favBtnClick:(id)sender{
    if ([self.actionDelegate respondsToSelector:@selector(hotelListCell:didAction:)]) {
        [self.actionDelegate hotelListCell:self didAction:HotelListActionFav];
    }
}

/******* 导航 *******/
- (void)navBtnClick:(id)sender{
    if ([self.actionDelegate respondsToSelector:@selector(hotelListCell:didAction:)]) {
        [self.actionDelegate hotelListCell:self didAction:HotelListActionNav];
    }
}

/******* 分享 *******/
- (void)shareBtnClick:(id)sender{
    if ([self.actionDelegate respondsToSelector:@selector(hotelListCell:didAction:)]) {
        [self.actionDelegate hotelListCell:self didAction:HotelListActionShare];
    }
}

@end
