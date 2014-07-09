//
//  InterHotelSearchFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelSearchFilterController.h"
#import "InterHotelLocationRequest.h"
#import "ElongURL.h"
#import "InterHotelLocationCatalogFilterController.h"
#import "InterHotelLocationDataFilterController.h"
#import "InterHotelSearcher.h"

@interface InterHotelSearchFilterController ()

@property (nonatomic, retain) InterHotelPriceStarFilterController *priceStarController;
@property (nonatomic, retain) UINavigationController *locationController;

@property (nonatomic, retain) HttpUtil *httpUtil;

@end

@implementation InterHotelSearchFilterController

- (void)dealloc
{
    [_locationInfo release];
    [_keyword release];
    [_priceStarController release];
    [_locationController release];
    [_httpUtil cancel];
    [_httpUtil release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil minPrice:(NSUInteger) minPrice_ maxPrice:(NSUInteger) maxPrice_ starLevel:(NSUInteger) starLevel_ locationInfo:(NSDictionary *)locationInfo_ keyword:(NSString *)keyword_
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.minPrice = minPrice_;
        self.maxPrice = maxPrice_;
        self.starLevel = starLevel_;
        self.locationInfo = locationInfo_;
        self.keyword = keyword_;
        
        
        CGRect frame = self.priceTab.frame;
        frame.size.height = 100;
        self.priceTab.frame = frame;
        
        frame = self.starTab.frame;
        frame.size.height = 100;
        frame.origin.y = 100;
        self.starTab.frame = frame;
        
        self.tabHeight = 100;
        
        self.brandTab.hidden = YES;
        self.locationTab.hidden = YES;
        self.otherTab.hidden = YES;
        
        [self.starButton setImage:[UIImage noCacheImageNamed:@"filterPoi.png"] forState:UIControlStateNormal];
        [self.starButton setImage:[UIImage noCacheImageNamed:@"filterPoi_Press.png"] forState:UIControlStateHighlighted];
        [self.starButton setImage:[UIImage noCacheImageNamed:@"filterPoi_Press.png"] forState:UIControlStateSelected];
        self.starLabel.text = @"区域";
        
        self.priceLabel.numberOfLines = 0;
        self.priceLabel.frame = CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height * 2);
        self.priceLabel.text = @"价格\n星级";
        
        if (_minPrice != 0 && _maxPrice == NSUIntegerMax) {
            [self addItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterPrice];
        }
        else if (_maxPrice != 0&&_maxPrice != NSUIntegerMax) {
            [self addItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterPrice];
        }
        
        if (_starLevel != 0) {
            NSArray *starArray = [[[NSArray alloc] initWithObjects:
                                   STAR_LIMITED_NONE,
                                   STAR_LIMITED_OTHER,
                                   STAR_LIMITED_THREE,
                                   STAR_LIMITED_FOUR,
                                   STAR_LIMITED_FIVE,
                                   nil] autorelease];
            [self addItem:[starArray safeObjectAtIndex:self.starLevel] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterStar];
        }
        
        if (_locationInfo != nil) {
            [self addItem:[_locationInfo safeObjectForKey:@"LandMarkNameEn"] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterLocation];
        }
        
        if (self.keyword != nil && self.keyword.length > 0) {
            [self addItem:self.keyword withStartPoint:self.touchPoint withTag:InterHotelSearchFilterOther];
        }
        
        [self updateTab];
        
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
        InterHotelLocationRequest *locationRequest = [InterHotelLocationRequest shared];
        locationRequest.cityName = searcher.cityNameEn;
        locationRequest.countryCode = searcher.countryId;
        
        if (_httpUtil) {
            [_httpUtil cancel];
            SFRelease(_httpUtil);
        }
        
        _httpUtil = [[HttpUtil alloc] init];
        [_httpUtil sendAsynchronousRequest:INTER_SEARCH PostContent:[locationRequest request] CachePolicy:CachePolicyHotelArea Delegate:self];
        
    }
    return self;
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

- (void)tabTappedAtIndex:(NSUInteger)index
{
    if (index == 1 && index == self.selectedIndex) {
        [self.locationController popToRootViewControllerAnimated:YES];
    }
    [super tabTappedAtIndex:index];
}

- (void)updateTab
{
    self.priceButton.selected = NO;
    self.starButton.selected = NO;
    self.locationButton.selected = NO;
    self.brandButton.selected = NO;
    self.priceLabel.highlighted = NO;
    self.starLabel.highlighted = NO;
    self.locationlabel.highlighted = NO;
    self.brandLabel.highlighted = NO;
    
    for (UIView *subView in [self.selectedContainer subviews]) {
        [subView removeFromSuperview];
    }
    
    CGRect newFrame = self.locationNavigationBar.frame;
    if (self.selectedIndex == 0) {
        newFrame.origin.x = self.view.frame.size.width;
    }
    else if (self.locationController.viewControllers.count == 1) {
        newFrame.origin.x = self.view.frame.size.width;
    }
    else {
        newFrame.origin.x = 60;
    }
    self.locationNavigationBar.frame = newFrame;
    
    switch (self.selectedIndex) {
        case 0:
            self.priceButton.selected = YES;
            self.priceLabel.highlighted = YES;
            if (self.priceStarController == nil) {
                self.priceStarController = [[[InterHotelPriceStarFilterController alloc] initWithNibName:nil bundle:nil] autorelease];
                self.priceStarController.delegate = self;
            }
            
            self.priceStarController.minPrice = self.minPrice;
            self.priceStarController.maxPrice = self.maxPrice;
            self.priceStarController.starLevle = self.starLevel;
            [self.selectedContainer addSubview:self.priceStarController.view];
            self.priceStarController.view.frame = self.selectedContainer.bounds;
            break;
        case 1:
        {
            self.starButton.selected = YES;
            self.starLabel.highlighted = YES;
            InterHotelLocationRequest *locationRequest = [InterHotelLocationRequest shared];
            if (self.locationController == nil) {
                InterHotelLocationCatalogFilterController *locationFilter = [[[InterHotelLocationCatalogFilterController alloc] init] autorelease];
                locationFilter.catalogList = locationRequest.locationList;
                self.locationController = [[[UINavigationController alloc] initWithRootViewController:locationFilter] autorelease];
                self.locationController.navigationBarHidden = YES;
                self.locationController.wantsFullScreenLayout = YES;
                self.locationController.delegate = self;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            }
            
            for (UIViewController *controller in self.locationController.viewControllers) {
                if ([controller isKindOfClass:[InterHotelLocationDataFilterController class]]) {
                    InterHotelLocationDataFilterController *dataFilter = (InterHotelLocationDataFilterController *)controller;
                    dataFilter.selectedData = self.locationInfo;
                }
                else {
                    InterHotelLocationCatalogFilterController *filter = (InterHotelLocationCatalogFilterController *)controller;
                    filter.selectedData = self.locationInfo;
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
        default:
            break;
    }
    
    [self.locationNavigationBar.superview bringSubviewToFront:self.locationNavigationBar];
}

- (void)itemWithTagTapped:(NSUInteger)tag
{
    switch (tag) {
        case InterHotelSearchFilterPrice:
            self.minPrice = 0;
            self.maxPrice = NSUIntegerMax;
            break;
        case InterHotelSearchFilterStar:
            self.starLevel = 0;
            break;
        case InterHotelSearchFilterLocation:
            self.locationInfo = nil;
            [self updateTab];
            break;
        case InterHotelSearchFilterOther:
            self.keyword = nil;
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
    self.locationInfo = nil;
    self.keyword = nil;
    
    [self updateTab];
}

- (IBAction)confirm:(id)sender
{
    if (self.minPrice > self.maxPrice) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最低价格大于最高价格，无法完成搜索。"
														message:nil
													   delegate:self
											  cancelButtonTitle:@"确认"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    else {
        NSMutableDictionary *filterInfo = [NSMutableDictionary dictionary];
        [filterInfo setValue:[NSNumber numberWithInt:self.minPrice] forKey:@"MinPrice"];
        [filterInfo setValue:[NSNumber numberWithInt:self.maxPrice] forKey:@"MaxPrice"];
        [filterInfo setValue:[NSNumber numberWithInt:self.starLevel] forKey:@"StarLevel"];
        [filterInfo setValue:self.locationInfo forKey:@"Location"];
        [filterInfo setValue:self.keyword forKey:@"Keyword"];
        [self.filterDelegate searchFilterController:self didFinishedWithInfo:filterInfo];
        
        
        if (UMENG) {
            if (self.starLevel != 0) {
                // 国际酒店选择星级筛选
                [MobClick event:Event_InterHotelFilter_Star];
            }
            if (self.locationInfo) {
                // 国际酒店选择区域搜索筛选
                [MobClick event:Event_InterHotelFilter_Location];
            }
           
            // 国际酒店筛选页点击确定
            [MobClick event:Event_InterHotelFilter_Confirm];
        }
        
    }
}

- (IBAction)locationBack:(id)sender
{
    [self.locationController popViewControllerAnimated:YES];
}

#pragma mark InterHotelLocationDataFilterDelegate

- (void)InterHotelLocationDataFilter:(InterHotelLocationDataFilterController *)filter didSelectData:(NSDictionary *)data
{
    self.locationInfo = data;
    
    for (UIViewController *controller in self.locationController.viewControllers) {
        if ([controller isKindOfClass:[InterHotelLocationDataFilterController class]]) {
            InterHotelLocationDataFilterController *dataFilter = (InterHotelLocationDataFilterController *)controller;
            dataFilter.selectedData = self.locationInfo;
        }
        else {
            InterHotelLocationCatalogFilterController *filter = (InterHotelLocationCatalogFilterController *)controller;
            filter.selectedData = self.locationInfo;
        }
    }
    
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:InterHotelSearchFilterLocation];
    if (button) {
        [self updateItem:[data safeObjectForKey:@"LandMarkNameEn"] withTag:InterHotelSearchFilterLocation];
    }
    else {
        [self addItem:[data safeObjectForKey:@"LandMarkNameEn"] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterLocation];
    }
}

#pragma mark InterHotelLocationFilterDelegate

- (void)interHotelLocationFilter:(InterHotelLocationFilterController *)filter didSelectLocation:(NSDictionary *)location
{
    self.locationInfo = location;
    
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:InterHotelSearchFilterLocation];
    if (button) {
        [self updateItem:[location safeObjectForKey:@"EnName"] withTag:InterHotelSearchFilterLocation];
    }
    else {
        [self addItem:[location safeObjectForKey:@"EnName"] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterLocation];
    }
}

#pragma mark InterHotelPriceStarFilterDelegate

- (void)interHotelPriceStarFilter:(InterHotelPriceStarFilterController *)fitelr priceRangeChangedWithMinPrice:(NSUInteger)minPrice withMaxPrice:(NSUInteger)maxPrice
{
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:InterHotelSearchFilterPrice];
    
    if (minPrice == 0 && maxPrice == NSUIntegerMax) {
        if (button) {
            [self deleteItem:InterHotelSearchFilterPrice];
        }
    }
    else {
        if (button) {
            if (maxPrice == NSUIntegerMax) {
                [self updateItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withTag:InterHotelSearchFilterPrice];
            }
            else {
                [self updateItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withTag:InterHotelSearchFilterPrice];
            }
        }
        else {
            if (maxPrice == NSUIntegerMax) {
                [self addItem:[NSString stringWithFormat:@"大于%d", self.minPrice] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterPrice];
            }
            else {
                [self addItem:[NSString stringWithFormat:@"%d-%d", self.minPrice, self.maxPrice] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterPrice];
            }
        }
    }
}

- (void)interHotelPriceStarFilter:(InterHotelPriceStarFilterController *)fitelr starLevelChanged:(NSUInteger)starLevel
{
    self.starLevel = starLevel;
    NSArray *starArray = [[[NSArray alloc] initWithObjects:
                           STAR_LIMITED_NONE,
                           STAR_LIMITED_OTHER,
                           STAR_LIMITED_THREE,
                           STAR_LIMITED_FOUR,
                           STAR_LIMITED_FIVE,
                           nil] autorelease];
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:InterHotelSearchFilterStar];
    if (starLevel != 0) {
        if (button) {
            [self updateItem:[starArray safeObjectAtIndex:self.starLevel] withTag:InterHotelSearchFilterStar];
        }
        else {
            [self addItem:[starArray safeObjectAtIndex:self.starLevel] withStartPoint:self.touchPoint withTag:InterHotelSearchFilterStar];
        }
    }
    else {
        if (button) {
            [self deleteItem:InterHotelSearchFilterStar];
        }
    }
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count > 1) {
        if ([viewController isKindOfClass:[InterHotelLocationCatalogFilterController class]]) {
            InterHotelLocationCatalogFilterController *controller = (InterHotelLocationCatalogFilterController *)viewController;
            controller.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            self.locationNavigationLabel.text = controller.locationTitle;
        }
        else {
            InterHotelLocationDataFilterController *controller = (InterHotelLocationDataFilterController *)viewController;
            controller.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            self.locationNavigationLabel.text = controller.locationTitle;
        }
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x= 60;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
    else {
        InterHotelLocationCatalogFilterController *controller = (InterHotelLocationCatalogFilterController *)viewController;
        controller.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [UIView animateWithDuration:0.35 animations:^(void){
            CGRect newFrame = self.locationNavigationBar.frame;
            newFrame.origin.x = self.view.frame.size.width;
            self.locationNavigationBar.frame = newFrame;
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *dic = [PublicMethods unCompressData:responseData];
	
	if (![Utils checkJsonIsErrorNoAlert:dic]) {
        InterHotelLocationRequest *locationRequest = [InterHotelLocationRequest shared];
        locationRequest.locationList = [dic safeObjectForKey:@"LandMarkTypeInfo"];
        
        if (self.locationController.viewControllers.count > 0) {
            InterHotelLocationCatalogFilterController *controller = (InterHotelLocationCatalogFilterController *)[[self.locationController viewControllers] safeObjectAtIndex:0];
            [controller setCatalogList:locationRequest.locationList];
        }
	}
}

@end
