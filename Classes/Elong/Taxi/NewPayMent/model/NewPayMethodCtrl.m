//
//  NewPayMethodCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-4-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NewPayMethodCtrl.h"
#import "PayMentModel.h"
#import "NewPayMentCtrl.h"
#import "PayMentManager.h"
#import "CoordinateTransform.h"
#import "AccountManager.h"

static NSMutableArray *credictCardList = nil;
@interface NewPayMethodCtrl ()

@end

@implementation NewPayMethodCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (typeUtil)
    {
        typeUtil.delegate = nil;
        [typeUtil  cancel];
        SFRelease(typeUtil);
    }
    [tDic release];
    [_modelAr  release];
    [super dealloc];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
 - (void) goChannel:(NSInteger ) bizType  andDic:(NSDictionary  *) topDic{
    tDic = [topDic retain];
//    if (typeUtil)
//    {
//        [typeUtil  cancel];
//        SFRelease(typeUtil);
//    }
    
    // typeUtil = [[HttpUtil  alloc]init];
     NSString  *card= @"";
     if ([CoordinateTransform  adjustIsLogin])
     {
        card = [[AccountManager instanse] cardNo];
         
     }else
     {
         card = @"";
     }
    
     NSDictionary  *dic = [NSDictionary  dictionaryWithObjectsAndKeys:@"9106",@"channelType",@"",@"accessToken" ,[NSString  stringWithFormat:@"%d",bizType],@"bizType",card,@"cardNo",@"7801",@"language",nil];
    NSString  *str = [dic JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"paymentProds" andParam:str];

     HttpUtil *util = [HttpUtil shared];
     [util  requestWithURLString:url Content:nil Delegate:self];

}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    GetPayProdsResp   *model = [[GetPayProdsResp alloc]initWithDataDic:root];
    
    NewPayMentCtrl  *ctrl = [[NewPayMentCtrl  alloc]initWithTitle:@"支付订单" style:NavBarBtnStyleOnlyBackBtn];
    
    ctrl.modelAr =model.paymentTags;
    
    ctrl.topDic = tDic;
    
    self.modelAr = model.paymentTags;
    
    [[PayMentManager  allBankList] removeAllObjects];
    
    [[PayMentManager  allBankList]  addObjectsFromArray:model.paymentTags] ;
    
    [delegate.navigationController pushViewController:ctrl  animated:YES];
    
    [ctrl  release];
    
    [model release];
}



+ (NSArray *)getBankList:(NSArray *)modelAr
{
    NSMutableArray  *bAr = [NSMutableArray  array];
    for ( PaymentTag  *model  in  modelAr)
    {
        
        for  (PaymentType  *typeModel in model.paymentTypes)
        {
            if ([typeModel.tagId  intValue]==   CrediCardType)
            {
                
                for (PaymentProduct *product in typeModel.paymentProducts)
                {
                    NSMutableDictionary  *bankDic = [NSMutableDictionary  dictionary];
                    [bankDic  setObject:product.categoryId forKey:@"Id"];
                    [bankDic setObject:product.productNameCN forKey:@"Name"];
                    [bankDic  setObject:product.needCVV2 forKey:@"Cvv"];
                    [bankDic  setObject:product.needCertificateNo forKey:@"IdentityCard"];
                    [bankDic   setObject:product.productId forKey:@"ProductId"];
                    [bAr  addObject:bankDic];
                }
                
            }
        }
    }
    
    return bAr;
    
}


+ (NewUniformPaymentType) checkAllModel:(NSIndexPath *) indexPath  andModelAr:(NSArray *)modelAr
{
    PaymentTag  *model   = [modelAr safeObjectAtIndex:indexPath.row];
    
    for  (PaymentType  *typeModel in model.paymentTypes)
    {
        if ([typeModel.tagId  intValue]==   CrediCardType)
        {
            
            return NewUniformPaymentTypeCreditCard;
        }
        else if ([typeModel.tagId   intValue]== 3)
        {
            for (PaymentProduct  *product in  typeModel.paymentProducts)
            {
                if ([product.productCode  intValue]==  WeiXinType )
                {
                    return NewUniformPaymentTypeWeixin;
                }else if  ([product.productCode   intValue]
                           == AliPayApp)
                {
                    return NewUniformPaymentTypeAlipayWap;
                }else  if  ([product.productCode  intValue] == AliPayWeb)
                {
                    return NewUniformPaymentTypeAlipay;
                }
            }
        }
    }
    return   OrtherPayType;
}

+(NSMutableArray  *)credictCardList

{

    @synchronized(credictCardList)
    {
		if(!credictCardList)
        {
			credictCardList = [[NSMutableArray alloc] init];

		}
    }
    return credictCardList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
