//
//  RentCarDetailedBillViewController.m
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#define TITLE1X 20  // 第一列title的初始x
#define TITLE2X 176  // 第二列title的初始x
#define CONTENT1X 87 // 第一列content的初始x
#define CONTENT2X 237 // 第一列content的初始x

#define BEGINHEIGHT 140 //初始位置
#define VERTICALSPACE 10  //行间距
#define LABLEWIDTH 63  //lable 宽度
#define LABLEHTIGHT 23  //lable 高度

#import "RentCarDetailedBillViewController.h"
#import "RentCarChargesInfoViewController.h"
#import "RentCarBillModel.h"
#import "LzssUncompress.h"
@interface RentCarDetailedBillViewController ()

@end

@implementation RentCarDetailedBillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    _orderStatus = nil;
    _tipDes = nil;
    self.totoKiloLengthLabel = nil;
    self.totoTimeLengthLabel = nil;
    self.detailBillModel = nil;
    [super dealloc];
}

-(void)requestTheBillTip{

    NSDictionary *req = @{@"channel":@"RentCar",@"page":@"OrderInfoBillDetail",@"positionId":@"TipsDescription",@"productLine":@"iphone",};
    NSString *json = [req JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"contentResource" andParam:json];
    if (STRINGHASVALUE(url)) {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //后台服务完成 才请求
    if ([self.orderStatus isEqualToString:@"8"]) {
        [self requestTheBillTip];
    }

    [self createview];
}
#pragma mark -
#pragma mark 视图层
-(void)createview{
    
    self.totoKiloLengthLabel.text = self.detailBillModel.kiloLength;
    NSString *string = [[self.detailBillModel.startTime stringByAppendingFormat:@"-%@",self.detailBillModel.endTime] stringByAppendingFormat:@"总计%@",self.detailBillModel.timeLength];
    //NSLog(@"-------%@",string);
    self.totoTimeLengthLabel.text = string;
    NSArray *realAmountDetailArr=[self.detailBillModel billDetail];
    
    int height  = 130;
    
    for (int i=0; i<[realAmountDetailArr count]; i++) {
        
        RentCarBillModel *billModel = [realAmountDetailArr objectAtIndex:i];
        
        int titlex = i%2?TITLE2X:TITLE1X;
        
        int titley = BEGINHEIGHT+(i/2)*VERTICALSPACE+(i/2)*LABLEHTIGHT;
        
        CGRect rect = CGRectMake(titlex, titley, LABLEWIDTH, LABLEHTIGHT);
        
        UILabel *title = [[UILabel alloc]initWithFrame:rect];
        title.font = FONT_14;
        title.backgroundColor = [UIColor clearColor];
        title.text = billModel.realAmountType;
        title.textColor = [UIColor grayColor];
        [self.view addSubview:title];
        [title release];
        
        rect.origin.x += 65;
        
        UILabel *content = [[UILabel alloc]initWithFrame:rect];
        content.font = FONT_16;
        content.text = billModel.realFee;
        content.textColor = RGBCOLOR(52, 52, 52, 1);
        content.textAlignment = NSTextAlignmentRight;
        content.backgroundColor = [UIColor clearColor];
        [self.view addSubview:content];
        [content release];
        
        
        if (i==([realAmountDetailArr count]-1)) {
            height = content.bottom;
        }
    }
    
    UILabel *amountLable = [[UILabel alloc]initWithFrame:CGRectMake(20, height+20, 136, 23)];
    amountLable.font = FONT_B16;
    amountLable.backgroundColor = [UIColor clearColor];
    amountLable.text = @"实际用车费用总计";
    [self.view addSubview:amountLable];
    [amountLable release];
    
    
    UILabel *moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(219, amountLable.top, 20, 23)];
    moneyLable.font = FONT_15;
    moneyLable.backgroundColor = [UIColor clearColor];
    moneyLable.textColor = RGBCOLOR(93, 93, 93, 1);
    moneyLable.text = @"￥";
    [self.view addSubview:moneyLable];
    [moneyLable release];
    
    UILabel *moneyConLable = [[UILabel alloc]initWithFrame:CGRectMake(235, amountLable.top, 85, 23)];
    moneyConLable.font = [UIFont systemFontOfSize:20];
    moneyConLable.textColor = RGBCOLOR(254, 75, 32, 1);
    moneyConLable.backgroundColor = [UIColor clearColor];
    moneyConLable.text = self.detailBillModel.totalPrice;
    moneyConLable.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:moneyConLable];
    [moneyConLable release];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, amountLable.bottom+5, SCREEN_WIDTH-40, 50)];
    tipLabel.numberOfLines = 0;
	tipLabel.textColor	= RGBACOLOR(52, 52, 52, 1);
	tipLabel.font		= FONT_12;
    tipLabel.tag        = 99;
	tipLabel.backgroundColor = [UIColor clearColor];

    //tipLabel.text		= @"请核对您的账单，如有疑问，可拨打艺龙客服中心热线咨询。如无异议，系统将在2小时后自动收取剩余费用，以节省您的时间";
	[self.view addSubview:tipLabel];
    [tipLabel release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"root===%@",root);
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }

    UILabel *label = (UILabel *)[self.view viewWithTag:99];
    NSArray *array = [root objectForKey:@"contentList"];
    NSString *string = @"";
    if ([array count] > 0) {
        NSDictionary *dic = [array objectAtIndex:0];
        string = [dic objectForKey:@"content"];
    }
    label.text = string;
}

@end
