    //
//  GrouponSuccessController.m
//  ElongClient
//	团购成功提示页面
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponSuccessController.h"
#import "GrouponSharedInfo.h"
#import "OrderManagement.h"
#import "ShareTools.h"
#import "GrouponFillOrder.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "AlipayViewController.h"
#import "GOrderHistoryRequest.h"
#import "GrouponOrderHistoryController.h"
#import "UniformCounterViewController.h"

#define PassAlertTag    89301
#define AlipayAlertTag  89302
#define BackHomeAlertTag 89303

@implementation GrouponSuccessController
@synthesize imagefromparent;

static GrouponSuccessController *instance = nil;

+(GrouponSuccessController *) currentInstance{
    return  instance;
}
+(void)setInstance:(GrouponSuccessController *)inst{
	instance = inst;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    SFRelease(pass);
    [passUtil cancel];
    SFRelease(passUtil);
	[valueArray	release];
	[titleArray	release];
	[labelArray release];
	[imagefromparent release];
    
    [buttonmView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithOrderID:(NSInteger)orderID {
	return [self initWithOrderID:orderID payType:GrouponOrderPayTypeCreditCard];
}

- (id)initWithOrderID:(NSInteger)orderID payType:(GrouponOrderPayType)type
{
	if (self = [super initWithTopImagePath:nil andTitle:@"订单成功" style:_NavOnlyHomeBtnStyle_]) {
		[self setShowBackBtn:NO];
        self.grouponPayType = type;
        
		titleArray = [[NSArray alloc] initWithObjects:@"订  单  号：", @"消费金额：", @"所购项目：", nil];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        bgView.image = [UIImage stretchableImageWithPath:@"groupon_success_bg.png"];
        [self.view insertSubview:bgView atIndex:0];
        [bgView release];
        
		orderNo = orderID;
        isCouldPay = NO;
        UniformCounterDataModel *model = [UniformCounterDataModel shared];
        
        NSString *grouponInfo = nil;        // 团购券信息
		GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
        if (STRINGHASVALUE(gInfo.title))
        {
            grouponInfo = gInfo.title;
        }
        
        NSString *orderPrice = nil;     // 团购总价
        if (model.orderTotalMoney > 0)
        {
            orderPrice = [NSString stringWithFormat:@"%.f", model.orderTotalMoney];
        }
        else
        {
            orderPrice = [NSString stringWithFormat:@"%d", [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice intValue] + (int)round([gInfo.expressFee floatValue]) : [gInfo.showTotalPrice intValue]];
        }
        
        NSString *orderName = nil;      // 团购产品名称
        if ([model.titlesArray count] > 0)
        {
            orderName = [NSString stringWithFormat:@"%@", [model.titlesArray safeObjectAtIndex:0]];
        }
        else
        {
            orderName = gInfo.prodName;
        }
		
		valueArray = [[NSMutableArray alloc] initWithObjects:
					  [NSString stringWithFormat:@"%d", orderID],
					  orderPrice,
					  orderName, nil];
        
        if (STRINGHASVALUE(grouponInfo))
        {
            [valueArray addObject:grouponInfo];
        }
		
		labelArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		[self performSelector:@selector(getValueAndSize)];
		[self performSelector:@selector(addInfoTable)];
        
        if(UMENG){
            //团购酒店订单成功页面
            [MobClick event:Event_GrouponHotelOrder_Succeed];
        }
        
        if (self.grouponPayType == GrouponOrderPayTypeCreditCard) {
            UMENG_EVENT(UEvent_Groupon_OrderSuccess);
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess) name:NOTI_WEIXIN_PAYSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
	}
	
	return self;
}



- (void)backhome{
	if (isCouldPay){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"支付未完成，您可以到个人中心－团购订单内完成支付"
													   delegate:self
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:@"确认", nil];
        alert.tag = BackHomeAlertTag;
		[alert show];
		[alert release];
	}
	else {
		[super backhome];
	}
}


- (void) back{
    [self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
}

-(void)setCouldPay:(BOOL)couldPay{
    isCouldPay = couldPay;
	if(isCouldPay){
        // 支付宝等待下单
		[self setNavTitle:@"支付订单"];
		successTipLabel.text = @"已下单！";
		payBtn.hidden = NO;
        buttonmView.hidden=YES;
		payNoteLabel.hidden = NO;

		[self setShowBackBtn:NO];

	}else {
        // 支付宝完成下单
        [GrouponFillOrder setIsGrouponPayment:NO];
		[self setNavTitle:@"预订成功"];
		successTipLabel.text = @"预订成功！";
		payBtn.hidden = YES;
        buttonmView.hidden=NO;
		payNoteLabel.hidden = YES;
		[self setShowBackBtn:YES];
	}
}


- (void)addInfoTable {
	// 信息table
	infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
	infoTable.backgroundColor	= [UIColor clearColor];
	infoTable.separatorStyle	= UITableViewCellSeparatorStyleNone;
	infoTable.dataSource		= self;
	infoTable.delegate			= self;
	[self.view addSubview:infoTable];
	[infoTable release];
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
    headerView.backgroundColor=[UIColor clearColor];
    infoTable.tableHeaderView=headerView;
    [headerView release];
}


// 获取value值与其label的size,并生成控件
- (void)getValueAndSize {
	// 订单部分
	textHeight = 50;
	
	for (NSInteger i = 0; i < [titleArray count]; i++) {
		// size of title
		CGSize titleSize	= [[titleArray safeObjectAtIndex:i] sizeWithFont:FONT_14];
		
		UILabel *titleLabel			= [[UILabel alloc] initWithFrame:CGRectMake(20, textHeight, titleSize.width, titleSize.height)];
		titleLabel.numberOfLines	= 0;
		titleLabel.font				= FONT_14;
		titleLabel.text				= [titleArray safeObjectAtIndex:i];
		titleLabel.backgroundColor	= [UIColor clearColor];
		[labelArray addObject:titleLabel];
		[titleLabel release];
		
		// size and content of value
		NSString *valueStr = [valueArray safeObjectAtIndex:i];
		
		if ([[NSNull null] isEqual:valueStr]) {
			// 空值处理
			valueStr = @"--";
		}
		
		CGSize valueSize = [valueStr sizeWithFont:FONT_B14 constrainedToSize:CGSizeMake(SCREEN_WIDTH-110, 45)];
		
		if (1 == i) {
			FXLabel *valueLabel = [[FXLabel alloc] initWithFrame:CGRectMake(95, textHeight, valueSize.width + 8, valueSize.height)];
			valueLabel.font					= FONT_14;
			valueLabel.text					= [NSString stringWithFormat:@"¥%@", valueStr];
			valueLabel.backgroundColor		= [UIColor clearColor];
			valueLabel.gradientStartColor	= COLOR_GRADIENT_START;
			valueLabel.gradientEndColor		= COLOR_GRADIENT_END;  
			valueLabel.clipsToBounds		= NO;
			valueLabel.adjustsFontSizeToFitWidth = YES;

			GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
			// 价格构成
			UILabel *priceStructure = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.frame.size.width,
																				0, 
																				287 - (valueLabel.frame.origin.x + valueLabel.frame.size.width),
																				valueLabel.frame.size.height)];
			NSString *priceStr = @"";
            if (gInfo.grouponID)
            {
                if ([gInfo.isInvoice boolValue]) {
                    priceStr = [NSString stringWithFormat:@"（¥%dx%d+%.0f快递费）",
                                (int)round([gInfo.salePrice floatValue]),
                                [gInfo.purchaseNum intValue],
                                [gInfo.expressFee floatValue]];
                }
                else {
                    priceStr = [NSString stringWithFormat:@"（¥%d x %d）",
                                (int)round([gInfo.salePrice floatValue]),
                                [gInfo.purchaseNum intValue]];
                }
            }
			
			priceStructure.font				= FONT_14;
			priceStructure.textColor		= [UIColor blackColor];
			priceStructure.backgroundColor	= [UIColor clearColor];
			priceStructure.text				= priceStr;
			priceStructure.minimumFontSize	= 9;
			priceStructure.adjustsFontSizeToFitWidth = YES;
			[valueLabel addSubview:priceStructure];
			[priceStructure release];
			
			[labelArray addObject:valueLabel];
			[valueLabel release];
		}
		else {
			UILabel *valueLabel;
            if (IOSVersion_7) {
                valueLabel			= [[UILabel alloc] initWithFrame:CGRectMake(95, textHeight, valueSize.width+8, valueSize.height)];
            }
            else
            {
                valueLabel			= [[UILabel alloc] initWithFrame:CGRectMake(95, textHeight, valueSize.width, valueSize.height)];
            }
			valueLabel.numberOfLines	= 0;
			if (0 == i) {
				// 订单号、消费金额加粗提醒
				valueLabel.font	= FONT_B14;
                
                if ([[valueArray safeObjectAtIndex:0] isEqualToString:@"0"]) {
                    // 没有订单号时，隐藏该行文字
                    titleLabel.hidden = YES;
                    valueLabel.hidden = YES;
                }
			}
			else {
				valueLabel.font	= FONT_14;
			}
			
			valueLabel.text				= [valueArray safeObjectAtIndex:i];
			valueLabel.backgroundColor	= [UIColor clearColor];
			
			[labelArray addObject:valueLabel];
			[valueLabel release];
		}
		
		textHeight += valueSize.height + 10;
	}
	
	// 团购券部分
	CGSize infoSize	= [[valueArray lastObject] sizeWithFont:FONT_13 constrainedToSize:CGSizeMake(250, 1000)];
	introHeight = infoSize.height + 63;
}


- (void)goMyOrder:(id) sender {
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
    
    UMENG_EVENT(UEvent_Groupon_OrderSuccess_Orders)
}


- (void)finishButtonPressed {
	if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passGrouponOn] && saveToPassbook) {
        NSString *orderID = [valueArray safeObjectAtIndex:0];
        NSString *cardNum = [[AccountManager instanse] cardNo];
        
        NSString *url = [PublicMethods getPassUrlByType:GrouponPass orderID:orderID cardNum:cardNum lat:@"0" lon:@"0"];
        
        if (passUtil) {
            [passUtil cancel];
            SFRelease(passUtil);
        }
        passUtil = [[HttpUtil alloc] init];
        [passUtil connectWithURLString:url Content:nil Delegate:self];
    }
    else {
        //返回首页
        [super backhome];
    }
}

- (void) clickCallBtn:(id) sender
{
    GrouponSharedInfo *gshareInfo = [GrouponSharedInfo shared];
    
    NSString *qianDianUrl=[[gshareInfo.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    
    NSArray *storeArray = [[gshareInfo.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
    Boolean isMultipleStore;
    if (storeArray.count > 1) {
        isMultipleStore = YES;
    }else{
        isMultipleStore = NO;
    }
    if (gshareInfo.appointmentPhone)
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu=nil;
        if (STRINGHASVALUE(qianDianUrl))
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:gshareInfo.appointmentPhone,@"在线预约",nil];
            menu.tag=UIActionSheetTag1;
        }
        else
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:gshareInfo.appointmentPhone,nil];
            menu.tag=UIActionSheetTag2;
        }
        
        menu.delegate = self;
        menu.actionSheetStyle = UIBarStyleBlackTranslucent;
        [menu showInView:appDelegate.window];
        [menu release];
    }
    else
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu=nil;
        if (!isMultipleStore)
        {
            if (STRINGHASVALUE(qianDianUrl))
            {
                menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"在线预约",nil];
                menu.tag=UIActionSheetTag3;
            }
            else
            {
                [Utils alert:@"预约电话请查看具体事项"];
                return;
            }
            
            return;
        }
        else
        {
            BOOL isCanMutipleStorePhone=[self isCouldMutilpleStorePhone];
            if (STRINGHASVALUE(qianDianUrl))
            {
                if (isCanMutipleStorePhone)
                {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"在线预约",@"电话预约",nil];
                    menu.tag=UIActionSheetTag4;
                }
                else
                {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"在线预约",nil];
                    menu.tag=UIActionSheetTag6;
                }
            }
            else
            {
                if (isCanMutipleStorePhone) {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"电话预约",nil];
                    
                    menu.tag=UIActionSheetTag5;
                }
                else
                {
                    [Utils alert:@"预约方式请查看具体事项，或者拨打400-666-1166"];
                }
            }
        }
        
        
        menu.delegate = self;
        menu.actionSheetStyle = UIBarStyleBlackTranslucent;
        [menu showInView:appDelegate.window];
        [menu release];
    }
}

//是否可以多店预约打电话
-(BOOL) isCouldMutilpleStorePhone
{
    GrouponSharedInfo *gshareInfo = [GrouponSharedInfo shared];
    NSArray *hotelInfoArray = [[gshareInfo.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
    if (ARRAYHASVALUE(hotelInfoArray))
    {
        for (NSDictionary *dic in hotelInfoArray)
        {
            if (dic==nil)
            {
                continue;
            }
            
            NSString *phoneStr = [dic safeObjectForKey:@"Telephone"];
            NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
            if ([phoneArray count] > 0)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *library = [[[PKPassLibrary alloc] init] autorelease];
    if ([library containsPass:pass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}


- (UIView *)selectPassbookViewByHeight:(NSInteger)offY {
	////加载checkbox
	UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(10, offY, SCREEN_WIDTH, 50)];
	selectedView.backgroundColor = [UIColor clearColor];
    // title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, HSC_CELL_HEGHT)];
    titleLabel.backgroundColor	= [UIColor clearColor];
    titleLabel.textColor		= [UIColor blackColor];
    titleLabel.font				= FONT_B16;
    titleLabel.textAlignment	= UITextAlignmentLeft;
	titleLabel.text = @"订单保存到";
	
	UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(152, 14, 72, 23)];
	passImg.image = [UIImage noCacheImageNamed:@"passbook_success.png"];
	[selectedView addSubview:passImg];
	[passImg release];
	
    [selectedView addSubview:titleLabel];
    [titleLabel release];
    
    saveToPassbook = NO;
    // button
    NSString *imgPath;
    imgPath = saveToPassbook ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HSC_CELL_HEGHT)/*CGRectMake(15 + i * 155, 0, 140, HSC_CELL_HEGHT)*/];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(saveToPass:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(12.5, 23.5, 12.5, 268.5);//UIEdgeInsetsMake(12.5, 19, 12.5, 93);
    [selectedView addSubview:button];
	[button release];
    
	return [selectedView autorelease];
}


- (void)saveToPass:(id)sender {
    NSString *orderID = [valueArray safeObjectAtIndex:0];
    NSString *cardNum = [[AccountManager instanse] cardNo];
    
    NSString *url = [PublicMethods getPassUrlByType:GrouponPass orderID:orderID cardNum:cardNum lat:@"0" lon:@"0"];
    
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    passUtil = [[HttpUtil alloc] init];
    [passUtil connectWithURLString:url Content:nil Delegate:self];
    
    UMENG_EVENT(UEvent_Groupon_OrderSuccess_Passbook)
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.row)
    {
        double lastLblHeight=178;
        
        if (labelArray.count>0)
        {
            UILabel *findLbl = [labelArray safeObjectAtIndex:labelArray.count-1];
            if (findLbl)
            {
                lastLblHeight=findLbl.frame.origin.y+findLbl.frame.size.height+16;
            }
        }
        
        return lastLblHeight;
	}
	else
    {
        double grouponContentHeight=0;
        NSString *grouponContent=[valueArray lastObject];
        if (STRINGHASVALUE(grouponContent))
        {
            NSArray *firstSplit = [grouponContent componentsSeparatedByString:@"● "];
            grouponContentHeight = [self computeGrouponContentViewHeight:firstSplit];
        }
        
        int offY = [valueArray count] > 3 ? grouponContentHeight : 0;
        
        BOOL isAddPassBookView=NO;
        
        if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passGrouponOn])
        {
            isAddPassBookView=YES;
        }
        
        [self setButtomView:isAddPassBookView];
        
        //支付包隐藏
        if ([GrouponFillOrder getIsGrouponPayment])
        {
            offY=offY+10+32+10+BOTTOM_BUTTON_HEIGHT+10;
        }
        else
        {
            offY=offY+buttonmView.frame.size.height;
        }
        
        return offY;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.contentView.backgroundColor = [UIColor clearColor];
		
		//int height = indexPath.row == 0 ? textHeight : introHeight;
		
		if (indexPath.row == 0) {
            
            double lastLblHeight=178;
            
            if (labelArray.count>0)
            {
                UILabel *findLbl = [labelArray safeObjectAtIndex:labelArray.count-1];
                if (findLbl)
                {
                    lastLblHeight=findLbl.frame.origin.y+findLbl.frame.size.height+16;
                }
            }
            
			// 添加背景图
			UIView *envelopImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, lastLblHeight)];
            envelopImg.backgroundColor=[UIColor whiteColor];
			[cell.contentView addSubview:envelopImg];
			[envelopImg release];
            
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
			
			// 添加订单信息
			successTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 180, 29)];
			successTipLabel.text				= @"预订成功 !";
            successTipLabel.textAlignment=NSTextAlignmentLeft;
			successTipLabel.font				= [UIFont boldSystemFontOfSize:19];
			successTipLabel.backgroundColor		= [UIColor clearColor];
            successTipLabel.textColor=RGBACOLOR(250, 148, 63, 1);
			[envelopImg addSubview:successTipLabel];
			[successTipLabel release];
			
			for (int i = 0; i < 2 * [titleArray count]; i ++) {
				[envelopImg addSubview:[labelArray safeObjectAtIndex:i]];
			}
            
            upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImgDown.png"]];
            upSplitView.frame = CGRectMake(0, envelopImg.frame.size.height-7, SCREEN_WIDTH, 7);
            upSplitView.contentMode=UIViewContentModeScaleToFill;
            [envelopImg addSubview:upSplitView];
            [upSplitView release];
		}
		else {
            int offY=10;
            
            if ([valueArray count] > 3)
            {
                // 添加团购券使用说明
                NSString *grouponContent=[valueArray lastObject];
                UIView *grouponContentView=nil;
                if (STRINGHASVALUE(grouponContent))
                {
                    NSArray *firstSplit = [grouponContent componentsSeparatedByString:@"● "];
                    grouponContentView= [self getGrouponContentView:firstSplit];
                    [cell addSubview:grouponContentView];
                }
                
                //偏移量
                if (grouponContentView) {
                    offY = grouponContentView.frame.origin.y + grouponContentView.frame.size.height;
                }
            }
            
            BOOL isAddPassBookView=NO;
            
            if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passGrouponOn])
            {
                isAddPassBookView=YES;
            }
            
            [self setButtomView:isAddPassBookView];
            buttonmView.frame=CGRectMake(0, offY, SCREEN_WIDTH, buttonmView.frame.size.height);
            [cell addSubview:buttonmView];
            
            //支付包隐藏
            if ([GrouponFillOrder getIsGrouponPayment]) {
                buttonmView.hidden=YES;
            }
            
            //支付提示信息
            NSString *alipayTip = @"";
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (self.grouponPayType == GrouponOrderPayTypeAlipay) {
                alipayTip = delegate.isNonmemberFlow ? @"非会员支付宝预订无法在订单管理页面继续支付，请直接点击“支付宝支付”进行支付." :  @"请在30分钟内完成支付，如未及时支付，将取消本次预订。";
            }else if(self.grouponPayType == GrouponOrderPayTypeWeixin){
                alipayTip = @"请在30分钟内完成支付，如未及时支付，将取消本次预订。";
            }
            
			payNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, offY+10, SCREEN_WIDTH-40, 32)];
			payNoteLabel.backgroundColor = [UIColor clearColor];
			payNoteLabel.text = alipayTip;
			payNoteLabel.font = [UIFont boldSystemFontOfSize:13];
			payNoteLabel.textColor = [UIColor colorWithRed:215.0/255.0 green:39.0/255.0 blue:69.0/255.0 alpha:1];
			payNoteLabel.numberOfLines = 0;
			[cell.contentView addSubview:payNoteLabel];
			[payNoteLabel release];
			payNoteLabel.hidden = YES;

            if (self.grouponPayType == GrouponOrderPayTypeAlipay) {
                //支付宝支付相关控件
                switch ([UniformCounterViewController paymentType])
                {
                    case UniformPaymentTypeAlipay:
                    {
                        payBtn = [UIButton uniformButtonWithTitle:@"支付宝支付" ImagePath:nil Target:self Action:@selector(payByalipay) Frame:CGRectMake(20, offY+10+32+10, SCREEN_WIDTH-40, BOTTOM_BUTTON_HEIGHT)];
                    }
                        break;
                    case UniformPaymentTypeAlipayWap:
                    {
                        payBtn = [UIButton uniformButtonWithTitle:@"支付宝支付" ImagePath:nil Target:self Action:@selector(payByAlipayWap) Frame:CGRectMake(20, offY+10+32+10, SCREEN_WIDTH-40, BOTTOM_BUTTON_HEIGHT)];
                    }
                        break;
                    case UniformPaymentTypeDepositCard:
                    {
                        payBtn = [UIButton uniformButtonWithTitle:@"储蓄卡支付" ImagePath:nil Target:self Action:@selector(payByAlipayWap) Frame:CGRectMake(20, offY+10+32+10, SCREEN_WIDTH-40, BOTTOM_BUTTON_HEIGHT)];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [cell.contentView addSubview:payBtn];
                payBtn.hidden = YES;
            }
            else if(self.grouponPayType == GrouponOrderPayTypeWeixin){
                //支付宝支付相关控件
                payBtn = [UIButton uniformButtonWithTitle:@"微信支付" ImagePath:nil Target:self Action:@selector(payByWeixin) Frame:CGRectMake(20, offY+10+32+10, SCREEN_WIDTH-40, BOTTOM_BUTTON_HEIGHT)];
                [cell.contentView addSubview:payBtn];
                payBtn.hidden = YES;
            }
            
            if (self.grouponPayType == GrouponOrderPayTypeCreditCard) {
                [self setCouldPay:NO];
            }else{
                [self setCouldPay:YES];
            }
		}
    }
	   
    return cell;
}

//设置底部栏，是否有passbook
-(void) setButtomView:(BOOL) isHavePassbook
{
    if (buttonmView) {
        return;
    }
    
    double gridHeight=45;
    int addRows=0;
    
    buttonmView=[[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH,gridHeight*4)];
    [buttonmView retain];
    
    //电话预约
    UIButton *btnCallBook=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCallBook.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnCallBook.frame=CGRectMake(0, 45*addRows, SCREEN_WIDTH, gridHeight);
    [btnCallBook setTitle:@"预约" forState:UIControlStateNormal];
//    [btnCallBook setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 171)];
    [btnCallBook setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 200)];
    [btnCallBook setTitleColor:RGBACOLOR(108, 108, 108, 1) forState:UIControlStateNormal];
    btnCallBook.titleLabel.font=FONT_14;
    [btnCallBook setImage:[UIImage noCacheImageNamed:@"orderPhoneBook.png"] forState:UIControlStateNormal];
//    [btnCallBook setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 204)];
    [btnCallBook setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 230)];
    [buttonmView addSubview:btnCallBook];
    [btnCallBook addTarget:self action:@selector(clickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 右箭头
    UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5, gridHeight/2 - 4, 5, 9)];
    rightArrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [btnCallBook addSubview:rightArrowImageView];
    [rightArrowImageView release];
    
    UIImageView *split= [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    split.frame = CGRectMake(0, gridHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    split.contentMode=UIViewContentModeScaleToFill;
    [btnCallBook addSubview:split];
    [split release];
    
    addRows++;
    
    if (isHavePassbook)
    {
        //添加到passbook
        UIButton *btnAddToPassbook=[UIButton buttonWithType:UIButtonTypeCustom];
        btnAddToPassbook.titleLabel.textAlignment=NSTextAlignmentLeft;
        btnAddToPassbook.frame=CGRectMake(0, 45*addRows, SCREEN_WIDTH, gridHeight);
        [btnAddToPassbook setTitle:@"添加到Passbook" forState:UIControlStateNormal];
        [btnAddToPassbook setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 125)];
        [btnAddToPassbook setTitleColor:RGBACOLOR(108, 108, 108, 1) forState:UIControlStateNormal];
        btnAddToPassbook.titleLabel.font=FONT_14;
        [btnAddToPassbook setImage:[UIImage noCacheImageNamed:@"addToPassBook.png"] forState:UIControlStateNormal];
        [btnAddToPassbook setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 149)];
        [buttonmView addSubview:btnAddToPassbook];
        [btnAddToPassbook addTarget:self action:@selector(saveToPass:) forControlEvents:UIControlEventTouchUpInside];
        
        // 右箭头
        rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5, gridHeight/2 - 4, 5, 9)];
        rightArrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [btnAddToPassbook addSubview:rightArrowImageView];
        [rightArrowImageView release];
        
        split= [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        split.frame = CGRectMake(0, gridHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        split.contentMode=UIViewContentModeScaleToFill;
        [btnAddToPassbook addSubview:split];
        [split release];
        
        addRows++;
    }
    
    //查看订单
    UIButton *btnViewHotelOrder=[UIButton buttonWithType:UIButtonTypeCustom];
    btnViewHotelOrder.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnViewHotelOrder.frame=CGRectMake(0, 45*addRows, SCREEN_WIDTH, gridHeight);
    [btnViewHotelOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnViewHotelOrder setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 171)];
    [btnViewHotelOrder setTitleColor:RGBACOLOR(108, 108, 108, 1) forState:UIControlStateNormal];
    btnViewHotelOrder.titleLabel.font=FONT_14;
    [btnViewHotelOrder setImage:[UIImage noCacheImageNamed:@"viewOrder.png"] forState:UIControlStateNormal];
    [btnViewHotelOrder setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 204)];
    [buttonmView addSubview:btnViewHotelOrder];
    [btnViewHotelOrder addTarget:self action:@selector(goMyOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    // 右箭头
    rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5, gridHeight/2 - 4, 5, 9)];
    rightArrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [btnViewHotelOrder addSubview:rightArrowImageView];
    [rightArrowImageView release];
    
    split= [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    split.frame = CGRectMake(0, gridHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    split.contentMode=UIViewContentModeScaleToFill;
    [btnViewHotelOrder addSubview:split];
    [split release];
    
    addRows++;
    
    //转发
    UIButton *btnShareOrder=[UIButton buttonWithType:UIButtonTypeCustom];
    btnShareOrder.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnShareOrder.frame=CGRectMake(0, 45*addRows, SCREEN_WIDTH, gridHeight);
    [btnShareOrder setTitle:@"帮别人订，转发订单" forState:UIControlStateNormal];
    [btnShareOrder setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 106)];
    [btnShareOrder setTitleColor:RGBACOLOR(108, 108, 108, 1) forState:UIControlStateNormal];
    btnShareOrder.titleLabel.font=FONT_14;
    [btnShareOrder setImage:[UIImage noCacheImageNamed:@"shareOrder.png"] forState:UIControlStateNormal];
    [btnShareOrder setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 128)];
    [buttonmView addSubview:btnShareOrder];
    [btnShareOrder addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    
    // 右箭头
    rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-9-5, gridHeight/2 - 4, 5, 9)];
    rightArrowImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [btnShareOrder addSubview:rightArrowImageView];
    [rightArrowImageView release];
    
    addRows++;
    
    buttonmView.frame=CGRectMake(0, 0 , SCREEN_WIDTH,gridHeight*addRows);
}

//计算团购内容的高度
-(CGFloat) computeGrouponContentViewHeight:(NSArray *) arr
{
    if (arr==nil||arr.count==0) {
        return 0;
    }
    
    double addOffSet=0;
    for (int i=0; i<arr.count; i++)
    {
        if (!STRINGHASVALUE(arr[i]))
        {
            continue;
        }
        
        NSString *temContent=[NSString stringWithFormat:@"● %@",arr[i]];
        
        CGSize size = CGSizeMake(SCREEN_WIDTH-40, 1000);
        CGSize newSize = [temContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        
        addOffSet=addOffSet+newSize.height+7;
    }

    return addOffSet+35;
}

//团购内容
-(UIView *) getGrouponContentView:(NSArray *) arr
{
    if (arr==nil||arr.count==0) {
        return nil;
    }
    
    UIView *grouponContentView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, introHeight-40)] autorelease];
    grouponContentView.backgroundColor=RGBACOLOR(246, 246, 246, 1);
    
    double addOffSet=0;
    int addCnt=0;
    for (int i=0; i<arr.count; i++)
    {
        if (!STRINGHASVALUE(arr[i]))
        {
            continue;
        }
        
        NSString *temContent=[NSString stringWithFormat:@"● %@",arr[i]];
        
        UILabel *lblTem=[[UILabel alloc] init];
        lblTem.backgroundColor=[UIColor clearColor];
        lblTem.text=temContent;
        lblTem.textColor=RGBACOLOR(147, 147, 147, 1);
        lblTem.font=[UIFont systemFontOfSize:12];
        lblTem.numberOfLines=0;
        
        CGSize size = CGSizeMake(SCREEN_WIDTH-40, 1000);
        CGSize newSize = [lblTem.text sizeWithFont:lblTem.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        
        if (addCnt==0)
        {
            lblTem.frame=CGRectMake(20, 10, SCREEN_WIDTH-40, newSize.height);
        }
        else
        {
            lblTem.frame=CGRectMake(20, 10+addOffSet, SCREEN_WIDTH-40, newSize.height);
        }
        
        addOffSet=addOffSet+newSize.height+7;
        
        [grouponContentView addSubview:lblTem];
        
        addCnt++;
        [lblTem release];
    }
    
    UIImageView *split= [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    split.frame = CGRectMake(0, addOffSet+35- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    split.contentMode=UIViewContentModeScaleToFill;
    [grouponContentView addSubview:split];
    [split release];
    
    grouponContentView.frame=CGRectMake(0, 0, SCREEN_WIDTH,addOffSet+35);
    
    return grouponContentView;
}

-(void) shareInfo{
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage =  imagefromparent;//[self screenshotOnCurrentView];
	
	GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	shareTools.grouponId = gInfo.prodID;
	shareTools.weiBoContent = [self weiboContent];	
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用用艺龙旅行客户端团购酒店成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];
    
    UMENG_EVENT(UEvent_Groupon_OrderSuccess_Share)
}


-(UIImage *) screenshotOnCurrentView{
	shareBtn.hidden = YES;
	confirmButton.hidden = YES;
    callBtn.hidden = YES;
	goMyOrderBtn.hidden = YES;
	
	UIImage *screenShot = [infoTable imageByRenderingViewWithSize:infoTable.contentSize];
	
	shareBtn.hidden = NO;
	confirmButton.hidden = NO;
    callBtn.hidden = NO;
	goMyOrderBtn.hidden = NO;
	
	return screenShot;
}


- (NSString *) smsContent{
	GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];

	NSString *hotelName= gInfo.prodName;
	NSString *startTime_str	= [TimeUtils displayDateWithJsonDate:gInfo.startTime_str 
													   formatter:@"yyyy-MM-dd"];
	NSString *endTime_str		= [TimeUtils displayDateWithJsonDate:gInfo.endTime_str 
													  formatter:@"yyyy-MM-dd"];
	
	
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端团购了一家酒店，订单号：%@，%@，有效期：%@至%@。",[NSString stringWithFormat:@"%d",orderNo],hotelName,startTime_str,endTime_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	return messageBody;
}

- (NSString *) mailContent{
	GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	
	NSString *hotelName= gInfo.prodName;
	NSString *startTime_str	= [TimeUtils displayDateWithJsonDate:gInfo.startTime_str 
													   formatter:@"yyyy-MM-dd"];
	NSString *endTime_str		= [TimeUtils displayDateWithJsonDate:gInfo.endTime_str 
													  formatter:@"yyyy-MM-dd"];
	NSString *message = [NSString stringWithFormat:@"我在艺龙旅行客户端成功团购一家酒店，既便捷又超值。订单号：%@，%@，有效期：%@至%@。",[NSString stringWithFormat:@"%d",orderNo],hotelName,startTime_str,endTime_str];
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
	return messageBody;
}

- (NSString *) weiboContent{
	GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端团购了一家酒店，%@，艺龙价仅售¥%@。",gInfo.prodName,gInfo.salePrice];
	NSString *content = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}

-(void)payByalipay{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
	[GrouponOrderHistoryController setInstance:nil];
	[GrouponSuccessController setInstance:nil];
    instance = [self retain];    //将当前VC赋值给变量，以供回调使用
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
        //客户端存在，打开客户端
        //客户端支付
        payType = @"Client";
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:[NSNumber numberWithInt:orderNo] forKey:@"OrderId"];
        [mutDict safeSetObject:@"elongIPhone://" forKey:@"ReturnUrl"];
        [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
        if ([[AccountManager instanse] cardNo]) {
            [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
        }
        
        NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
        [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
        [mutDict release];
    }
    else{
        // 提示用户安装支付宝客户端
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝客户端！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


// 目前支付宝网页支付和储蓄卡支付都走这个方法
- (void)payByAlipayWap
{
    payType = @"wap";
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:[NSNumber numberWithInt:orderNo] forKey:@"OrderId"];
    [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
    [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
    if ([[AccountManager instanse] cardNo]) {
        [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
    }
    
    NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
    [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
    [mutDict release];
}


- (void) payByWeixin{
    if(![WXApi isWXAppInstalled]){
        [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您更换别的支付方式或下载微信"];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您更换别的支付方式或更新微信"];
        return;
    }
    
    payType = @"weixin";
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:[NSNumber numberWithInt:orderNo] forKey:@"OrderId"];
    [mutDict safeSetObject:[NSNumber numberWithInt:6] forKey:@"PayMethod"];
    if ([[AccountManager instanse] cardNo]) {
        [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
    }
    
    NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
    [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
    [mutDict release];
}

-(void) paySuccess{
	[self setCouldPay:NO];
}

#pragma mark -
#pragma mark Notification
- (void) weixinPaySuccess{
    [self paySuccess];
    
    UMENG_EVENT(UEvent_Groupon_OrderSuccess)
}

- (void) alipayPaySuccess{
    [self paySuccess];
    UMENG_EVENT(UEvent_Groupon_OrderSuccess)
}

- (void)notiByAlipayWap:(NSNotification *)noti{
    [self paySuccess];
    UMENG_EVENT(UEvent_Groupon_OrderSuccess)
}


- (void)notiByAppActived:(NSNotification *)noti{
    // 监测到程序被从后台激活时，询问用户支付情况
    if (jumpToSafari){
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:@"是否已完成支付宝支付"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"未完成"
                                                    otherButtonTitles:@"已支付", nil];
        askingAlert.tag = AlipayAlertTag;
        [askingAlert show];
        [askingAlert release];
        
        jumpToSafari = NO;
    }
}

#pragma mark -
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==UIActionSheetTag1)
    {
        if (buttonIndex==0)
        {
            [self telAppointAction];
        }
        else if(buttonIndex==1)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag2)
    {
        if (buttonIndex==0)
        {
            [self telAppointAction];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag3)
    {
        if(buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag4)
    {
        if (buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else if(buttonIndex==1)
        {
            [self jumpToMutipleStoreAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag5)
    {
        if (buttonIndex==0)
        {
            [self jumpToMutipleStoreAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag6)
    {
        if (buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
}

#pragma mark -
#pragma mark 三种预约的方法
//非多店电话预约
-(void) telAppointAction
{
    GrouponSharedInfo *gshareInfo = [GrouponSharedInfo shared];
    if (gshareInfo.appointmentPhone==nil) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", gshareInfo.appointmentPhone];
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:urlString]]) {
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        
        if (UMENG) {
            //团购电话预约
            [MobClick event:Event_GrouponAppointment];
        }
    }
}

//跳入多店的电话预约
-(void) jumpToMutipleStoreAppoint
{
    GrouponSharedInfo *gshareInfo = [GrouponSharedInfo shared];
    GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:gshareInfo.detailDic style:GrouponPhoneItem];
    [self.navigationController pushViewController:itemVC animated:YES];
    [itemVC release];
}

//团购在线预约
-(void) tuanOnlineAppoint
{
    GrouponSharedInfo *gshareInfo = [GrouponSharedInfo shared];
    NSString *qianDianUrl=[[gshareInfo.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    if (STRINGHASVALUE(qianDianUrl))
    {
        GrouponAppointViewController *onlineBookingController = [[GrouponAppointViewController alloc] initWithTitle:@"在线预约" targetUrl:qianDianUrl style:_NavOnlyBackBtnStyle_];
        [self.navigationController pushViewController:onlineBookingController animated:YES];
        [onlineBookingController release];
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (PassAlertTag == alertView.tag){
        if (buttonIndex != 0){
            // 前往更新passbook
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:pass];
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
    }else if(AlipayAlertTag == alertView.tag){
        if (0 != buttonIndex){
            // 已支付
            [self paySuccess];
        }else{
        }
    }
    else if(BackHomeAlertTag == alertView.tag){
        if (0 != buttonIndex) {
            [super backhome];
        }
    }
}

#pragma mark -
#pragma mark Http

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (util == passUtil) {
        
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            return;
        }
        NSError *error = nil;
        
        SFRelease(pass);
        pass = [[PKPass alloc] initWithData:responseData error:&error];
        
        PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
        
        if ([passLibrary containsPass:pass]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passbook已存在该酒店订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            alert.tag = PassAlertTag;
            [alert show];
            [alert release];
        }else{
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:pass];
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
    else {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        
        if([payType isEqualToString:@"Client"]){
            if([[root safeObjectForKey:@"IsAllowContinuePay"] boolValue]){
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
                NSString *appScheme = @"elongIPhone";
                NSString *orderString = [root safeObjectForKey:@"Url"];
                //获取安全支付单例并调用安全支付接口
                AlixPay * alixpay = [AlixPay shared];
                int ret = [alixpay pay:orderString applicationScheme:appScheme];
                if (ret == kSPErrorSignError) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
            
            
        }else if([payType isEqualToString:@"wap"]){
            NSString *urlString = [root safeObjectForKey:@"Url"];
            NSRange range = [urlString rangeOfString:@"sign="];
            NSString *prefixString = [urlString substringToIndex:range.location+range.length];
            NSString *signString = [urlString substringFromIndex:range.location+range.length];
            NSString *combineString = [NSString stringWithFormat:@"%@%@",[prefixString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],signString];
            NSURL *url = [NSURL URLWithString:combineString];

            if ([[UIApplication sharedApplication] canOpenURL:url]){
                // 能用safari打开优先用safari打开
                [[UIApplication sharedApplication] newOpenURL:url];
                jumpToSafari = YES;
            }
            else{
                AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
                alipayVC.requestUrl = url;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alipayVC];
                
                if (IOSVersion_7) {
                    nav.transitioningDelegate = [ModalAnimationContainer shared];
                    nav.modalPresentationStyle = UIModalPresentationCustom;
                }
                if(IOSVersion_7){
                    [self presentViewController:nav animated:YES completion:nil];
                }else{
                    [self presentModalViewController:nav animated:YES];
                }
                
                [alipayVC release];
                [nav release];
                jumpToSafari = NO;
            }
            
            
        }else if([payType isEqualToString:@"weixin"]){
            NSString *url = [root safeObjectForKey:@"Url"];
            if (!STRINGHASVALUE(url)) {
                [PublicMethods showAlertTitle:@"" Message:@"未能获取支付页面"];
                return;
            }
            PayReq *req = [[[PayReq alloc] init] autorelease];
            NSDictionary *dict = [url JSONValue];
            req.partnerId = [dict objectForKey:@"partnerId"];
            req.prepayId = [dict objectForKey:@"prepayId"];
            req.package = [dict objectForKey:@"package"];
            req.sign = [dict objectForKey:@"sign"];
            req.nonceStr = [dict objectForKey:@"nonceStr"];
            req.timeStamp = [[dict objectForKey:@"timeStamp"] longLongValue];
            [WXApi safeSendReq:req];
            
            
        }
    }
}


@end
