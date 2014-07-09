//
//  TaxiTryAgainCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiTryAgainCtrl.h"
#import "UIViewExt.h"
#import "TaxiPublicDefine.h"
#import "CallTaxiVC.h"
#import "SendTaxiContrl.h"

@interface TaxiTryAgainCtrl ()

@end

@implementation TaxiTryAgainCtrl

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
    self.selected =  NO;
    self.order.addPrice = @"0";
    self.tipButton.highlighted  = NO;
    [self.tipButton  addTarget:self action:@selector(tipBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipLabel.text = @"  加    ¥5元小费";
//    
    NSString  *str1 = [NSString  stringWithFormat:@"加"];
    NSRange  range = [self.tipLabel.text  rangeOfString:str1];
    [self setColor:[UIColor  blackColor] andFont:[UIFont systemFontOfSize:17] andloc:range.location andLenth:range.length andLabel:self.tipLabel];
    
    
    NSString  *str2 = [NSString  stringWithFormat:@"¥"];
    NSRange range2 = [self.tipLabel.text rangeOfString:str2];
    [self setColor:[UIColor  orangeColor] andFont:[UIFont  systemFontOfSize:22] andloc:range2.location  andLenth:2 andLabel:self.tipLabel];
   
    NSString  *str3 = [NSString  stringWithFormat:@"元"];
    NSRange range3 = [self.tipLabel.text  rangeOfString:str3];
    [self  setColor:[UIColor blackColor] andFont:[UIFont  systemFontOfSize:17] andloc:range3.location andLenth:3 andLabel:self.tipLabel];
    
    UIButton  *tryAgainBt = [UIButton  uniformButtonWithTitle:@"继续叫车" ImagePath:Nil Target:self Action:@selector(tryAgainAction) Frame:CGRectMake(20, self.tipButton.bottom + 50, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:tryAgainBt];
    
}


- (void) tryAgainAction
{
    self.order.orderId = @"";
    
    NSString *paramJson = [[self.order convertDictionaryFromObjet] JSONString];
    
    NSString *url = [PublicMethods  composeNetSearchUrl:TAXIURL forService:@"createOrder"];
    
    if (STRINGHASVALUE(url)) {
    
        [HttpUtil requestURL:url postContent:paramJson delegate:self];
    }

}
//下单请求
- (void) requestNet
{
    
      
}
- (void) setColor:(UIColor  *) textColor  andFont:(UIFont *) textFont andloc:(NSInteger) loc  andLenth:(NSInteger)len  andLabel:(AttributedLabel *) label
{
    
    [label  setFont:textFont fromIndex:loc length:len];
    [label  setColor:textColor fromIndex:loc length:len];
}
- (void)  tipBtAction
{
    self.selected = !self.selected;
    if (self.selected) {
        [self.tipButton  setImage:[UIImage  imageNamed:@"btn_choice_checked"] forState:UIControlStateNormal];
        
        self.order.addPrice = @"5";
        
        UMENG_EVENT(UEvent_Car_ReOrder_Tip)
        
    }else{
        [self.tipButton  setImage:[UIImage  imageNamed:@"btn_choice"] forState:UIControlStateNormal];
        self.order.addPrice = @"0";
        
        UMENG_EVENT(UEvent_Car_ReOrder_WithoutTip)
    }
}
#pragma mark - httpDelegate
- (void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
    //成功后返回上个界面继续派单
    NSLog(@"tap and back to SendTaxiContrl");
    SendTaxiContrl *vc = nil;
    for (UIViewController *v  in self.navigationController.childViewControllers) {
        if ([v isKindOfClass:[SendTaxiContrl class]]) {
            vc = (SendTaxiContrl *)v;
            break;
        }
    }
    [vc setOrderID:[root objectForKey:@"orderId"]];
    [vc doTheAction];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void) httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tipLabel release];
    [_tipButton release];
    SFRelease(_order);
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTipLabel:nil];
    [self setTipButton:nil];
    [super viewDidUnload];
}
@end
