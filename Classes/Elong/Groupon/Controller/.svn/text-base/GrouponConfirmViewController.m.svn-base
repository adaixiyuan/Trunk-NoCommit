    //
//  GrouponConfirmViewController.m
//  ElongClient
//  团购确认页面
//
//  Created by haibo on 11-11-24.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponConfirmViewController.h"
#import "GrouponSharedInfo.h"
#import "GOrderRequest.h"
#import "GrouponSuccessController.h"
#import "AccountManager.h"
#import "ElongURL.h"
#import "FXLabel.h"
#import "Utils.h"
#import "GrouponFillOrder.h"
#import "UniformCounterDataModel.h"

@implementation GrouponConfirmViewController

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[valueArray	release];
	[titleArray	release];
	[labelArray release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Initialization

- (id)initWithCardInfo:(NSMutableDictionary *)cardInfo {
	if (self = [super initWithTopImagePath:@"" andTitle:@"订单确认" style:_NavNoTelStyle_]) {
		gInfo = [GrouponSharedInfo shared];
		gInfo.creditCardInfo = cardInfo;
        dataModel = [UniformCounterDataModel shared];
        
        if (STRINGHASVALUE([[AccountManager instanse] name])) {
            titleArray = [[NSArray alloc] initWithObjects:@"订单总额：", @"酒店名称：", @"订  购  人：",
                          @"手  机  号：", /*@"电子邮箱：" ,*/ @"需要发票：", @"发票抬头：",
                          @"邮寄地址：", @"发票类型：", @"邮寄费用：",nil];
        }else{
            titleArray = [[NSArray alloc] initWithObjects:@"订单总额：", @"酒店名称：", /*@"订  购  人：",*/
                          @"手  机  号：", /*@"电子邮箱：" ,*/ @"需要发票：", @"发票抬头：",
                          @"邮寄地址：", @"发票类型：", @"邮寄费用：",nil];
        }
		
		showPrice = [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice intValue] + (int)round([gInfo.expressFee floatValue]) : [gInfo.showTotalPrice intValue];
		NSString *name	= STRINGHASVALUE([[AccountManager instanse] name]) ? [[AccountManager instanse] name] : @"--";
        if (STRINGHASVALUE([[AccountManager instanse] name])) {
            valueArray = [[NSArray alloc] initWithObjects:
                          [NSString stringWithFormat:@"¥ %d", showPrice],
                          gInfo.prodName,
                          name,
                          gInfo.mobile,
                          //gInfo.email,
                          [NSString stringWithFormat:@"%@", [gInfo.isInvoice boolValue] ? @"是" : @"否"],
                          [gInfo.invoiceInfo safeObjectForKey:INVOICETITLE_GROUPON],
                          [gInfo.invoiceInfo safeObjectForKey:ADDRESS_GROUPON],
                          [gInfo.invoiceInfo safeObjectForKey:TYPE_GROUPON],
                          [NSString stringWithFormat:@"¥%.0f",[gInfo.expressFee floatValue]], nil];
        }else{
            valueArray = [[NSArray alloc] initWithObjects:
                          [NSString stringWithFormat:@"¥ %d", showPrice],
                          gInfo.prodName,
                          gInfo.mobile,
                          //gInfo.email,
                          [NSString stringWithFormat:@"%@", [gInfo.isInvoice boolValue] ? @"是" : @"否"],
                          [gInfo.invoiceInfo safeObjectForKey:INVOICETITLE_GROUPON],
                          [gInfo.invoiceInfo safeObjectForKey:ADDRESS_GROUPON],
                          [gInfo.invoiceInfo safeObjectForKey:TYPE_GROUPON],
                          [NSString stringWithFormat:@"¥%.0f",[gInfo.expressFee floatValue]], nil];
        }
		
		
		labelArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		[self performSelector:@selector(getValueAndSize)];	
		[self performSelector:@selector(addInfoTable)];
        
        switch (_payType) {
            case GrouponOrderPayTypeAlipay:
            {
                // 支付宝支付的情况
                if (UMENG) {
                    //团购酒店支付宝确认页面
                    [MobClick event:Event_GrouponHotelOrder_Alipay_Confirm];
                }
            }
                break;
            case GrouponOrderPayTypeCreditCard:
            {
                // 信用卡支付
                if (UMENG) {
                    //团购酒店信用卡确认页面
                    [MobClick event:Event_GrouponHotelOrder_Credit_Confirm];
                }
            }
                break;
            default:
                break;
        }
	}
	
	return self;
}


- (void) nextState{
    [self commitButtonPressed];
}


- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}


- (void)addInfoTable {
	// 信息显示
	int maxHeight = totalHeight + invoiceHeight;
	if (maxHeight > MAX_INFO_HEIGHT) {
		maxHeight = MAX_INFO_HEIGHT;
	}
	
	infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, maxHeight)];
	infoTable.backgroundColor	= [UIColor clearColor];
	infoTable.separatorStyle	= UITableViewCellSeparatorStyleNone;
	infoTable.dataSource		= self;
	infoTable.delegate			= self;
	[self.view addSubview:infoTable];
	[infoTable release];
	
	UIButton *confirmButton = [UIButton uniformButtonWithTitle:@"提交订单" 
													 ImagePath:@"confirm_sign.png"
														Target:self 
														Action:@selector(commitButtonPressed) 
														 Frame:CGRectMake(13, maxHeight + 30, 294, 46)];
	[self.view addSubview:confirmButton];
}


// 获取value值与其label的size,并生成控件
- (void)getValueAndSize {
	totalHeight		= 15;
	invoiceHeight	= -5;
	
	int count = [gInfo.isInvoice boolValue] ? [titleArray count] : [titleArray count] - 4;
	for (NSInteger i = 0; i < count; i++) {
		// size of title
		CGSize titleSize	= [[titleArray safeObjectAtIndex:i] sizeWithFont:FONT_16];
		int labelHeight		= i >= [titleArray count] - 4 ? invoiceHeight : totalHeight;
		
		UILabel *titleLabel			= [[UILabel alloc] initWithFrame:CGRectMake(25, labelHeight, titleSize.width, titleSize.height)];
		titleLabel.numberOfLines	= 0;
		titleLabel.font				= FONT_16;
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
		
		CGSize valueSize = [valueStr sizeWithFont:FONT_B16 constrainedToSize:CGSizeMake(190, 1000)];
		if (0 == i || [titleArray count] - 1 == i) {
			FXLabel *valueLabel = [[FXLabel alloc] initWithFrame:CGRectMake(105, labelHeight, valueSize.width, valueSize.height)];
			valueLabel.font					= FONT_B16;
			valueLabel.text					= [valueArray safeObjectAtIndex:i];
			valueLabel.backgroundColor		= [UIColor clearColor];
			valueLabel.gradientStartColor	= COLOR_GRADIENT_START;
			valueLabel.gradientEndColor		= COLOR_GRADIENT_END;  
			valueLabel.clipsToBounds = NO;
			valueLabel.adjustsFontSizeToFitWidth = YES;
			
			if (0 == i) {
				// 价格构成
				UILabel *priceStructure = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.frame.size.width,
																					0, 
																					295 - (valueLabel.frame.origin.x + valueLabel.frame.size.width),
																					valueLabel.frame.size.height)];
				NSString *priceStr; 
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
				
				priceStructure.font				= FONT_15;
				priceStructure.textColor		= [UIColor blackColor];
				priceStructure.backgroundColor	= [UIColor clearColor];
				priceStructure.text				= priceStr;
				priceStructure.minimumFontSize	= 9;
				priceStructure.adjustsFontSizeToFitWidth = YES;
				[valueLabel addSubview:priceStructure];
				[priceStructure release];
			}
			
			[labelArray addObject:valueLabel];
			[valueLabel release];
		}
		else {
			UILabel *valueLabel			= [[UILabel alloc] initWithFrame:CGRectMake(105, labelHeight, valueSize.width, valueSize.height)];
			valueLabel.numberOfLines	= 0;
			if (3 == i || 4 == i) {
				// 手机号、邮箱加粗提醒
				valueLabel.font	= FONT_B16;
			}
			else {
				valueLabel.font	= FONT_16;
			}
			
			valueLabel.text				= [valueArray safeObjectAtIndex:i];
			valueLabel.backgroundColor	= [UIColor clearColor];
			
			[labelArray addObject:valueLabel];
			[valueLabel release];
		}
		
		if (i >= [titleArray count] - 4) {
			invoiceHeight += valueSize.height + 10;
		}
		else {
			totalHeight += valueSize.height + 10;
		}
        
        
		if (i == 5) {
            if ([gInfo.InvoiceMode intValue] == 0) {//如果是发票的用户到酒店自取 则把需要发票的那一项的内容至为空 
                UILabel *templabl = (UILabel*)[labelArray safeObjectAtIndex:10];//需要发票的label
                templabl.text = @"";
                UILabel *templablex = (UILabel*)[labelArray safeObjectAtIndex:11];//是否需要发票的label
                templablex.text = @"";
            }
        }
	}
}


- (void)commitButtonPressed {
    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
    
    switch (_payType)
    {
        case GrouponOrderPayTypeAlipay:
        {
            // 支付宝支付的情况
            gSharedInfo.payType = GrouponOrderPayTypeAlipay;
            gSharedInfo.payMethod = WeiXinPayMethodJS;
            GOrderRequest *orderReq = [GOrderRequest shared];
            [orderReq reGatherData];
            
            HttpUtil *httpUtil = [HttpUtil shared];
            httpUtil.autoReLoad = NO;
            [[Profile shared] start:@"团购下单"];
            [httpUtil connectWithURLString:GROUPON_SEARCH Content:[orderReq grouponOrderCompress:NO] Delegate:self];
        }
            break;
        case GrouponOrderPayTypeCreditCard:
        {
            [[Profile shared] start:@"团购下单"];
            
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (delegate.isNonmemberFlow)
            {
                // 非会员走以前的信用卡支付流程
                gSharedInfo.payType = GrouponOrderPayTypeCreditCard;
                gSharedInfo.payMethod = WeiXinPayMethodJS;
                GOrderRequest *orderReq = [GOrderRequest shared];
                [orderReq nonNumberReGatherData];
                
                [Utils orderRequest:GROUPON_SEARCH req:[orderReq grouponOrderCompress:NO] delegate:self];
            }
            else
            {
                // 团购新支付流程成单
                NSMutableDictionary *mutDict = [dataModel getUniformPayData:UniformFromTypeGroupon];
                
                if (DICTIONARYHASVALUE(mutDict))
                {
                    NSNumber *month = [gInfo.creditCardInfo safeObjectForKey:@"ExpireMonth"];
                    NSString *monthStr = nil;
                    if ([month safeIntValue] < 10)
                    {
                        monthStr = [NSString stringWithFormat:@"0%@", month];
                    }
                    else
                    {
                        monthStr = [NSString stringWithFormat:@"%@", month];
                    }
                    
                    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", [gInfo.creditCardInfo safeObjectForKey:@"ExpireYear"], monthStr];
                    //dateStr = @"2015-01-01";
                    
                    // 设置信用卡支付参数
                    NSDictionary *dcDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithFloat:dataModel.waitingPayMoney], cc_amt_API,
                                           NUMBER(0),cc_customer_service_amt_API,
                                           [gInfo.creditCardInfo safeObjectForKey:CREDITCARD_NUMBER], credit_card_no_API,
                                           dateStr, expire_date_API,
                                           [gInfo.creditCardInfo safeObjectForKey:@"VerifyCode"], verify_code_API,
                                           [gInfo.creditCardInfo safeObjectForKey:@"HolderName"], card_holder_API,
                                           [gInfo.creditCardInfo safeObjectForKey:@"CertificateType"], id_type_API,
                                           [gInfo.creditCardInfo safeObjectForKey:@"CertificateNumber"], id_no_API,
                                           NUMBER(4601), cc_currency_API,
                                           [[AccountManager instanse] cardNo], elongCardNo_API,
                                           [[gInfo.creditCardInfo safeObjectForKey:CreditCardType_API] safeObjectForKey:@"Id"], creditCardType_API,
                                           [[gInfo.creditCardInfo safeObjectForKey:CreditCardType_API] safeObjectForKey:NAME_RESP], creditCardName_API, nil];
                    
                    [mutDict safeSetObject:dcDic forKey:cc_API];
                    
                    // 支付产品ID,纯CA为0，其它为1
                    if (dataModel.caAmount >= dataModel.orderTotalMoney)
                    {
                        [mutDict safeSetObject:NUMBER(0) forKey:payment_product_id_API];
                    }
                    else
                    {
                        for (NSDictionary *bankDic in dataModel.banksOfCreditCard)
                        {
                            // 遍历银行列表取出和选中信用卡一致的银行产品编号
                            if ([[bankDic safeObjectForKey:categoryId_API] intValue] == [[[gInfo.creditCardInfo safeObjectForKey:CreditCardType_API] safeObjectForKey:@"Id"] intValue])
                            {
                                [mutDict safeSetObject:[bankDic safeObjectForKey:productId_API] forKey:payment_product_id_API];
                            }
                        }
                    }
                    
                    NSString *url = [HttpUtil javaAPIPostReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_pay];
                    [HttpUtil requestURL:url postContent:[mutDict JSONString] delegate:self];
                }
            }
        }
            break;
        case GrouponOrderPayTypeWeixin:
        {
            // 微信支付
            gSharedInfo.payType = GrouponOrderPayTypeWeixin;
            gSharedInfo.payMethod = WeiXinPayMethodApp;
            GOrderRequest *orderReq = [GOrderRequest shared];
            [orderReq reGatherData];
            [[Profile shared] start:@"团购下单"];
            [Utils orderRequest:GROUPON_SEARCH req:[orderReq grouponOrderCompress:NO] delegate:self];
        }
            break;
        default:
            break;
    }
}


- (void)saveGrouponOrderForNonmemberWithID:(NSNumber *)orderID {
	// 为非会员存储团购订单信息
	NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_GROUPON_ORDERS];
	NSMutableArray *grouponOrders = nil;
	
	if (!orderData) {
		grouponOrders = [NSMutableArray arrayWithCapacity:2];
	}
	else {
		grouponOrders = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
	}
	
	NSMutableDictionary *order = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  gInfo.purchaseNum, BOOKINGNUMS_GROUPON,
								  gInfo.grouponID, GROUPONID_GROUPON,
								  orderID, ORDERID_GROUPON,
								  gInfo.prodID, PRODID_GROUPON,
								  gInfo.prodName, PRODNAME_GROUPON,
								  gInfo.prodType, PRODTYPE_GROUPON,
								  gInfo.salePrice, SALEPRICE_GROUPON,
								  [NSString stringWithFormat:@"%d", showPrice], TOTALPRICE_GROUPON,
								  nil];
	
	[grouponOrders insertObject:order atIndex:0];
	orderData = [NSKeyedArchiver archivedDataWithRootObject:grouponOrders];
	[[NSUserDefaults standardUserDefaults] setObject:orderData forKey:NONMEMBER_GROUPON_ORDERS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark NetWork Delegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if([GrouponFillOrder getIsGrouponPayment]){
        // 支付宝流程不重发请求，需要弹网络错误
        [PublicMethods showAlertTitle:@"您的网络不太给力，请稍候再试" Message:nil];
    }
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (_payType == GrouponOrderPayTypeCreditCard &&
        !appDelegate.isNonmemberFlow)
    {
        root = [PublicMethods unCompressData:responseData];
    }
    else
    {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        root = [string JSONValue];
    }
	
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    NSNumber *orderNO;
    if ([root safeObjectForKey:ORDERID_GROUPON] && [root safeObjectForKey:ORDERID_GROUPON] != [NSNull null]) {
        orderNO = [root safeObjectForKey:ORDERID_GROUPON];
        if ([orderNO intValue] == 0) {
            // 系统出错时，返回订单号为0的情况
            if ([[root safeObjectForKey:@"ErrorCode"] intValue] == 1000) {
                // 不是重单的情况
                if (STRINGHASVALUE([root safeObjectForKey:@"ErrorMessage"])) {
                    [PublicMethods showAlertTitle:[root safeObjectForKey:@"ErrorMessage"] Message:nil];
                } else {
                    [Utils alert:@"系统正忙，请稍后再试"];
                }
                
                return;
            }
        }
    }else{
        orderNO = [NSNumber numberWithLong:0];
    }
	   
     ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    switch (_payType)
    {
        case GrouponOrderPayTypeCreditCard:
        {
            if (delegate.isNonmemberFlow) {
                // 非会员流程存储订单信息
                [self saveGrouponOrderForNonmemberWithID:orderNO];
            }
            else
            {
                orderNO = [NSNumber numberWithInt:[dataModel.orderID intValue]];
            }
            
            // 进入成功页面
            GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[orderNO intValue] payType:GrouponOrderPayTypeCreditCard];
            controller.imagefromparent = [self performSelector:@selector(captureView)];
            [delegate.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case GrouponOrderPayTypeAlipay:
        {
            NSString *message = [root safeObjectForKey:@"ErrorMessage"];
            if ([[root safeObjectForKey:@"IsError"] boolValue]) {
                // 支付宝流程还是弹出提示
                if ([root safeObjectForKey:@"ErrorMessage"]==[NSNull null]||[message isEqualToString:@""]) {
                    [PublicMethods showAlertTitle:@"服务器错误" Message:nil];
                } else {
                    [PublicMethods showAlertTitle:message Message:nil];
                }
                
                return;
            }
            
            // 进入支付页面
            GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[orderNO integerValue] payType:GrouponOrderPayTypeAlipay];
            controller.imagefromparent = [self performSelector:@selector(captureView)];
            [delegate.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case GrouponOrderPayTypeWeixin:
        {
            // 进入支付页面
            GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[orderNO integerValue] payType:GrouponOrderPayTypeWeixin];
            controller.imagefromparent = [self performSelector:@selector(captureView)];
            [delegate.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
            
        default:
            break;
            
        [[Profile shared] end:@"团购下单"];
    }
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([gInfo.isInvoice boolValue]) {
		return 2;
	}
	
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.row) {
		return totalHeight + 5;
	}
	else {
		return invoiceHeight + 5;
	}
}


-(UIImage *)captureView
{
    CGSize size = infoTable.contentSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    infoTable.layer.masksToBounds=NO;
	[infoTable.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	infoTable.layer.masksToBounds = YES;
    return newImage;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.contentView.backgroundColor = [UIColor clearColor];
		
		// 添加背景圆角图
		int height = indexPath.row == 0 ? totalHeight : invoiceHeight;
		UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 308, height - 5)];
		[cell.contentView addSubview:backView];
		[backView release];
		
		if (indexPath.row == 0) {
			// 添加订单信息
			for (int i = 0; i < 2 * ([titleArray count] - 4); i ++) {
				[cell.contentView addSubview:[labelArray safeObjectAtIndex:i]];
			}
		}
		else {
			// 添加发票信息
			for (int i = 8; i > 0; i --) {
				[cell.contentView addSubview:[labelArray safeObjectAtIndex:2*[titleArray count] - i]];
			}
		}
    }
    
    return cell;
}


@end
