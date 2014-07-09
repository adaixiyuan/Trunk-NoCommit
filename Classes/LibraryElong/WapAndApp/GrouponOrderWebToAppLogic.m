//
//  GrouponOrderWebToAppLogic.m
//  ElongClient
//
//  Created by Dawn on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderWebToAppLogic.h"
#import "ElongURL.h"
#import "GrouponSharedInfo.h"
#import "GrouponFillOrder.h"
#import "GDetailRequest.h"

@implementation GrouponOrderWebToAppLogic

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.app = nil;
    self.ref = nil;
    self.prodid = nil;
    
    if (grouponDetailHttpUtil) {
        [grouponDetailHttpUtil cancel];
        SFRelease(grouponDetailHttpUtil);
    }
    
    [super dealloc];
}

#pragma mark -- 基类方法重写

//是否可以处理
-(BOOL) isCouldhanle{
    if (!DICTIONARYHASVALUE(dictData)){
        return NO;
    }
    
    self.app = [dictData safeObjectForKey:@"app"];
    if (!STRINGHASVALUE(self.app)) {
        return NO;
    }
    if (![self.app isEqualToString:@"tuanorder"]) {
        return NO;
    }
    self.ref = [dictData safeObjectForKey:@"ref"];
    self.prodid = [dictData safeObjectForKey:@"prodid"];
    
    
    if (!STRINGHASVALUE(self.prodid)) {
        return NO;
    }
    
    return YES;
}

//处理数据，跳转订单填写页
-(void) hanldeData{
    [self goGrouponDetail:self.prodid];
}

- (void) booking:(NSDictionary *)detailDic{
    // 点击购买,存储相关信息
    GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
    [gInfo clearData];
    gInfo.salePrice	= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:SALEPRICE_GROUPON];
    gInfo.expressFee	= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:EXPRESSFEE_GROUPON];
    gInfo.title			= @"";//[self purchaseNotes:@"● "];//[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:TITLE_GROUPON];
    gInfo.prodName		= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
    gInfo.grouponID     = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:GROUPONID_GROUPON];
    gInfo.prodID		= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON];
    gInfo.prodType		= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODTYPE_GROUPON];
    gInfo.InvoiceMode   = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"InvoiceMode"];
    gInfo.startTime_str = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"StartSaleDate"];
    gInfo.endTime_str   = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"EndSaleDate"];
    gInfo.cashPayment   = 0;
    // 联系电话
    NSString *phoneStr = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ContactPhone"];
    NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
    if ([phoneArray count] > 0){
        gInfo.appointmentPhone = [phoneArray safeObjectAtIndex:0];
    }
    
    gInfo.detailDic = detailDic;
    gInfo.qianDianUrl=[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    
    // 手机专享产品,0:正常产品，1：手机专享
    gInfo.mobileProductType = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"MobileProductType"];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    //ElongClientAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (islogin/* || delegate.isNonmemberFlow*/) {
        // 已登录或者已选择过非会员预订流程
        GrouponFillOrder *controller = [[GrouponFillOrder alloc] init];
        controller.isSkipLogin = NO;
        [delegate.navigationController pushViewController:controller animated:YES];
        [controller release];
        [self invokeComplicatedDelegate];
    }
    else {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:GrouponOrder];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
        [self invokeComplicatedDelegate];   
    }
}


- (void)goGrouponDetail:(NSString *)prodId{
    if (![prodId isEqual:[NSNull null]] && [prodId intValue] != 0) {
        GDetailRequest *gDReq = [GDetailRequest shared];
        [gDReq setProdId:prodId];
        
        if (grouponDetailHttpUtil) {
            [grouponDetailHttpUtil cancel];
            SFRelease(grouponDetailHttpUtil);
        }
        
        grouponDetailHttpUtil = [[HttpUtil alloc] init];
        [grouponDetailHttpUtil connectWithURLString:GROUPON_SEARCH Content:[gDReq grouponDetailCompress:YES]  StartLoading:NO EndLoading:NO  Delegate:self];
    }
	else {
        [PublicMethods showAlertTitle:@"该团购已失效" Message:@"请选择其它酒店"];
    }
}


#pragma mark -
#pragma mark HttpUtil

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if(util == grouponDetailHttpUtil){
        // 进入详情页面
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([root objectForKey:@"ProductDetail"]==[NSNull null]) {
            [PublicMethods showAlertTitle:nil Message:@"该团购产品已过期"];
            return;
        }
        
        [self booking:root];
    }
}

@end
