//
//  CredtCardPayCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-4-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CredtCardPayCtrl.h"
#import "CoordinateTransform.h"
#import "SelectCard.h"
#import "CredtCardPayCtrl.h"
#import "NewPayMethodCtrl.h"
#import "PayMentManager.h"


@interface CredtCardPayCtrl ()

@end

@implementation CredtCardPayCtrl

- (void)dealloc
{
    
    if (createCardHttpUtil) {
        [createCardHttpUtil  cancel];
        SFRelease(createCardHttpUtil);
        
    }

    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)creditPayAction
{
    
    if (![CoordinateTransform  adjustIsLogin])
    {
        // 非会员
        [[SelectCard allCards] removeAllObjects];
        
        //修改为直接去新增信用卡
        //[self goSelectCard];
        
//        JPostHeader *postheader = [[JPostHeader alloc] init];
//        [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
//        [postheader release];
        
        [[SelectCard cardTypes] removeAllObjects];
        
        NSArray  *ar = [PayMentManager  allBankList];
        
        [[SelectCard cardTypes] addObjectsFromArray:[PayMentManager  getBankList:ar]] ;		// 存储银行信息
        
        
        AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeRentCar];
        
       // controller.delegate = self;
//        [self.navigationController pushViewController:controller animated:YES];
//        [controller release];
        
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        
    }else
    {
        // 会员
        [[SelectCard allCards] removeAllObjects];
        
        [self requestCrediteCardList];
    }

}

- (void) requestCrediteCardList
{
    if (createCardHttpUtil) {
        [createCardHttpUtil cancel];
        SFRelease(createCardHttpUtil);
    }
    createCardHttpUtil = [[HttpUtil alloc] init];
    [createCardHttpUtil connectWithURLString:MYELONG_SEARCH Content:[[MyElongPostManager card] requesString:NO] StartLoading:YES EndLoading:YES Delegate:self];
}

- (void)goSelectCard
{ 
   
    [[SelectCard cardTypes] removeAllObjects];
    
    NSArray  *ar = [PayMentManager  allBankList];
    
    [[SelectCard cardTypes] addObjectsFromArray:[PayMentManager  getBankList:ar]] ;		// 存储银行信息
   
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *nextTitle = @"租车支付";
    SelectCard *controller = [[SelectCard alloc] init:nextTitle style:_NavNormalBtnStyle_ nextState:RENTCAR_STATE canUseCA:NO];
    // 使用Coupon
    controller.useCoupon = NO;
    [delegate.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    
    NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *root = [string JSONValue];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    if(createCardHttpUtil == util)
    {
        /************************进入信用卡选择页面******************************/
        [[SelectCard allCards] removeAllObjects];
        if ([root safeObjectForKey:@"CreditCards"]!=[NSNull null]) {
            [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
        }
        [self goSelectCard];
    }else{
    
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
        
        AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeGroupon];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
