//
//  GrouponSharedInfo.m
//  ElongClient
//	团购共享数据
//
//  Created by haibo on 11-11-24.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponSharedInfo.h"


static GrouponSharedInfo *info;

@implementation GrouponSharedInfo

@synthesize salePrice;
@synthesize expressFee;
@synthesize title;
@synthesize showTotalPrice;
@synthesize realTotalPrice;
@synthesize isInvoice;
@synthesize purchaseNum;
@synthesize prodName;
@synthesize invoiceInfo;
@synthesize grouponID;
@synthesize prodID;
@synthesize prodType;
@synthesize realCost;
@synthesize email;
@synthesize mobile;
@synthesize creditCardInfo;
@synthesize InvoiceMode;
@synthesize mobileProductType;
@synthesize inDateDescription;
@synthesize startTime_str;
@synthesize endTime_str;

@synthesize payType;
@synthesize appointmentPhone;

- (void)dealloc {
	self.salePrice		= nil;
	self.expressFee		= nil;
	self.title			= nil;
	self.realTotalPrice	= nil;
	self.showTotalPrice	= nil;
	self.purchaseNum	= nil;
	self.prodName		= nil;
	self.isInvoice		= nil;
	self.invoiceInfo	= nil;
	self.grouponID		= nil;
	self.prodID			= nil;
	self.prodType		= nil;
	self.realCost		= nil;
	self.email			= nil;
	self.mobile			= nil;
	self.creditCardInfo	= nil;
	self.InvoiceMode    = nil;
    self.appointmentPhone = nil;
    self.detailDic=nil;
    self.qianDianUrl=nil;
    self.inDateDescription = nil;
    
    SFRelease(mobileProductType);
    SFRelease(_cashAmount);
    
	[info release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized (info) {
		if (!info) {
			info = [[GrouponSharedInfo alloc] init];
		}
	}
	
	return info;
}


- (void)clearData
{
    self.salePrice		= nil;
	self.expressFee		= nil;
	self.title			= nil;
	self.realTotalPrice	= nil;
	self.showTotalPrice	= nil;
	self.purchaseNum	= nil;
	self.prodName		= nil;
	self.isInvoice		= nil;
	self.invoiceInfo	= nil;
	self.grouponID		= nil;
	self.prodID			= nil;
	self.prodType		= nil;
	self.realCost		= nil;
	self.email			= nil;
	self.mobile			= nil;
	self.creditCardInfo	= nil;
	self.InvoiceMode    = nil;
    self.appointmentPhone = nil;
    self.detailDic      = nil;
    self.qianDianUrl    = nil;
    self.inDateDescription = nil;
    _cashAmount = 0;
    mobileProductType = 0;
}

@end
