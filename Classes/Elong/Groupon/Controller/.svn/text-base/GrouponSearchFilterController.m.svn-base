//
//  GrouponSearchFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
// 

#import "GrouponSearchFilterController.h"
#import "GListRequest.h"
#import "GListFilterRequest.h"
#import "GListBrandFilterRequest.h"
#import "Utils.h"
#import "ElongURL.h"
#import "GrouponLocationFilterController.h"
#import "GrouponSubwayViewController.h"
#import "GrouponAirportViewController.h"
#import "GrouponBrandFilterViewController.h"

@interface GrouponSearchFilterController ()

@property (nonatomic, retain) HotelPriceFilterController *priceController;
@property (nonatomic, retain) HotelStarFilterController *starController;
@property (nonatomic, retain) GrouponBrandFilterViewController *brandController;
@property (nonatomic, retain) GrouponTypeFilterViewController *typeController;
@property (nonatomic, retain) UINavigationController *locationController;
@property (nonatomic, assign) BOOL errorWhileLoading;

@end

@implementation GrouponSearchFilterController

- (void)dealloc
{
    [_httpUtil cancel];
    [_httpUtil release];
    
    [_brandhttpUtil cancel];
    [_brandhttpUtil release];
    
    [_brandData release];
    [_selectedBrand release];
    
    [_typeData release];
    [_selectedType release];
    
    _priceController.delegate=nil;
    [_priceController release];
    
    _starController.delegate=nil;
    [_starController release];
    
    _brandController.delegate=nil;
    [_brandController release];
    
    _typeController.delegate=nil;
    [_typeController release];
    
    _locationController.delegate=nil;
    [_locationController release];
    
    [_location release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isShowLocation:(BOOL) isShowLocation
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //类型controller
        if (self.typeController==nil) {
            self.typeController = [[[GrouponTypeFilterViewController alloc] initWithFrame:self.selectedContainer.bounds] autorelease];
            self.typeController.delegate = self;
        }
        
        GListRequest *cityListReq = [GListRequest shared];
        
        GListFilterRequest *areaReq = [GListFilterRequest shared];
        NSDictionary *dic = [areaReq getAreaInfoForCity:cityListReq.cityName];
        if (!dic) {
            [areaReq setCurrentCity:cityListReq.cityName];
            self.httpUtil = [[[HttpUtil alloc] init] autorelease];
            [self.httpUtil connectWithURLString:GROUPON_SEARCH
                                        Content:[areaReq grouponFilterAreaRequest]
                                   StartLoading:NO
                                     EndLoading:NO
                                       Delegate:self];
        }
        else
        {
            isBrandDataLoadingOk=NO;
            //处理类型数据
            [self handleTypeData:dic];
        }
        
        //团购品牌数据
        [self getBrandData];
        
        //self.minPrice = [cityListReq getMinPrice];
       // self.maxPrice = [cityListReq getMaxPrice];
        self.starLevel = [cityListReq getStarLevel];
        if (isShowLocation) {
            self.location = cityListReq.location;
        }
        
        self.selectedBrand=cityListReq.brand;
        self.selectedType=cityListReq.typpee;
        
        self.otherLabel.text=@"类型";
        self.brandTab.hidden = NO;
//        self.otherTab.hidden = YES;
        
        if (_minPrice != 0 && _maxPrice == NSUIntegerMax) {
            [self addItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withStartPoint:self.touchPoint withTag:1024];
        }
        else if (_maxPrice != 0 && _maxPrice != NSUIntegerMax) {
            [self addItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withStartPoint:self.touchPoint withTag:1024];
        }
        
        NSArray *starArray = [[[NSArray alloc] initWithObjects:
                               STAR_LIMITED_NONE,
                               STAR_LIMITED_FIVE,
                               STAR_LIMITED_FOUR,
                               STAR_LIMITED_THREE,
                               STAR_LIMITED_OTHER,nil] autorelease];
        NSString *starText = [starArray safeObjectAtIndex:self.starLevel];
        if (self.starLevel != 0) {
            [self addItem:starText withStartPoint:CGPointZero withTag:1025];
        }
        
        if (self.location) {
            if([self.location safeObjectForKey:@"Name"]){
                [self addItem:[self.location safeObjectForKey:@"Name"] withStartPoint:CGPointZero withTag:1026];
            }
        }
        
        if (self.selectedBrand)
        {
            if ([[self.selectedBrand safeObjectForKey:@"BrandId"] intValue]>0)
            {
                [self addItem:[self.selectedBrand safeObjectForKey:@"BrandName"] withStartPoint:CGPointZero withTag:1027];
            }
            else
            {
                self.selectedBrand=nil;
            }
        }
        
        if (self.typeData)
        {
            if ([[self.selectedType safeObjectForKey:@"CategoryId"] intValue]>0)
            {
                [self addItem:[self.selectedType safeObjectForKey:@"CategoryName"] withStartPoint:CGPointZero withTag:1028];
            }
            else
            {
                self.selectedType=nil;
            }
        }
        
        // 隐藏价格
        self.otherTab.frame = self.brandTab.frame;
        self.brandTab.frame = self.locationTab.frame;
        self.locationTab.frame = self.starTab.frame;
        self.starTab.frame = self.priceTab.frame;
        self.priceTab.hidden = YES;
        self.selectedIndex = 1;
        
        //不显示区域的
        if (!isShowLocation) {
            // 隐藏区域
            self.otherTab.frame = self.brandTab.frame;
            self.brandTab.frame = self.locationTab.frame;
            self.locationTab.hidden = YES;
        }
        else
        {
            CGRect locationFrame = self.locationTab.frame;
            self.locationTab.frame = self.starTab.frame;
            self.starTab.frame = locationFrame;
            self.selectedIndex = 2;
        }
        
        [self updateTab];
    }
    return self;
}

//得到团购品牌数据
-(void) getBrandData
{
    if (self.brandController == nil)
    {
        self.brandController = [[[GrouponBrandFilterViewController alloc] initWithFrame:self.selectedContainer.bounds] autorelease];
        self.brandController.delegate = self;
    }
    
    isBrandDataLoadingOk=NO;
    
    GListRequest *cityListReq = [GListRequest shared];
    
    //从缓存中取
    GListBrandFilterRequest *brandReq = [GListBrandFilterRequest shared];
    NSDictionary *dic = [brandReq getBrandInfoForCity:cityListReq.cityName];
    
    if (dic)
    {
        //处理数据
        [self handleBrandData:dic isUpdateCache:NO];
        return;
    }
    
    NSString *cityId=[PublicMethods getCityIDWithCity:cityListReq.cityName];
    
    if (!STRINGHASVALUE(cityId)) {
        return;
    }

    NSDictionary *brandParam=[[NSDictionary alloc] initWithObjectsAndKeys:cityId,@"CityId", nil];
    
    
    NSString *url = [PublicMethods composeNetSearchUrl:@"tuan"
                                            forService:@"getTuanBrand"
                                              andParam:[brandParam JSONString]];
    
    self.brandhttpUtil = [[[HttpUtil alloc] init] autorelease];
    
    [self.brandhttpUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    
    [brandParam release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTab
{
    self.priceButton.selected = NO;
    self.starButton.selected = NO;
    self.locationButton.selected = NO;
    self.brandButton.selected=NO;
    self.otherButton.selected=NO;
    self.priceLabel.highlighted = NO;
    self.starLabel.highlighted = NO;
    self.locationlabel.highlighted = NO;
    self.brandLabel.highlighted=NO;
    self.otherLabel.highlighted=NO;
    
    for (UIView *subView in [self.selectedContainer subviews]) {
        [subView removeFromSuperview];
    }
    
    CGRect newFrame = self.locationNavigationBar.frame;
    newFrame.origin.x = self.view.frame.size.width;
    self.locationNavigationBar.frame = newFrame;
    
    switch (self.selectedIndex) {
        case 0:
            self.priceButton.selected = YES;
            self.priceLabel.highlighted = YES;
        
            if (self.priceController == nil) {
                self.priceController = [[[HotelPriceFilterController alloc] initWithNibName:nil bundle:nil] autorelease];
                self.priceController.priceRangeArray = [NSArray arrayWithObjects:@"价格不限", @"100元以下", @"100元-200元", @"200元-500元", @"500元以上", nil];
                self.priceController.showVipContainer = NO;
                self.priceController.delegate = self;
            }

            if (self.minPrice == 0 && self.maxPrice == NSUIntegerMax) {
                self.priceController.selectedIndex = 0;
            }
            else if (self.maxPrice == 100) {
                self.priceController.selectedIndex = 1;
            }
            else if (self.maxPrice == NSUIntegerMax) {
                self.priceController.selectedIndex = 4;
            }
            else if (self.minPrice == 100) {
                self.priceController.selectedIndex = 2;
            }
            else {
                self.priceController.selectedIndex = 3;
            }
            
            [self.selectedContainer addSubview:self.priceController.view];
            
            self.priceController.view.frame = self.selectedContainer.bounds;
            
            break;
        case 1:
            self.starButton.selected = YES;
            self.starLabel.highlighted = YES;
            if (self.starController == nil) {
                self.starController = [[[HotelStarFilterController alloc] initWithNibName:nil bundle:nil] autorelease];
                self.starController.delegate = self;
            }
            [self.starController setSelectedIndex:_starLevel];
            [self.selectedContainer addSubview:self.starController.view];

            break;
        case 2:
        {
            self.locationButton.selected = YES;
            self.locationlabel.highlighted = YES;
            
            if (self.errorWhileLoading) {
                GrouponLocationFilterController *controller = [[GrouponLocationFilterController alloc] init];
                controller.error = YES;
                self.locationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
                GrouponLocationFilterController *filter = (GrouponLocationFilterController *)[self.locationController.viewControllers objectAtIndex:0];
                filter.location = self.location;
                self.locationController.navigationBarHidden = YES;
                self.locationController.wantsFullScreenLayout = YES;
                self.locationController.delegate = self;
                [controller release];
            }
            else if (self.locationController == nil) {
                GrouponLocationFilterController *controller = [[GrouponLocationFilterController alloc] init];
                self.locationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
                //传递已经选中的选项
                controller.location = self.location;
                
                GListRequest *cityListReq = [GListRequest shared];
                
                GListFilterRequest *areaReq = [GListFilterRequest shared];
                NSDictionary *dic = [areaReq getAreaInfoForCity:cityListReq.cityName];
                
                NSArray *districtList = [[NSArray alloc] initWithArray:[dic safeObjectForKey:DISTRICTLIST_RESP]];
                
                // 行政区
                controller.districtArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in districtList) {
                    
                    if (!DICTIONARYHASVALUE(dict)) {
                        continue;
                    }
                    
                    [controller.districtArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[dict safeObjectForKey:@"DistrictID"],[dict safeObjectForKey:@"DistrictName"],[dict safeObjectForKey:@"GrouponCnt"], nil]
                                                                                     forKeys:[NSArray arrayWithObjects:@"DistrictID",@"ItemName",@"GrouponCnt", nil]]];
                }
                
                // 商圈
                controller.businessDistrictArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in districtList) {
                    if (0 == [[dict safeObjectForKey:DISTRICTID_RESP] intValue]){
                        for (NSDictionary *tdict in [dict safeObjectForKey:BIZSECTIONLIST_RESP]) {
                            NSString *count = [tdict safeObjectForKey:@"GrouponCnt"];
                            if (count == nil) {
                                count = [NSString stringWithFormat:@"%d", 0];
                            }
                            if (!DICTIONARYHASVALUE(tdict)) {
                                continue;
                            }
                            
                            [controller.businessDistrictArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[tdict safeObjectForKey:@"BizSectionID"],[tdict safeObjectForKey:@"BizSectionName"],[tdict safeObjectForKey:@"DistrictID"], count, nil]
                                                                                                     forKeys:[NSArray arrayWithObjects:@"BizSectionID",@"ItemName",@"DistrictID",@"GrouponCnt", nil]]];
                        }
                    }
                }
                NSString *count = [[controller.districtArray safeObjectAtIndex:0] safeObjectForKey:@"GrouponCnt"];
                if (count != nil) {
                    [controller.businessDistrictArray insertObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",@"全部",@"0", count, nil]
                                                                                                      forKeys:[NSArray arrayWithObjects:@"BizSectionID",@"ItemName",@"DistrictID",@"GrouponCnt", nil]] atIndex:0];
                }
                [districtList release];
                
                // 地铁
                NSArray *subwayStations;
                if ([dic safeObjectForKey:@"SubwayStations"] == [NSNull null]) {
                    subwayStations = nil;
                }else{
                    subwayStations = [NSArray arrayWithArray:[dic safeObjectForKey:@"SubwayStations"]];
                }
                controller.stations = subwayStations;
                controller.subwayArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in subwayStations) {
                    BOOL exist = NO;
                    for (NSDictionary *tdict in controller.subwayArray) {
                        if ([[tdict safeObjectForKey:@"LineName"] isEqualToString:[dict safeObjectForKey:@"LineName"]]) {
                            exist = YES;
                            break;
                        }
                    }
                    
                    if (exist) {
                        continue;
                    }
                    
                    [controller.subwayArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[dict safeObjectForKey:@"LineName"], nil]
                                                                                   forKeys:[NSArray arrayWithObjects:@"LineName",nil]]];
                }
                
                // 机场、火车站
                NSArray *airportRailways;
                if ([dic safeObjectForKey:@"AirportRailways"] == [NSNull null]) {
                    airportRailways = nil;
                }else{
                    airportRailways = [NSArray arrayWithArray:[dic safeObjectForKey:@"AirportRailways"]];
                }
                controller.airports = airportRailways; // 机场火车站数组
                self.locationController.navigationBarHidden = YES;
                self.locationController.wantsFullScreenLayout = YES;
                self.locationController.delegate = self;
                [controller release];
            }
            else if (self.locationController)
            {
                GrouponLocationFilterController *filter = (GrouponLocationFilterController *)[self.locationController.viewControllers safeObjectAtIndex:0];
                filter.location=self.location;
                
                //刷新子页面
                if (self.locationController.viewControllers.count>1)
                {
                    id curVc=[self.locationController.viewControllers safeObjectAtIndex:1];
                    
                    if ([curVc isMemberOfClass:[GrouponDistrictViewController class]])
                    {
                        GrouponDistrictViewController *distinctVC = (GrouponDistrictViewController *)[self.locationController.viewControllers safeObjectAtIndex:1];
                        if (distinctVC)
                        {
                            distinctVC.item = [self.location safeObjectForKey:@"Name"];
                            [distinctVC reloadData];
                        }
                    }
                    else if ([curVc isMemberOfClass:[GrouponSubwayViewController class]])
                    {
                        GrouponSubwayViewController *subwayVC = (GrouponSubwayViewController *)[self.locationController.viewControllers safeObjectAtIndex:1];
                        if (subwayVC)
                        {
                            subwayVC.item = [self.location safeObjectForKey:@"Name"];
                            [subwayVC reloadData];
                        }
                    }
                    else if ([curVc isMemberOfClass:[GrouponAirportDetailViewController class]])
                    {
                        GrouponAirportDetailViewController *airportVC = (GrouponAirportDetailViewController *)[self.locationController.viewControllers safeObjectAtIndex:1];
                        if (airportVC)
                        {
                            airportVC.item = [self.location safeObjectForKey:@"Name"];
                            [airportVC reloadData];
                        }
                    }
                }
            }
            
            
            [self.selectedContainer addSubview:self.locationController.view];
            self.locationController.view.frame = self.selectedContainer.bounds;
            
            if (self.locationController.viewControllers.count > 1) {
                CGRect newFrame = self.locationNavigationBar.frame;
                newFrame.origin.x = 60;
                self.locationNavigationBar.frame = newFrame;
            }
            else {
                CGRect newFrame = self.locationNavigationBar.frame;
                newFrame.origin.x = self.view.frame.size.width;
                self.locationNavigationBar.frame = newFrame;
            }
        }
            break;
        //品牌
        case 3:
        {
            self.brandButton.selected = YES;
            self.brandLabel.highlighted = YES;
            if (self.brandController == nil)
            {
                self.brandController = [[[GrouponBrandFilterViewController alloc] initWithFrame:self.selectedContainer.bounds] autorelease];
                self.brandController.delegate = self;
            }
            else
            {
                [self.brandController resizeWithFrame:self.selectedContainer.bounds];
            }
            
            //数据没有取到呢 loading.......
            if (isBrandDataLoadingOk==NO)
            {
                [self.brandController startLoadingView];
            }
            else
            {
                if (self.selectedBrand)
                {
                    [self.brandController selectItem:self.selectedBrand];
                }
                else
                {
                    [self.brandController selectIndex:0];
                }
            }

            [self.selectedContainer addSubview:self.brandController.view];
            break;
        }
        //分类
        case 4:
        {
            self.otherButton.selected = YES;
            self.otherLabel.highlighted = YES;
            
            [self.typeController resizeWithFrame:self.selectedContainer.bounds];
            
            //数据没有取到呢 loading.......
            if (isTypeDataLoadingOk==NO)
            {
                [self.typeController startLoadingView];
            }
            else
            {
                if (self.selectedType)
                {
                    [self.typeController selectItem:self.selectedType];
                }
                else
                {
                    [self.typeController selectIndex:0];
                }
            }
            
            [self.selectedContainer addSubview:self.typeController.view];

            break;
        }
        default:
            break;
    }
    
    [self.locationNavigationBar.superview bringSubviewToFront:self.locationNavigationBar];
}

- (void)itemWithTagTapped:(NSUInteger)tag
{
    switch (tag) {
        case 1024: // price
            self.minPrice = 0;
            self.maxPrice = NSUIntegerMax;
            break;
        case 1025: // star
            self.starLevel = 0;
            break;
        case 1026: // location
            self.location = nil;
            break;
        case 1027:  //brand
            self.selectedBrand=nil;
            break;
        case 1028:
            self.selectedType=nil;
            break;
        default:
            break;
    }
}

- (void)reset
{
    self.minPrice = 0;
    self.maxPrice = NSUIntegerMax;
    self.starLevel = 0;
    self.location = nil;
    self.selectedBrand=nil;
    self.selectedType=nil;
}

- (void)tabTappedAtIndex:(NSUInteger)index
{
    if (index == self.selectedIndex && self.selectedIndex == 2) {
        [self.locationController popToRootViewControllerAnimated:YES];
    }
    
    [super tabTappedAtIndex:index];
}

- (void)confirm
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:[NSNumber numberWithInt:_starLevel] forKey:@"StarLevel"];
//    [info setValue:[NSNumber numberWithInt:_minPrice] forKey:@"MinPrice"];
//    [info setValue:[NSNumber numberWithInt:_maxPrice] forKey:@"MaxPrice"];
    [info setValue:self.location forKey:@"Location"];
    
    GListRequest *cityListReq = [GListRequest shared];
    cityListReq.location = self.location;
    cityListReq.brand=self.selectedBrand;
    cityListReq.typpee=self.selectedType;
    
    if (UMENG) {
        // 星级
        if (_starLevel != 0) {
            [MobClick event:Event_GrouponHotelFilter_Star];
        }
        // 区域
        if (self.location) {
            [MobClick event:Event_GrouponHotelFilter_Location];
        }
        
        // 品牌
        if (self.selectedBrand) {
            [MobClick event:Event_GrouponHotelFilter_Brand];
        }
        
        // 筛选
        [MobClick event:Event_GrouponHotelFilter_Confirm];
    }

    
    [self.filterDelegate searchFilterController:self didFinishedWithInfo:info];
}

- (IBAction)locationBack:(id)sender
{
    [self.locationController popViewControllerAnimated:YES];
}

#pragma mark - HttpDelegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util!=self.brandhttpUtil)
    {
        self.errorWhileLoading = YES;
        if (self.selectedIndex == 2) {
            [self.locationController.view removeFromSuperview];
            self.locationController = nil;
            [self updateTab];
        }
        
        //结束loading
        [self.typeController endLoadingView];
        //显示错误页面
        [self.typeController setFailViewUI:NO showTxt:@"加载失败"];
        //数据去回来了
        isTypeDataLoadingOk=YES;
    }
    else if (util==self.brandhttpUtil)
    {
        //结束loading
        [self.brandController endLoadingView];
        //显示错误页面
        [self.brandController setFailViewUI:NO showTxt:@"加载失败"];
        //数据去回来了
        isBrandDataLoadingOk=YES;
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    //品牌数据
    if (util==self.brandhttpUtil)
    {
        [self handleBrandData:root isUpdateCache:YES];
    }
    else
    {
        GListRequest *cityListReq = [GListRequest shared];
        GListFilterRequest *areaReq = [GListFilterRequest shared];
        [areaReq setAreaInfo:root forCity:cityListReq.cityName];
        
        if (self.selectedIndex == 2) {
            [self.locationController.view removeFromSuperview];
            self.locationController = nil;
            [self updateTab];
        }
        
        //处理类型数据
        [self handleTypeData:root];
    }
}

//处理类型数据
-(void) handleTypeData:(NSDictionary *) root
{
    //数据去回来了
    isTypeDataLoadingOk=YES;
    //结束loading
    [self.typeController endLoadingView];
    
    if (ARRAYHASVALUE([root safeObjectForKey:@"Categories"]))
    {
        self.typeData=[NSMutableArray arrayWithArray:[root safeObjectForKey:@"Categories"]];
        [self.typeData insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"CategoryId",@"类型不限",@"CategoryName",nil] atIndex:0];
        
        [self.typeController fillData:self.typeData];
        [self.typeController setFailViewUI:YES showTxt:@"加载失败"];
    }
    else
    {
        [self.typeController setFailViewUI:NO showTxt:@"暂无数据"];
    }
    
    if (self.selectedType)
    {
        [self.typeController selectItem:self.selectedType];
    }
    else
    {
        [self.typeController selectIndex:0];
    }
}

//处理品牌数据
-(void) handleBrandData:(NSDictionary *) root isUpdateCache:(BOOL) isUpdateCache
{
    //数据去回来了
    isBrandDataLoadingOk=YES;
    //结束loading
    [self.brandController endLoadingView];
    
    if (ARRAYHASVALUE([root safeObjectForKey:@"TuanBrands"]))
    {
        self.brandData=[NSMutableArray arrayWithArray:[root safeObjectForKey:@"TuanBrands"]];
        [self.brandData insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"BrandId",@"品牌不限",@"BrandName",nil] atIndex:0];
        
        [self.brandController fillData:self.brandData];
        [self.brandController setFailViewUI:YES showTxt:@"加载失败"];
        
        //存到缓存
        if (isUpdateCache)
        {
            GListRequest *cityListReq = [GListRequest shared];
            GListBrandFilterRequest *brandReq = [GListBrandFilterRequest shared];
            [brandReq setBrandInfo:root forCity:cityListReq.cityName];
        }
    }
    else
    {
        [self.brandController setFailViewUI:NO showTxt:@"暂无数据"];
    }
    
    if (self.selectedBrand)
    {
        [self.brandController selectItem:self.selectedBrand];
    }
    else
    {
        [self.brandController selectIndex:0];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(viewController)];
    if ([className isEqual:@"GrouponDistrictViewController"]) {
        GrouponDistrictViewController *controller = (GrouponDistrictViewController *)viewController;
        controller.distictList.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else if ([className isEqual:@"GrouponSubwayViewController"]) {
        GrouponSubwayViewController *controller = (GrouponSubwayViewController *)viewController;
        controller.subwayList.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else if ([className isEqual:@"GrouponAirportViewController"]) {
        GrouponAirportViewController *controller = (GrouponAirportViewController *)viewController;
        controller.airportList.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else if ([className isEqual:@"GrouponSubwayDetailViewController"]) {
        GrouponSubwayDetailViewController *controller = (GrouponSubwayDetailViewController *)viewController;
        controller.subwayList.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else if ([className isEqual:@"GrouponAirportDetailViewController"]) {
        GrouponAirportDetailViewController *controller = (GrouponAirportDetailViewController *)viewController;
        controller.airportList.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else {
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x = self.view.frame.size.width;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{}

- (void)hotelPriceFilterController:(HotelPriceFilterController *)priceFilter didSelectIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            self.minPrice = 0;
            self.maxPrice = NSUIntegerMax;
            break;
        case 1:
            self.minPrice = 0;
            self.maxPrice = 100;
            break;
        case 2:
            self.minPrice = 100;
            self.maxPrice = 200;
            break;
        case 3:
            self.minPrice = 200;
            self.maxPrice = 500;
            break;
        case 4:
            self.minPrice = 500;
            self.maxPrice = NSUIntegerMax;
            break;
        default:
            break;
    }
    
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1024];
    if (self.minPrice == 0 && self.maxPrice == NSUIntegerMax) {
        if (button) {
            [self deleteItem:1024];
        }
    }
    else {
        if (button) {
            if (self.maxPrice == NSUIntegerMax) {
                [self updateItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withTag:1024];
            }
            else {
                [self updateItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withTag:1024];
            }
        }
        else {
            if (self.maxPrice == NSUIntegerMax) {
                [self addItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withStartPoint:self.touchPoint withTag:1024];
            }
            else {
                [self addItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withStartPoint:self.touchPoint withTag:1024];
            }
        }
    }
}

- (void)grouponPriceFilter:(GrouponPriceFilterController *)fitelr priceRangeChangedWithMinPrice:(NSUInteger)minPrice withMaxPrice:(NSUInteger)maxPrice
{
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1024];
    
    if (minPrice == 0 && maxPrice == NSUIntegerMax) {
        if (button) {
            [self deleteItem:1024];
        }
    }
    else {
        if (button) {
            if (maxPrice == NSUIntegerMax) {
                [self updateItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withTag:1024];
            }
            else {
                [self updateItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withTag:1024];
            }
        }
        else {
            if (maxPrice == NSUIntegerMax) {
                [self addItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withStartPoint:self.touchPoint withTag:1024];
            }
            else {
                [self addItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withStartPoint:self.touchPoint withTag:1024];
            }
        }
    }
}

- (void)hotelStarFilterController:(HotelStarFilterController *)starFilter didSelectIndex:(NSUInteger)index
{
    _starLevel = index;
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1025];
    if (_starLevel != 0) {
        if (button != nil) {
            [self updateItem:[starFilter.starArray safeObjectAtIndex:index] withTag:1025];
        }
        else {
            [self addItem:[starFilter.starArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:1025];
        }
    }
    else {
        [self deleteItem:1025];
    }
}

#pragma mark - GrouponBrandFilterDelegate
- (void) grouponBrandFilterController:(GrouponBrandFilterViewController *) filter index:(int)index
{
    self.selectedBrand=[self.brandData safeObjectAtIndex:index];
    
    if (self.selectedBrand==nil) {
        return;
    }
    
    int curBrandId=[[self.selectedBrand safeObjectForKey:@"BrandId"] intValue];
    
    //品牌不限
    if (curBrandId==-1)
    {
       [self deleteItem:1027];
    }
    
    NSString *brandName = [self.selectedBrand safeObjectForKey:@"BrandName"];
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1027];
    if (button != nil)
    {
        [self updateItem:brandName withTag:1027];
    }
    else
    {
        [self addItem:brandName withStartPoint:self.touchPoint withTag:1027];
    }
}

-(void) grouponTypeFilterController:(GrouponTypeFilterViewController *)filter index:(int)index
{
    self.selectedType=[self.typeData safeObjectAtIndex:index];
    
    if (self.selectedType==nil) {
        return;
    }
    
    int curTypeId=[[self.selectedType safeObjectForKey:@"CategoryId"] intValue];
    
    //品牌不限
    if (curTypeId==-1)
    {
        [self deleteItem:1028];
    }
    
    NSString *categoryName = [self.selectedType safeObjectForKey:@"CategoryName"];
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1028];
    if (button != nil)
    {
        [self updateItem:categoryName withTag:1028];
    }
    else
    {
        [self addItem:categoryName withStartPoint:self.touchPoint withTag:1028];
    }
}

- (void)grouponDistrictVC:(GrouponDistrictViewController *)grouponDistrictVC didSelectedAtIndex:(NSInteger)index;
{
    if (index != 0) {
        if (grouponDistrictVC.type == 0) {
            // 商圈
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            [info setValue:[[grouponDistrictVC.dataArray objectAtIndex:index] valueForKey:@"ItemName"] forKey:@"Name"];
            [info setValue:[[grouponDistrictVC.dataArray objectAtIndex:index] valueForKey:@"BizSectionID"] forKey:@"BusinessAreaId"];
            self.location = info;
        }
        else {
            // 行政区
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            [info setValue:[[grouponDistrictVC.dataArray objectAtIndex:index] valueForKey:@"ItemName"] forKey:@"Name"];
            [info setValue:[[grouponDistrictVC.dataArray objectAtIndex:index] valueForKey:@"DistrictID"] forKey:@"DistrictId"];
            self.location = info;
        }
        
        UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1026];
        if (button != nil) {
            [self updateItem:[self.location safeObjectForKey:@"Name"] withTag:1026];
        }
        else {
            [self addItem:[self.location safeObjectForKey:@"Name"] withStartPoint:self.touchPoint withTag:1026];
        }

    }
    else {
        UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1026];
        if (button != nil) {
            [self deleteItem:1026];
            self.location=nil;
        }
    }
    
    if (self.locationController)
    {
        GrouponLocationFilterController *filter = (GrouponLocationFilterController *)[self.locationController.viewControllers safeObjectAtIndex:0];
        filter.location=self.location;
    }
    
    [self.locationController popToRootViewControllerAnimated:YES];
}

- (void)grouponSubwayDetailVC:(GrouponSubwayDetailViewController *)grouponSubwayDetailVC didSelectedAtIndex:(NSInteger)index;
{
    // 地铁
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:[[grouponSubwayDetailVC.dataArray objectAtIndex:index] valueForKey:@"StationName"] forKey:@"Name"];
    [info setValue:[[grouponSubwayDetailVC.dataArray objectAtIndex:index] valueForKey:@"Lat"] forKey:@"Lat"];
    [info setValue:[[grouponSubwayDetailVC.dataArray objectAtIndex:index] valueForKey:@"Lng"] forKey:@"Lng"];
    self.location = info;
    
    if (self.locationController)
    {
        GrouponLocationFilterController *filter = (GrouponLocationFilterController *)[self.locationController.viewControllers safeObjectAtIndex:0];
        filter.location=self.location;
    }
    
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1026];
    if (button != nil) {
        [self updateItem:[self.location safeObjectForKey:@"Name"] withTag:1026];
    }
    else {
        [self addItem:[self.location safeObjectForKey:@"Name"] withStartPoint:self.touchPoint withTag:1026];
    }
    
    [self.locationController popToRootViewControllerAnimated:YES];
}

- (void)grouponAirportDetailVC:(GrouponAirportDetailViewController *)grouponAirportDetailVC didSelectedAtIndex:(NSInteger)index;
{
    // 机场 or 火车站
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:[[grouponAirportDetailVC.dataArray objectAtIndex:index] valueForKey:@"Name"] forKey:@"Name"];
    [info setValue:[[grouponAirportDetailVC.dataArray objectAtIndex:index] valueForKey:@"Lat"] forKey:@"Lat"];
    [info setValue:[[grouponAirportDetailVC.dataArray objectAtIndex:index] valueForKey:@"Lng"] forKey:@"Lng"];
    self.location = info;
    
    if (self.locationController)
    {
        GrouponLocationFilterController *filter = (GrouponLocationFilterController *)[self.locationController.viewControllers safeObjectAtIndex:0];
        filter.location=self.location;
    }
    
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:1026];
    if (button != nil) {
        [self updateItem:[self.location safeObjectForKey:@"Name"] withTag:1026];
    }
    else {
        [self addItem:[self.location safeObjectForKey:@"Name"] withStartPoint:self.touchPoint withTag:1026];
    }
    
    [self.locationController popToRootViewControllerAnimated:YES];
}

@end
