//
//  CallSuccessViewController.m
//  ElongClient
//
//  Created by nieyun on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CallSuccessViewController.h"
#import "DetaileDriverCell.h"
#import "UIViewExt.h"
#import "HttpUtil.h"
#import "ElongURL.h"
#import "AttributedLabel.h"
#import  "TaxiListContrl.h"
#import "TaxiListModel.h"
#import "CoordinateTransform.h"
#import "CallTaxiVC.h"
#import "TaxiPublicDefine.h"
#import "PublicMethods.h"

@interface CallSuccessViewController ()

@end

@implementation CallSuccessViewController

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
    
    
    [self addHeadView];
    
    [self  sucessViewAddObjects];
    
    [self  tableviewSet];
    
    [self addFinishButton];
    //不获取司机经纬度
   // [self  driverPostionRuequest];
    
    [self  tipShow];
    //-----------------------------如果有经纬度--------------------------------------
//    [self  sucessViewAddObjects];
//    
//
//    [self  distanceShow:self.distance andTime:self.dua];
    //----------------------------没有经纬度--------------------------------------
    
    
    IsFirst = 0;
    
    UMENG_EVENT(UEvent_Car_OrderSuccess)
    
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
    vc.absolutelyNew = YES;
    
    [self.navigationController popToViewController:vc animated:YES];

}



//即将消失时取消请求
- (void) viewWillDisappear:(BOOL)animated
{
    if (driverUtil)
    {
        [driverUtil  cancel];
    }
}


#pragma mark - initView
- (void) addHeadView
{
    callSucessView   = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 150)];
    
    callSucessView.backgroundColor  = [UIColor  clearColor];
    
    
    UIImage  *img = [UIImage  imageNamed:@"elong-icon_box"];
    
    img = [img  stretchableImageWithLeftCapWidth:70 topCapHeight:50];
    
    UIImageView  *sucBgimagev = [[UIImageView  alloc]initWithImage:img];
    
    sucBgimagev.backgroundColor = [UIColor  clearColor];
    
    sucBgimagev.userInteractionEnabled = YES;
    
    sucBgimagev.frame= CGRectMake(20, 20, callSucessView.width, callSucessView.height + 40 );
    
    [sucBgimagev  addSubview:callSucessView];
    
    [self.view addSubview:sucBgimagev];
    
    [sucBgimagev addSubview:callSucessView];
    
    [sucBgimagev  release];

}

- (void)  tableviewSet
{
    tablebView  =[[UITableView  alloc]initWithFrame:CGRectMake(20, callSucessView.bottom + 60, 280,TABLEBODYHEIGHT ) style:UITableViewStylePlain];
    
    if (!IOSVersion_7)
    {
        tablebView.backgroundColor  = [UIColor  whiteColor];

    }
    
    tablebView.backgroundView = nil;
    
    tablebView.delegate  =self;
    
    tablebView.dataSource = self;
   
    tablebView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    tablebView.scrollEnabled = NO;
    
    [self.view  addSubview:tablebView];
    
    [self  tableFootViewSet];
    
}


- (void) tableFootViewSet
{
    UILabel *footLabel = [[UILabel  alloc]initWithFrame:CGRectMake(tablebView.left, tablebView.bottom+2, tablebView.width , TABLEFOOTHEIGHT)];
    footLabel.text = TIP;
    footLabel.adjustsFontSizeToFitWidth = YES;
    footLabel.font = [UIFont  systemFontOfSize:13];
    footLabel.backgroundColor = [UIColor  clearColor];
    footLabel.textColor = [UIColor colorWithWhite:0.390 alpha:1.000];
    [self.view addSubview:footLabel];
    [footLabel release];
}
- (void) addFinishButton
{
    UIButton  *finishButton = [UIButton  uniformButtonWithTitle:@"查看订单" ImagePath:Nil Target:self Action:@selector(buttonAction) Frame:CGRectMake(tablebView.left, tablebView.bottom  + 40, tablebView.width, 40)];

    [self.view addSubview:finishButton];
}

- (void) sucessViewAddObjects
 {
      
    
         UILabel  *sucLabel  =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, callSucessView.width, 50)];
         
         sucLabel.text = @"         得嘞，我马上到...";
         
         [sucLabel  setFont:[UIFont  boldSystemFontOfSize:22]];
         
         sucLabel.backgroundColor = [UIColor  clearColor];
         
         [callSucessView addSubview:sucLabel];
         
         [sucLabel  release];
     
     
         distanceLabel  =[[AttributedLabel  alloc]initWithFrame:CGRectMake(0,sucLabel.bottom + 10 , sucLabel.width, 30)];
         
         [callSucessView  addSubview:distanceLabel];
     
        distanceLabel.backgroundColor = [UIColor  clearColor];
         
         [distanceLabel release];
         
         UILabel   *warmLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, distanceLabel.bottom+10, distanceLabel.width, 30)];
         warmLabel.text = @"              请保持手机通畅";
         
         warmLabel.textColor  = [ UIColor  lightGrayColor];
         
         warmLabel.backgroundColor = [UIColor  clearColor];
         
         [callSucessView  addSubview:warmLabel];
         
         [warmLabel  release];

     
}


- (void) setColor:(UIColor  *) textColor  andFont:(UIFont *) textFont andloc:(NSInteger) loc  andLenth:(NSInteger)len  andLabel:(AttributedLabel *) label
{
    
    [label  setFont:textFont fromIndex:loc length:len];
    [label  setColor:textColor fromIndex:loc length:len];
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
    
    UMENG_EVENT(UEvent_Car_OrderSuccess_Orders)
}


#pragma mark - tableDelegate

- (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *str = @"cell";
     DetaileDriverCell *cell = [tablebView  dequeueReusableCellWithIdentifier:str];
    if (cell == nil)
    {
        cell = [[[NSBundle  mainBundle]loadNibNamed:@"DetaileDriverCell" owner:self options:nil]lastObject];
    }
     cell.driverModel = self.detaileModel.responseInfo;
    cell.cellType = DetaileDriverCellFromSuccess;
   
     return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEBODYHEIGHT;
}

#pragma mark - directionRequest
- (void) driverPostionRuequest
{
    if (driverUtil)
    {
        [driverUtil cancel];
        SFRelease(driverUtil);
    }
    driverUtil = [[HttpUtil alloc]init];
    
    NSString  *orderId = self.detaileModel.orderId;
  
    NSDictionary  *dic = nil;
    if (orderId)
    {
       dic  = [NSDictionary  dictionaryWithObject:orderId forKey:@"orderId"];

    }
    NSString  *str = [dic JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"takeTaxi/getDriverLoc" andParam:str];
    [driverUtil  requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    
    [[UIApplication  sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void) searchDirectionWithLoading:(BOOL)loading  andCooldiate:(CLLocation *) location
{
    
    NSString *postString = nil;
  //  CLLocationCoordinate2D userloacation =CLLocationCoordinate2DMake(39.9551, 116.3715);
//    CLLocationCoordinate2D  ccld = CLLocationCoordinate2DMake(39.9455, 116.383);
    
    CLLocationCoordinate2D   userloacation = [[PositioningManager  shared]myCoordinate];
    
    postString = [NSString stringWithFormat:@"%@?from=nav&latOrigin=%f&lngOrgin=%f&latDes=%f&lngDes=%f&mode=%@",
                  AUTONAVI,
                  userloacation.latitude,
                  userloacation.longitude,
                  location.coordinate.latitude,
                  location.coordinate.longitude,
                  (travelMode == Driving?@"driving":@"walking")];
    
    [self searchDirectionWithURLString:postString];
    
}


- (void) searchDirectionWithURLString:(NSString *)url
{
    
    NSString *getUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (USENEWNET) {
        if (directionUtil) {
            [directionUtil cancel];
            SFRelease(directionUtil);
        }
        
        directionUtil = [[HttpUtil alloc] init];
        [directionUtil connectWithURLString:getUrl
                                    Content:nil
                               StartLoading:NO
                                 EndLoading:NO
                                   Delegate:self];
    }
    
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}


#pragma mark - httpDelegate
- (void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{

    if (util == directionUtil)
    {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        
        [self  dealWithDirectionResult:root];
        
    }
    else  if (util == driverUtil)
    {
        NSDictionary  *dic = [PublicMethods  unCompressData:responseData];
        
        NSLog(@"positionpositon%@",dic);
        
        if ([[dic  objectForKey:@"IsError"] intValue] != 0)
        {
            [[UIApplication  sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self  performSelector:@selector(driverPostionRuequest) withObject:nil afterDelay:10] ;
            
            return;
        }
        
      //-------------------------------测试用的，正式注掉即可-------------------------
//        CLLocationCoordinate2D  coodiate1 = CLLocationCoordinate2DMake(39.948 + i/10.0, 116.342+i/10.0);
//        coodiate1 = [CoordinateTransform  BaiDuCoordinateToGoogleCoordinate:coodiate1];
//        CLLocation  *location = [[CLLocation  alloc]initWithLatitude:coodiate1.latitude longitude:coodiate1.longitude];
//        [self  searchDirectionWithLoading:NO andCooldiate:location];
//        [location release];
      //-----------------------------正式用的，打开即可-------------------------------
     
        CLLocationCoordinate2D  coodiate= CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"]  floatValue], [[dic  objectForKey:@"longitude"]floatValue]);
        //百度转谷歌
        coodiate = [CoordinateTransform  BaiDuCoordinateToGoogleCoordinate:coodiate];
        CLLocation  *location = [[CLLocation alloc]initWithLatitude:coodiate.latitude longitude:coodiate.longitude];
        [self  searchDirectionWithLoading:NO andCooldiate:location];
        [location release];
    }
    else
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
        //进入订单表页，取消请求司机经纬度
        [NSObject  cancelPreviousPerformRequestsWithTarget:self];
        
        TaxiListContrl  *taxiList = [[TaxiListContrl  alloc] initWithTopImagePath:nil andTitle:@"打车订单" style:_NavOnlyBackBtnStyle_   andArray:modelAr];
        
        taxiList.fromSuccess = YES;
        
        [self.navigationController  pushViewController:taxiList animated:YES];
        [taxiList  release];

    }
}


-(void) httpConnectionDidCanceled:(HttpUtil *)util1
{
    
}


#pragma mark- dealMap
- (void) dealWithDirectionResult:(NSDictionary *)root{
    
    [[UIApplication  sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSObject *routesObj = [root safeObjectForKey:@"routes"];
    NSObject *listObj = [root safeObjectForKey:@"list"];
    if (routesObj && routesObj != [NSNull null]) {
        mapDataFrom = GoogleMap;
    }else{
        
        if (listObj && listObj != [NSNull null]) {
            mapDataFrom = AutoNavi;
        }else{
            mapDataFrom = EmptyMapData;
        }
    }
    
    if (mapDataFrom == GoogleMap) {
        NSArray *routesArray = (NSArray *)routesObj;
        NSString *routesOK = (NSString *)[root safeObjectForKey:@"status"];
        // 取得正常数据的情况下
        if ([routesArray count] > 0 && [routesOK isEqualToString:@"OK"])
        {
            NSArray  *obg = (NSArray  *)routesObj;
            NSDictionary  *totalDic= [[[obg  safeObjectAtIndex:0]  objectForKey:@"legs"] safeObjectAtIndex:0];
           // NSLog(@"%@",totalDic);
            
            NSDictionary  *totalRoutsDic = [totalDic  safeObjectForKey:@"distance"];
            float  d = [[totalRoutsDic  objectForKey:@"value"]floatValue]/1000.0;
            NSString *dis = [NSString  stringWithFormat:@"%.1f公里",d];
           
            
            
            NSDictionary  *totalTimeDic = [totalDic  safeObjectForKey:@"duration"];
            NSString  *dua = [totalTimeDic objectForKey:@"value"];
            int   t = [dua  floatValue]/60;
            NSString  *duation = [NSString  stringWithFormat:@"%d分钟",t];
            
            IsFirst ++;
            
            [self  distanceShow:[self checkText:dis] andTime:[self  checkText:duation]];
            
            [self  performSelector:@selector(driverPostionRuequest) withObject:nil afterDelay:10] ;
           
        }
        
    }
}


- (NSString  *) checkText:(NSString  *)text
{
    NSMutableString  *distance = [NSMutableString  stringWithFormat:@"%@",text];
    NSString  *str= @" ";
    NSRange  range = [text  rangeOfString:str];
    if (range.location !=  NSNotFound) {
        [distance  deleteCharactersInRange:range];
    }
    return (NSString  *)distance;
}


- (void) distanceShow:(NSString  *) distance  andTime:(NSString  *) duaration
{
    if (distance && duaration)
    {
        distanceLabel.text= [NSString  stringWithFormat:@"  我距你%@,预计%@赶到",distance,duaration];
        
       
        
        
        [self  setColor:[UIColor  grayColor] andFont:[UIFont  systemFontOfSize:16] andloc:0  andLenth:distanceLabel.text.length  andLabel:distanceLabel];
        
        
        NSRange  range2 = [distanceLabel.text  rangeOfString:duaration];
        
        [self setColor:[UIColor  orangeColor] andFont:[UIFont  systemFontOfSize:20] andloc:range2.location andLenth:range2.length andLabel:distanceLabel];
        
        NSRange  range = [distanceLabel.text  rangeOfString:distance];
        
        [self  setColor:[UIColor  orangeColor] andFont:[UIFont  systemFontOfSize:20] andloc:range.location andLenth:range.length andLabel:distanceLabel];

    }
    
}

- (void) tipShow
{
    distanceLabel.text = [NSString  stringWithFormat:@"       司机已抢单，确认短信已发出"];
    
    [self  setColor:[UIColor  grayColor] andFont:[UIFont  systemFontOfSize:16] andloc:0  andLenth:distanceLabel.text.length  andLabel:distanceLabel];
    
    NSString  *str1 = @"已抢单";
   
    NSRange  range =  [distanceLabel.text  rangeOfString:str1];
    
    [self  setColor:RGBACOLOR(65, 159, 252, 1) andFont:[UIFont systemFontOfSize:20] andloc:range.location andLenth:range.length andLabel:distanceLabel];
    
    NSString  *str2 = @"已发出";
    
    NSRange range2 = [distanceLabel.text rangeOfString:str2];
    
    [self  setColor:RGBACOLOR(65, 159, 252, 1) andFont:[UIFont  systemFontOfSize:20] andloc:range2.location andLenth:range2.length andLabel:distanceLabel];
    
    
}

  - (void)dealloc
{
    [tablebView  release];
    
    [NSObject  cancelPreviousPerformRequestsWithTarget:self];
    
    [driverUtil cancel];
    
    SFRelease(driverUtil);
    
    [directionUtil  cancel];
    
    SFRelease(directionUtil);
    
    [callSucessView  release];
   
    [_detaileModel  release];
    
    [_orderId  release];
   
   
  
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
