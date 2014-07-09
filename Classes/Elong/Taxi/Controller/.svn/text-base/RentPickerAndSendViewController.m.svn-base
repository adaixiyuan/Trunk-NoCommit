//
//  RentPickUpViewController.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#import "RentPickerAndSendViewController.h"
#import "CustomSegmented.h"
#import "TaxiPublicDefine.h"
#import "TaxiUtils.h"
#import "TaxiTypeViewController.h"
#import "CustomPicker.h"
#import "ELCalendarViewController.h"
#import "FlightListViewController.h"
#import "AirportListViewController.h"
#import "ChooseDepartVC.h"
#import "RentCity.h"
#import "PositioningManager.h"
#import "FastPositioning.h"
#import "TaxiFillManager.h"
#import "EvaluteModel.h"
#import "RentFlight.h"
#import "CoordinateTransform.h"

#define Flight_Tip       @"按航班号接机，我们会自动追踪航班信息，因航班延误造成的等待时间不需要您支付费用"
#define AirPort_Tip     @"按机场名称填写，航班延误产生的等待需支付费用，建议按航班号填写"

#define Tip_NoFlight @"请您选择乘坐航班号"
#define Tip_NoAirPort @"请您选择乘坐机场"
#define Tip_Send_NoDestination @"请您选择您的出发地点"
#define Tip_NotSameCity @"目前暂不提供跨城市服务，请您重新安排行程"
#define CHECK_PASS @"OK"

#define Cell_Height 50
#define Tip_TAG 100
#define NoSupportTag 101
#define CHOOSETAG 102

//SegmentIndex
#define Seg_Airport 0
#define Seg_Flight 1

#define Enable_Nomal [[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23]
#define Enable_Nomal_Pressed [[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23]
#define Unable  [[UIImage imageNamed:@"TaxiUnable.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23]

@interface RentPickerAndSendViewController ()

@end


@implementation RentPickerAndSendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDefaultValue];
    }
    return self;
}

-(void)setDefaultValue{
    
    goList = NO;
    
    FastPositioning *fast = [FastPositioning shared];
    if (STRINGHASVALUE(fast.addressName)) {
        AddressInfo *info = [[AddressInfo alloc] init];
        info.name = fast.addressName;
        info.cityName = [[PositioningManager shared] positionCurrentCity];
        self.startPoint = info;
        [info release];
    }
    AddressInfo *info = [[AddressInfo alloc] init];
    self.destination = info;
    [info    release];
    
    self.flightTime = [TaxiUtils checkDateOffTheGievnDateString:@"22:00"];
    self.air_Time = [TaxiUtils getDateOfHours:2 MinsByTen:YES];
    //Request
    if ((![TaxiFillManager shareInstance].customAirports)||[[TaxiFillManager shareInstance].customAirports count]==0) {
        [self requestTheServiceCoverAndAirportList];
    }
    
    self.selectedAirport = [TaxiUtils getTheDefaultAirportByLocationCity:[[PositioningManager shared] positionCurrentCity] andCustomAirports:[TaxiFillManager shareInstance].customAirports];
    self.airport = self.selectedAirport.name;
    self.cityCode = self.selectedAirport.cityCode;
    [TaxiFillManager shareInstance].carUseCity = self.selectedAirport.cityName;
    
}

-(void)requestTheServiceCoverAndAirportList{
    
    NSString *type = (self.type == RentCarType_Pick)?RENT_PICKER:RENT_SEND;
    NSDictionary *req  = @{@"productType":type};
    
    NSString *paramJson = [req JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:RENTCAR_URL forService:@"getService" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        if (httpUti) {
            [httpUti cancel];
            SFRelease(httpUti);
        }
        httpUti = [[HttpUtil alloc] init];
        [httpUti requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    if (httpUti) {
        [httpUti cancel];
        SFRelease(httpUti);
    }
    SFRelease(_airportArrays);
    SFRelease(_tableView);
        [sheet release];
    
    SFRelease(_flightNum);
    SFRelease(_flightTime);
    SFRelease(_air_Time);
    SFRelease(_airport);
    SFRelease(_destination);
    SFRelease(_selectedFlight);
    SFRelease(_selectedAirport);
    SFRelease(_startPoint);
    SFRelease(_cityCode);
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.type ==  RentCarType_Pick) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"按机场", @"按航班号", nil];
        CustomSegmented *seg = [[CustomSegmented alloc] initCommanSegmentedWithTitles:titleArray
                                                                          normalIcons:nil
                                                                       highlightIcons:nil];
        seg.delegate		= self;
        seg.selectedIndex	= segmentselectedindex;
        [self.view addSubview:seg];
        [seg release];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+20 * COEFFICIENT_Y, SCREEN_WIDTH, SCREEN_HEIGHT-44-20-20 * COEFFICIENT_Y) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [self  createFootView];
    
}
-(UIView *)createFootView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    if (self.type == RentCarType_Pick) {
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20,0, SCREEN_WIDTH-40, 40)];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.font = FONT_11;
        tip.textColor = RGBACOLOR(153, 153, 153, 1);
        tip.numberOfLines = 0;
        tip.tag = Tip_TAG;
        tip.lineBreakMode  = NSLineBreakByWordWrapping;
        tip.text =  (segmentselectedindex==Seg_Flight)?Flight_Tip:AirPort_Tip;
        tip.backgroundColor = [UIColor clearColor];
        [view addSubview:tip];
        [tip release];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = CHOOSETAG;
    [btn setTitle:@"去选车" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 60, SCREEN_WIDTH-40, 40)];
    [btn setBackgroundImage:Enable_Nomal forState:UIControlStateNormal];
    [btn setBackgroundImage:Enable_Nomal_Pressed forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goAndSelectCar:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    return [view autorelease];
}

-(void)prepareDataForEstimateTheCarprice{

    EvalueRequestModel *model = [[EvalueRequestModel alloc] init];
    model.flightNum = self.flightNum;
    model.cityCode = self.cityCode;
    model.productType = (self.type == RentCarType_Pick)?RENT_PICKER:RENT_SEND;
    model.airPortCode = (self.type == RentCarType_Pick)?
                                    ((segmentselectedindex  == Seg_Flight)?self.selectedFlight.dest:self.selectedAirport.airPortCode):
                                    self.selectedAirport.airPortCode;
    model.carTypeCode = @"";
    model.rentTime = @"";
    model.fromAddress = (self.type == RentCarType_Pick)?
                                        ((segmentselectedindex == Seg_Flight)?self.selectedFlight.destName:self.selectedAirport.name):
                                        self.startPoint.name;
    model.startTime = (self.type == RentCarType_Pick)?
                                ((segmentselectedindex == Seg_Flight)?[TaxiUtils addsecsStringByGivenTimeString:self.flightTime]:[TaxiUtils addsecsStringByGivenTimeString:self.air_Time]):
                                [TaxiUtils addsecsStringByGivenTimeString:self.air_Time];
    
    //判断较多 另写一个方法
    [self fillTheCoordinateDataWithType:self.type andModel:model];
    [TaxiFillManager shareInstance].evalueRqModel = model;
    [model release];
}
-(void)fillTheCoordinateDataWithType:(RentCarType)type andModel:(EvalueRequestModel *)model{

    if (type == RentCarType_Pick) {
        if (segmentselectedindex == Seg_Flight) {
           model.fromLongitude = self.selectedFlight.destLng;
            model.fromLatitude = self.selectedFlight.destLat;
        }else{
            model.fromLatitude = self.selectedAirport.latitude;
            model.fromLongitude = self.selectedAirport.longitude;
        }
        
        if (STRINGHASVALUE(self.destination.name)) {
            NSArray *locatins = [self.destination.location componentsSeparatedByString:@","];
            NSString *longitude = [locatins  objectAtIndex:0];
            NSString *latitude = [locatins objectAtIndex:1];
            model.toAddress = self.destination.name;
            //统一转成百度
            CLLocationCoordinate2D google_coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
            CLLocationCoordinate2D baidu_coordinate = [CoordinateTransform GoogleCoordinateToBaiDuCoordinate:google_coordinate];
            model.toLongitude = [NSString stringWithFormat:@"%f",baidu_coordinate.longitude];
            model.toLatitude =  [NSString stringWithFormat:@"%f",baidu_coordinate.latitude];
        
            [TaxiFillManager shareInstance].hasDestination = YES;
        
        }else
        {
            [TaxiFillManager shareInstance].hasDestination = NO;
        }
    }else{
        //送机
        if (STRINGHASVALUE(self.startPoint.location)) {
            //用户点选，已获取经纬度
            NSArray *locatins = [self.startPoint.location componentsSeparatedByString:@","];
            NSString *longitude = [locatins  objectAtIndex:0];
            NSString *latitude = [locatins objectAtIndex:1];
            model.fromAddress = self.startPoint.name;
            CLLocationCoordinate2D google_coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
            CLLocationCoordinate2D baidu_coordinate = [CoordinateTransform GoogleCoordinateToBaiDuCoordinate:google_coordinate];
            model.fromLongitude = [NSString stringWithFormat:@"%f",baidu_coordinate.longitude];
            model.fromLatitude =  [NSString stringWithFormat:@"%f",baidu_coordinate.latitude];
        }else{
            //设备定位获取经纬度
            model.fromAddress = self.startPoint.name;
            CLLocationCoordinate2D baidu_coordinate = [CoordinateTransform GoogleCoordinateToBaiDuCoordinate:[[PositioningManager shared] myCoordinate]];
            model.fromLongitude = [NSString stringWithFormat:@"%f",baidu_coordinate.longitude];
            model.fromLatitude =  [NSString stringWithFormat:@"%f",baidu_coordinate.latitude];
        }
        model.toAddress = self.selectedAirport.name;
        model.toLatitude = self.selectedAirport.latitude;
        model.toLongitude = self.selectedAirport.longitude;
        
        [TaxiFillManager shareInstance].hasDestination = YES;

    }
    model.mapSupporter = @"1";//百度！
}
-(NSString *)checkTheUserInput{
    if (self.type == RentCarType_Pick) {
        if (segmentselectedindex == Seg_Flight) {
            //航班号
            if (!self.flightNum) {
                return Tip_NoFlight;
            }
            if (![TaxiUtils checkTheTimeIsAvailable:self.flightTime]) {
                return nil;
            }
            
        }else{
            //机场
            if (!self.airport) {
                return Tip_NoAirPort;
            }
            if (![TaxiUtils checkTheTimeIsAvailable:self.air_Time]) {
                return nil;
            }
        }
    }else{
        //送机
        if (!self.airport) {
            return Tip_NoAirPort;
        }
        if(!self.startPoint){
            return Tip_Send_NoDestination;
        }
        if (![TaxiUtils checkTheTimeIsAvailable:self.air_Time]) {
            return nil;
        }
    }
    
    //判断是否跨城市
    if (self.type == RentCarType_Pick) {
        if (segmentselectedindex == Seg_Flight) {
            //按航班
            if (![TaxiUtils checkIsSameCity:self.selectedFlight.destCity another:self.destination.cityName]) {
                return Tip_NotSameCity;
            }
        }else{
            //按机场
            if (![TaxiUtils checkIsSameCity:self.selectedAirport.cityName another:self.destination.cityName]) {
                return Tip_NotSameCity;
            }
        }
    }else{
        //送机
        if (![TaxiUtils checkIsSameCity:self.selectedAirport.cityName another:self.startPoint.cityName]) {
            return Tip_NotSameCity;
        }
    }
    
    
    return CHECK_PASS;
}

-(void)goAndSelectCar:(UIButton *)sender
{
    if ([[ServiceConfig share] monkeySwitch]) {
        return;
    }
    NSString *result = [self checkTheUserInput];
    
    if ([result isEqualToString:CHECK_PASS]) {
        
        [self prepareDataForEstimateTheCarprice];
        
        NSDictionary *dic = nil;
        if (self.type == RentCarType_Pick) {
            if (segmentselectedindex == Seg_Flight) {
                //按航班号
                dic = @{@"cityCode":self.cityCode,@"productType":RENT_PICKER,@"airPortCode":self.selectedFlight.dest};
                [TaxiFillManager shareInstance].airPortCode = self.selectedFlight.dest;
                
            }else if (segmentselectedindex == Seg_Airport){
                //按机场
                dic = @{@"cityCode":self.cityCode,@"productType":RENT_PICKER,@"airPortCode":self.selectedAirport.airPortCode};
                [TaxiFillManager shareInstance].airPortCode = self.selectedAirport.airPortCode;
            }
            [TaxiFillManager shareInstance].productType = RENT_PICKER;
            
        }else
        {
            //送机
            dic = @{@"cityCode":self.cityCode,@"productType":RENT_SEND,@"airPortCode":self.selectedAirport.airPortCode};
            [TaxiFillManager shareInstance].airPortCode = self.selectedAirport.airPortCode;
            [TaxiFillManager shareInstance].productType = RENT_SEND;
        }
        [TaxiFillManager shareInstance].currentCityCode = self.cityCode;
        NSString  *jsonStr = [dic  JSONString];
        NSString  *url = [PublicMethods  composeNetSearchUrl:RENTCAR_URL forService:@"getCarType" andParam:jsonStr];
        [HttpUtil  requestURL:url postContent:nil delegate:self];
    }else
    {
        if (nil != result) {
                [Utils alert:result];
        }
    }
}

#pragma mark
#pragma mark HTTP------------Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    if (util == httpUti)
    {
        NSMutableArray *sup_citys = [[NSMutableArray alloc] init];
        NSArray *cityList = [root objectForKey:@"cityList"];
        for (NSDictionary *city in cityList) {
            RentCity *acity = [[RentCity alloc] init];
            [acity convertObjectFromGievnDictionary:city];
            [sup_citys addObject:acity];
            [acity release];
        }
        self.airportArrays = sup_citys;
        [sup_citys release];
        
        //机场列表写入
        [TaxiFillManager shareInstance].customAirports =  [TaxiUtils getTheCustomAirPortOrTerminalsByGivenArrays:self.airportArrays];
        //默认机场
        self.selectedAirport = [TaxiUtils getTheDefaultAirportByLocationCity:[[PositioningManager shared] positionCurrentCity] andCustomAirports:[TaxiFillManager shareInstance].customAirports];
        self.airport = self.selectedAirport.name;
        self.cityCode = self.selectedAirport.cityCode;
        [TaxiFillManager shareInstance].carUseCity = self.selectedAirport.cityName;
        [_tableView reloadData];
        [self performSelector:@selector(gotoAirportList) withObject:nil afterDelay:0.25];
    }else
    {
        NSArray  *ar = [root objectForKey:@"carTypeList"];
        if ([ar count] > 0) {
            TaxiTypeViewController  *ctrl = [[TaxiTypeViewController  alloc]initWithTitle:@"车型选择" style:NavBarBtnStyleOnlyBackBtn];
            ctrl.totalAr  = ar;
            [self.navigationController  pushViewController:ctrl animated:YES];
            [ctrl  release];
        }else{
            [Utils alert:@"获取到的车型列表为空,请重试!"];
        }
        
    }
}

-(void)gotoAirportList{

    if (goList) {
        AirportListViewController  *airport = [[AirportListViewController alloc] initWithTitle:@"选择机场" style:NavBarBtnStyleOnlyBackBtn];
        airport.dataSource = [TaxiFillManager shareInstance].customAirports;
        airport.delegate = self;
        [self.navigationController pushViewController:airport animated:YES];
        [airport release];
    }
    
}

#pragma mark -
#pragma mark CustomSegmented Delegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index {
    segmentselectedindex = index;
    UILabel *tip = (UILabel *)[[_tableView tableFooterView] viewWithTag:Tip_TAG];
	switch (index) {
		case 0:{
            tip.text = AirPort_Tip;//Flight_Tip;
            if (STRINGHASVALUE(self.selectedAirport.cityCode)) {
                self.cityCode = self.selectedAirport.cityCode;
                [TaxiFillManager shareInstance].carUseCity = self.selectedAirport.cityName;
            }
        }
			break;
		case 1:{
            tip.text = Flight_Tip;
            if (STRINGHASVALUE(self.selectedFlight.destCityCode)) {
                self.cityCode = self.selectedFlight.destCityCode;
                [TaxiFillManager shareInstance].carUseCity = self.selectedFlight.destCity;

            }
        }
			break;
	}
    [_tableView reloadData];
}
#pragma mark
#pragma mark  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_Height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if (indexPath.row == 0) {
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)]];
        }
        if (indexPath.row == 2){
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,Cell_Height-1, SCREEN_WIDTH, 1)]];
        }else{
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(50, Cell_Height-1, SCREEN_WIDTH-50, 1)]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = FONT_17;
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"Rent_Time.png"];
            NSString *string = nil;
            if (self.type == RentCarType_Pick) {
                NSRange range = [self.flightTime rangeOfString:@" "];
                NSString *subString = nil;
                if (range.location != NSNotFound) {
                    subString = [self.flightTime substringToIndex:range.location];
                }else{
                    subString = self.flightTime;
                }
                string = (segmentselectedindex == Seg_Flight)?(subString):self.air_Time;
            }else{
                string = self.air_Time;
            }
            cell.textLabel.text = string;
            cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
            break;
         case 1:
            cell.imageView.image = [UIImage imageNamed:@"Airplane.png"];
            if (self.type == RentCarType_Pick) {
                if (segmentselectedindex == Seg_Flight) {
                    //航班
                    if (!self.flightNum) {
                        cell.textLabel.text = @"请选择航班";
                        cell.textLabel.textColor = RGBCOLOR(153, 153, 153, 1);
                    }else{
                        cell.textLabel.text = self.flightNum;
                        cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                    }
                }else{
                    //机场
                    if (!self.airport) {
                        cell.textLabel.text = @"请选择机场";
                        cell.textLabel.textColor = RGBCOLOR(153, 153, 153, 1);
                    }else{
                        cell.textLabel.text = self.airport;
                        cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                    }
            }
            }else{
                //送机
                if (!self.airport) {
                    cell.textLabel.text = @"请选择机场";
                    cell.textLabel.textColor = RGBCOLOR(153, 153, 153, 1);
                }else{
                    cell.textLabel.text = self.airport;
                    cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                }
            }
            break;
          case 2:
            if (self.type == RentCarType_Pick) {
                cell.imageView.image = [UIImage imageNamed:@"Rent_End.png"];
                if (!STRINGHASVALUE(self.destination.name)) {
                    cell.textLabel.text = @"请选择目的地";
                    cell.textLabel.textColor = RGBCOLOR(153, 153, 153, 1);
                }else{
                    cell.textLabel.text = self.destination.name;
                    cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                }
            }else{
            //送机
                cell.imageView.image = [UIImage imageNamed:@"Rent_Start.png"];
                if (!STRINGHASVALUE(self.startPoint.name)) {
                    cell.textLabel.text = @"请选择出发地";
                    cell.textLabel.textColor = RGBCOLOR(153, 153, 153, 1);
                }else{
                    cell.textLabel.text = self.startPoint.name;
                    cell.textLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                }
            }
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //
        if (self.type == RentCarType_Pick && segmentselectedindex == Seg_Flight) {
            
            NSRange range = [self.flightTime rangeOfString:@" "];
            if (range.location != NSNotFound) {
                NSArray *compents = [self.flightTime componentsSeparatedByString:@" "];
                self.flightTime = [compents objectAtIndex:0];
            }
            NSDate *f_time = [NSDate dateFromString:self.flightTime withFormat:TIME_FORMATTER_Flight];
            ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:f_time checkOut:nil type:UseTaxi];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }else{
            //时间选择
            sheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil,nil];
            CustomPicker *picker = [[CustomPicker  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256) Delegate:self andOriginalDate:[TaxiUtils getDateOfHours:2 MinsByTen:YES]];
            [sheet addSubview:picker];
            [picker release];
            [sheet showInView:self.view];
        }
    }else if (indexPath.row == 1){
        if (self.type == RentCarType_Pick && segmentselectedindex == Seg_Flight) {
            //航班列表
            FlightListViewController *flight = [[FlightListViewController alloc] initWithTitle:@"查看航班" style:NavBarBtnStyleOnlyBackBtn];
            NSRange range = [self.flightTime rangeOfString:@" "];
            if (range.location == NSNotFound) {
                flight.time = self.flightTime;
            }else{
                flight.time = [self.flightTime substringToIndex:range.location];
            }
            
            flight.delegate = self;
            [self.navigationController pushViewController:flight animated:YES];
            [flight release];
        }else{
            //机场列表
            if ((![TaxiFillManager shareInstance].customAirports) || [[TaxiFillManager shareInstance].customAirports count] == 0) {
                goList = YES;
                [self requestTheServiceCoverAndAirportList];
                return;
            }
            AirportListViewController  *airport = [[AirportListViewController alloc] initWithTitle:@"选择机场" style:NavBarBtnStyleOnlyBackBtn];
            airport.dataSource = [TaxiFillManager shareInstance].customAirports;
            airport.delegate = self;
            [self.navigationController pushViewController:airport animated:YES];
            [airport release];
        }
    }else{
        //起始点、目的地
        if (self.type == RentCarType_Pick) {
            //终点
            NSString *city = nil;
            if (segmentselectedindex == Seg_Flight) {
                if (!self.flightNum) {
                    [Utils alert:Tip_NoFlight];
                    return;
                }
                city = self.selectedFlight.destCity;
            }else{
                if (!self.airport) {
                    [Utils alert:Tip_NoAirPort];
                    return;
                }
                city = self.selectedAirport.cityName;
            }

            ChooseDepartVC *choose = [[ChooseDepartVC alloc] initWithTitle:@"目的地" style:NavBarBtnStyleOnlyBackBtn];
            choose.entrance = Entrance_RentCar;
            choose.type = TaxiDepart_end;
            choose.delegate = self;
            choose.searchCity = city;
            choose.needLatAndLongtitude = YES;
            choose.checkSpanCity = YES;
            [self.navigationController pushViewController:choose animated:YES];
            [choose release];
        }else{
            //起点
            if (!self.airport) {
                [Utils alert:Tip_NoAirPort];
                return;
            }
            ChooseDepartVC *choose  = [[ChooseDepartVC alloc] initWithTitle:@"出发地" style:NavBarBtnStyleOnlyBackBtn];
            choose.entrance = Entrance_RentCar;
            choose.checkSpanCity = YES;

            if ([TaxiUtils checkIsSameCity:[[PositioningManager shared] positionCurrentCity] another:self.selectedAirport.cityName]) {
                choose.type = TaxiDepart_start;
            }else{
                choose.type = TaxiDepart_end;
            }
            choose.delegate = self;
            choose.searchCity = self.selectedAirport.cityName;
            choose.needLatAndLongtitude = YES;
            [self.navigationController pushViewController:choose animated:YES];
            [choose release];
        }
    }
}
#pragma mark
#pragma mark  CustomPickerDelegate
-(void)dismissTheActionSheet{
    if (sheet) {
        [sheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)doneTheActionWithResult:(NSString *)string{
    self.air_Time = string;
    [_tableView reloadData];
}
#pragma mark
#pragma mark -----------Call Back Methords-----------
//航班回调
-(void)getTheSelectedAirport:(RentFlight *)flight andFlightNum:(NSString *)flightNo{
    
    self.flightNum = flightNo;
    self.cityCode = flight.destCityCode;
    self.selectedFlight = flight;
    [TaxiFillManager shareInstance].carUseCity = flight.destCity;
    
    //将时分置空
    NSRange range = [self.flightTime rangeOfString:@" "];
    if (range.location != NSNotFound) {
        self.flightTime = [self.flightTime substringToIndex:range.location];
    }
    
    if ([TaxiUtils getFlightTimeFromGivenFlight:flight]) {
        //加一天
        NSLog(@"%@",self.flightTime);
        NSDate *current = [NSDate dateFromString:self.flightTime withFormat:TIME_FORMATTER_Flight];
        NSDate *tomorrow = [NSDate dateWithTimeInterval:24*60*60 sinceDate:current];
        NSString *time = [TimeUtils displayDateWithNSDate:tomorrow formatter:TIME_FORMATTER_Flight];
        self.flightTime = time;
        
        NSRange range = [flight.departTime rangeOfString:@"+"];
        NSString *appeding = [flight.departTime substringToIndex:range.location];
        self.flightTime  = [self.flightTime stringByAppendingFormat:@" %@",appeding];

    }else{
        self.flightTime  = [self.flightTime stringByAppendingFormat:@" %@",flight.departTime];
    }
    [_tableView reloadData];
}
//机场回调
-(void)getTheSelectedCustomAirport:(CustomAirportTerminal *)model{
    self.airport = model.name;
    self.cityCode = model.cityCode;
    self.selectedAirport = model;
    [TaxiFillManager shareInstance].carUseCity = model.cityName;

    if (self.type == RentCarType_Send && (![TaxiUtils checkIsSameCity:[[PositioningManager shared] positionCurrentCity] another:self.selectedAirport.cityName])) {
        self.startPoint = nil;
    }else{
        FastPositioning *fast = [FastPositioning shared];
        if (STRINGHASVALUE(fast.addressName)) {
            AddressInfo *info = [[AddressInfo alloc] init];
            info.name = fast.addressName;
            info.cityName = [[PositioningManager shared] positionCurrentCity];
            self.startPoint = info;
            [info release];
        }
    }

    [_tableView reloadData];
}
//日历回调
-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate{
    if (nil == cinDate) {
        return;
    }else{
        self.flightNum = nil;
        self.flightTime = [TimeUtils displayDateWithNSDate:cinDate formatter:TIME_FORMATTER_Flight];
        [_tableView reloadData];
    }
}
/*
 * 目的地/出发地 CallBack
 */
-(void)getTheSelectedAddressInfo:(AddressInfo *)info andDepartType:(TaxiDepart_Type)type{
    //
    if (nil == info) {
        return;
    }
    
    if (type == TaxiDepart_end) {
        if (self.type == RentCarType_Send) {
            self.startPoint = info;
        }else{
            self.destination = info;
        }
    }else{
        self.startPoint = info;
    }
    [_tableView reloadData];
}
-(void)getTheUserInputAddress:(NSString *)address andDepartType:(TaxiDepart_Type)type{
    self.destination.name = address;
    [_tableView reloadData];
}
@end
