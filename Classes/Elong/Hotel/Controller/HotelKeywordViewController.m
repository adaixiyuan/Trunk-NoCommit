//
//  HotelKeywordViewController.m
//  ElongClient
//
//  reframe by dawn 14-3-11
//
//  Created by Wang Shuguang on 13-4-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelKeywordViewController.h"
#import "HotelKeywordListRequest.h"
#import "HotelConditionRequest.h"
#import "HotelSearch.h"
#import "DefineHotelReq.h"
#import "InterHotelListResultVC.h"
#import "InterHotelSuggestRequest.h"
#import "InterHotelSearcher.h"
#import "SearchBarView.h"

#define cell_height (37)

@interface HotelKeywordViewController (){
    UIButton *iflyBtn;
}

@property (nonatomic,retain) NSMutableArray *historyArray;
@property (nonatomic,copy) NSString *m_key;
@property (nonatomic,retain) NSArray *filterArray;

@end

@implementation HotelKeywordViewController

@synthesize searchBar;
@synthesize searchCity = _searchCity;
@synthesize historyArray;
@synthesize viewController;
@synthesize delegate;
@synthesize withNavHidden;
@synthesize searchList;
@synthesize searchBarIsShow;

- (void)dealloc{
    self.searchCity = nil;
    self.historyArray = nil;
    self.m_key = nil;
    self.keywordFilter = nil;
    self.filterArray = nil;
    if (suggestHasUpdated) {
        // 如果用户发起过新的suggest请求，更新缓存里的数据
        HotelKeywordListRequest *hklReq = [HotelKeywordListRequest shared];
        [hklReq saveDataToCache];
    }
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.searchCity  = nil;
	self.historyArray = nil;
    searchList.delegate = nil;
    searchList.dataSource = nil;
    [searchList release];
    searchList = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    
    [searchBar removeObserver:self forKeyPath:@"text"];
    
    [searchBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithSearchCity:(NSString *)city contentsController:(UIViewController *)vc{
    if (self = [super init]) {
        self.viewController = vc;
        self.withNavHidden = YES;
        isInterHotel = NO;
        suggestHasUpdated = NO;
        
        // 关键词搜索城市
        self.searchCity = city;
        
        // 搜索框
        searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.delegate      = self;

        if (self.independent) {
            // 模块独立
            searchBar.placeholder   = @"酒店名、地址等";
            if (!STRINGHASVALUE(searchBar.text) && self.keywordFilter) {
                // 如果有上一次搜索条件时显示之
                searchBar.text = self.keywordFilter.keyword;
            }
        }else{
            // 给搜索框赋值
            InterHotelSearcher *searcher = [InterHotelSearcher shared];
            if (!searcher.isInterHotelProgress) {
                // 国内酒店
                searchBar.placeholder   = @"酒店名、地址等";
                HotelConditionRequest *hcReq = [HotelConditionRequest shared];
                if (!STRINGHASVALUE(searchBar.text) && hcReq.keywordFilter) {
                    // 如果有上一次搜索条件时显示之
                    searchBar.text = hcReq.keywordFilter.keyword;
                }
            }
            else {
                // 国际酒店
                searchBar.placeholder   = @"酒店名";
                InterHotelSearcher *searcher = [InterHotelSearcher shared];
                if (STRINGHASVALUE(searcher.keywords)) {
                    searchBar.text = searcher.keywords;
                }
            }

        }
        
        searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44) style:UITableViewStylePlain];
        searchList.backgroundColor = [UIColor whiteColor];
        searchList.separatorStyle = UITableViewCellSeparatorStyleNone;

        

        // 注册消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInterHotelByNoti:) name:NOTI_INTERHOTEL_SUGGEST object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshByNoti:) name:NOTI_KEYWORD_UPDATE object:nil];
        
        //
        [searchBar addObserver:self
                    forKeyPath:@"text"
                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context:nil];
        
         [self resizeIFlyBtn];
    }
    return self;
}

- (void) setIndependent:(BOOL)independent{
    _independent = independent;
    
    if (self.independent) {
        // 模块独立
        searchBar.placeholder   = @"酒店名、地址等";
        if (self.keywordFilter) {
            // 如果有上一次搜索条件时显示之
            searchBar.text = self.keywordFilter.keyword;
        }
    }else{
        // 给搜索框赋值
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        if (!searcher.isInterHotelProgress) {
            // 国内酒店
            searchBar.placeholder   = @"酒店名、地址等";
            HotelConditionRequest *hcReq = [HotelConditionRequest shared];
            if (!STRINGHASVALUE(searchBar.text) && hcReq.keywordFilter) {
                // 如果有上一次搜索条件时显示之
                searchBar.text = hcReq.keywordFilter.keyword;
            }
        }
        else {
            // 国际酒店
            searchBar.placeholder   = @"酒店名";
            InterHotelSearcher *searcher = [InterHotelSearcher shared];
            if (STRINGHASVALUE(searcher.keywords)) {
                searchBar.text = searcher.keywords;
            }
        }
        
    }
}

- (void) resizeIFlyBtn{
    NSString *tempstring = searchBar.text;
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tempstring.length == 0) {
        iflyBtn.frame = CGRectMake(SCREEN_WIDTH - 46, -4, 40, 50);
    }else{
        iflyBtn.frame = CGRectMake(SCREEN_WIDTH - 80, -4, 40, 50);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if(object == searchBar){
        [self resizeIFlyBtn];
    }
}

- (void) positionBtnClick:(id)sender{
    
    [self resizeIFlyBtn];
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    iflyBtn.hidden = NO;
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[HotelSearchResultManager class]]) {
                HotelSearchResultManager *searchResultManager = (HotelSearchResultManager *)self.viewController;
                searchResultManager.favBtn.hidden = NO;
            }
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(hotelKeywordVCSearchNearby:)]){
        [self.delegate hotelKeywordVCSearchNearby:self];
    }
}

- (void) setIflyIsShow:(BOOL)iflyIsShow{
    _iflyIsShow = iflyIsShow;
    if(iflyIsShow){
        if(!iflyBtn){
            iflyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            iflyBtn.frame = CGRectMake(SCREEN_WIDTH - 46, -4, 40, 50);
            [iflyBtn setImage:[UIImage noCacheImageNamed:@"ifly_mac.png"] forState:UIControlStateNormal];
            [iflyBtn setImage:[UIImage noCacheImageNamed:@"ifly_mac_h.png"] forState:UIControlStateHighlighted];
            [iflyBtn addTarget:self action:@selector(iflyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [searchBar addSubview:iflyBtn];
        }
    }else{
        if(iflyBtn){
            [iflyBtn removeFromSuperview];
            iflyBtn = nil;
        }
    }
    
    [self resizeIFlyBtn];
}

- (void) setNearbyIsShow:(BOOL)nearbyIsShow{
    _nearbyIsShow = nearbyIsShow;
    if (nearbyIsShow) {
        if (!searchList.tableHeaderView) {
            // 周边搜索
            UIView *positionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
            positionView.backgroundColor = [UIColor whiteColor];
            searchList.tableHeaderView = positionView;
            [positionView release];
            
            UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            positionBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
            positionBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            [positionBtn setTitle:@"查看我附近的酒店" forState:UIControlStateNormal];
            [positionBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
            [positionBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
            [positionView addSubview:positionBtn];
            [positionBtn addTarget:self action:@selector(positionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            positionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0);
            
            UIImageView *positionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 36, 0, 36, 36)];
            positionImageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            positionImageView.contentMode = UIViewContentModeCenter;
            [positionView addSubview:positionImageView];
            [positionImageView release];
            [positionView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 36 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            iconImageView.contentMode = UIViewContentModeCenter;
            iconImageView.image = [UIImage noCacheImageNamed:@"elong_gps_h.png"];
            [positionView addSubview:iconImageView];
            [iconImageView release];
        }
    }else{
        searchList.tableHeaderView = nil;
    }
}

- (void) iflyBtn:(id)sender{
    if([delegate respondsToSelector:@selector(hotelKeywordVCDidBeginListen:)]){
        [delegate hotelKeywordVCDidBeginListen:self];
    }
}

- (void)setSearchCity:(NSString *)searchCity{
    [_searchCity release];
    _searchCity = [searchCity copy];
    
    // 加载搜索历史
    self.historyArray = [NSMutableArray arrayWithArray:[PublicMethods allSearchKeysForCity:self.searchCity]];
}


- (void)setViewController:(UIViewController *)controller{
    viewController = controller;
    if ([viewController isKindOfClass:[HotelSearchResultManager class]]) {
        isInterHotel = NO;
    }
    else if ([viewController isKindOfClass:[InterHotelListResultVC class]]) {
        isInterHotel = YES;
    }
}

#pragma mark -
#pragma mark Private Method

// 展示关键词的联想结果
- (void)showResultForKeyword:(NSString *)keyword{
	if ([keyword isEqualToString:self.searchBar.text]) {
		// 如果是当前正在搜索的关键字，则对列表进行刷新
		[self refreshAddressListByKeyword:keyword];
	}
}

// ???
- (void)refreshByNoti:(NSNotification *)noti{
	NSString *keyword = (NSString *)[noti object];
    [self showResultForKeyword:keyword];
}

- (void)refreshInterHotelByNoti:(NSNotification *)noti{
    NSString *keyword = (NSString *)[noti object];
    [self showResultForKeyword:keyword];
}

// 清空搜索结果
- (void)cancelSearchCondition{
    self.m_key = nil;
    if (self.independent) {
        self.keywordFilter = nil;
    }else{
        HotelConditionRequest *hcReq = [HotelConditionRequest shared];
        [hcReq clearKeywordFilter];
    }
}


// 刷新国内酒店suggest
- (void)refreshNativeHotelSuggestByKeyword:(NSString *)key{
    // 更新地址列表
    self.m_key = key;
	if (key) {
        HotelKeywordListRequest *hklReq = [HotelKeywordListRequest shared];
        // 从本地查询cityid
        hklReq.currentCityID = [PublicMethods getCityIDWithCity:self.searchCity];
        
        NSArray *addressArray;
		// 无搜索字段时
        if ([key isEqualToString:@" "]) {
            addressArray = self.historyArray;
        }
		// 有搜索字段时
        else{
            addressArray = [hklReq getAddressListByKeyword:key];
        }
        
		if ([addressArray isKindOfClass:[NSArray class]]) {
			// 已请求过的情况
			self.filterArray = addressArray;
			[searchList performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
		}
		else {
			// 未请求时，重新请求
			NSString *newkey =  key;
			[hklReq requestForKeyword:newkey];
            suggestHasUpdated = YES;
		}
	}
	else {
		// 没有搜索字段时
		self.filterArray = [NSArray array];
		[searchList reloadData];
	}
}

// 刷新国际酒店suggest
- (void)refreshInterHotelSuggestByKeyword:(NSString *)key
{
    // 更新酒店列表
    self.m_key = key;
	if (key) {
        InterHotelSuggestRequest *isreq = [InterHotelSuggestRequest shared];
        
        NSArray *addressArray;
		// 无搜索字段时
        if ([key isEqualToString:@" "]) {
            addressArray = self.historyArray;
        }
		// 有搜索字段时
        else {
            addressArray = [isreq getSuggestByKeyword:key];
        }
        
		if ([addressArray isKindOfClass:[NSArray class]]) {
			// 已请求过的情况
			self.filterArray = addressArray;
			[searchList performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
		}
		else {
			// 未请求时，重新请求
			NSString *newkey =  key;
			[isreq requestForKeyword:newkey];
            suggestHasUpdated = YES;
		}
	}
	else {
		// 没有搜索字段时
		self.filterArray = [NSArray array];
		[searchList reloadData];
	}
}

- (void)refreshAddressListByKeyword:(NSString *)key{
    if (!isInterHotel) {
        // 国内酒店搜索
        [self refreshNativeHotelSuggestByKeyword:key];
    }
    else {
        // 国外酒店搜索
        [self refreshInterHotelSuggestByKeyword:key];
    }
}

// 返回keyword类型
- (NSString *)keywordName:(NSDictionary *)filter{
    if ([filter safeObjectForKey:@"Type"] && [filter safeObjectForKey:@"Type"]!=[NSNull null]) {
        NSInteger type = [[filter safeObjectForKey:@"Type"] intValue];
        switch (type) {
            case HotelKeywordTypeAirportAndRailwayStation:{         // 1：机场/火车站(按照坐标处理)
                return @"机场/火车站    ";
            }
            case HotelKeywordTypeSubwayStation:{                    // 2：地铁站(按坐标处理)
                return @"地铁站    ";
            }
            case HotelKeywordTypeBusiness:{                         // 3：商圈(按区域处理)
                return @"商圈    ";
            }
            case HotelKeywordTypeBrand:{                            // 5：品牌(按品牌处理)
                return @"品牌    ";
            }
            case HotelKeywordTypeDistrict:{                         // 6：行政区(按区域处理)
                return @"行政区    ";
            }
            case HotelKeywordTypeNormal:{                           // 9：酒店名(按酒店名处理)
                return @"";
            }
            case HotelKeywordTypePOI:{                              // 99：POI(按经纬度处理)
                return @"地标    ";
            }
            default:
                return @"";
        }
    }
    return @"";
}

// 设定搜索条件
- (void)keywordFilter:(NSDictionary *)filter{
    JHotelKeywordFilter *keywordFilter = nil;
    if (self.independent) {
        // 模块独立
        self.keywordFilter = [[[JHotelKeywordFilter alloc] init] autorelease];
        keywordFilter = self.keywordFilter;
    }else{
        // 取得搜索条件的单例
        HotelConditionRequest *hcReq = [HotelConditionRequest shared];
        [hcReq clearKeywordFilter];
        keywordFilter = hcReq.keywordFilter;
    }
    
    // keyword suguestion 类型
    NSInteger type = [[filter safeObjectForKey:@"Type"] intValue];
    keywordFilter.keywordType = type;
    keywordFilter.keyword = [filter safeObjectForKey:NAME_RESP];
    switch (type) {
        case HotelKeywordTypeAirportAndRailwayStation:{}        // 1：机场/火车站(按照坐标处理)
        case HotelKeywordTypeSubwayStation:{}                   // 2：地铁站(按坐标处理)
        case HotelKeywordTypePOI:{                              // 99：POI(按经纬度处理)
            keywordFilter.lat = [[filter safeObjectForKey:@"Lat"] floatValue];
            keywordFilter.lng = [[filter safeObjectForKey:@"Lng"] floatValue];
            break;
        }
        case HotelKeywordTypeBrand:{                            // 5：品牌(按品牌处理)
            keywordFilter.pid = [[filter safeObjectForKey:@"PropertiesId"] intValue];
            break;
        }
        case HotelKeywordTypeBusiness:{}                        // 3：商圈(按区域处理)
        case HotelKeywordTypeDistrict:{}                        // 6：行政区(按区域处理)
        case HotelKeywordTypeNormal:{                           // 9：酒店名(按酒店名处理)
            if (keywordFilter) {
                if ([keywordFilter.keyword isEqualToString:@""]) {
                    keywordFilter.keyword = nil;
                }
            }
            
            break;
        }
        default:
            break;
    }
}

// 清空搜索历史
- (void)deleteallcell:(id)sender{
    [self.historyArray removeAllObjects];
    
    [PublicMethods clearSearchKeyforCity:self.searchCity];
    
    [searchList reloadData];
    
    self.searchBar.text = @"";
}

#pragma mark -
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (![self.m_key isEqualToString:@" "] && self.m_key) {
		if ([self.filterArray count] > 0) {
            NSString *firstWord = nil;      // tableview第一栏显示的文字
            if (isInterHotel) {
                firstWord = [_filterArray safeObjectAtIndex:0];
            }
            else {
                firstWord = [[_filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP];
            }
            
			if ([firstWord isEqualToString:self.searchBar.text]) {
				// 不重复显示联想与输入重复的内容
				return [self.filterArray count];
			}
			else {
				return [self.filterArray count] + 1;
			}
		}
		else {
			return 1;
		}
    }
    else {
        if (self.historyArray == nil || self.historyArray.count == 0) {
            return 0;
        }else{
            return [self.historyArray count] + 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([searchBar.text isEqualToString:@" "] && indexPath.row == [self.historyArray count]) {
        return cell_height+20;
    }
    return cell_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    [view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"     搜索历史:";
    [label release];
    if (([self.m_key isEqualToString:@" "] || self.m_key == nil) && [self.historyArray count])
        return view;
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (([self.m_key isEqualToString:@" "] || self.m_key == nil)  && [self.historyArray count]){
        return 30;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
	static NSString *SelectTableCellKeyex = @"SelectTableCellKeyex";
    CommonCell *cell;
	
	if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
    
        if (indexPath.row == [self.historyArray count]){
            cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKeyex];
            if (!cell) {
                cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKeyex
                                                        height:cell_height+20
                                                         style:CommonCellStyleRightArrow] autorelease];
                cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
                cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.textLabel.numberOfLines = 1;
                
                UIImageView *dashview = (UIImageView*)[cell.contentView viewWithTag:101];
                dashview.hidden = YES;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(92, 2, 136, 30);
                button.tag = 103;
                [button addTarget:self action:@selector(deleteallcell:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
                [button setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
                [button setTitle:@"清除搜索历史" forState:UIControlStateNormal];
                [cell addSubview:button];
                cell.clipsToBounds = NO;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.cellImage.hidden = YES;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
                cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
                cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
            }
            
        }
        else{
            cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
            if (!cell) {
                cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
                                                        height:cell_height
                                                         style:CommonCellStyleRightArrow] autorelease];
                
                cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
                cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                cell.cellImage.hidden = YES;
                cell.textLabel.numberOfLines = 1;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
                cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
                cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
            }
            
        }
       
        if (indexPath.row == [self.historyArray count]) {
            
            UIButton *button = (UIButton*)[cell viewWithTag:103];
            button.hidden = NO;
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
        if (indexPath.row != [self.historyArray count]){
            UIButton *button = (UIButton*)[cell viewWithTag:103];
            button.hidden = NO;
            cell.textLabel.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
            NSDictionary *dict = [self.historyArray safeObjectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self keywordName:dict];
            cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
        }
	}
    else{
        cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
		if (!cell) {
			cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
													height:cell_height
													 style:CommonCellStyleRightArrow] autorelease];
            
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
			cell.cellImage.hidden = YES;
            cell.textLabel.numberOfLines = 1;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
            cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
            cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
            cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
		}
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.hidden = YES;
            }
        }
        
        if (indexPath.row == 0) {
            // 第一行显示用户当前搜索内容
            cell.textLabel.text = self.searchBar.text;
            cell.detailTextLabel.text = @"";
        }
        else {
            NSString *firstWord = nil;      // tableview第一栏显示的文字
            if (isInterHotel) {
                firstWord = [_filterArray safeObjectAtIndex:0];
            }
            else {
                firstWord = [[_filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP];
            }
            
            if ([firstWord isEqualToString:self.searchBar.text]) {
                // 不重复显示联想与输入重复的内容
                if (isInterHotel) {
                    cell.textLabel.text = [self.filterArray safeObjectAtIndex:indexPath];
                }
                else {
                    NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row];
                    cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
                    cell.detailTextLabel.text = [self keywordName:dict];
                }
            }
            else {
                if (isInterHotel) {
                    cell.textLabel.text = [self.filterArray safeObjectAtIndex:indexPath.row - 1];;
                }
                else {
                    NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row - 1];
                    cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
                    cell.detailTextLabel.text = [self keywordName:dict];
                }
            }
        }
    }
    
    if (!isInterHotel) {
        cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 240, cell.textLabel.frame.size.height);
    }
    
	return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
        self.searchBar.showsCancelButton = YES;
        iflyBtn.hidden = YES;
        for(id cc in [self.searchBar subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                btn.enabled = YES;
            }
        }
    }
}

#pragma mark -
#pragma mark 用户点击搜索建议数据

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    iflyBtn.hidden = NO;
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[HotelSearchResultManager class]]) {
                HotelSearchResultManager *searchResultManager = (HotelSearchResultManager *)self.viewController;
                searchResultManager.favBtn.hidden = NO;
            }
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
	
    if (self.independent) {
        // 国内酒店流程
        if (![self.m_key isEqualToString:@" "] && ![self.filterArray isEqualToArray:self.historyArray]) {
            NSDictionary *tdict = nil;
            if ([self.filterArray count] > 0 && [[[self.filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP] isEqualToString:self.searchBar.text]) {
                // 联想出的数据与搜索关键字一样
                tdict = [self.filterArray safeObjectAtIndex:indexPath.row];
            }
            else if ([self.filterArray count] > 0 && indexPath.row != 0) {
                // 有联想出的数据时,且不是第一行时，用联想数据
                tdict = [self.filterArray safeObjectAtIndex:indexPath.row - 1];
            }
            else {
                NSString *searchName = [NSString stringWithFormat:@"%@",self.searchBar.text];
                if (!searchName) {
                    searchName = @"";
                }
                tdict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, NAME_RESP, NUMBER(9), @"Type", nil];
            }
            [self keywordFilter:tdict];
            
            if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
                [delegate hotelKeywordVC:self didGetKeyword:[tdict safeObjectForKey:NAME_RESP]];
            }
        }else{
            if (indexPath.row == [self.historyArray count]) {
                return;
            }
            
            NSDictionary *filterDict = [self.filterArray safeObjectAtIndex:indexPath.row];
            
            if (!DICTIONARYHASVALUE(filterDict))
            {
                return;
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:filterDict];
            
            if ([dict safeObjectForKey:@"Type"] && [dict safeObjectForKey:@"Type"]!=[NSNull null]) {
                
            }else{
                [dict safeSetObject:NUMBER(HotelKeywordTypeNormal) forKey:@"Type"];
            }
            
            [self keywordFilter:dict];
            
            if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
                [delegate hotelKeywordVC:self didGetKeyword:[dict safeObjectForKey:NAME_RESP]];
            }
        }
    }else{
        if (isInterHotel) {
            // 国际酒店流程
            if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
                CommonCell *cell = (CommonCell *)[tableView cellForRowAtIndexPath:indexPath];
                [delegate hotelKeywordVC:self didGetKeyword:cell.textLabel.text];
                
                // 通知首页更新
                NSString *homeKeyword = cell.textLabel.text;
                if (!homeKeyword ) {
                    homeKeyword = @"";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_INTERKEYWORDCHANGE
                                                                    object:self
                                                                  userInfo:[NSDictionary dictionaryWithObject:homeKeyword forKey:HOTEL_SEARCH_KEYWORD]];
            }
        }
        else {
            // 国内酒店流程
            if (![self.m_key isEqualToString:@" "] && ![self.filterArray isEqualToArray:self.historyArray]) {
                NSDictionary *tdict = nil;
                if ([self.filterArray count] > 0 && [[[self.filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP] isEqualToString:self.searchBar.text]) {
                    // 联想出的数据与搜索关键字一样
                    tdict = [self.filterArray safeObjectAtIndex:indexPath.row];
                }
                else if ([self.filterArray count] > 0 && indexPath.row != 0) {
                    // 有联想出的数据时,且不是第一行时，用联想数据
                    tdict = [self.filterArray safeObjectAtIndex:indexPath.row - 1];
                }
                else {
                    NSString *searchName = [NSString stringWithFormat:@"%@",self.searchBar.text];
                    if (!searchName) {
                        searchName = @"";
                    }
                    tdict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, NAME_RESP, NUMBER(9), @"Type", nil];
                }
                // 通知首页更新
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                                    object:self
                                                                  userInfo:[NSDictionary dictionaryWithObject:[tdict safeObjectForKey:NAME_RESP] forKey:HOTEL_SEARCH_KEYWORD]];
                [self keywordFilter:tdict];
                
                if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
                    [delegate hotelKeywordVC:self didGetKeyword:[tdict safeObjectForKey:NAME_RESP]];
                }
            }else{
                if (indexPath.row == [self.historyArray count]) {
                    return;
                }
                
                NSDictionary *filterDict = [self.filterArray safeObjectAtIndex:indexPath.row];
                
                if (!DICTIONARYHASVALUE(filterDict))
                {
                    return;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:filterDict];
                
                // 通知首页更新
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                                    object:self
                                                                  userInfo:[NSDictionary dictionaryWithObject:[dict safeObjectForKey:NAME_RESP] forKey:HOTEL_SEARCH_KEYWORD]];
                
                if ([dict safeObjectForKey:@"Type"] && [dict safeObjectForKey:@"Type"]!=[NSNull null]) {
                    
                }else{
                    [dict safeSetObject:NUMBER(HotelKeywordTypeNormal) forKey:@"Type"];
                }
                
                [self keywordFilter:dict];
                
                if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
                    [delegate hotelKeywordVC:self didGetKeyword:[dict safeObjectForKey:NAME_RESP]];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar_{
    // 状态设置为显示
    searchBarIsShow = YES;
    if ([delegate respondsToSelector:@selector(hotelKeywordVCDidBeginEdit:)]) {
        [delegate hotelKeywordVCDidBeginEdit:self];
    }
    
    searchList.delegate = self;
    searchList.dataSource = self;
    [self setSearchCity:[NSString stringWithFormat:@"%@",self.searchCity]];
    
    self.filterArray = nil;
    
    [searchBar setShowsCancelButton:YES animated:YES];
    iflyBtn.hidden = YES;
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[HotelSearchResultManager class]]) {
                HotelSearchResultManager *searchResultManager = (HotelSearchResultManager *)self.viewController;
                searchResultManager.favBtn.hidden = YES;
            }
            
        }else{
            [self.viewController.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
   
    if (searchBar.superview && !searchList.superview) {
        if (!isInterHotel) {
            [self.viewController.view addSubview:searchList];
        }
        else {
            InterHotelListResultVC *controller = (InterHotelListResultVC *)viewController;
            [controller.view addSubview:searchList];
        }
        
        searchList.alpha = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 1;
    }];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_
{
    // Cancel按钮换成中文显示
    UIView *viewTop = IOSVersion_7 ? searchBar.subviews[0] : searchBar;
    NSString *classString = IOSVersion_7 ? @"UINavigationButton" : @"UIButton";
    
    for (UIView *subView in viewTop.subviews) {
        if ([subView isKindOfClass:NSClassFromString(classString)]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    // 去掉键盘搜索默认置灰
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? searchBar_.subviews : [[searchBar_.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    
    
    NSString *searchStr = searchBar.text;
	if (STRINGHASVALUE(searchStr)) {
		searchBar.text = searchStr;				// 启动搜索表格
		[self refreshAddressListByKeyword:searchStr];
	}
    NSString *tempstring = searchBar.text;
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.historyArray count] && [tempstring length] == 0){
        [self refreshAddressListByKeyword:@" "];	// 启动搜索表格
    }else{
        [searchList reloadData];
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];		// 把tableview撑高
	footView.backgroundColor = [UIColor clearColor];
	searchList.tableFooterView = footView;
	[footView release];
	
	searchList.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *tempstring = searchText;
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([tempstring length]>0) {
        [self refreshAddressListByKeyword:tempstring];
    }
	if ([tempstring length] == 0) {
        [self refreshAddressListByKeyword:@" "];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *tempstring = nil;
    if ([text isEqualToString:@""]) {
        if (searchBar.text.length) {
            range.location = searchBar.text.length - 1;
            range.length = 1;
            tempstring = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
        }
    }else{
        tempstring = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    }
    
    tempstring = [tempstring stringByReplacingOccurrencesOfString:@" " withString:@""];
   
	if ([tempstring length]>0) {
        [self refreshAddressListByKeyword:tempstring];
    }
	if ([tempstring length] == 0) {
        [self refreshAddressListByKeyword:@" "];
    }
    
    NSLog(@"%@",tempstring);
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_{
    
    [self resizeIFlyBtn];
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    iflyBtn.hidden = NO;
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[HotelSearchResultManager class]]) {
                HotelSearchResultManager *searchResultManager = (HotelSearchResultManager *)self.viewController;
                searchResultManager.favBtn.hidden = NO;
            }
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }

    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
    
    if ([delegate respondsToSelector:@selector(hotelKeywordVC:cancelWithContent:)]) {
        [delegate hotelKeywordVC:self cancelWithContent:[NSString stringWithFormat:@"%@",searchBar_.text]];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_{
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    NSString *tempstring = self.searchBar.text;
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempstring length] == 0 ) {
//        return;
    }
    
    if (self.independent) {
        NSString *searchName = [NSString stringWithFormat:@"%@",tempstring];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, NAME_RESP, NUMBER(9), @"Type", nil];
        [self keywordFilter:dict];
    }else{
        if (isInterHotel) {
            // 国际酒店
            // 通知首页更新
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_INTERKEYWORDCHANGE
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObject:tempstring forKey:HOTEL_SEARCH_KEYWORD]];
        }
        else {
            // 国内酒店
            // 通知首页更新
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObject:tempstring forKey:HOTEL_SEARCH_KEYWORD]];
            
            NSString *searchName = [NSString stringWithFormat:@"%@",tempstring];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, NAME_RESP, NUMBER(9), @"Type", nil];
            [self keywordFilter:dict];
        }

    }
    
    [searchBar setShowsCancelButton:NO animated:YES];
    iflyBtn.hidden = NO;
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[HotelSearchResultManager class]]) {
                HotelSearchResultManager *searchResultManager = (HotelSearchResultManager *)self.viewController;
                searchResultManager.favBtn.hidden = NO;
            }

        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];

    if ([delegate respondsToSelector:@selector(hotelKeywordVC:didGetKeyword:)]) {
        [delegate hotelKeywordVC:self didGetKeyword:tempstring];
    }
}



- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	NSString *searchStr = controller.searchBar.text;
	if (!STRINGHASVALUE(searchStr)) {
		[self cancelSearchCondition];
	}
}


@end
