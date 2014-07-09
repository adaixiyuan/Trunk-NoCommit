//
//  HotelFavorite.m
//  ElongClient
//
//  Created by WangHaibin on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define FLIGHT_CUSTOMER_CELL_HEIGHT 100
#define CHECKTAG		1011
#define DELHOTEL 0
#define DETAILHOTEL 1

#import "HotelFavorite.h"
#import "HotelConditionRequest.h"
#import "StarsView.h"
#import "HtmlStandbyViewController.h"
#import "DefineHotelReq.h"
#import "DefineHotelResp.h"
#import "MyElongCenter.h"
#import "UIImageView+WebCache.h"
#import "HotelListCell.h"
#import "RoundCornerView+WebCache.h"
#import "HotelPromotionInfoRequest.h"

@interface HotelFavorite()
@property (nonatomic,retain) UIButton *morebutton;
@property (nonatomic,retain) NSIndexPath *selectIndexPath;
@property (nonatomic,assign) BOOL category;
@property (nonatomic,retain) NSMutableArray *hotelArray;
@property (nonatomic,retain) NSArray *sortCityArray;
@property (nonatomic,retain) NSMutableArray *sortIndexArray;
@end

@implementation HotelFavorite
@synthesize totalCount = _totalCount;
@synthesize morebutton;
@synthesize category;
@synthesize hotelArray;


@synthesize isSkipLogin;

- (void) dealloc{
    self.morebutton = nil;
    self.selectIndexPath = nil;
    self.hotelArray = nil;
    self.sortCityArray = nil;
    self.sortIndexArray = nil;
    if (moreFavRequest) {
        [moreFavRequest cancel];
        [moreFavRequest release],moreFavRequest = nil;
    }
    [super dealloc];
}

- (id)initWithEditStyle:(BOOL)canEdit{
	return [self initWithEditStyle:canEdit category:NO];
}

- (id) initWithEditStyle:(BOOL)canEdit category:(BOOL)category_{
    if (self = [super initWithTopImagePath:nil andTitle:@"收藏酒店" style:_NavOnlyBackBtnStyle_]) {
		editState = canEdit;
		self.isSkipLogin = NO;
        self.category = category_;
        self.hotelArray = [NSMutableArray array];
        
        if (self.category) {
            NSArray *favhotels = [MyElongCenter allHotelFInfo];
            NSMutableArray *cityArray = [NSMutableArray array];
            
            for (NSDictionary *dict in favhotels) {
                if ([dict objectForKey:@"CityName"]) {
                    if (![cityArray containsObject:[dict objectForKey:@"CityName"]]) {
                        [cityArray addObject:[dict objectForKey:@"CityName"]];
                    }
                }
            }
            
            NSLog(@"%@",cityArray);
            self.sortCityArray = [cityArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 localizedCaseInsensitiveCompare:obj2];
            }];
            
            self.sortIndexArray = [NSMutableArray array];
            for (NSString *city in self.sortCityArray) {
                if (city.length>1) {
                    [self.sortIndexArray addObject:[city substringToIndex:2]];
                }
            }
            
            for (NSString *city in self.sortCityArray) {
                NSMutableDictionary *hotelDict = [NSMutableDictionary dictionary];
                [hotelDict setObject:city forKey:@"CityName"];
                
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *dict in favhotels) {
                    if ([[dict objectForKey:@"CityName"] isEqualToString:city]) {
                        [list addObject:dict];
                    }
                }
                [hotelDict setObject:list forKey:@"CityList"];
                
                [self.hotelArray addObject:hotelDict];
            }
            
            // 去最近收藏5个
            if (favhotels.count) {
                NSMutableDictionary *hotelDict = [NSMutableDictionary dictionary];
                [hotelDict setObject:@"最新收藏" forKey:@"CityName"];
                NSMutableArray *list = [NSMutableArray array];
            
                for (int i = 0; i < 5 && i < favhotels.count; i++) {
                    NSDictionary *dict = [favhotels objectAtIndex:i];
                    [list addObject:dict];
                }
                
                [hotelDict setObject:list forKey:@"CityList"];
                
                [self.hotelArray insertObject:hotelDict atIndex:0];
                
                [self.sortIndexArray insertObject:@"最新" atIndex:0];
            }
            
        }
        
        [favoriteTableView reloadData];
        
        [self performSelector:@selector(layoutTableView) withObject:nil afterDelay:0.3];
		
		if ([[MyElongCenter allHotelFInfo] count]!=0 && editState) {
			self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
		}
	}
	
	return self;
}

- (void)back
{
	if (isSkipLogin) {
		NSArray *navCtrls = self.navigationController.viewControllers;
		[self.navigationController popToViewController:[navCtrls safeObjectAtIndex:[navCtrls count] - 3] animated:YES];
	}
	else {
		[super back];
	}
}

-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width
{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	
	return expectedLabelSize.height;
	
}

-(void)clickNavRightBtn{
	[favoriteTableView setEditing:!favoriteTableView.editing animated:YES];

	if (favoriteTableView.editing) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(clickNavRightBtn)];
	}else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
	}
	
	[self refreshNavRightBtnStatus];
}

-(void) refreshNavRightBtnStatus
{
    NSInteger sectionNum = [self numberOfSectionsInTableView:favoriteTableView];
    NSInteger totalNum = 0;
    for (int i = 0; i < sectionNum; i++) {
        totalNum += [self tableView:favoriteTableView numberOfRowsInSection:i];
    }
    if (totalNum > 0) {
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        favoriteTableView.hidden = YES;
        m_blogView.hidden = NO;
    }
}

- (void)setTabViewHeight
{
	int tabHeight = 0;
	if ([MyElongCenter allHotelFInfo] != nil && [[MyElongCenter allHotelFInfo] count] > 0) {
		if ([[MyElongCenter allHotelFInfo] count] <= 4) {
			tabHeight = FLIGHT_CUSTOMER_CELL_HEIGHT *[[MyElongCenter allHotelFInfo] count];
		} else {
			tabHeight = FLIGHT_CUSTOMER_CELL_HEIGHT *4;
		}
		favoriteTableView.frame = CGRectMake(5, 12, 310, tabHeight);
	}
	if ([[MyElongCenter allHotelFInfo] count] == 0) {
		favoriteTableView.frame = CGRectMake(5, 12, 310, 0);
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
	
}

-(void)ChangeTextlableColor
{
	UILabel* lable = (UILabel*)[[self.navigationItem.rightBarButtonItem customView]  viewWithTag:10];
	lable.textColor = [UIColor whiteColor];
	
}

-(void)clickLogoutDrag
{
	UILabel* lable = (UILabel*)[[self.navigationItem.rightBarButtonItem customView]  viewWithTag:10];
	lable.textColor = COLOR_NAV_TITLE;
	
	
}

-(void)viewDidLoad
{
	[super viewDidLoad];
    
	//table view
	favoriteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
	favoriteTableView.delegate = self;
	favoriteTableView.dataSource = self;
	favoriteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//    if (IOSVersion_7) {
//        favoriteTableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    }

	[self.view addSubview:favoriteTableView];
	
	m_blogView = [Utils addView:@"您还未收藏酒店"];

	[self.view addSubview:m_blogView];
	
	[favoriteTableView reloadData];
	[self refreshNavRightBtnStatus];

	currentRow = -1;

}

- (void) layoutTableView{
    if (IOSVersion_7) {
        for (UIView *view in favoriteTableView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
                if ([view respondsToSelector:@selector(setFont:)]) {
                    [view performSelector:@selector(setFont:) withObject:[UIFont boldSystemFontOfSize:11.0f]];
                    [favoriteTableView reloadData];
                }
            }
        }
    }
}

- (void) viewDidAppear:(BOOL)animated{
    if (self.selectIndexPath) {
        [favoriteTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

- (void) setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
     //HotelFavoriteRequest *jghf=[HotelPostManager favorite];
    
    /*
    if ([[MyElongCenter allHotelFInfo] count] < self.totalCount && [[MyElongCenter allHotelFInfo] count] > 0 && [[MyElongCenter allHotelFInfo] count] >= jghf.pageSize) {
        self.morebutton = [UIButton uniformMoreButtonWithTitle:@"更多酒店订单"
                                                        Target:self
                                                        Action:@selector(clickMorehotel:)
                                                         Frame:CGRectMake(0, 0, 320, 44)];
        favoriteTableView.tableFooterView = self.morebutton;
    }
     */

}

- (void)clickMorehotel:(id)sender{
    //更多收藏
    HotelFavoriteRequest *jghf=[HotelPostManager favorite];
    [jghf nextPage];
    
    if (moreFavRequest) {
        [moreFavRequest cancel];
        [moreFavRequest release],moreFavRequest = nil;
    }
    moreFavRequest = [[HttpUtil alloc] init];
    
    [moreFavRequest connectWithURLString:HOTELSEARCH
                             Content:[jghf request]
                        StartLoading:YES
                          EndLoading:YES
                            Delegate:self];
}

#pragma mark -------
#pragma mark Table Data Source Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.category) {
        return self.hotelArray.count;
    }else{
        return 1;
    }
}

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.sortIndexArray;
//}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if ([MyElongCenter allHotelFInfo] == nil || [[MyElongCenter allHotelFInfo] count] == 0) {
		m_blogView.hidden = NO;
		if (!favoriteTableView.editing) {
			[self.navigationItem.rightBarButtonItem.customView setHidden:YES];
		}
		return 0;
	}
	m_blogView.hidden = YES;
	[self.navigationItem.rightBarButtonItem.customView setHidden:NO];

    if (self.category) {
        return [[[self.hotelArray objectAtIndex:section] objectForKey:@"CityList"] count];
    }
	return [[MyElongCenter allHotelFInfo] count];
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.category) {
        return 20;
    }else{
        return 0;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.category) {
        UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        cityView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
        UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 20)];
        cityLbl.backgroundColor=[UIColor clearColor];
        cityLbl.text= [self tableView:tableView titleForHeaderInSection:section];
        cityLbl.font= FONT_B15;
        cityLbl.textColor =  RGBACOLOR(52, 52, 52, 1);
        cityLbl.textAlignment=UITextAlignmentLeft;
        [cityView addSubview:cityLbl];
        [cityLbl release];
        
        return [cityView autorelease];
    }else{
        return nil;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.hotelArray.count) {
        return [[self.hotelArray objectAtIndex:section] objectForKey:@"CityName"];
    }else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * favoriteTableCellidentifier = @"favoriteTableCellidentifier";
    HotelListCell *cell =(HotelListCell *) [tableView dequeueReusableCellWithIdentifier:favoriteTableCellidentifier];
    BOOL showImage = [[SettingManager instanse] defaultDisplayHotelPic];
    if (cell == nil) {
        cell = [[[HotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favoriteTableCellidentifier haveImage:showImage] autorelease];
        cell.backPriceLbl.hidden = YES;
        cell.backImageView.hidden = YES;
        cell.priceEndLbl.hidden = YES;
        cell.originalPriceLbl.hidden = YES;
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.dashView.hidden = YES;
    }else{
        cell.dashView.hidden = NO;
    }

	NSUInteger row = [indexPath row];
	NSDictionary *customer = nil;
    if (self.category) {
        customer = [[[self.hotelArray objectAtIndex:indexPath.section] objectForKey:@"CityList"] objectAtIndex:indexPath.row];
    }else{
        customer = [[MyElongCenter allHotelFInfo] safeObjectAtIndex:row];
    }
    
    cell.hotelNameLbl.text = [NSString stringWithFormat:@"%@", [customer safeObjectForKey:@"HotelName"]];
	
	if (showImage) {
        NSString *imageUrl = [customer objectForKey:@"PicUrl"];
        [cell.hotelImageView setImageWithURL:[NSURL URLWithString:imageUrl]
                            placeholderImage:[UIImage imageNamed:@"bg_nohotelpic.png"]
                                     options:SDWebImageCacheMemoryOnly];
    }
	
    // 设置星级
    int starlevel=[[customer safeObjectForKey:NEWSTAR_CODE] intValue];
    [cell setStar:starlevel];
    
    // 计算好评率 四舍五入
    int goodComment = [[customer safeObjectForKey:@"GoodComment"] intValue];
    int badComment = [[customer safeObjectForKey:@"BadComment"] intValue];
    
    cell.commentLbl.hidden=NO;
    if ([customer safeObjectForKey:@"CommentPoint"]&&[customer safeObjectForKey:@"CommentPoint"]!=[NSNull null])
    {
        float commentPoint = [[customer safeObjectForKey:@"CommentPoint"] floatValue];
        
        if (commentPoint>0)
        {
            cell.commentLbl.text=[PublicMethods getCommentDespLogic:goodComment badComment:badComment comentPoint:[[customer safeObjectForKey:@"CommentPoint"] floatValue]];
        }
        else
        {
            cell.commentLbl.text=[PublicMethods getCommentDespOldLogic:goodComment badComment:badComment];
            cell.commentLbl.hidden=YES;
        }
    }
    else
    {
        cell.commentLbl.text=[PublicMethods getCommentDespOldLogic:goodComment badComment:badComment];
    }
    
    // 特殊处理
    cell.starLbl.text = [NSString stringWithFormat:@"%@  %@",cell.starLbl.text,cell.commentLbl.text];
    cell.commentLbl.text = @"";
	
    // 酒店设施 wifi和停车场
    cell.parkImageView.hidden = NO;
    cell.wifiImageView.hidden = NO;
    cell.parkImageView.image = nil;
    cell.wifiImageView.image = nil;
    if (([[customer safeObjectForKey:@"HotelFacilityCode"] integerValue] & 0x3) == 0) {
        cell.wifiImageView.image = nil;
    }
    else {
        cell.wifiImageView.image  = [UIImage noCacheImageNamed:@"hotellist_wifi.png"];
    }
    
    if (([[customer safeObjectForKey:@"HotelFacilityCode"] integerValue] & 0x30) == 0) {
        cell.parkImageView.image = nil;
    }
    else {
        if (cell.wifiImageView.image == nil) {
            cell.wifiImageView.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
        }else{
            cell.parkImageView.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
        }
    }
    
    // 没有坐标时显示所在区域
    if ([customer safeObjectForKey:@"DistrictAreaName"]!=[NSNull null]) {
        if([customer safeObjectForKey:@"BusinessAreaName"]!=[NSNull null] && [customer safeObjectForKey:@"BusinessAreaName"]){
            if ([[customer safeObjectForKey:@"DistrictAreaName"] isEqualToString:[customer safeObjectForKey:@"BusinessAreaName"]]) {
                cell.addressLbl.text= [NSString stringWithFormat:@"%@",[customer safeObjectForKey:@"DistrictAreaName"]];
            }else{
                cell.addressLbl.text= [NSString stringWithFormat:@"%@  %@",[customer safeObjectForKey:@"DistrictAreaName"],[customer safeObjectForKey:@"BusinessAreaName"]];
            }
        }else{
            cell.addressLbl.text= [NSString stringWithFormat:@"%@",[customer safeObjectForKey:@"DistrictAreaName"]];
        }
        
    }else {
        cell.addressLbl.text=@"";
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    
	HotelListCell *cell = (HotelListCell *)[tableView cellForRowAtIndexPath:indexPath];
	NSDictionary *customer = nil;
    if (self.category) {
        customer = [[[self.hotelArray objectAtIndex:indexPath.section] objectForKey:@"CityList"] objectAtIndex:indexPath.row];
    }else{
        customer = [[MyElongCenter allHotelFInfo] safeObjectAtIndex:indexPath.row];
    }
    
	if ([ProcessSwitcher shared].hotelHtml5On) {
        // 走html预备流程
        CFStringRef cfResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                       (CFStringRef)cell.hotelNameLbl.text,
                                                                       NULL,
                                                                       CFSTR("&=@;!'*#%-,:/()<>[]{}?+ "),
                                                                       kCFStringEncodingUTF8);
        NSString *result = [NSString stringWithString:(NSString *)cfResult];
        CFRelease(cfResult);
        HtmlStandbyViewController *standyVC = [[HtmlStandbyViewController alloc] initWithHotelOrderwithHotelName:result];
        [self.navigationController pushViewController:standyVC animated:YES];
        [standyVC release];
        return;
    }
    
    // 查询的酒店详情
    NSDictionary *hotel = customer;
    NSString *hotelId = [hotel safeObjectForKey:@"HotelId"];
    
    // 获取入离店日期
    NSString *CheckonDate = nil;
    NSString *CheckoutDate = nil;
    
    if (CheckonDate == nil) {
        CheckonDate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
        CheckoutDate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
    }
    
    if ([hotel safeObjectForKey:@"HotelSpecialType"]) {
        isSevenDay = YES;
    }
    
    BOOL isUnsined= NO;
    
    if ([hotel safeObjectForKey:@"IsUnsigned"]&&[hotel safeObjectForKey:@"IsUnsigned"]!=[NSNull null])
    {
        isUnsined=[[hotel safeObjectForKey:@"IsUnsigned"] boolValue];
    }
    
    [self hoteldetail:hotelId CheckInDate:CheckonDate CheckOutDate:CheckoutDate isUnsigned:isUnsined];
}

-(void)hoteldetail:(NSString *)hotelId CheckInDate:(NSString *)checkInDate CheckOutDate:(NSString *)checkOutDate isUnsigned:(BOOL) isUnsigned
{
	linktype = DETAILHOTEL;
	
	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    [hoteldetail setIsUnsigned:isUnsigned];
    if (isSevenDay) {
        [hoteldetail setSevenDay:YES];
    }
	[hoteldetail setCheckDate:checkInDate checkoutdate:checkOutDate];
    
	[Utils request:HOTELSEARCH req:[hoteldetail requesString:YES] policy:CachePolicyHotelDetail  delegate:self];
    
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.checkinDate = checkInDate;
    promotionInfoRequest.checkoutDate = checkOutDate;
}

- (void)goHotelDetail{
    HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
    [self.navigationController pushViewController:hoteldetail animated:YES];
    [hoteldetail release];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
		favoriteTableView.tableFooterView) {
		// 滚到底向上拉，并且有更多按钮时，申请更多数据
		[self clickMorehotel:nil];
	}
}

#pragma mark ------
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
    
    currentRow = row;
	
	//Post delete
	JDeleteHotelFavorite *jdelHF=[MyElongPostManager deleteHF];
	[jdelHF clearBuildData];
    
    NSDictionary *customer = nil;
    if (self.category) {
        customer = [[[self.hotelArray objectAtIndex:indexPath.section] objectForKey:@"CityList"] objectAtIndex:indexPath.row];
    }else{
        customer = [[MyElongCenter allHotelFInfo] safeObjectAtIndex:row];
    }
	[jdelHF setHotelId:[customer safeObjectForKey:@"HotelId"]];
	
    linktype = DELHOTEL;
    [Utils request:HOTELSEARCH req:[jdelHF requesString:NO] delegate:self disablePop:YES disableClosePop:YES disableWait:YES];
	
    // 删除
    if (self.category) {
        
        NSMutableArray *indexPathArray = [NSMutableArray array];
        NSMutableArray *removeArray = [NSMutableArray array];
        NSString *hotelId = [customer safeObjectForKey:@"HotelId"];
        for (NSDictionary *city in self.hotelArray) {
            for (NSDictionary *hotel in [city objectForKey:@"CityList"]) {
                if ([[hotel objectForKey:@"HotelId"] isEqualToString:hotelId]) {
                    NSInteger row = [[city objectForKey:@"CityList"] indexOfObject:hotel];
                    NSInteger section = [self.hotelArray indexOfObject:city];
                    [indexPathArray addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                    [removeArray addObject:hotel];
                }
            }
        }
        
        for (NSDictionary *city in self.hotelArray){
            for (NSDictionary *hotel in removeArray) {
                [[city objectForKey:@"CityList"] removeObject:hotel];
            }
        }
        
        
        [tableView beginUpdates];
        [favoriteTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        
        //[favoriteTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [[MyElongCenter allHotelFInfo] removeObjectAtIndex:currentRow];
        [favoriteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    
    
    [self refreshNavRightBtnStatus];
	
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    if (self.selectIndexPath) {
        [favoriteTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if (self.selectIndexPath) {
        [favoriteTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    if (util == moreFavRequest) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([root objectForKey:@"HotelFavorites"] == [NSNull null]) {
            
        }else {
            
            NSArray *mHFavorites = [root objectForKey:@"HotelFavorites"];
            [[MyElongCenter allHotelFInfo] addObjectsFromArray:mHFavorites];
            
            if ([[MyElongCenter allHotelFInfo] count] < self.totalCount && mHFavorites.count) {
                favoriteTableView.tableFooterView = self.morebutton;
            }else{
                favoriteTableView.tableFooterView = nil;
            }
            
            [favoriteTableView reloadData];
        }
    }else{
        if (linktype == DELHOTEL) {
            NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
            NSDictionary *root = [string JSONValue];
            
            if ([Utils checkJsonIsError:root]) {
                return ;
            }
            
        }else if(linktype == DETAILHOTEL){
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            if ([Utils checkJsonIsError:root]) {
                return ;
            }
            
            if ([[root objectForKey:HOTELID_REQ] isEqual:[NSNull null]]) {
                [PublicMethods showAlertTitle:@"酒店信息已过期" Message:nil];
                return;
            }
            
            [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
            [[HotelDetailController hoteldetail] removeRepeatingImage];
            
            HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
            promotionInfoRequest.orderEntrance = OrderEntranceFav;
            promotionInfoRequest.hotelId = [root safeObjectForKey:@"HotelId"];
            promotionInfoRequest.hotelName = [root safeObjectForKey:@"HotelName"];
            promotionInfoRequest.cityName = [root safeObjectForKey:@"CityName"];
            promotionInfoRequest.star = [root safeObjectForKey:@"NewStarCode"];
            
            [self goHotelDetail];
            
            
        }
    }
    
}

@end
