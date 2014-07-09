    //
//  HotelSearchConditionViewCtrontroller.m
//  ElongClient
//
//  Created by haibo on 11-12-29.
//  Copyright 2011 elong. All rights reserved.
//

#import "HotelSearchConditionViewCtrontroller.h"
#import "HotelConditionRequest.h"
#import "HotelKeywordListRequest.h"
#import "ConditionDisplayViewController.h"
#import "SubConditionDisplayViewController.h"
#import "HotelFavorite.h"
#import "DefineHotelReq.h"
#import "MyElongCenter.h"
#import "HotelSearchConditionItem.h"

#define kIconViewTag	6477
#define kTextFieldTag	6478
#define kTopSplitViewTag 6479
#define kBottomSplitViewTag 6480
@interface HotelSearchConditionViewCtrontroller(){
    
}
@property (nonatomic, copy)     NSString *searchCity;
@property (nonatomic, retain)   NSArray *filterArray;
@end

@implementation HotelSearchConditionViewCtrontroller

@synthesize searchCity;

#pragma mark -
#pragma mark Memory management

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    self.searchCity     = nil;
    keyTable.delegate   = nil;
    self.keywordFilter  = nil;
    self.filterArray    = nil;
    self.conditionItems = nil;
    
	[keyTable			release];
    
    [keywordVC release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithSearchCity:(NSString *)city title:(NSString *)title navBarBtnStyle:(NavBarBtnStyle)btnStyle displaySearchBar:(BOOL)searchbar{
    displaySearch = searchbar;
    if (self = [super initWithTitle:title style:btnStyle]) {
    
        
        NSMutableArray *itemArray = [NSMutableArray array];

        HotelSearchConditionItem *item = [[HotelSearchConditionItem alloc] init];
        item.image = [UIImage noCacheImageNamed:@"business_ico.png"];
        item.title = @"商    圈";
        item.itemType = HotelKeywordTypeBusiness;
        [itemArray addObject:item];
        [item release];
        
        item = [[HotelSearchConditionItem alloc] init];
        item.image = [UIImage noCacheImageNamed:@"brand_ico.png"];
        item.title = @"品    牌";
        item.itemType = HotelKeywordTypeBrand;
        [itemArray addObject:item];
        [item release];
        
        item = [[HotelSearchConditionItem alloc] init];
        item.image = [UIImage noCacheImageNamed:@"district_ico.png"];
        item.title = @"行政区";
        item.itemType = HotelKeywordTypeDistrict;
        [itemArray addObject:item];
        [item release];
        
        item = [[HotelSearchConditionItem alloc] init];
        item.image = [UIImage noCacheImageNamed:@"metro_ico.png"];
        item.title = @"地    铁";
        item.itemType = HotelKeywordTypeSubwayStation;
        [itemArray addObject:item];
        [item release];
        
        item = [[HotelSearchConditionItem alloc] init];
        item.image = [UIImage noCacheImageNamed:@"traffic_ico.png"];
        item.title = @"机场 / 火车站";
        item.itemType = HotelKeywordTypeAirportAndRailwayStation;
        [itemArray addObject:item];
        [item release];
        
        self.conditionItems = itemArray;
        
		self.searchCity = city;
        keywordVC.searchCity = city;
	}
	return self;

}

- (void) removeConditionItem:(HotelKeywordType)keywordType{
    NSMutableArray *itemArray = [NSMutableArray array];
    for (HotelSearchConditionItem *item in self.conditionItems) {
        if (item.itemType != keywordType) {
            [itemArray addObject:item];
        }
    }
    self.conditionItems = itemArray;
    [keyTable reloadData];
}

- (void) reloadData{
    [keyTable reloadData];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad{
	[super viewDidLoad];
	int offY = 0;
    float hoffY = 0;
	if (displaySearch) {
        if (!keywordVC) {
            keywordVC = [[HotelKeywordViewController alloc] initWithSearchCity:self.searchCity contentsController:self];
            keywordVC.delegate = self;
            keywordVC.viewController = self;
            [self.view addSubview:keywordVC.searchBar];
            keywordVC.keywordFilter = self.keywordFilter;
            keywordVC.independent = self.independent;
            keywordVC.nearbyIsShow = self.nearByIsShow;
            offY = 44;
            hoffY = 30;
        }
	}
    
	// add Table
    if (!keyTable) {
        keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, offY, self.view.frame.size.width, 400 * COEFFICIENT_Y) style:UITableViewStylePlain];
        keyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        keyTable.dataSource		= self;
        keyTable.scrollEnabled = NO;
        keyTable.delegate		= self;
        keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        keyTable.backgroundColor=[UIColor clearColor];
        [self.view addSubview:keyTable];
        keyTable.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, hoffY)] autorelease];
    }
    
    [keyTable reloadData];
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
    [searchReq clearDataOnly];
    
    
    [searchReq setSearchCity:searchCity];
    currentRow = -1;
    [Utils request:OTHER_SEARCH req:[searchReq requestForAllCondition] policy:CachePolicyHotelArea delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setNearByIsShow:(BOOL)nearByIsShow{
    _nearByIsShow = nearByIsShow;
    keywordVC.nearbyIsShow = nearByIsShow;
}

#pragma mark -
#pragma mark HotelKeywordViewControllerDelegate

- (void) hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC didGetKeyword:(NSString *)keyword{
    // 刷新
    [keyTable reloadData];
    
    if (self.independent) {
        // 独立模块只负责传递数据
        if ([self.delegate respondsToSelector:@selector(hotelSearchConditionViewCtrontroller:didSelect:)]) {
            [self.delegate hotelSearchConditionViewCtrontroller:self didSelect:hotelKeywordVC.keywordFilter];
        }
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HotelSearch class]]) {
                HotelSearch *searchCtr = (HotelSearch *)controller;
                [self.navigationController popToViewController:searchCtr animated:YES];
                break;
            }
        }
    }
}

- (void) hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC cancelWithContent:(NSString *)content{
    if (self.independent) {
        // 独立模块只负责传递数据
        if ([self.delegate respondsToSelector:@selector(hotelSearchConditionViewCtrontroller:didSelect:)]) {
            [self.delegate hotelSearchConditionViewCtrontroller:self didSelect:nil];
        }
    }else{
        // 取消搜索结果
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE object:self userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
    }
    
    // 清空记录
    [hotelKeywordVC cancelSearchCondition];
    
    // 刷新
    [keyTable reloadData];
}

- (void) hotelKeywordVCDidBeginEdit:(HotelKeywordViewController *)hotelKeywordVC{

}

- (void) hotelKeywordVCSearchNearby:(HotelKeywordViewController *)hotelKeywordVC{
    if ([self.delegate respondsToSelector:@selector(hotelSearchConditionViewCtrontrollerSearchNearby:)]) {
        [self.delegate hotelSearchConditionViewCtrontrollerSearchNearby:self];
    }
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardDidHide:(NSNotification *)notification {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	keyTable.contentInset = UIEdgeInsetsZero;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.conditionItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger height = 50;
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    if (!searchReq.isAllDataLoaded) {
        return 0;
    }

    HotelSearchConditionItem *conditionItem = (HotelSearchConditionItem *)[self.conditionItems objectAtIndex:indexPath.row];
    
    switch (conditionItem.itemType) {
        case HotelKeywordTypeBusiness:
            if (searchReq.commercialArray.count == 0) {
                height = 0;
            }
            break;
            // add brand
        case HotelKeywordTypeBrand:
            if (searchReq.brandArray.count == 0) {
                height = 0;
            }
            break;
            // end
        case HotelKeywordTypeDistrict:
            if (searchReq.districtArray.count == 0) {
                height = 0;
            }
            break;
        case HotelKeywordTypeSubwayStation:
            if (searchReq.metroArray.count == 0) {
                height = 0;
            }
            break;
        case HotelKeywordTypeAirportAndRailwayStation:
            if (searchReq.trafficArray.count == 0) {
                height = 0;
            }
            break;
        default:
            break;
    }
    
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    UITableViewCell *cell = nil;
    
	cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectTableCellKey]autorelease];
        
        // icon
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 50)];
        iconView.contentMode = UIViewContentModeCenter;
        iconView.tag		 = kIconViewTag;
        [cell.contentView addSubview:iconView];
        [iconView release];
        
        // condition
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, self.view.frame.size.width - 64 - 16, 50)];
        titleLbl.font			 = FONT_B16;
        titleLbl.minimumFontSize = 12;
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.tag			 = kTextFieldTag;
        titleLbl.lineBreakMode = UILineBreakModeTailTruncation;
        titleLbl.textColor	 =  RGBACOLOR(52, 52, 52, 1);
        [cell.contentView addSubview:titleLbl];
        [titleLbl release];
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        topSplitView.tag = kTopSplitViewTag;
        [cell.contentView addSubview:topSplitView];
        [topSplitView release];
        
        UIImageView *bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        bottomSplitView.tag = kBottomSplitViewTag;
        [cell.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 16, 0, 8, 50)];
        arrow.contentMode =  UIViewContentModeCenter;
        arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [cell.contentView addSubview:arrow];
        [arrow release];
    }
    
    HotelSearchConditionItem *conditionItem = (HotelSearchConditionItem *)[self.conditionItems objectAtIndex:indexPath.row];
    
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:kIconViewTag];
    icon.image = conditionItem.image;
    
    UILabel *conditionField = (UILabel *)[cell.contentView viewWithTag:kTextFieldTag];
    
    HotelKeywordType keywordType = conditionItem.itemType;
    
    JHotelKeywordFilter *filter = nil;
    
    // 模块独立
    if (self.independent) {
        filter = self.keywordFilter;
    }
    if (filter.keywordType == keywordType) {
        conditionField.text			= [NSString stringWithFormat:@"%@  (%@)",conditionItem.title,filter.keyword];
    }else{
        conditionField.text			= [NSString stringWithFormat:@"%@",conditionItem.title];
    }
    
    UIImageView *topSplitView = (UIImageView *)[cell.contentView viewWithTag:kTopSplitViewTag];
    UIImageView *bottomSplitView = (UIImageView *)[cell.contentView viewWithTag:kBottomSplitViewTag];
    
    
    // 最后一个不等于0的cell
    NSInteger lastCellIndex = 0;
    NSInteger firstCellIndex = -1;
    for (NSInteger i = 0; i < [self tableView:tableView numberOfRowsInSection:0]; i++) {
        if ([self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] > 0) {
            lastCellIndex = i;
            if (firstCellIndex == -1) {
                firstCellIndex = i;
            }
        }
    }
    
    if (indexPath.row == firstCellIndex) {
        topSplitView.hidden = NO;
        bottomSplitView.hidden = NO;
    }else{
        topSplitView.hidden = YES;
        bottomSplitView.hidden = NO;
    }
    
    
    if (firstCellIndex == lastCellIndex) {
        topSplitView.frame = topSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        bottomSplitView.frame = CGRectMake(0, 50 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    }else if (indexPath.row == firstCellIndex) {
        topSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        bottomSplitView.frame = CGRectMake(64, 50 - SCREEN_SCALE, SCREEN_WIDTH - 64, SCREEN_SCALE);
    }else if(indexPath.row == lastCellIndex){
        bottomSplitView.frame = CGRectMake(0, 50 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    }else{
        topSplitView.frame = CGRectMake(64, 0, SCREEN_WIDTH - 64, SCREEN_SCALE);
        bottomSplitView.frame = CGRectMake(64, 50 - SCREEN_SCALE, SCREEN_WIDTH - 64, SCREEN_SCALE);
    }
	return cell;
}

#pragma mark -
#pragma mark 用户点击搜索建议数据

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (keywordVC.searchBarIsShow) {
        return;
    }
    
	[self.view endEditing:YES];
    currentRow = indexPath.row;
    
    // 跳转
    [self goNextStep];
}

// 跳转
- (void) goNextStep{
    if (currentRow < 0) {
        return;
    }
    
    HotelSearchConditionItem *conditionItem = (HotelSearchConditionItem *)[self.conditionItems objectAtIndex:currentRow];
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
    NSArray *disArray = searchReq.districtArray;
    NSArray *comArray = searchReq.commercialArray;
    NSArray *metroArray = searchReq.metroSubArray;
    
    NSInteger type = conditionItem.itemType;
    
    if (searchReq.isAllDataLoaded) {
        switch (type) {
                // 品牌
            case HotelKeywordTypeBrand: {
                SubConditionDisplayViewController *controller = [[SubConditionDisplayViewController alloc]
                                                                 initWithIconPath:nil
                                                                 Title:conditionItem.title
                                                                 hotelKeywordType:HotelKeywordTypeBrand
                                                                 Datas:searchReq.brandArray  navShadowHidden:YES];
                controller.locationTitle = @"品牌";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                controller.delegate = self;
                controller.keywordFilter = self.keywordFilter;
            }
                break;
            case HotelKeywordTypeDistrict:
                // 行政区
            case HotelKeywordTypeBusiness: {
                // 商圈
                SubConditionDisplayViewController *controller = [[SubConditionDisplayViewController alloc]
                                                                 initWithIconPath:nil
                                                                 Title:conditionItem.title
                                                                 hotelKeywordType:type
                                                                 Datas:type == HotelKeywordTypeBusiness ? comArray : disArray  navShadowHidden:YES];
                if (type == HotelKeywordTypeBusiness) {
                    controller.locationTitle = @"商圈";
                }
                else {
                    controller.locationTitle = @"行政区";
                }
                
                [self.navigationController
                 pushViewController:controller animated:YES];
                [controller release];
                controller.delegate = self;
                controller.keywordFilter = self.keywordFilter;
            }
                break;
            case HotelKeywordTypeSubwayStation: {
                ConditionDisplayViewController *controller = [[ConditionDisplayViewController alloc]
                                                              initWithIconPath:nil
                                                              Title:conditionItem.title
                                                              hotelKeywordType:HotelKeywordTypeSubwayStation
                                                              Datas:metroArray navShadowHidden:YES];
                controller.typeStr = (type == HotelKeywordTypeSubwayStation ? SUBWAY_STATION : AIRPORT_RAILWAY);
                controller.locationTitle = @"地铁";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                controller.delegate = self;
                controller.keywordFilter = self.keywordFilter;
            }
                break;
            case HotelKeywordTypeAirportAndRailwayStation: {
                SubConditionDisplayViewController *controller = [[SubConditionDisplayViewController alloc]
                                                                 initWithIconPath:nil
                                                                 Title:conditionItem.title
                                                                 hotelKeywordType:HotelKeywordTypeAirportAndRailwayStation
                                                                 Datas:searchReq.trafficArray  navShadowHidden:YES];
                controller.locationTitle = @"机场/火车站";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                controller.delegate = self;
                controller.keywordFilter = self.keywordFilter;
            }
                break;
            default:
                break;
        }
    }
    else {
        [searchReq clearData];
        
        [searchReq setSearchCity:searchCity];
        [Utils request:OTHER_SEARCH req:[searchReq requestForAllCondition] policy:CachePolicyHotelArea delegate:self];
    }
}

#pragma mark -
#pragma mark ConditionDisplayViewControllerDelegate

- (void) conditionDisplayViewController:(ConditionDisplayViewController *)conditionDisplayVC didSelect:(JHotelKeywordFilter *)locationInfo{
    // 只传递数据
    if ([self.delegate respondsToSelector:@selector(hotelSearchConditionViewCtrontroller:didSelect:)]) {
        [self.delegate hotelSearchConditionViewCtrontroller:self didSelect:locationInfo];
    }
}

#pragma mark -
#pragma mark SubConditionDisplayViewControllerDelegate

- (void) subConditionDisplayViewController:(SubConditionDisplayViewController *)subConditionDisplayVC didSelect:(JHotelKeywordFilter *)locationInfo{
    // 只传递数据
    if ([self.delegate respondsToSelector:@selector(hotelSearchConditionViewCtrontroller:didSelect:)]) {
        [self.delegate hotelSearchConditionViewCtrontroller:self didSelect:locationInfo];
    }
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
	NSDictionary *dic = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:dic]) {
		return;
	}
	
	HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    [searchReq setAllCondition:dic];
    [keyTable reloadData];
    
    // 跳转
    [self goNextStep];
}

@end
