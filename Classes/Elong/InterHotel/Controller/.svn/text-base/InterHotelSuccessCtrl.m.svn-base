//
//  InterHotelSuccessCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-7-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelSuccessCtrl.h"
#import "InterHotelPostManager.h"
#import "FXLabel.h"
#import "InterHotelDetailCtrl.h"
#import "GoogleConversionPing.h"
#import <MapKit/MapKit.h>
#import "OrderManagement.h"

@interface InterHotelSuccessCtrl ()

@property(nonatomic,retain) UIScrollView *scrollview;
@property(nonatomic,retain) UIImageView *envelopImg;
@property(nonatomic,retain) UIButton *confirmButton;
@property(nonatomic,retain) UIButton *goMyOrderBtn;
@property(nonatomic,retain) UIButton *goHotelBtn;
@property(nonatomic,retain) UIImageView *line_1,*line_2,*line_3;
@property (nonatomic,retain) PKPass *pass;

- (void)goHotel ;       //带我去酒店
- (void)goMyOrder;  //查看订单
-(void)confirm; //确定

@end


#define VALUE_XOFFSET 3
#define Y_SPACE 14

@implementation InterHotelSuccessCtrl
@synthesize scrollview;
@synthesize envelopImg;
@synthesize confirmButton,goMyOrderBtn,goHotelBtn;
@synthesize line_1,line_2,line_3;

- (void)dealloc
{
    self.pass = nil;
    [scrollview release];
    [envelopImg release];
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOrderNo:(NSString *)orderNo
{
    self =  [super initWithTopImagePath:nil andTitle:_string(@"s_hotel_ordersuccess") style:_NavOnlyHomeBtnStyle_];
    if (self) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44);
        
        
        //异步发送订单号--新增功能
        NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
        float latitude = 0.0;
        float longitude = 0.0;
        if(DICTIONARYHASVALUE(baseInfo)){
            latitude = [[baseInfo safeObjectForKey:@"Latitude"] floatValue];
            longitude = [[baseInfo safeObjectForKey:@"Longitude"] floatValue];
        }
        [PublicMethods saveHotelOrderGpsWithOrderNo:orderNo HotelLat:latitude HotelLon:longitude];
        //--------------
        
		[self setShowBackBtn:NO];
    
        if(!scrollview){
            scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 20-44)];
        }
        
        // 添加背景图
        if(!envelopImg){
            envelopImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 194)];
            envelopImg.backgroundColor = [UIColor whiteColor];
            
            UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImgUp.png"]];
            upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 7);
            upSplitView.contentMode=UIViewContentModeScaleToFill;
            [envelopImg addSubview:upSplitView];
            [upSplitView release];
            
            UIImageView *lagImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImg.png"]];
            lagImageView.frame = CGRectMake(SCREEN_WIDTH-80, 0, 63, 44);
            lagImageView.contentMode=UIViewContentModeScaleToFill;
            [envelopImg addSubview:lagImageView];
            [lagImageView release];
        }
        [self.scrollview addSubview:envelopImg];
        
        // 添加订单信息
        UILabel *successTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 180, 29)];
        successTipLabel.text				= @"预订成功 !";
        successTipLabel.font				= [UIFont boldSystemFontOfSize:20];
        successTipLabel.textColor           = RGBACOLOR(252, 152, 44, 1);
        successTipLabel.backgroundColor		= [UIColor clearColor];
        [envelopImg addSubview:successTipLabel];
        [successTipLabel release];
        
        float ypos;
        int orderid = [orderNo intValue];
        //订单号
        if(orderid == 0){
            ypos = 60;
        }else{
            ypos=[self makeListLabel:envelopImg pos:CGPointMake(20, 50) name:_string(@"s_hotelorderid_title") value:orderNo valuehighlight:RGBACOLOR(52, 52, 52, 1)];
        }
        //消费金额
        JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
        NSMutableDictionary *tmpDic = [interOrder getObjectForKey:Req_InterHotelProducts];
        float orderTotalPrice = 0;
        NSString *hotelName = @"";
        if(DICTIONARYHASVALUE(tmpDic)){
            orderTotalPrice = [[tmpDic safeObjectForKey:Req_OrderTotalPrice] floatValue];
            hotelName = [tmpDic safeObjectForKey:Req_HotelName];
        }
        ypos=[self makePriceListLabel:envelopImg pos:CGPointMake(20, ypos) name:_string(@"s_hoteltotalcash_title") value:[NSNumber numberWithFloat:orderTotalPrice] valuehighlight:RGBACOLOR(52, 52, 52, 1)];
        //酒店名称
        ypos = [self makeListLabel:envelopImg pos:CGPointMake(20, ypos) name:_string(@"s_ho_name") value:hotelName valuehighlight:RGBACOLOR(52, 52, 52, 1)];
        
        int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
        //预付卡需要提示
        if (promotionTag == 4) {
            //获取预付卡金额
            NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
            NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
            float giftcardAmount = [[priceInfo safeObjectForKey:@"GiftCardAmount"] floatValue];

            UILabel *giftcardLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,ypos+10, 290, 0)] autorelease];
            giftcardLabel.backgroundColor = [UIColor clearColor];
            giftcardLabel.textColor = [UIColor redColor];
            giftcardLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            giftcardLabel.numberOfLines = 0;
            [envelopImg addSubview:giftcardLabel];
            
            NSString *giftCardDesp = [NSString stringWithFormat:@"恭喜获得%.f元艺龙礼品卡！结账后3个工作日内艺龙会将礼品卡卡号和密码发送短信给您，可以到艺龙账户充值使用。",giftcardAmount];
            CGSize giftCardSize = [giftCardDesp sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(290, INT_MAX)];
            giftcardLabel.frame = CGRectMake(20, ypos+10, 290, giftCardSize.height);
            if (giftcardAmount > 0) {
                giftcardLabel.text = giftCardDesp;
            }
            
            envelopImg.frame = CGRectMake(0, 8, SCREEN_WIDTH, ypos+20+giftCardSize.height+10);
            ypos = ypos+20+giftCardSize.height;
        }
        //添加底部图片
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImgDown.png"]];
        upSplitView.frame = CGRectMake(0, envelopImg.frame.size.height-7, SCREEN_WIDTH, 7);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [envelopImg addSubview:upSplitView];
        [upSplitView release];
        
        // 暂时隐藏passbook
        
        //[self makeupOrdreSaveFrom:ypos];
        
        // 添加下方按钮
        confirmButton = [UIButton uniformButtonWithTitle:@"确 定"
                                               ImagePath:nil
                                                  Target:self
                                                  Action:@selector(confirm)
                                                   Frame:CGRectMake(20,ypos+60, SCREEN_WIDTH - 40, BOTTOM_BUTTON_HEIGHT)];
        
        [scrollview addSubview:confirmButton];
        
        
        goMyOrderBtn = [UIButton arrowButtonWithTitle:@"订单管理"
                                               Target:self
                                               Action:@selector(goMyOrder)
                                                Frame:CGRectMake(0, confirmButton.frame.origin.y + confirmButton.frame.size.height + 12, SCREEN_WIDTH, 44)
                                          Orientation:ArrowOrientationRight];
        goMyOrderBtn.titleLabel.font = FONT_15;
        [goMyOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 171)];
        [goMyOrderBtn setImage:[UIImage noCacheImageNamed:@"viewOrder.png"] forState:UIControlStateNormal];
        [goMyOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 204)];
        
        [scrollview addSubview:goMyOrderBtn];
        
        line_1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        line_1.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [goMyOrderBtn addSubview:line_1];
        
        line_2 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        line_2.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [goMyOrderBtn addSubview:line_2];
        
        goHotelBtn = [UIButton arrowButtonWithTitle:@"带我去酒店"
                                             Target:self
                                             Action:@selector(goHotel)
                                              Frame:CGRectMake(0, goMyOrderBtn.frame.origin.y + goMyOrderBtn.frame.size.height, SCREEN_WIDTH, 44)
                                        Orientation:ArrowOrientationRight];
        goHotelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 211);
        goHotelBtn.titleLabel.font = FONT_15;
        [scrollview addSubview:goHotelBtn];
        line_3 = [[[UIImageView alloc] initWithFrame:CGRectMake(0,  44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        line_3.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [goHotelBtn addSubview:line_3];
        
        scrollview.contentSize=CGSizeMake(320, goHotelBtn.frame.origin.y+goHotelBtn.frame.size.height+48);
        [self.view addSubview:scrollview];
        
        
        if (UMENG) {
            //国际酒店订单成功页面
            [MobClick event:Event_InterHotelOrder_Succeed];
        }
    }
    return self;
}

- (void) makeupOrdreSaveFrom:(float)ypos{
    

    if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
        UIView *passSelectedView = [[UIView alloc] initWithFrame:CGRectMake(10, ypos + 114, SCREEN_WIDTH, 50)];
        passSelectedView.backgroundColor = [UIColor clearColor];
        
        // title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, HSC_CELL_HEGHT)/*CGRectMake(65 + i * 155, 0, 100, HSC_CELL_HEGHT)*/];
        titleLabel.backgroundColor	= [UIColor clearColor];
        titleLabel.textColor		= [UIColor blackColor];
        titleLabel.font				= FONT_B16;
        titleLabel.textAlignment	= UITextAlignmentLeft;
        titleLabel.text = @"订单保存到";
        
        UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(152, 14, 72, 23)];
        passImg.image = [UIImage noCacheImageNamed:@"passbook_success.png"];
        [passSelectedView addSubview:passImg];
        [passImg release];
        
        [passSelectedView addSubview:titleLabel];
        [titleLabel release];
        
        // button
        NSString *imgPath;
        imgPath = @"btn_checkbox.png";
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HSC_CELL_HEGHT)/*CGRectMake(15 + i * 155, 0, 140, HSC_CELL_HEGHT)*/];
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(mutipleConditionBeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(12.5, 23.5, 12.5, 268.5);//UIEdgeInsetsMake(12.5, 19, 12.5, 93);
        [passSelectedView addSubview:button];
        [button release];
        
        [scrollview addSubview:passSelectedView];
        [passSelectedView release];
    }
}


- (void)mutipleConditionBeSelected:(id)sender {
	UIButton *btn = (UIButton *)sender;
    saveordertoalbum = !saveordertoalbum;
    NSString *imgPath = saveordertoalbum ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
    [btn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    
    [self saveToPassbook];
}

- (void) saveToPassbook{
//    NSString *lat = [NSString stringWithFormat:@"%@", [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D]];
//    NSString *lon = [NSString stringWithFormat:@"%@", [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D]];
//    NSString *orderID = [NSString stringWithFormat:@"%ld", [[HotelPostManager hotelorder] orderNo]];
//    NSString *cardNum = [[AccountManager instanse] cardNo];
//    NSString *url = [PublicMethods getPassUrlByType:HotelPass orderID:orderID cardNum:cardNum lat:lat lon:lon];
    
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    passUtil = [[HttpUtil alloc] init];
    [passUtil connectWithURLString:@"" Content:nil Delegate:self];
}



#pragma mark - Public Methods
//文字高度
-(int)labelHeightWithNSString:(UIFont *)font frame:(CGRect)frame string:(NSString *)string width:(int)width{
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 60) lineBreakMode:UILineBreakModeCharacterWrap];
	return expectedLabelSize.height;
}

//提示信息Label
-(int)tipLabel:(UIView *)contentView pos:(CGPoint)pos string:(NSString *)string font:(UIFont *)font fontcolor:(UIColor *)fontcolor{
	int x=pos.x;
	int y=pos.y;
	UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 270, 38)];
	valuelabel.font=font;
	valuelabel.backgroundColor=[UIColor clearColor];
	valuelabel.textColor=fontcolor;
	valuelabel.numberOfLines=3;
	valuelabel.lineBreakMode=UILineBreakModeWordWrap;
	valuelabel.text=[NSString stringWithFormat:@"%@",string];
	int height = [self labelHeightWithNSString:font frame:valuelabel.frame string:string width:240];
	valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+2, valuelabel.frame.size.width,height);
	[contentView addSubview:valuelabel];
	[valuelabel release];
	return y+valuelabel.frame.size.height+Y_SPACE;
}
//价格信息
-(int)makePriceListLabel:(UIView *)contentView pos:(CGPoint)pos name:(NSString *)name value:(id)value valuehighlight:(UIColor *)valuehighlight{
	int x=pos.x;
	int y=pos.y;
	UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 30)];
	titlelabel.font= FONT_15;
	titlelabel.textColor = RGBACOLOR(93, 93, 93, 1);
	titlelabel.backgroundColor=[UIColor clearColor];
	titlelabel.text=[NSString stringWithFormat:@"%@：",name];
	titlelabel.textAlignment=UITextAlignmentLeft;
	
	NSString *currencyMark = @"¥ ";
	UILabel *valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(x+80+VALUE_XOFFSET, y, 200, 30)];
	valuelabel.font					= [UIFont boldSystemFontOfSize:15];
	valuelabel.text					= [NSString stringWithFormat:@"%@%.2f", currencyMark, [value floatValue]];
	valuelabel.backgroundColor		= [UIColor clearColor];
    valuelabel.textColor            = RGBACOLOR(254, 75, 32, 1);
	valuelabel.clipsToBounds		= NO;
	valuelabel.adjustsFontSizeToFitWidth = YES;
    
    // google订单统计
    [GoogleConversionPing pingWithConversionId:@"983846556" label:@"1lpVCLS0lwcQnJ2R1QM" value:valuelabel.text isRepeatable:YES];
    
	[contentView addSubview:titlelabel];
	[contentView addSubview:valuelabel];
	[titlelabel release];
	[valuelabel release];
	//[flaglabel release];
	return y+valuelabel.frame.size.height ;
}


-(int)makeListLabel:(UIView *)contentView pos:(CGPoint)pos name:(NSString *)name value:(id)value valuehighlight:(UIColor *)valuehighlight{
	int x=pos.x;
	int y=pos.y;
	UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y + 1, 100, 30)];
	titlelabel.font=FONT_15;
	titlelabel.textColor=RGBACOLOR(93, 93, 93, 1);
	titlelabel.backgroundColor=[UIColor clearColor];
	titlelabel.text=[NSString stringWithFormat:@"%@：",name];
	titlelabel.textAlignment=UITextAlignmentLeft;
    
    titlelabel.adjustsFontSizeToFitWidth = YES;
    titlelabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	
	UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(x+80+VALUE_XOFFSET, y, 200, 30)];
	valuelabel.font=FONT_15;
	valuelabel.backgroundColor=[UIColor clearColor];
	valuelabel.textColor=valuehighlight;
	valuelabel.textAlignment=UITextAlignmentLeft;
	valuelabel.numberOfLines =  0;
    valuelabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    valuelabel.adjustsFontSizeToFitWidth = YES;
    valuelabel.minimumFontSize = 12.0f;
    valuelabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
	if ([value isKindOfClass:[NSString class]]) {
		valuelabel.text=[NSString stringWithFormat:@"%@",value];
        CGSize size = CGSizeMake(200, 80);
        CGSize newSize = [value sizeWithFont:valuelabel.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        
		int height = newSize.height;
		int plusheight = 0;
        if (height == 60)
            plusheight = -3;
        else
            plusheight = 6;
		//[valuelabel sizeToFit];
		valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+plusheight, valuelabel.frame.size.width,height);
	}else if ([value isKindOfClass:[NSArray class]]) {
		
		NSMutableString *mutablestring=[[NSMutableString alloc] init];
		int count = 0;
		for (NSString *s in value)
		{
			[mutablestring appendFormat:@"%@ ",s];
			count++;
			if (count>=4) {
				[mutablestring appendFormat:@"%@",@"\n"];
				count=0;
			}
		}
		valuelabel.text=[NSString stringWithFormat:@"%@",mutablestring];
		int height = [self labelHeightWithNSString:FONT_15 frame:valuelabel.frame string:mutablestring width:200];
		
		
		valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+6, valuelabel.frame.size.width,height);
		
		
		[mutablestring release];
	}
	[contentView addSubview:titlelabel];
	[contentView addSubview:valuelabel];
	[titlelabel release];
	[valuelabel release];
	return y+valuelabel.frame.size.height+Y_SPACE;
}


#pragma mark - Action Methods

- (void)goHotel {
    NSDictionary *basedInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];

	double lat = 0;
	double lon = 0;
    NSString *hotelName = @"";
    NSString *hotelAddress = @"";
    if(DICTIONARYHASVALUE(basedInfo)){
        lat = [[basedInfo safeObjectForKey:@"Latitude"] doubleValue];
        lon = [[basedInfo safeObjectForKey:@"Longitude"] doubleValue];
        hotelName = [basedInfo safeObjectForKey:@"HotelName"];
        hotelAddress = [basedInfo safeObjectForKey:@"HotelAddress"];
    }
    
	if (lat != 0 || lon != 0) {
        [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(lat, lon) title:hotelName];
    }
	else {
		// 酒店没有坐标时用酒店地址导航
		[PublicMethods pushToMapWithDestName:hotelAddress];
	}
}


- (void)goMyOrder {
	// 订单查询
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
    order.isFromOrder = YES;
    [self.navigationController pushViewController:order animated:YES];
    [order release];
}

-(void)confirm{	
	//[super backhome];
	[self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
}

#pragma mark -
#pragma mark PKAddPassesViewControllerDelegate

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    if (IOSVersion_61) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HotelSearch class]]) {
                HotelSearch *searchCtr = (HotelSearch *)controller;
                [self.navigationController popToViewController:searchCtr animated:YES];
                break;
            }
        }
    }
    else {
        PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
        if ([passLibrary containsPass:self.pass]) {
            [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
        }
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HotelSearch class]]) {
                HotelSearch *searchCtr = (HotelSearch *)controller;
                [self.navigationController popToViewController:searchCtr animated:YES];
                [Utils clearHotelData];
                
                break;
            }
        }
    }
}



#pragma mark -
#pragma mark HttpUtilDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (util == passUtil) {
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            
            return;
        }
        NSError *error;

        self.pass = [[[PKPass alloc] initWithData:responseData error:&error] autorelease];

        PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:self.pass];
        if (addPassVC) {
            addPassVC.delegate = self;
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
        else {
            [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
        }
    }
}

@end
