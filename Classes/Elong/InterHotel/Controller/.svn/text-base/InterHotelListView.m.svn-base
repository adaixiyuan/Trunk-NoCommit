//
//  InterHotelListVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelListView.h"
#import "HotelKeywordViewController.h"
#import "InterHotelListCell.h"
#import "InterHotelSearcher.h"
#import "InterHotelDefine.h"
#import "SettingManager.h"
#import "InterHotelDetailCtrl.h"
#import "ElongURL.h"
#import "DefineHotelResp.h"

#define kDaodaoURL      @"http://www.daodao.com/img/cdsi/img2-daodao/branding/transparent_pixel-MCID-0.gif"

@interface InterHotelListView ()
@property (nonatomic,assign) NSInteger bookDays;

@end

@implementation InterHotelListView
@synthesize selectIndexPath;
@synthesize keywordVC;


#pragma mark -
#pragma mark SystemCallBack


- (void)dealloc {
	// cancel Downloads
    self.rootController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[queue cancelAllOperations];
	[queue release];
	
    //	self.areaName = nil;
    self.listTableView = nil;
    //    self.searchcontent = nil;
    //    self.filterArray = nil;
    //    self.m_key = nil;
    //
	[progressManager release];
	[tableImgeDict release];
    [tableFootView release];
    [moreHotelButton release];

    [moreHotelReq cancel];
    SFRelease(moreHotelReq);

    //    [tonightUtil cancel];
    //    SFRelease(tonightUtil);
    //
    [keywordVC release];
    //
    //    if (animateView) {
    //        [animateView release];
    //        animateView = nil;
    //    }
    //
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame rootController:(id)controller {
	if (self = [super initWithFrame:frame]) {
        self.rootController = controller;
        
		tableImgeDict	= [[NSMutableDictionary alloc] initWithCapacity:2];
		progressManager	= [[NSMutableDictionary alloc] initWithCapacity:2];
		queue = [[NSOperationQueue alloc] init];
        
        [self addMainContent];
        
        if (UMENG) {
            //国际酒店列表页面
            InterHotelSearcher *searcher = [InterHotelSearcher shared];
            [MobClick event:Event_InterHotelList label:searcher.cityNameEn];
        }
	}
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
	
    NSDate *checkIn = [NSDate dateFromString:searcher.checkInDate withFormat:@"yyyy-MM-dd"];
    NSDate *checkOut = [NSDate dateFromString:searcher.checkOutDate withFormat:@"yyyy-MM-dd"];
    
    self.bookDays = [checkOut timeIntervalSinceDate:checkIn]/24/60/60;
    
    
	return self;
}


// 添加搜索框
- (void)addSearchBar {
    // 搜索框
    if (!keywordVC) {
        keywordVC = [[HotelKeywordViewController alloc] initWithSearchCity:_rootController.cityName contentsController:_rootController];
        keywordVC.delegate = _rootController;
        keywordVC.viewController = _rootController;
        keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        keywordVC.searchList.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
        keywordVC.withNavHidden = YES;
        keywordVC.searchBar.translucent = NO;
        
        keywordVC.searchBar.clipsToBounds = NO;
    }
    
    [self addSubview:keywordVC.searchBar];
}


- (void)addTableHeaderView {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    
    _listTableView.tableHeaderView = headerView;
}


- (void)makeMoreLoadingView {
	tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 47)];
	
	UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiView.center = tableFootView.center;
    [aiView startAnimating];
	[tableFootView addSubview:aiView];
    [aiView release];
    
    moreHotelButton = [[UIButton alloc] initWithFrame:tableFootView.frame];
    moreHotelButton.titleLabel.font = FONT_14;
    moreHotelButton.adjustsImageWhenHighlighted = NO;
    [moreHotelButton setTitle:@"点击加载更多酒店" forState:UIControlStateNormal];
    [moreHotelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreHotelButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
}


// 点击更多酒店按钮
- (void)clickMoreButton {
    isRequstMore = NO;
    _listTableView.tableFooterView = tableFootView;
    [self morehotel];
}


// 添加主要显示内容
- (void)addMainContent {
    // 无酒店提示
	nullTipLabel					= [[UILabel alloc] initWithFrame:CGRectMake(50, 50 * COEFFICIENT_Y, 180, 40)];
	nullTipLabel.backgroundColor	= [UIColor clearColor];
    nullTipLabel.textColor          = RGBACOLOR(93, 93, 93, 1);
	nullTipLabel.text				= @"未找到符合条件的酒店";
	nullTipLabel.textAlignment		= UITextAlignmentCenter;
	nullTipLabel.font				= [UIFont boldSystemFontOfSize:16];
	nullTipLabel.center				= self.center;
	[self addSubview:nullTipLabel];
	[nullTipLabel release];
    
    // 生成酒店列表
    if (!_listTableView.superview) {
        if (!_listTableView) {
            _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height) style:UITableViewStylePlain];
            _listTableView.delegate=self;
            _listTableView.dataSource=self;
            _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        [self addSubview:_listTableView];
        
        [self addTableHeaderView];
    }
    
    // 搜索栏
    [self addSearchBar];
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
	_hotelCount = [searcher.hotelList count];
	if (_hotelCount == HOTEL_PAGESIZE) {
        // 国际酒店数量暂不准确，有25个酒店即生成更多按钮
		[self makeMoreLoadingView];
	}
	
	[self performSelector:@selector(refreshData) withObject:nil afterDelay:0.1];		// 防止更多按钮提前出现
}


- (void)refreshData {
    // 恢复searchbar
    searchBarHidden = NO;
    keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    isRequstMore = NO;
    lastHotelId = 0;
    
	[tableImgeDict removeAllObjects];
	[progressManager removeAllObjects];
	
	[_listTableView reloadData];
	
	[_listTableView setContentOffset:CGPointMake(0, 0)];
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    _hotelCount = [searcher.hotelList count];
	_listTableView.hidden = _hotelCount == 0 ? YES : NO;
    
    [_rootController restoreSearchMoreHotel];
    // 判断是否可以出现更多按钮
	if (_hotelCount < HOTEL_PAGESIZE) {
		_listTableView.tableFooterView = nil;
        [_rootController forbidSearchMoreHotel];
	}else {
		if (!tableFootView) {
			[self makeMoreLoadingView];
		}
		_listTableView.tableFooterView = tableFootView;
	}
    
    if (_hotelCount % HOTEL_PAGESIZE != 0) {
        // 不满足页数最大容量,肯定不会有下一页
		_listTableView.tableFooterView = nil;
		_rootController.isMaximum = YES;
		[_rootController forbidSearchMoreHotel];
	}
}

// 加载更多
- (void) addMoreData{
    // 更新数据过后，刷新表格与地图得显示
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    _hotelCount = [searcher.hotelList count];
    [_listTableView reloadData];
    [self checkFoot];

}


- (void)requestImageWithURLPath:(NSString *)path AtIndexPath:(NSIndexPath *)indexPath {
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    NSDictionary *hotel = [searcher.hotelList safeObjectAtIndex:indexPath.row];
	NSString *hotelID	= [NSString stringWithFormat:@"%@", [hotel safeObjectForKey:HOTELID_REQ]];
	
	if(STRINGHASVALUE(hotelID)) {
		if (![progressManager safeObjectForKey:hotelID]) {
			// 过滤重复请求
			ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:hotelID indexPath:indexPath];
			[queue addOperation:downLoader];
			downLoader.delegate		= self;
            downLoader.doDiskCache  = YES;
			downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
			[progressManager safeSetObject:downLoader forKey:hotelID];
			[downLoader release];
            
            // 国际酒店再给到到网发送一个请求
            HttpUtil *daodaoUtil = [[[HttpUtil alloc] init] autorelease];
            [daodaoUtil connectWithURLString:kDaodaoURL Content:nil StartLoading:NO EndLoading:NO Delegate:nil];
		}
	}
}
//
//
//- (void)cancelSearchCondition {
//	// 取消搜索结果
//	for (UIViewController *controller in self.navigationController.viewControllers) {
//		if ([controller isKindOfClass:[HotelSearch class]]) {
//			HotelSearch *searchCtr = (HotelSearch *)controller;
//            searchCtr.keywordlabelstring = @"";
//			searchCtr.m_keywordsTextField.text = @"";
//
//			break;
//		}
//	}
//
//	HotelConditionRequest *hcReq = [HotelConditionRequest shared];
//	if (hcReq.isFromLastMinute) {
//		hcReq.o_selectedCondition = nil;
//	}
//	else {
//		hcReq.selectedCondition = nil;
//	}
//}
//
//- (NSInteger) getDiscount:(NSDictionary *)hotel{
//    NSInteger formerPirce = 0;
//    if ([hotel objectForKey:@"LmOriPrice"]!=[NSNull null] && [hotel objectForKey:@"LmOriPrice"]) {
//        formerPirce = [[hotel objectForKey:@"LmOriPrice"] intValue];
//    }
//
//    NSInteger price = [[NSString stringWithFormat:@"%.f",[[hotel objectForKey:RespHL__LowestPrice_D] floatValue]] intValue];
//
//    if (formerPirce == 0) {
//        return 0;
//    }else if(formerPirce - price<0){
//        return 0;
//    }else{
//        return (price + 0.0) * 10/formerPirce;
//    }
//}
//
//
//#pragma mark -
//#pragma mark Sort
//#pragma mark function
//NSInteger sortByCaloricValue(id obj1, id obj2, void *context)
//{
//
//	float i1 = [[obj1 objectForKey:RespHL__Rating_D] floatValue];
//	float i2 = [[obj2 objectForKey:RespHL__Rating_D] floatValue];
//
//	//sort by desc
//	if (i1 < i2)
//		return NSOrderedDescending;
//	else if (i1 > i2)
//		return NSOrderedAscending;
//	else
//		return NSOrderedSame;
//
//}
//
//
#pragma mark -
#pragma mark Public

- (void)checkFoot {
    [_rootController restoreSearchMoreHotel];
	if (_hotelCount % HOTEL_PAGESIZE != 0) {
        // 不满足页数最大容量,肯定不会有下一页
		_listTableView.tableFooterView = nil;
		_rootController.isMaximum = YES;
		[_rootController forbidSearchMoreHotel];
	}
    else {
        // 满足最大容量时，再判断是否发送了重复请求
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        NSNumber *currentIdNum = [[searcher.hotelList lastObject] safeObjectForKey:HOTELID_REQ];
        NSInteger currentHotelId = 0;           // 取出当前列表里最后一个酒店的hotelid
        if (!OBJECTISNULL(currentIdNum)) {
            currentHotelId = [currentIdNum intValue];
        }
        
        if (currentHotelId != lastHotelId) {
            // 列表里数据不同，确实存在下一页
            _listTableView.tableFooterView = tableFootView;
            _rootController.isMaximum = NO;
        }
        else {
            // 列表里存在2组相同数据，禁止再次翻页
            _listTableView.tableFooterView = nil;
            _rootController.isMaximum = YES;
            [_rootController forbidSearchMoreHotel];
        }
        
        lastHotelId = currentHotelId;
	}
}

//- (void)reSearchByAreaName:(NSString *)string {
//	if (!STRINGHASVALUE(string)) {
//		string = @"";
//	}
//
//	linktype = HOTELSORT;
//	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
//	[hotelsearcher resetPage];
//	[hotelsearcher setStarCode:string];
//
//	[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] delegate:self];
//}
//
//
//- (void)keepHotelNumber {
//	for (NSInteger i = 0; i < HOTEL_PAGESIZE; i ++) {
//		NSDictionary *hotel = [[HotelSearch hotels] safeObjectAtIndex:i];
//		if ([tableImgeDict count] > 0) {
//			[tableImgeDict removeObjectForKey:[hotel objectForKey:RespHL__HotelId_S]];
//			[progressManager removeObjectForKey:[hotel objectForKey:RespHL__HotelId_S]];
//		}
//	}
//
//	[[HotelSearch hotels] removeObjectsInRange:NSMakeRange(0, HOTEL_PAGESIZE)];
//	[listTableView reloadData];
//
//
//    beginDrag = NO;
//	[listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:MAX_HOTEL_COUNT - HOTEL_PAGESIZE - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//}
//
//
//#pragma mark -
//#pragma mark Action
//#pragma mark morehotel
//
- (void)morehotel {
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    [searcher nextPage];

    if (moreHotelReq) {
        [moreHotelReq cancel];
        SFRelease(moreHotelReq);
    }

    moreHotelReq = [[HttpUtil alloc] init];

    [_rootController setSwitchButtonActive:NO];
    [moreHotelReq connectWithURLString:INTER_SEARCH
                               Content:[searcher request]
                          StartLoading:NO
                            EndLoading:NO
                            AutoReload:YES
                              Delegate:self];

    _listTableView.tableFooterView = tableFootView;
    
    if (UMENG) {
        //国际酒店列表加载更多
        [MobClick event:Event_InterHotelList_More];
    }
}


- (void)setRootController:(InterHotelListResultVC *)rootController {
    _rootController = rootController;
    keywordVC.viewController = rootController;
}


//#pragma mark hoteldetail
//
//-(void)hoteldetail:(NSString *)hotelId CheckInDate:(NSString *)checkInDate CheckOutDate:(NSString *)checkOutDate{
//	linktype = HOTELDETAIL;
//
//	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
//	[hoteldetail clearBuildData];
//	[hoteldetail setHotelId:hotelId];
//    if (isSevenDay) {
//        [hoteldetail setSevenDay:YES];
//    }
//	[hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
//
//	[Utils request:HOTELSEARCH req:[hoteldetail requesString:YES] policy:CachePolicyHotelDetail  delegate:self];
//}
//
//
#pragma mark -
#pragma mark HttpResponse

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    [_rootController setSwitchButtonActive:YES];
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        _listTableView.tableFooterView = nil;
        isRequstMore = NO;
        return ;
    }
    
    if (util == moreHotelReq) {
        // 请求更多酒店
        [_rootController checkHotelFull];

        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        if (ARRAYHASVALUE(dataArray)) {
            [searcher.hotelList addObjectsFromArray:dataArray];
            _hotelCount += [dataArray count];
            
            if (searcher.hotelList.count > 0) {
                searcher.countryId = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CountryCode"];
                searcher.cityNameEn = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CityEnName"];
            }
        }

        // 更新数据过后，刷新表格与地图得显示
        [_listTableView reloadData];
        [_rootController refreshMapData];
        [self checkFoot];

        isRequstMore = NO;
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        _listTableView.tableFooterView = moreHotelButton;
        [_rootController setSwitchButtonActive:YES];
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        [searcher prePage];
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        _listTableView.tableFooterView = moreHotelButton;
        [_rootController setSwitchButtonActive:YES];
    }
}

#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo {
	UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
	NSString *keyName		= [imageInfo safeObjectForKey:keyForName];
	
	if (image && indexPath && keyName) {
		NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:
								  indexPath, @"indexPath",
								  image, @"image",
								  keyName, @"name",
								  nil];
		
		[self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
	}
}

#pragma mark -
#pragma mark Image Thread

- (void)setCellImageWithData:(id)celldata {
	NSString *name		= [celldata safeObjectForKey:@"name"];
	UIImage *img		= [celldata safeObjectForKey:@"image"];
	NSIndexPath *index	= [celldata safeObjectForKey:@"indexPath"];
	
	if (img && name && index) {
        [tableImgeDict safeSetObject:img forKey:name];
        
		InterHotelListCell *cell = (InterHotelListCell *)[_listTableView cellForRowAtIndexPath:index];
		[cell.hotelImageView endLoading];
		cell.hotelImageView.image = img;
	}
}


#pragma mark tableViewDelegate
#pragma mark - UITableViewDelegate、UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
	InterHotelListCell *cell = (InterHotelListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[InterHotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    NSDictionary *hotelDic = [searcher.hotelList safeObjectAtIndex:indexPath.row];
    if (DICTIONARYHASVALUE(hotelDic)) {
        // 酒店名
        cell.hotelNameLable.text = [NSString stringWithFormat:@"%@", [hotelDic safeObjectForKey:InterHotel_Name]];
        
        // 酒店图片
        if ([[SettingManager instanse] defaultDisplayHotelPic]) {
            NSArray *idArray = [NSArray arrayWithArray:[tableImgeDict allKeys]];
            NSString *hotelID = [NSString stringWithFormat:@"%@", [hotelDic safeObjectForKey:HOTELID_REQ]];
            if(![idArray containsObject:hotelID]) {
                cell.hotelImageView.image = nil;
                [cell.hotelImageView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
                
                [self requestImageWithURLPath:[hotelDic safeObjectForKey:InterHotel_ListImgUrl]
                                  AtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            }else {
                [cell.hotelImageView endLoading];
                cell.hotelImageView.image = [tableImgeDict safeObjectForKey:hotelID];
            }
            
            // 选中时的背景图
            
            cell.haveImage = YES;
        }else{
            cell.haveImage = NO;
        }
        
        // 酒店返现
        if ([[hotelDic objectForKey:@"PromotionTag"] intValue] ==3) {
            if (!OBJECTISNULL([hotelDic objectForKey:@"DiscountTotal"])) {
                [cell setDiscountPrice:[[hotelDic objectForKey:@"DiscountTotal"] floatValue]/self.bookDays];
            }else{
                [cell setDiscountPrice:0];
            }
        }else{
            [cell setDiscountPrice:0];
        }
        
        //酒店送预付卡
        if ([[hotelDic objectForKey:@"PromotionTag"] intValue] ==4) {
            if (!OBJECTISNULL([hotelDic objectForKey:@"GiftCardAmount"])) {
                //此处金额跟房间数和间夜数没有关系，直接取值判断即可
                [cell setGiftCardPrice:[[hotelDic objectForKey:@"GiftCardAmount"] floatValue]];
            }else{
                [cell setGiftCardPrice:0];
            }
        }else{
            [cell setGiftCardPrice:0];
        }
        
        // 酒店星级
        NSString *hotelRating = [hotelDic safeObjectForKey:InterHotel_Rating];
        if (!OBJECTISNULL(hotelRating)) {
            [cell setHotelStar:hotelRating];
        }
        
        // 道道评论
        NSNumber *userRating = [hotelDic safeObjectForKey:InterHotel_UserRating];
        if (!OBJECTISNULL(userRating)) {
            [cell setDaodaoRating:[userRating floatValue]];
        }
        
        // 酒店地址
        cell.locationLabel.text = [NSString stringWithFormat:@"%@", [hotelDic safeObjectForKey:InterHotel_Location]];
        
        // 酒店实际价格
        double realPrice = 0;
        NSNumber *lowRate = [hotelDic safeObjectForKey:InterHotel_LowRate];
        if (!OBJECTISNULL(lowRate)) {
            realPrice = [lowRate floatValue];
        }
        
        [cell setPrice:(int)realPrice];
        
        // 酒店划价
        double promoPrice = 0;
        NSNumber *promoRate = [hotelDic safeObjectForKey:InterHotel_PromoRate];
        if (!OBJECTISNULL(promoRate)) {
            promoPrice = [promoRate floatValue];
            if (promoPrice == realPrice) {
                // 划价和现价相等的情况，不是9折，不显示
                promoPrice = 0;
            }
        }
        
        [cell setPromoPrice:promoPrice];
        
        // 促销信息显示
        NSDictionary *hotelProperty = [hotelDic safeObjectForKey:InterHotel_HotelProperty];
        if (DICTIONARYHASVALUE(hotelProperty)) {
            NSString *promotionDescription = [hotelProperty safeObjectForKey:InterHotel_PromoDescription];
            if (STRINGHASVALUE(promotionDescription)) {
                [cell showPromotionInfo:promotionDescription];
            }
            else {
                // 没有促销信息的cell矮一些
                [cell hiddenPromotionInfo];
            }
        }
        else {
            [cell hiddenPromotionInfo];
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellHeight = 0;
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    NSDictionary *hotelDic = [searcher.hotelList safeObjectAtIndex:indexPath.row];
    NSDictionary *hotelProperty = [hotelDic safeObjectForKey:InterHotel_HotelProperty];
    if (DICTIONARYHASVALUE(hotelProperty)) {
        NSString *promotionDescription = [hotelProperty safeObjectForKey:InterHotel_PromoDescription];
        if (STRINGHASVALUE(promotionDescription)) {
            cellHeight = 146;
        }
        else {
            // 没有促销信息的cell矮一些
            cellHeight = 126;
        }
    }
    else {
        cellHeight = 126;
    }
    
    return cellHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    return [searcher.hotelList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndexPath = indexPath;
    
    [_rootController cancelOrderView];
    
    InterHotelSearcher *interSearcher = [InterHotelSearcher shared];
    NSMutableDictionary *tmpDic = [interSearcher.hotelList safeObjectAtIndex:indexPath.row];
    
    [tmpDic safeSetObject:interSearcher.checkInDate forKey:Req_ArriveDate];     //额外新增入离日期
    [tmpDic safeSetObject:interSearcher.checkOutDate forKey:Req_DepartureDate];
     InterHotelDetailCtrl *interDetail = [[InterHotelDetailCtrl alloc] initWithDataDic:tmpDic];
    [self.rootController.navigationController pushViewController:interDetail animated:YES];
    [interDetail release];
}

#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_listTableView.tableFooterView && !isRequstMore) {
        // 当还有更多酒店时在滑到倒数第5行时发起请求
		NSArray *array = [_listTableView visibleCells];
        NSIndexPath *cellIndex = [_listTableView indexPathForCell:[array lastObject]];
        
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        if (cellIndex.row >= [searcher.hotelList count] - 5) {
            isRequstMore = YES;
            [self morehotel];
        }
	}
    
    NSInteger minCellNum = SCREEN_4_INCH ? 5 : 4;       // 少于这个数目的不做动画

    if (minCellNum < _hotelCount) {
        if (scrollView.contentOffset.y - moveY > 60) {
            if (!searchBarHidden) {
                searchBarHidden = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
                [UIView commitAnimations];

                moveY = scrollView.contentOffset.y;
            }

        }else if(scrollView.contentOffset.y - moveY < -50){
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];

                moveY = scrollView.contentOffset.y;
            }
        }
        if (scrollView.contentOffset.y <= 44) {
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];

                moveY = scrollView.contentOffset.y;
            }
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    beginDrag = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    beginDrag = NO;
}

- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(searchBarHidden){
        searchBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        }];
        moveY = scrollView.contentOffset.y;
    }
}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beginDrag = YES;
    moveY = scrollView.contentOffset.y;
}

@end
