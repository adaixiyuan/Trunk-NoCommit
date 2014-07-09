//
//  RentSuccessController.m
//  ElongClient
//
//  Created by nieyun on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentSuccessController.h"
#import "TaxiFillManager.h"
#import "SelectCard.h"
#import "RentComfirmController.h"



@interface RentSuccessController ()
{
@private
    HttpUtil *createCardHttpUtil;
}
@end

@implementation RentSuccessController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_stateLabel release];
    [_orderNumLabel release];
    [_priceLabel release];
    [_typeLabel release];
    [_prePayLabel release];
    
    if (createCardHttpUtil) {
        [createCardHttpUtil cancel];
        SFRelease(createCardHttpUtil);
    }
    [_bjView release];
    [newPayControl  release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setStateLabel:nil];
    [self setOrderNumLabel:nil];
    [self setPriceLabel:nil];
    [self setTypeLabel:nil];
    [self setPrePayLabel:nil];
    [self setBjView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.orderNumLabel.text = [self.orderDic  objectForKey:@"orderId"];
    self.priceLabel.text =   [NSString  stringWithFormat:@"¥%@",[self.orderDic  objectForKey:@"orderAmount"]];
    self.typeLabel.text = [self.orderDic  objectForKey:@"carTypeName"];
    
    TaxiFillManager  *manager = [TaxiFillManager shareInstance];
    manager.gorderIdt = [self.orderDic  objectForKey:@"gorderId"];
    manager.orderId = [self.orderDic  objectForKey:@"orderId"];
    manager.payMentToeken = [self.orderDic  objectForKey:@"payMentToeken"];
    
    UIButton  *button = [UIButton  uniformButtonWithTitle:@"去支付" ImagePath:nil Target:self Action:@selector(payAction) Frame:CGRectMake((SCREEN_WIDTH - 275)/2, self.bjView.bottom+ 70, 279, 44)];
    [self.view  addSubview:button];
    
    // Do any additional setup after loading the view from its nib.
}





- (void) payAction
{
    newPayControl = [[NewPayMethodCtrl  alloc]init];
    
    
    NSString  *total =  [NSString  stringWithFormat:@"%d",[[TaxiFillManager shareInstance].fillRqModel.orderAmount  intValue]];
    
    [newPayControl  goChannel:RENT_TYPE andDic:[NSDictionary  dictionaryWithObjectsAndKeys:total,@"totalPrice",[NSNumber  numberWithInt:RENT_TYPE],@"sourceType",[NSArray  arrayWithObjects:@"",nil],@"detaile", nil]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
