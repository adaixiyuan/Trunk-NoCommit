//
//  TaxiPayViewController.m
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiPayViewController.h"
#import "TaxiFillManager.h"
#import "UIViewExt.h"
#import "RentPickerAndSendViewController.h"
#import "OrderManagement.h"

@interface TaxiPayViewController ()

@end

@implementation TaxiPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.orderNumLabel.text = [self.orderDic  objectForKey:@"orderId"];
    self.endPositionLabel.hidden = YES;
    TaxiFillManager  *manager = [TaxiFillManager  shareInstance];
    self.priceLabel.text = [NSString  stringWithFormat:@"¥%@",[self.orderDic  objectForKey:@"ccAmt"]];
    self.taxiTypeLabel.text = manager.fillRqModel.carTypeName;
    self.startPosirionLabel.text = manager.evalueRqModel.fromAddress;
    self.endPositionLabel.hidden = NO;
    if (manager.hasDestination)
    {
        self.endPositionLabel.text = manager.evalueRqModel.toAddress;
    }else
    {
        self.endPositionLabel.text = @"暂无";
       // self.useTimeLabel.top = self.endPositionLabel.top;
    }
    self.useTimeLabel.text = manager.evalueRqModel.startTime;
    
    [self listButtonInit];

    // Do any additional setup after loading the view from its nib.
}




- (void) listButtonInit
{
    UIButton  *bt = [[UIButton alloc]initWithFrame:CGRectMake(0,300, SCREEN_WIDTH, 44)];
    bt.backgroundColor = [UIColor  whiteColor];
    
    UIImageView  *imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(20, (44 - 17)/2, 17, 17)];
    imageV.image = [UIImage  imageNamed:@"viewOrder"];
    [bt addSubview:imageV];
    [bt addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:bt];
    
    UILabel  *label = [[UILabel  alloc]initWithFrame:CGRectMake(imageV.right +40, imageV.top, 100, imageV.height)];
    label.text = @"查看订单";
    label.font = [UIFont  systemFontOfSize:15];
    [bt addSubview:label];
    
    [label  release];
    
    [imageV  release];
  
    
    UIImageView  *topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
    [bt  addSubview:topLineView];
    [topLineView release];
    
    
    UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, bt.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
    [bt  addSubview:bottomLineView];
    [bottomLineView  release];
    
      [bt  release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//by lc
- (void)buttonAction
{
    
    // 订单查询
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
    order.isFromOrder = YES;
    [self.navigationController pushViewController:order animated:YES];
    [order release];

    
}
- (void)dealloc {
  
    [_orderDic  release];
    [_orderNumLabel release];
    [_priceLabel release];
    [_taxiTypeLabel release];
    [_startPosirionLabel release];
    [_endPositionLabel release];
    [_useTimeLabel release];
    [_orderId release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOrderNumLabel:nil];
    [self setPriceLabel:nil];
    [self setTaxiTypeLabel:nil];
    [self setStartPosirionLabel:nil];
    [self setEndPositionLabel:nil];
    [self setUseTimeLabel:nil];
    [super viewDidUnload];
}
@end
