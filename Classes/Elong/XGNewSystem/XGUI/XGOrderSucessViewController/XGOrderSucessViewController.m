//
//  XGOrderSucessViewController.m
//  ElongClient
//
//  Created by guorendong on 14-5-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#define tipInfoString @"●  温馨提示:此酒店为酒店直销，如有任何需要，您可以直接联系酒店，联系方式见订单。"
#define DisTipInfoString  [NSString stringWithFormat:@"%@%@%@%@",self.infoModel.Remark.length>0?@"●  ":@"",self.infoModel.Remark.length>0?self.infoModel.Remark:@"",self.infoModel.Remark.length>0?@"\n":@"",tipInfoString];
#import "XGOrderSucessViewController.h"
#import "ShareTools.h"
#import "XGFramework.h"
#import "NSString+URLEncoding.h"

#import "XGHotelInfoViewController.h"
#import "XGOrderDetailViewController.h"
#import "OrderManagement.h"
@interface XGOrderSucessViewController ()

@end

@implementation XGOrderSucessViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.goHotelButton.backgroundColor=[UIColor whiteColor];
    self.playOrderButton.backgroundColor =[UIColor whiteColor];
    [self setSucessPage];
    [NSString stringWithFormat:@"%@%@%@%@",self.infoModel.Remark.length>0?@"●  商家说明:":@"",self.infoModel.Remark.length>0?self.infoModel.Remark:@"",self.infoModel.Remark.length>0?@"\n":@"",tipInfoString];
    
}
-(void)setSucessPage
{
    if (self.infoModel ==nil) {
        [self backhome];
        return;
    }
    self.orderNoLabel.text=self.infoModel.OrderId;
    self.totalAmountLabel.text=[NSString stringWithFormat:@"￥%@",self.infoModel.TotalPrice];
    
    CGSize totalsize = [self.totalAmountLabel.text sizeWithFont:self.totalAmountLabel.font constrainedToSize:CGSizeMake(self.totalAmountLabel.width, 10000) lineBreakMode:self.totalAmountLabel.lineBreakMode];
    
    self.totalAmountLabel.size = CGSizeMake(totalsize.width, self.totalAmountLabel.height);
    
    self.totaTips.frame = CGRectMake((self.totalAmountLabel.right>0?self.totalAmountLabel.right:112)+5, self.totaTips.top, self.totaTips.width, self.totaTips.height);
    
    self.hotelNameLabel.text =self.infoModel.HotelInfo.HotelName;
    self.venterLable.lineBreakMode =NSLineBreakByWordWrapping;

    NSString *tipString = DisTipInfoString;
    CGSize size = [tipString sizeWithFont:self.venterLable.font constrainedToSize:CGSizeMake(self.venterLable.width, 10000) lineBreakMode:self.venterLable.lineBreakMode];
    self.venterLable.frame=CGRectMake(self.venterLable.left, self.venterLable.top, size.width, size.height);
    self.venterLable.text=DisTipInfoString;
    self.actionViews.frame=CGRectMake(0, self.venterLable.bottom+15.0, self.actionViews.width, self.actionViews.height);
}





-(void)shareInfo
{
    //
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = [[XGApplication shareApplication] getViewImage:self.view];//[self screenshotOnCurrentView];
	shareTools.weiBoContent = [self getContent];
	shareTools.msgContent = [self getContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订酒店成功！";
	shareTools.mailContent = [self getContent];
	[shareTools  showItems];
}




- (NSString *) getContent{
	NSString *message = nil;
    
    NSString *arrDateStr = [TimeUtils displayDateWithNSTimeInterval:[self.infoModel.CheckInDate doubleValue]/1000 formatter:@"yyyy年MM月dd日"];
    NSString *leaDateStr = [TimeUtils displayDateWithNSTimeInterval:[self.infoModel.CheckOutDate doubleValue]/1000 formatter:@"yyyy年MM月dd日"];;
    
    message = [NSString stringWithFormat:@"我在艺龙成功预订了一家酒店，订单号：%@，【%@】，地址：%@，日期：%@至%@，酒店电话：%@",self.infoModel.OrderId,self.infoModel.HotelInfo.HotelName,self.infoModel.HotelInfo.Address,arrDateStr,leaDateStr,self.infoModel.HotelPhone];
		
	NSString *content  = message;//[NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}
-(id)init
{
    self  =[super initWithTitle:@"订单成功" style:NavBarBtnStyleBackShareHomeTel];
    if (self) {
        
    }
    return self;
}
//去酒店
- (IBAction)goHotelAction:(id)sender {
    double latitude = [self.infoModel.HotelInfo.Latitude doubleValue];
	double longitude = [self.infoModel.HotelInfo.Longitude doubleValue];
    
    
    
    if (latitude != 0 || longitude != 0) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:self.infoModel.HotelInfo.HotelName];
        }else{
            // 酒店有坐标时用酒店坐标导航
            [PublicMethods pushToMapWithDesLat:latitude Lon:longitude];
        }
    }
    else {
        // 酒店没有坐标时用酒店地址导航
        [PublicMethods pushToMapWithDestName:self.infoModel.HotelInfo.Address];
    }

    
//	if (lat != 0 || lon != 0) {
//        [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(lat, lon) title:self.infoModel.HotelInfo.HotelName];
//    }
//	else {
//		// 酒店没有坐标时用酒店地址导航
//		[PublicMethods pushToMapWithDestName:self.infoModel.HotelInfo.Address];
//	}
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//切换到订单详情

- (IBAction)playOrderAction:(id)sender {
    // 请求单据详情
    
   OrderManagement * order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    order.isFromOrder = YES;
    [self.navigationController pushViewController:order animated:YES];

    return;

//
//    NSDictionary *dict =@{
//                          @"CardNo":[AccountManager instanse].cardNo,
//                          @"orderId":self.infoModel.OrderId
//                          };
//    
//    NSLog(@"请求参数 ....dict==%@",dict);
//    NSString *reqbody=[dict JSONString];
//    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
//    body =[body URLEncodedString];
//    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderDetail"];
//    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
//    
//    // 组装url
//    NSLog(@"请求url=====%@",url);
//    
//    __unsafe_unretained typeof(self) weakself = self;
//    
//    XGHttpRequest *r =[[XGHttpRequest alloc] init];
//    [r evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
//        
//        NSDictionary *result =returnValue;
//        NSLog(@"result===%@",result);
//        
//        if (type == XGRequestCancel) {
//            return;
//        }
//        if (type ==XGRequestFaild) {
//            return;
//        }
//        //等真实接口出来，我们调用
//        if ([Utils checkJsonIsError:returnValue])
//        {
//            return;
//        }
//        
//        NSDictionary *orderDetailDict=[result safeObjectForKey:@"OrderDetail"];
//        
//        XGOrderModel *orderDetailModel = [[XGOrderModel alloc]init];
//        
//        [orderDetailModel convertObjectFromGievnDictionary:orderDetailDict relySelf:YES];
//        
//        XGOrderDetailViewController *orderDetailVC = [[XGOrderDetailViewController alloc]init];
//        orderDetailVC.orderModel = orderDetailModel;
//        [weakself.navigationController pushViewController:orderDetailVC animated:YES];
//        
//        NSLog(@"===%@",result);
//    }];
//
    
}
-(NSString *)viewName
{
    return @"业务界面.订单成功页";
}
-(void)back
{
    NSInteger count =self.navigationController.viewControllers.count;
    UIViewController *cv =nil;
    if (count>2) {
        cv =self.navigationController.viewControllers[count-1-2];
    }
    if (cv ==nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popToViewController:cv animated:YES];
    }
}

- (void)dealloc {
}
- (void)viewDidUnload {
    [self setPlayOrderButton:nil];
    [self setGoHotelButton:nil];
    [super viewDidUnload];
}
@end
