//
//  HotelListCell.m
//  ElongClient
//
//  Created by Dawn on 13-12-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UnsignedHotelListCell.h"
#import "HotelListMode.h"

@interface UnsignedHotelListCell()
@property (nonatomic,assign) BOOL haveImage;

@property (nonatomic,assign) NSInteger cellHeight;
@end

#define HOTELLISTFUNCTION_WIDTH 228
@implementation UnsignedHotelListCell


- (void) dealloc{
    self.hotelNameLbl = nil;
    self.hotelImageView = nil;
    self.starLbl = nil;
    self.priceMarkLbl = nil;
    self.priceLbl = nil;
    self.priceEndLbl = nil;
    self.fullyBookedLbl = nil;
    self.hotelId = nil;
    self.indexPath = nil;
    self.referencePriceLbl=nil;
    if (favUtil) {
        [favUtil cancel];
        [favUtil release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction recommend:(BOOL)recommend{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.haveImage = image;
        self.cellHeight = 95;
        
        if (!IOSVersion_5) {
            haveAction = NO;
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 &&
            [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        {
            if ([[[UIDevice currentDevice] systemVersion] compare:@"5.1.0"] == NSOrderedAscending ||
                [[[UIDevice currentDevice] systemVersion] compare:@"5.1.0"] == NSOrderedSame
                )
            {
                haveAction = NO;
            }
        }
        
        UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight)];
        frontView.backgroundColor = [UIColor whiteColor];
        
        if (haveAction) {
            // 背面隐藏功能按钮
            backView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - HOTELLISTFUNCTION_WIDTH, 0, HOTELLISTFUNCTION_WIDTH, self.cellHeight)];
            backView.backgroundColor  = [UIColor whiteColor];
            [self.contentView addSubview:backView];
            backView.userInteractionEnabled = YES;
            [backView release];
            
            // 功能模块
            navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:navBtn];
            navBtn.frame = CGRectMake(0, 0, HOTELLISTFUNCTION_WIDTH/3, backView.frame.size.height);
            [navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [navBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [navBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun2.png"] forState:UIControlStateNormal];
            [navBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun2_h.png"] forState:UIControlStateSelected];
            [navBtn setTitle:@"导航" forState:UIControlStateNormal];
            [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:shareBtn];
            shareBtn.frame = CGRectMake(HOTELLISTFUNCTION_WIDTH/3, 0, HOTELLISTFUNCTION_WIDTH/3, backView.frame.size.height);
            [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [shareBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [shareBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun1.png"] forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun1_h.png"] forState:UIControlStateSelected];
            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:favBtn];
            favBtn.frame = CGRectMake(2 * HOTELLISTFUNCTION_WIDTH/3, 0, HOTELLISTFUNCTION_WIDTH/3, backView.frame.size.height);
            [favBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [favBtn setTitleColor:RGBACOLOR(137, 137, 137, 1) forState:UIControlStateHighlighted];
            [favBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun0.png"] forState:UIControlStateNormal];
            [favBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"hotellistcell_fun0_h.png"] forState:UIControlStateSelected];
            [favBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [favBtn addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            // cell 内容
            scrollContenView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight)];
            scrollContenView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:scrollContenView];
            scrollContenView.contentSize = CGSizeMake(backView.frame.size.width + frontView.frame.size.width , self.cellHeight);
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
            frontView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight);
        }else{
            frontView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight);
            [self.contentView addSubview:frontView];
            [frontView release];
        }
        
        
        // 酒店图片
        if (self.haveImage) {
            self.hotelImageView = [[[RoundCornerView alloc] initWithFrame:CGRectMake(6, 6, 75 + 6, 75 + 6)] autorelease];
            self.hotelImageView.imageRadius = 2.0f;
            [frontView addSubview:self.hotelImageView];
        }else{
            self.hotelImageView = nil;
        }
        
        // 酒店名
        self.hotelNameLbl = [[[UILabel alloc] initWithFrame:CGRectMake(95, 9, SCREEN_WIDTH - 95 - 10, 20)] autorelease];
        self.hotelNameLbl.font = [UIFont boldSystemFontOfSize:16.0f];
        self.hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        [frontView addSubview:self.hotelNameLbl];
        if (!self.haveImage) {
            self.hotelNameLbl.frame = CGRectMake(10, 9, SCREEN_WIDTH - 40, 20);
        }
        
        // 星级
        self.starLbl = [[[UILabel alloc] initWithFrame:CGRectMake(95, 52, 200, 14)] autorelease];
        self.starLbl.font = [UIFont systemFontOfSize:12];
        self.starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.starLbl.backgroundColor = [UIColor clearColor];
        [frontView addSubview:self.starLbl];
        if (!self.haveImage) {
            self.starLbl.frame = CGRectMake(10, 53, 100, 14);
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
        
        // 起
        self.priceEndLbl = [[[UILabel alloc] initWithFrame:CGRectMake(290, 35, 14, 14)] autorelease];
        self.priceEndLbl.font = [UIFont systemFontOfSize:12.0f];
        self.priceEndLbl.backgroundColor = [UIColor clearColor];
        self.priceEndLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.priceEndLbl.text = @"起";
        [frontView addSubview:self.priceEndLbl];
        
        //暂无报价
        self.fullyBookedLbl =  [[[UILabel alloc] initWithFrame:CGRectMake(220, 0, 100, self.cellHeight)] autorelease];
        self.fullyBookedLbl.hidden = YES;
        self.fullyBookedLbl.textColor = RGBACOLOR(108, 108, 108, 1);
        self.fullyBookedLbl.text = @"暂无报价";
        self.fullyBookedLbl.backgroundColor = [UIColor clearColor];
        self.fullyBookedLbl.textAlignment = UITextAlignmentCenter;
        [frontView addSubview:self.fullyBookedLbl];
        
        // 箭头
        UIImageView *arrowImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(305, 0, 5, self.cellHeight)] autorelease];
        arrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        arrowImageView.contentMode = UIViewContentModeCenter;
        [frontView addSubview:arrowImageView];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        self.backgroundColor = [UIColor whiteColor];
        
        // 分割线
        UIImageView *dashView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, self.cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        dashView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:dashView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier haveImage:image haveAction:haveAction recommend:NO];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image{
    
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier haveImage:image haveAction:NO];
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

#pragma mark -
#pragma mark 功能模块

/******* 收藏 *******/
- (void)favBtnClick:(id)sender{
    
    [Utils alert:@"抱歉，该酒店无法预订，暂不支持收藏，谢谢。"];
    return;
    
    // 注册收藏监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFavorSuccess:) name:NOTI_ADDFAVOR_SUCCESS object:nil];
    
    // 调用收藏酒店接口
    BOOL islogin = [[AccountManager instanse] isLogin];
	if (islogin) {
		JAddFavorite *addFavorite = [HotelPostManager addFavorite];
		[addFavorite setHotelId:self.hotelId];
        
        if (favUtil) {
            [favUtil cancel];
            [favUtil release];
        }
        favUtil = [[HttpUtil alloc] init];
        [favUtil connectWithURLString:HOTELSEARCH  Content:[addFavorite requesString:YES] StartLoading:NO EndLoading:NO Delegate:self];
        
        // 停止监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
	}else {
        [[HotelDetailController hoteldetail] safeSetObject:self.hotelId forKey:@"HotelId"];
        
        // 需登录收藏
		LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavNormalBtnStyle_ state:_HotelAddFavorite_];
		[self.parentNav pushViewController:login animated:YES];
		[login release];
	}
}

- (void)getFavorSuccess:(NSNotification *)noti{
	// 停止监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
    [PublicMethods showAlertTitle:@"" Message:@"收藏成功"];
}

/******* 导航 *******/
- (void)navBtnClick:(id)sender{
    
    if (IOSVersion_6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否离开应用进行导航？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
        [alert release];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否离开应用进行导航？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
        [alert release];
        
    }
    return ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        double latitude  = [[self.hotelDict safeObjectForKey:@"Latitude"] doubleValue];
        double longitude  = [[self.hotelDict safeObjectForKey:@"Longitude"] doubleValue];
        
        if (latitude==0&&longitude==0) {
            [Utils alert:@"抱歉，酒店坐标不存在，无法导航，谢谢"];
        }
        
        [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:[self.hotelDict safeObjectForKey:@"HotelName"]];
    }
}

/******* 分享 *******/
- (void)shareBtnClick:(id)sender{
    ElongClientAppDelegate *_delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *controller = [_delegate.navigationController.viewControllers lastObject];
	ShareTools *shareTools = [ShareTools shared];
    shareTools.sharefrom = Sharefromhotelist;
    shareTools.contentViewController = controller;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
    NSString *hotelid = [self.hotelDict safeObjectForKey:@"HotelId"];
    shareTools.mailImage = self.imageView.image;
	shareTools.hotelId = hotelid;
	shareTools.msgContent = @"test";
	shareTools.mailTitle = @"我用艺龙客户端查找到一家酒店";
    shareTools.weiBoContent = [self weiboContent];
	shareTools.msgContent = [self smsContent];
	shareTools.mailContent = [self mailContent];
    
	[shareTools  showItems];
}

-(NSString *) smsContent{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",[self.hotelDict safeObjectForKey:@"HotelName"]];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[self.hotelDict safeObjectForKey:@"StarCode"]];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！下载链接：http://m.elong.com/b/r?p=z",[self.hotelDict safeObjectForKey:@"Address"]];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@",hotelname,starlevel,Address];
	return messageBody;
}

-(NSString *) mailContent{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",[self.hotelDict safeObjectForKey:@"HotelName"]];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[self.hotelDict safeObjectForKey:@"StarCode"]];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！",[self.hotelDict safeObjectForKey:@"Address"]];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@",hotelname,starlevel,Address];
	return messageBody;
}

- (NSString *) weiboContent
{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",[self.hotelDict safeObjectForKey:@"HotelName"]];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[self.hotelDict safeObjectForKey:@"StarCode"]];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！下载链接：http://m.elong.com/b/r?p=z",[self.hotelDict safeObjectForKey:@"Address"]];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@",hotelname,starlevel,Address];
	return messageBody;
}

// 设置酒店价格
- (void) setPrice:(NSInteger)price{
    float moveY = 0;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

#pragma mark-
#pragma mark UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    backView.hidden = NO;
    if (self.indexPath) {
        [self.parent deselectRowAtIndexPath:self.indexPath animated:NO];
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
        targetContentOffset->x = HOTELLISTFUNCTION_WIDTH;
        _action = YES;
    }else if(velocity.x != 0){
        if (self.action) {
            targetContentOffset->x = HOTELLISTFUNCTION_WIDTH;
        }else{
            targetContentOffset->x = 0;
        }
    }else{
        if (scrollView.contentOffset.x < 40 && !self.action) {
            self.action = NO;
        }else if(scrollView.contentOffset.x < HOTELLISTFUNCTION_WIDTH && !self.action){
            self.action = YES;
        }else if (scrollView.contentOffset.x > HOTELLISTFUNCTION_WIDTH - 40 && self.action){
            self.action = YES;
        }else if (scrollView.contentOffset.x > 0 && self.action){
            self.action = NO;
        }
    }
}

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
            
            [self.parent selectRowAtIndexPath:self.indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            id<UITableViewDelegate> listMode = self.parent.delegate;
            if([listMode respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
                [listMode tableView:self.parent didSelectRowAtIndexPath:self.indexPath];
            }
        }
    }else{
        position.x = position.x - SCREEN_WIDTH;
        if (position.x > 0 && position.x < HOTELLISTFUNCTION_WIDTH/3) {
            [navBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [navBtn setSelected:YES];
            [navBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }else if (position.x > HOTELLISTFUNCTION_WIDTH/3 && position.x < HOTELLISTFUNCTION_WIDTH * 2/3) {
            [shareBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [shareBtn setSelected:YES];
            [shareBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }else if(position.x > HOTELLISTFUNCTION_WIDTH * 2/3 && position.x < HOTELLISTFUNCTION_WIDTH){
            [favBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [favBtn setSelected:YES];
            [favBtn performSelector:@selector(setSelected:) withObject:NO afterDelay:0.2];
        }
        [self setAction:NO animated:YES];
    }
    
    [self performSelector:@selector(setSingleTapEnabled) withObject:nil afterDelay:0.1];
}

- (void) setSingleTapEnabled{
    [HotelListConfig share].singleTap = NO;
}


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
        [self.parent selectRowAtIndexPath:self.indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if(regonizer.state == UIGestureRecognizerStateEnded || regonizer.state == UIGestureRecognizerStateFailed || regonizer.state == UIGestureRecognizerStateCancelled){
        if (backView.hidden) {
            id<UITableViewDelegate> listMode = self.parent.delegate;
            if([listMode respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
                [listMode tableView:self.parent didSelectRowAtIndexPath:self.indexPath];
            }
        }
    }else if(regonizer.state == UIGestureRecognizerStateChanged){
        [self.parent deselectRowAtIndexPath:self.indexPath animated:NO];
        backView.hidden = NO;
    }
    
    [self performSelector:@selector(setSingleTapEnabled) withObject:nil afterDelay:0.1];
}

- (void) setAction:(BOOL)action{
    [self setAction:action animated:YES];
}

- (void) setAction:(BOOL)action animated:(BOOL)animated{
    _action = action;
    if (_action) {
        [scrollContenView setContentOffset:CGPointMake(HOTELLISTFUNCTION_WIDTH, 0) animated:animated];
    }else{
        [scrollContenView setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}

#pragma mark -
#pragma mark HttpUtilDelegate
- (void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if (util == favUtil) {
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        [PublicMethods showAlertTitle:@"" Message:@"收藏成功"];
    }
}

@end
