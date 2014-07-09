//
//  GOrderRequest.m
//  ElongClient
//	团购订单提交请求
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "GOrderRequest.h"
#import "GrouponSharedInfo.h"
#import "AccountManager.h"
#import "ElongClientAppDelegate.h"


static GOrderRequest *request = nil;

@implementation GOrderRequest


- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[GOrderRequest alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init])
    {
		contents = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


- (void)reGatherData {
	GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	NSLog(@"%d",gInfo.payType);
	NSMutableDictionary *orderDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  gInfo.grouponID, grouponID_API,
									  gInfo.prodID, prodId_API,
									  gInfo.prodName, prodName_API,
									  gInfo.prodType, prodType_API,
									  gInfo.expressFee, expressFee_API,
									  gInfo.purchaseNum, bookingNums_API,
									  gInfo.salePrice, salePrice_API,
									  gInfo.mobile, mobile_API,
									  gInfo.isInvoice, isInvoice_API,
                                      gInfo.mobileProductType, mobileProductType_API, nil];
    
    
    
    if (DICTIONARYHASVALUE(gInfo.invoiceInfo))
    {
        [orderDic safeSetObject:gInfo.invoiceInfo forKey:invoice_API];
    }
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (delegate.isNonmemberFlow) {
		// 非会员卡号设为固定号码
		[orderDic safeSetObject:NONMEMBER_GROUPONCARDNO forKey:cardNo_API];
	}
	else {
		[orderDic safeSetObject:[[AccountManager instanse] cardNo] forKey:cardNo_API];
		[orderDic safeSetObject:[[AccountManager instanse] name] forKey:userName_API];
	}

	[contents setDictionary:orderDic];
}


- (void)nonNumberReGatherData
{
    GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	NSLog(@"%d",gInfo.payType);
	NSMutableDictionary *orderDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     gInfo.grouponID, GROUPONID_GROUPON,
                                     gInfo.prodID, PRODID_GROUPON,
                                     gInfo.prodName, PRODNAME_GROUPON,
                                     gInfo.prodType, PRODTYPE_GROUPON,
                                     gInfo.expressFee, EXPRESSFEE_GROUPON,
                                     gInfo.purchaseNum, BOOKINGNUMS_GROUPON,
                                     gInfo.salePrice, SALEPRICE_GROUPON,
                                     gInfo.mobile, MOBILE,
                                     gInfo.cashAmount, CASHAMOUNT,
                                     gInfo.isInvoice, ISINVOICE_GROUPON,
                                     gInfo.invoiceInfo, INVOICE_GROUPON,
                                     gInfo.mobileProductType,MOBILEPRODUCTTYPE_GROUPON, nil];
	if(gInfo.creditCardInfo!=nil && gInfo.creditCardInfo !=NULL){
		[orderDic safeSetObject:gInfo.creditCardInfo forKey:CREDITCARD];
	}
	[orderDic safeSetObject:[NSNumber numberWithInt:gInfo.payType] forKey:@"PayType"];
    [orderDic safeSetObject:[NSNumber numberWithInt:gInfo.payMethod] forKey:PAYMETHOD];
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (delegate.isNonmemberFlow) {
		// 非会员卡号设为固定号码
		[orderDic safeSetObject:NONMEMBER_GROUPONCARDNO forKey:CARD_NUMBER];
	}
	else {
		[orderDic safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
		[orderDic safeSetObject:[[AccountManager instanse] name] forKey:USER_NAME];
	}
    
	[contents safeSetObject:orderDic forKey:ORDERREQ_GROUPON];
    [contents safeSetObject:[PostHeader header] forKey:Resq_Header];
}


- (NSString *)grouponOrderCompress:(BOOL)animated {
	NSLog(@"request:%@",[contents JSONString]);
    if ([[ServiceConfig share] monkeySwitch]) {
        // 开着monkey时不能下单
        return nil;
    }
    
	return [NSString stringWithFormat:@"action=CreateOrder&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}


- (NSString *)getGrouponOrderReq
{
    return [contents JSONString];
}


- (NSDictionary *)getContent
{
    return contents;
}

@end
