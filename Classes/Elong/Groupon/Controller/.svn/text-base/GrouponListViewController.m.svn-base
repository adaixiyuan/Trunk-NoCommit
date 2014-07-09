//
//  GrouponListViewController.m
//  ElongClient
//
//  Created by Dawn on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponListViewController.h"
#import "GrouponHomeViewController.h"
#import "GrouponItemCell.h"
#import "GListRequest.h"
#import "GrouponFavorite.h"

static int TABLE_HEIGHT		= 120;

@interface GrouponListViewController ()


@property (nonatomic, retain) NSOperationQueue      *queue;             // 图片下载队列
@property (nonatomic, assign) NSInteger             moveY;              // 标记列表滚动位置
@property (nonatomic, assign) BOOL                  searchBarHidden;    // 搜索框是否隐藏

@end

@implementation GrouponListViewController
@synthesize homeVC;
@synthesize imageDic;
@synthesize progressDic;
@synthesize moveY;
@synthesize searchBarHidden;
@synthesize listView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
    // 移除所有已经下载的图片
    [imageDic removeAllObjects];
	
    // 终止当前图片下载队列中的图片下载
	NSArray *allDownloads = [progressDic allValues];
	[allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	[progressDic removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.queue cancelAllOperations];
    
    self.progressDic = nil;
    self.queue = nil;
    self.imageDic=nil;
    listView.delegate=nil;
    
    [_keywordVC release];
    [tableFootView release];
    [moreHotelButton release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
    
    // 存放下载的图片数据
	NSMutableDictionary *mDic	= [[NSMutableDictionary alloc] initWithCapacity:2];
	self.imageDic				= mDic;
	[mDic release];
	
    // 图片下载队列
	self.progressDic	= [NSMutableDictionary dictionaryWithCapacity:0];
    NSOperationQueue *tqueue = [[NSOperationQueue alloc] init];
	self.queue = tqueue;
    [tqueue release];

    // 团购列表
    listView				= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain];
    listView.dataSource		= self;
    listView.delegate		= self;
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.backgroundColor = [UIColor clearColor];
    
    // 团购列表顶部提示栏
    UIImageView *listHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 * 2)];
    listHeadView.image = [UIImage noCacheImageNamed:@"groupon_list_topbar.png"];
    listHeadView.contentMode = UIViewContentModeBottomRight;
    listView.tableHeaderView = listHeadView;
    [listHeadView release];
    
    // 加载更多按钮
    [self makeMoreLoadingView];
    
    if (NO == [self isLastPage]) {
        // 显示更多按钮
        listView.tableFooterView = moreButtonView;
    }else{
        listView.tableFooterView = nil;
    }
    
    [self.view addSubview:listView];
    [listView release];
    
    // 关键词搜索
    [self addSearchBar];
    
    if (UMENG) {
        //团购酒店列表页面
        [MobClick event:Event_GrouponHotelList];
    }
}

- (void)makeMoreLoadingView
{
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
    [moreHotelButton addTarget:self action:@selector(requestForNextPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keywordVC.searchBar.text = self.homeVC.keyword;
}

#pragma mark -
#pragma mark PrivateMethods

- (void) addSearchBar
{
    self.keywordVC = [[[GrouponKeywordViewController alloc] initWithSearchCity:homeVC.currentGrouponCity contentsController:self] autorelease];
    self.keywordVC.delegate = self;
    self.keywordVC.withNavHidden = YES;
    self.keywordVC.viewController = self.homeVC;
    self.keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.keywordVC.searchList.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    self.keywordVC.withNavHidden = YES;
    self.keywordVC.searchBar.translucent = NO;
    self.keywordVC.searchBar.clipsToBounds = NO;
    
    [self.view addSubview:self.keywordVC.searchBar];
}

// 判断是否是最后一页
- (BOOL)isLastPage
{
    if(homeVC.grouponDic == nil){
        return YES;
    }
	if ([[homeVC.grouponDic safeObjectForKey:ALLPAGECOUNT] intValue] == 0)
    {
		return YES;
	}
	
	return [[homeVC.grouponDic safeObjectForKey:ALLPAGECOUNT] isEqual:[homeVC.grouponDic safeObjectForKey:CURPAGEINDEX]];
}

// 为每个酒店页填充数据
- (void)setDataAtIndex:(NSInteger)index ForView:(GrouponItemCell *)gView
{
    if (index < [homeVC.allGroupons count]) {
        NSDictionary *gDic = [homeVC.allGroupons safeObjectAtIndex:index];
        
        // 设置星级
        NSArray *infoArray = [gDic safeObjectForKey:HOTELDETAILINFOS_RESP];
        
        if ([infoArray isKindOfClass:[NSArray class]]) {
            if ([infoArray count] > 1) {
                // 多家店的情况，不显示星级
                [gView setStarLbl:[[[infoArray safeObjectAtIndex:0] safeObjectForKey:STAR_RESP] intValue]];
            }
            else if ([infoArray count] == 1) {
                int starLevel = [[[infoArray safeObjectAtIndex:0] safeObjectForKey:STAR_RESP] intValue];
                if (starLevel < 3) {
                    starLevel = 0;
                }
                [gView setStarLbl:starLevel];
            }
            else {
                // 没有值时显示无星级
                [gView setStarLbl:0];
            }
        }
        else {
            // 数据出错，显示无星级
            [gView setStarLbl:0];
        }
        
        // 设置酒店名
        [gView setHotelName:[NSString stringWithFormat:@"%@", [gDic safeObjectForKey:PRODNAME_GROUPON]]];
        
        // 设置团购卖价
        [gView setSalePrice:[NSString stringWithFormat:@"%@",[[gDic safeObjectForKey:SALEPRICE_GROUPON] roundNumberToString]]];
        
        //设置附加信息
        [gView setGrouponAddtionInfoLbl:[gDic safeObjectForKey:@"HotelServices"]];
        
        // 设置团购数量
        int grouponNum = 0;
        if (!OBJECTISNULL([gDic safeObjectForKey:SALENUMS_GROUPON])) {
            grouponNum = [[gDic safeObjectForKey:SALENUMS_GROUPON] intValue];
        }
        
        if (grouponNum == 0) {
            [gView setGrouponNum:@"抢购第一单"];
        }else{
            [gView setGrouponNum:[NSString stringWithFormat:@"%@人已购买",[gDic safeObjectForKey:SALENUMS_GROUPON]]];
        }
        
        double salePrice = [[gDic safeObjectForKey:SALEPRICE_GROUPON] doubleValue];
        double originalPrice = [[gDic safeObjectForKey:SHOWPRICE_GROUPON] doubleValue];
        
        if (salePrice<originalPrice) {
            // 原价
            [gView setOrgPrice:[NSString stringWithFormat:@"%@",[[gDic safeObjectForKey:SHOWPRICE_GROUPON] roundNumberToString]]];
        }
        else
        {
            [gView setOrgPrice:@""];
        }

        
        //手机专项
        int mobileProductType=[[gDic safeObjectForKey:MOBILEPRODUCTTYPE_GROUPON] intValue];
        [gView setDiscountImgTmp:mobileProductType==1];
        
        // 设置地标
        NSArray *detailInfoArray = [gDic safeObjectForKey:@"HotelDetailInfos"];
        NSMutableString *hotelAreaString = [NSMutableString stringWithCapacity:2];
        if (ARRAYHASVALUE(detailInfoArray)) {
            NSDictionary *districtDic = [detailInfoArray safeObjectAtIndex:0];
            
            GListRequest *requst = [GListRequest shared];
            if([requst isPosition]){
                
                float curScope=[[gDic safeObjectForKey:@"Scope"] floatValue];
                
                if (curScope>0)
                {
                    float distance = curScope * 1000;
                    if (distance < 100) {
                        [hotelAreaString appendFormat:@"距离%.f米",distance];
                    }else{
                        [hotelAreaString appendFormat:@"距离%.1f公里",distance/1000];
                    }
                }
            }else{
                if (DICTIONARYHASVALUE(districtDic)) {
                    NSString *districtName = [districtDic safeObjectForKey:@"DistrictName"];
                    if (STRINGHASVALUE(districtName)) {
                        [hotelAreaString appendString:districtName];
                    }
                    
                    NSString *bizSectionName = [districtDic safeObjectForKey:@"BizSectionName"];
                    if (STRINGHASVALUE(bizSectionName)) {
                        [hotelAreaString appendFormat:@" %@", bizSectionName];
                    }
                }
            }
        }
        
        [gView setPoi:hotelAreaString];
        
        
        gView.hotelId               = [NSString stringWithFormat:@"%@", [gDic safeObjectForKey:PRODID_GROUPON]];
        
        NSString *imgKey = [NSString stringWithFormat:@"%@", [gDic safeObjectForKey:PRODID_GROUPON]];
        UIImage *image = [imageDic safeObjectForKey:imgKey];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [gView.hotelImageView endLoading];
            
            gView.hotelImageView.image = image;
        }
        else {
            gView.hotelImageView.image = nil;
            [gView.hotelImageView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
            [self requestImageWithURLPath:[gDic safeObjectForKey:PHOTOURL_GROUPON]
                                 ImageKey:imgKey
                              AtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }
}

// 为相应的团购产品填充图片
- (void)setImageByInfo:(NSDictionary *)infoDic
{
	UIImage *image          = [infoDic safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [infoDic safeObjectForKey:keyForPath];
	NSString *imageKey		= [infoDic safeObjectForKey:keyForName];
	
    if (image && indexPath && imageKey) {
        [imageDic safeSetObject:image forKey:imageKey];
        NSInteger index	= indexPath.row;
        GrouponItemCell *cell	= (GrouponItemCell *)[listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if (cell) {
            [cell.hotelImageView endLoading];
            cell.hotelImageView.image	= image;
        }
    }
}

// 请求指定地址的图片
- (void)requestImageWithURLPath:(NSString *)path ImageKey:(NSString *)imgKey AtIndexPath:(NSIndexPath *)indexPath
{
	// 从url请求图片
	if (STRINGHASVALUE(path) && ![progressDic safeObjectForKey:imgKey]) {
		// 过滤重复请求
		ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:imgKey indexPath:indexPath];
		[self.queue addOperation:downLoader];
		downLoader.delegate		= self;
        downLoader.doDiskCache  = YES;
		downLoader.noDataImage	= [UIImage imageNamed:@"hotel_detail_image.png"];
		[progressDic safeSetObject:downLoader forKey:imgKey];
		[downLoader release];
	}
}

- (void)requestForNextPage
{
    listView.tableFooterView = tableFootView;
    [homeVC requestForNextPage];
}

- (void)resetListFooterView
{
    listView.tableFooterView = moreHotelButton;
}

#pragma mark -
#pragma mark PublicMethods
- (void)reloadList
{
    [listView reloadData];
    
    if (NO == [self isLastPage]) {
		listView.tableFooterView = tableFootView;
	}
	else {
		listView.tableFooterView = nil;
	}

    if([homeVC.allGroupons count]){
        // 显示topbar
        listView.tableHeaderView.hidden = NO;
    }else{
        // 隐藏topbar 显示keyword
        listView.tableHeaderView.hidden = YES;
        [self resetKeywordBar];
    }
}

- (void)resetKeywordBar
{
    if(searchBarHidden)
    {
        searchBarHidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        self.keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [UIView commitAnimations];
        
        self.moveY = listView.contentOffset.y;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [homeVC.allGroupons count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"grouponItemCell";
	GrouponItemCell *cell		= [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell) {
        cell = [[[GrouponItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
	}
	
    // cell 赋值
	[self setDataAtIndex:indexPath.row ForView:cell];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return TABLE_HEIGHT;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selIndex = indexPath.row;
    NSDictionary *gDic = [homeVC.allGroupons safeObjectAtIndex:indexPath.row];
    [homeVC searchDetailInfoByHotelID:[gDic safeObjectForKey:PRODID_GROUPON]];
    
    UMENG_EVENT(UEvent_Groupon_List_DetailEnter)
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (listView.tableFooterView && !homeVC.moreRequest) {
        // 当还有更多酒店时在滑到倒数第5行时发起请求
		NSArray *array = [listView visibleCells];
        NSIndexPath *cellIndex = [listView indexPathForCell:[array lastObject]];
        
        if (cellIndex.row >= [homeVC.allGroupons count] - 5) {
            [homeVC requestForNextPage];
        }
	}

    NSInteger minCellNum = SCREEN_4_INCH ? 5 : 4;       // 少于这个数目的不做动画
    
    if (minCellNum < homeVC.allGroupons.count) {
        if (scrollView.contentOffset.y - self.moveY > 60) {
            if (!self.searchBarHidden) {
                self.searchBarHidden = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                self.keywordVC.searchBar.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
                self.moveY = scrollView.contentOffset.y;
            }
            
        }else if(scrollView.contentOffset.y - self.moveY < -50){
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                self.keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
                self.moveY = scrollView.contentOffset.y;
            }
        }
        if (scrollView.contentOffset.y <= 44) {
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                self.keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
               self.moveY = scrollView.contentOffset.y;
            }
        }
    }
}

- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if(searchBarHidden){
        searchBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        }];
        self.moveY = scrollView.contentOffset.y;
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.moveY = scrollView.contentOffset.y;
}

#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo
{
	[self performSelectorOnMainThread:@selector(setImageByInfo:) withObject:imageInfo waitUntilDone:NO];
}

#pragma mark -
#pragma mark GrouponKeywordViewControllerDelegate

- (void) grouponKeywordVCDidBeginEdit:(GrouponKeywordViewController *)grouponKeywordVC
{
    [listView setContentOffset:CGPointMake(0, 0)];
    listView.scrollEnabled = NO;
    
    // 切换城市重置数据
    if(![self.keywordVC.searchCity isEqualToString:homeVC.currentGrouponCity]){
        self.keywordVC.m_key = nil;
    }
    self.keywordVC.searchCity = homeVC.currentGrouponCity;
}

- (void) grouponKeywordVC:(GrouponKeywordViewController *)grouponKeywordVC didGetKeyword:(NSString *)keyword_ hitType:(int)hitType
{
    self.keywordVC.searchBar.text = keyword_;
    listView.scrollEnabled = YES;
    
    [self.homeVC searchGrouponWithKeyword:keyword_ hitType:hitType];
    
    UMENG_EVENT(UEvent_Groupon_List_Keyword)
}

- (void) grouponKeywordVC:(GrouponKeywordViewController *)grouponKeywordVC cancelWithContent:(NSString *)content
{
    listView.scrollEnabled = YES;
    
    if (STRINGHASVALUE(content)) {
        self.homeVC.keyword = content;
    }else{
        if (![self.homeVC.keyword isEqualToString:@""] && self.homeVC.keyword!=nil) {
            self.homeVC.keyword = nil;
            
            // 清空记录
            [grouponKeywordVC cancelSearchCondition];
            //[hotelKeywordVC cancelSearchCondition];
            [self.homeVC searchGrouponWithKeyword:nil hitType:0];
        }
    }
}

@end
