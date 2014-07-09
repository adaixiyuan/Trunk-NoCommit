//
//  CommitSuccessCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CommitSuccessCtrl.h"
#import "CallTaxiVC.h"
#import "UIViewExt.h"
#import "AccountManager.h"
#import "TaxiListContrl.h"
#import "PositioningManager.h"
#import "TaxiOrderManager.h"

@interface CommitSuccessCtrl ()

@end

@implementation CommitSuccessCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back{
    
    NSLog(@"tap and back to CallTaxiVC");
    CallTaxiVC *vc = nil;
    for (UIViewController *v  in self.navigationController.childViewControllers) {
        if ([v isKindOfClass:[CallTaxiVC class]]) {
            vc = (CallTaxiVC *)v;
            break;
        }
    }
    [self.navigationController popToViewController:vc animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *string = (STRINGHASVALUE([[PositioningManager shared] currentCity]))?[[PositioningManager shared] currentCity]:@"";
    
    switch ([[TaxiOrderManager shareInstance] currentType]) {
        case Taxi_onCall:
            self.callName.text = [NSString  stringWithFormat:@"%@打车",string];
            break;
        case Taxi_Pick:
            self.callName.text = [NSString  stringWithFormat:@"%@接机",string];
            break;
        case Taxi_Send:
            self.callName.text = [NSString  stringWithFormat:@"%@送机",string];
            break;
        default:
            break;
    }
    
    NSString *string2 = (STRINGHASVALUE(self.orderID))?self.orderID:@"";
    self.orderNum.text = [NSString  stringWithFormat:@"订单号：%@",string2];
    
    CGRect  rect = [self.orderNum  convertRect:self.orderNum.bounds toView:self.view];
    
    UIButton  *finishButton = [UIButton   uniformButtonWithTitle:@"查看订单" ImagePath:nil Target:self Action:@selector(buttonAction) Frame:CGRectMake(15, rect.origin.y + rect.size.height +50 , self.view.width - 30, 50)];
    [self.view  addSubview:finishButton];
    
    if (self.reserveType == TaxiReserve_out48Hours)
    {
        self.tipLabel.text = CommitTip;
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma - mark - 请求订单列表
- (void)  buttonAction
{
    NSMutableDictionary  *jsonDic = [NSMutableDictionary  dictionary];

    
    NSString *string = @"";
    string = (STRINGHASVALUE([[AccountManager instanse] cardNo]))?[[AccountManager instanse] cardNo]:[PublicMethods macaddress];
    [jsonDic setObject:string forKey:@"uid"];
    [jsonDic  setObject:[NSString stringWithFormat:@"01"] forKey:@"productType"];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"takeTaxi/orderList" andParam:jsonString];
    [HttpUtil  requestURL:url postContent:Nil delegate:self];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    NSMutableArray  *modelAr = [NSMutableArray  array];
    
    NSArray  *ar = [root  objectForKey:@"list"];
    
    for(NSDictionary  *dic  in ar)
    {
        TaxiListModel  *model = [[TaxiListModel  alloc]initWithDataDic:dic];
        [modelAr addObject:model];
        NSLog(@"modelmodel%@",model.orderTitle);
        [model release];
    }
    
    TaxiListContrl  *taxiList = [[TaxiListContrl  alloc] initWithTopImagePath:nil andTitle:@"打车订单" style:_NavOnlyBackBtnStyle_   andArray:modelAr];
    
    taxiList.fromSuccess = YES;

    [self.navigationController  pushViewController:taxiList animated:YES];
    
    [taxiList  release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_callName release];
    [_orderNum release];
    [_orderID release];
    _orderID = nil;
    [_tipLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCallName:nil];
    [self setOrderNum:nil];
    [self setTipLabel:nil];
    [super viewDidUnload];
}
@end
