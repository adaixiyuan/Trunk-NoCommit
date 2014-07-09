//
//  RentComfirmController.m
//  ElongClient
//
//  Created by nieyun on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentComfirmController.h"
#import "TaxiFillManager.h"
#import "TaxiPayViewController.h"
#import "AccountManager.h"
#import "StringEncryption.h"
#import "TaxiUtils.h"

@interface RentComfirmController ()

@end

@implementation RentComfirmController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         creditCardContents=[[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)dealloc
{
    
    [creditCardContents  release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setCardMessage:(NSDictionary *)card
{

    TaxiFillManager  *manager = [TaxiFillManager  shareInstance];
    
    [creditCardContents   safeSetObject:manager.evalueRqModel.cityCode forKey:@"cityCode"];//城市ID
    [creditCardContents  safeSetObject:manager.evalueRqModel.productType forKey:@"productType"];//服务类型0201 接机 0202 送机
    [creditCardContents   safeSetObject:manager.evalueRqModel.airPortCode forKey:@"airPortCode"];//接送机必传
    [creditCardContents  safeSetObject:manager.payMentToeken forKey:@"tradeNo"];//支付平台系统生成的token 流水号
    [creditCardContents  safeSetObject:manager.gorderIdt forKey:@"gorderId"];//业务订单号
    [creditCardContents  safeSetObject:manager.orderId forKey:@"orderId"];//业务订单号
    [creditCardContents  safeSetObject:[NSString  stringWithFormat:@"%.2f",[manager.fillRqModel.orderAmount  floatValue]] forKey:@"totalAmt"];//不含存在手续费的金额
    [creditCardContents  safeSetObject:[NSString  stringWithFormat:@"%.2f",[manager.fillRqModel.orderAmount  floatValue]] forKey:@"ccAmt"];//交易金额
    [creditCardContents  safeSetObject:[NSString  stringWithFormat:@"%.2f",0.00] forKey:@"ccCustomerServiceAmt"];//客户支付的手续费金额
    [creditCardContents safeSetObject:[card  safeObjectForKey:@"CreditCardNumber"]  forKey:@"creditCardNo"];//卡号
	[creditCardContents safeSetObject:[card safeObjectForKey:@"HolderName"] forKey:@"cardHolder"];//持卡人
    if(STRINGHASVALUE([card safeObjectForKey:@"VerifyCode"]))
    {
        [creditCardContents safeSetObject:[card safeObjectForKey:@"VerifyCode"]  forKey:@"verifyCode"];//验证码
    }else{
        [creditCardContents safeSetObject:@"" forKey:@"verifyCode"];//验证码
    }
    if ([card  safeObjectForKey:@"CertificateType"])
    {
        int   stype = [[card  safeObjectForKey:@"CertificateType"]  intValue];
        NSNumber  *finalType = [NSNumber  numberWithInt:[TaxiUtils  convertCertificate:stype]];
        
        [creditCardContents  safeSetObject:finalType forKey:@"idType"];//证件类型
    }
   
    NSString *deoing = nil;
    if (STRINGHASVALUE([card  safeObjectForKey:@"CertificateNumber"]))
    {
        deoing = [card  safeObjectForKey:@"CertificateNumber"];
    }else{
        deoing = @"";
    }
    
    [creditCardContents safeSetObject:deoing forKey:@"idNo"];

    
    if ([AccountManager instanse].isLogin) {
        [creditCardContents safeSetObject:[AccountManager instanse].cardNo forKey:@"uid"];//
    }else{
        [creditCardContents safeSetObject:[PublicMethods macaddress] forKey:@"uid"];//
    }
    
    
    int year = [[card safeObjectForKey:@"ExpireYear"] intValue];
   
    int month = [[card safeObjectForKey:@"ExpireMonth"] intValue];
    
    NSString *expireTime = nil;
    if (month < 10) {
        expireTime = [NSString stringWithFormat:@"%d-0%d-01",year,month];
    }else{
        expireTime = [NSString stringWithFormat:@"%d-%d-01",year,month];
    }
    [creditCardContents safeSetObject:expireTime  forKey:@"expireDate"];//证件过期时间

    [creditCardContents  safeSetObject:[card  safeObjectForKey:@"ProductId"]forKey:@"ProductId"];
  
    //API保存信用卡客史
    
    NSString *creditCardType = [[card safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Id"];
    NSString *creditCardName = [[card safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Name"];
    NSString *islogin = ([AccountManager instanse].isLogin)?@"1":@"2";
    
    [creditCardContents safeSetObject:creditCardType forKey:@"creditCardType"];
    [creditCardContents safeSetObject:creditCardName forKey:@"creditCardName"];
    [creditCardContents safeSetObject:islogin forKey:@"islogin"];

}

- (void) requestUrl
{
    NSString *jsonString = [creditCardContents  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/pay"];;
    util = [HttpUtil shared];
    [util requestWithURLString:url Content:jsonString StartLoading:YES EndLoading:YES Delegate:self];
    
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
	
	if ([Utils checkJsonIsError:root])
    {
		return ;
	}
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    TaxiPayViewController  *contrl = [[TaxiPayViewController  alloc]initWithTitle:@"预订成功" style:NavBarBtnStyleOnlyHomeBtn];
    contrl.orderDic = root;
    [delegate.navigationController pushViewController:contrl animated:YES];
    [contrl  release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
