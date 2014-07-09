//
//  SendTaxiContrl.m
//  ElongClient
//
//  Created by nieyun on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SendTaxiContrl.h"
#import "CallSuccessViewController.h"
#import "CircleView.h"
#import "TaxiTryAgainCtrl.h"
#import  "UIViewExt.h"
#import "ConfirmPhoneVC.h"
#import "TaxiOrderManager.h"
#import "CoordinateTransform.h"

#import  "FastPositioning.h"
#import "CallTaxiVC.h"

@interface SendTaxiContrl ()

@end

@implementation SendTaxiContrl

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [shortNumLabel  release];
    [countDownLabel  release];
    [sendTaxiRequest  cancel];
    [circle release];
    [taxiNumLabel  release];
    SFRelease(sendTaxiRequest);
    SFRelease(dModel);
    SFRelease(_againOrder);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


#pragma mark -
#pragma mark CircleViewDelegate

- (void) circleView:(CircleView *)circleView process:(float)process{
    countDown = (int) floor(process * TAXI_WAITING_SECONDS);
    if (countDown < TAXI_WAITING_SECONDS) {
        countDownLabel.text= [NSString stringWithFormat:@"%d秒",TAXI_WAITING_SECONDS-countDown];
    }else{
        //跳转到继续叫车
        [self  cancelAndGoFailed];
    }
}

-(void)cancelAndGoFailed{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
    
    if (sendTaxiRequest) {
        [sendTaxiRequest cancel];
        SFRelease(sendTaxiRequest);
    }
    [circle stopAnimation];
    [self jumpTryAgainCtrl];
}

#pragma mark -
#pragma mark Notifications

- (void) dealBackround{
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(enterForegroundNotification)  name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification)  name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(willResignActiveNotification)  name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didEnterBackgroundNotification{
    circle.pause = YES;
}

- (void)enterForegroundNotification{
    circle.pause = NO;
}

- (void)didBecomeActiveNotification{
    circle.pause = NO;
}

- (void)willResignActiveNotification{
    circle.pause = YES;
}

#pragma  mark
#pragma  mark UI  Related


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doTheAction];
    [self  dealBackround];
}

- (void)  circleInit
{
    if (circle) {
        [circle removeFromSuperview];
        [circle release];
    }
    circle = [[CircleView  alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 170, 150, 150)];

    circle.delegate = self;
    if (circle_Reset) {
        [circle  startAnimation:TAXI_WAITING_SECONDS andTimeFlow:TAXI_WAITING_SECONDS-self.timeflow];
    }else{
        [circle  startAnimation:TAXI_WAITING_SECONDS andTimeFlow:self.timeflow];
    }
  
    [self.view addSubview:circle];
}
//添加显示车辆数的label
- (void) labelInit
{
    if (!taxiNumLabel)
    {
        taxiNumLabel = [[UILabel  alloc]initWithFrame:CGRectMake(circle.left+ circle.width * 0.1,circle.top+circle.height*0.1 , circle.width -circle.width*0.2,circle.height*0.5 )];
        taxiNumLabel.textAlignment =  NSTextAlignmentCenter;
        taxiNumLabel.backgroundColor = [UIColor clearColor];
        // taxiNumLabel.backgroundColor = [UIColor clearColor];
        taxiNumLabel.font = [UIFont  boldSystemFontOfSize:30];
        taxiNumLabel.text = [NSString  stringWithFormat:@"0"];
        [self.view  addSubview:taxiNumLabel];
        
    }else{
        [self.view bringSubviewToFront:taxiNumLabel];
        taxiNumLabel.text = [NSString  stringWithFormat:@"0"];
        randomSum = 0;
    }
    
    if (!shortNumLabel) {
        shortNumLabel = [[UILabel  alloc]initWithFrame:CGRectMake(taxiNumLabel.left,taxiNumLabel.bottom-taxiNumLabel.height *0.2, taxiNumLabel.width,circle.height * 0.2)];
        shortNumLabel.backgroundColor = [UIColor  clearColor];
        shortNumLabel.text = @"    辆车已通知";
        shortNumLabel.textColor= [UIColor  lightGrayColor];
        shortNumLabel.tag = 1001;
        [self.view addSubview:shortNumLabel];
    }else{
        [self.view bringSubviewToFront:shortNumLabel];
    }
    
}

- (void) countDownLabelInit
{
    if (!countDownLabel)
    {
        countDownLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0,50 , 30)];
        countDownLabel.center = CGPointMake(circle.left + circle.width/2, circle.bottom + 15);
        countDownLabel.backgroundColor = [UIColor  clearColor];
        countDownLabel.textColor = [UIColor  lightGrayColor];
        countDownLabel.textAlignment = NSTextAlignmentCenter;
        [self.view  addSubview:countDownLabel];
    }
}

#pragma mark
#pragma mark Methord- Events

-(void)setDefaultValueOfRestInterval:(NSTimeInterval)rest andPushedNum:(int)nums andReset:(BOOL)reset{

    circle_Reset = !reset;

    if (rest <= 0) {
        return;
    }
    self.timeflow = (float)rest;
    randomSum = nums;
}

-(void)doTheAction{
    [self  circleInit];
    [self labelInit];
    [self  countDownLabelInit];
    [self requestTheOrderStatus];
}

-(void)requestTheOrderStatus{
    
    NSDictionary  *requestDic = [NSDictionary  dictionaryWithObject:self.orderID forKey:@"orderId"];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"takeTaxi/orderDetail" andParam:[requestDic JSONString]];
    if (sendTaxiRequest) {
        [sendTaxiRequest cancel];
        SFRelease(sendTaxiRequest);
    }
    sendTaxiRequest = [[ HttpUtil  alloc]init];
    [sendTaxiRequest  requestWithURLString:url Content:Nil StartLoading:NO EndLoading:NO Delegate:self];
}

- (void)  changeTaxiNum :(int )  num
{
    [self  randomCount:DefautTaxiNum andSum:num];
    
    taxiNumLabel.text = [NSString  stringWithFormat:@"%d",randomSum];
}

- (void) randomCount:(int) interval  andSum:(int) sum
{
    
    if (randomSum > DefautMaxNum)
    {
        return;
    }
    
    int i  = (arc4random()%(interval+1)) ;
    randomSum = randomSum + i;
}

- (void) jumpTryAgainCtrl{
    // 终止计时
    [circle stopAnimation];
    circle_Reset = NO;
    self.timeflow = 0;
    randomSum = 0;
    
    TaxiTryAgainCtrl  *againCtrl = [[TaxiTryAgainCtrl   alloc] initWithTitle:@"再次叫车" style:_NavOnlyBackBtnStyle_];
    //再次下单需传入生成的订单ID以及加价策略
    self.againOrder.orderId = self.orderID;
    [againCtrl setOrder:self.againOrder];
    
   
    [self.navigationController  pushViewController:againCtrl animated:YES];
    [againCtrl  release];
    
}

- (void)  jumpSuccessView
{
    CallSuccessViewController  *contrl =[[CallSuccessViewController  alloc]initWithTitle:@"叫车成功" style:NavBarBtnStyleOnlyBackBtn];
        contrl.detaileModel = dModel;
    [self.navigationController  pushViewController:contrl animated:YES];
    [contrl release];
    
}


- (void) back
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // 终止计时
    [circle stopAnimation];
    //连续计时 打点
    if (_delegate && [_delegate respondsToSelector:@selector(continueCountTimeRest:pushedNum:)]) {
        [_delegate continueCountTimeRest:TAXI_WAITING_SECONDS-countDown pushedNum:randomSum];
    }
    
    
    if (sendTaxiRequest) {
        [sendTaxiRequest cancel];
        SFRelease(sendTaxiRequest);
    }
    
    BOOL fromPhone = NO;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[ConfirmPhoneVC class]]) {
            fromPhone = YES;
            break;
        }
    }
    
    if (fromPhone) {
        CallTaxiVC *vc = nil;
        for (UIViewController *v  in self.navigationController.childViewControllers) {
            if ([v isKindOfClass:[CallTaxiVC class]]) {
                vc = (CallTaxiVC *)v;
                break;
            }
        }
        [self.navigationController popToViewController:vc animated:YES];
    }else{

        [super back ];
    }
}

#pragma mark - httpDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{    if (util == sendTaxiRequest)
{
        NSDictionary  *dic = [PublicMethods  unCompressData:responseData];

        if ([Utils  checkJsonIsError:dic])
        {
            return;
        }
       
        dModel = [[TaxiDetaileModel  alloc]initWithDataDic:[dic  objectForKey:@"order"]];
        //taxiNumLabel.text = [NSString  stringWithFormat:@"%d",[dModel.driverNum  intValue]];
    
    [self  changeTaxiNum :[dModel.driverNum  intValue]];
    
    NSLog(@"driverNum%@",dModel.driverNum);
    
        if ([dModel.orderStatus intValue] == 2)
        {
           
            
            [[NSNotificationCenter  defaultCenter] removeObserver:self];
           
            //防止出现叫车成功页面跳不过去
            [self  performSelector:@selector(jumpSuccessView) withObject:nil afterDelay:0.5];
            
            //重置转圈
            [circle stopAnimation];
            circle_Reset = NO;
            self.timeflow = 0;
            randomSum = 0;
         
        }else
        {
            [self performSelector:@selector(requestTheOrderStatus) withObject:nil afterDelay:[self.pollingTime doubleValue]];
        }
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void) httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    
}


@end
