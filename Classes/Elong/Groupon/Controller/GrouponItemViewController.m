//
//  GrouponItemViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponItemViewController.h"
#import "GrouponDetailViewController.h"
#import "GrouponMapViewController.h"
#import "GrouponCommentViewController.h"
#import "HotelInfoViewController.h"

@interface GrouponItemViewController ()
@property (nonatomic,assign) GrouponItemStyle itemStyle;
@property (nonatomic,assign) NSArray *hotelArray;
@property (nonatomic,copy) NSString *phoneNum;
@end

@implementation GrouponItemViewController
@synthesize detailDic;
@synthesize itemStyle;
@synthesize hotelArray;
@synthesize phoneNum;
@synthesize parentVC;

- (void)dealloc{
    self.phoneNum = nil;
    
    if (hoteldetailRequest) {
        [hoteldetailRequest cancel];
        [hoteldetailRequest release],
        hoteldetailRequest = nil;
    }
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary style:(GrouponItemStyle)grouponStyle{
	if (self = [super init:@"" style:_NavNoTelStyle_]){
        self.detailDic = dictionary;
        self.itemStyle = grouponStyle;
        self.hotelArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
        
        // 酒店名，星级，分享等
        [self addNavigationBarView];
        
        //
        hotelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20) style:UITableViewStylePlain];
        hotelList.delegate = self;
        hotelList.dataSource = self;
        hotelList.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:hotelList];
        [hotelList release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

// 构造导航栏和分享按钮
- (void)addNavigationBarView {
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, NAVIGATION_BAR_HEIGHT)];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:topView.bounds];
	titleLabel.backgroundColor	= [UIColor clearColor];
	titleLabel.textAlignment	= UITextAlignmentCenter;
	titleLabel.textColor		= [UIColor blackColor];
    
	titleLabel.text				= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
	titleLabel.text = [titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.numberOfLines	= 0;
	titleLabel.minimumFontSize	= 12;
	titleLabel.font				= [UIFont boldSystemFontOfSize:16];
	[topView addSubview:titleLabel];
	[titleLabel release];
    
//    NSArray *storeArray = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
//    
//    int statlevel = [[[storeArray  safeObjectAtIndex:0] safeObjectForKey:STAR_RESP] intValue];
//	if (statlevel < 3) {
//		statlevel = 0;
//	}
//	NSString *imgPath = @"star_ico.png";
//	if (statlevel > 0) {
//		// 有星级时，显示星级
//		BOOL isHalfLevel = NO;			// 是否有半星级的情况,只有艺龙评级会出现
//		if (statlevel > 10) {
//			isHalfLevel = statlevel % 10 == 5 ? YES : NO;
//			statlevel	= round(statlevel / 10.f);
//			imgPath		= @"elong_star.png";
//		}
//		
//		UIView *starBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13.6 * statlevel, 11)];
//		for (int i = 0; i < statlevel; i ++) {
//			UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(15 * i, 0, 11, 11)];
//			starImg.image = [UIImage imageNamed:imgPath];
//			[starBackView addSubview:starImg];
//			[starImg release];
//			
//			if (isHalfLevel && i == statlevel - 1) {
//				// 换掉最后一张图
//				starImg.image = [UIImage imageNamed:@"elong_star_half.png"];
//			}
//		}
//		
//		[topView addSubview:starBackView];
//		titleLabel.frame = CGRectOffset(titleLabel.frame, 0, -6);
//		titleLabel.numberOfLines = 1;
//		starBackView.center = CGPointMake(topView.center.x, topView.center.y + 11);
//		[starBackView release];
//	}
	
	self.navigationItem.titleView = topView;
	[topView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    
    return self.hotelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIImageView *splitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        splitView.frame = CGRectMake(0, cell.frame.size.height- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        splitView.contentMode=UIViewContentModeScaleToFill;
        [cell addSubview:splitView];
        [splitView release];
    }
    
    cell.textLabel.text = [[self.hotelArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"StoreName"];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemStyle == GrouponPhoneItem) {
        [self callPhoneAtIndex:indexPath.row];
    }else if(self.itemStyle == GrouponMapItem){
        NSDictionary *locationDic = [self.hotelArray safeObjectAtIndex:indexPath.row];
        double latitude		= [[locationDic safeObjectForKey:@"Latitude"] doubleValue];
        double longtitude	= [[locationDic safeObjectForKey:@"Longitude"] doubleValue];
        
        CLLocationCoordinate2D centerCoodinate;
        centerCoodinate.latitude  = latitude;
        centerCoodinate.longitude = longtitude;
        self.parentVC.publiccenterCoodinate = centerCoodinate;
        if (latitude == 0 && longtitude == 0) {
             [Utils alert:@"未找到该酒店位置信息"];
        }else{
            GrouponMapViewController *mapVC = [[GrouponMapViewController alloc] initWithDictionary:locationDic latitude:latitude longitude:longtitude];
            [self.navigationController pushViewController:mapVC animated:YES];
            [mapVC release];
            
            UMENG_EVENT(UEvent_Groupon_Detail_Map)
        }
        
    }else if(self.itemStyle == GrouponCommentItem){
        NSString *hotelId = [[self.hotelArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"RelHotelID"];
        if (hotelId && ![hotelId isEqualToString:@""]) {
            GrouponCommentViewController *commentVC = [[GrouponCommentViewController alloc] initWithDictionary:self.detailDic hotelId:hotelId];
            [self.navigationController pushViewController:commentVC animated:YES];
            [commentVC release];
            
            UMENG_EVENT(UEvent_Groupon_Detail_Comment)
        }else{
            [Utils alert:@"该酒店暂无评论"];
        }
    }
    //酒店详情
    else if(self.itemStyle == HotelDetailInfoItem)
    {
        NSString *hotelId = [[self.hotelArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"RelHotelID"];
        if (hotelId && ![hotelId isEqualToString:@""])
        {
            [self getHoteldetail:hotelId];
        }
        else
        {
            [Utils alert:@"该酒店暂无详情"];
        }
    }
}

// 点击电话按钮触发
- (void) callPhoneAtIndex:(NSInteger)index
{
    NSString *phoneStr = [[hotelArray safeObjectAtIndex:index] safeObjectForKey:@"Telephone"];
    NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
    if ([phoneArray count] > 0) {
        self.phoneNum = [phoneArray safeObjectAtIndex:0];
    }
    else {
        // 遇到正则表达式无法识别的电话，让用户去简介中拨打
        //titleLabel.text = [titleLabel.text stringByAppendingString:@"（预订电话请在简介中查询）"];
        self.phoneNum = nil;
    }
    
    if (self.phoneNum) {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:self.phoneNum,nil];
        menu.delegate = self;
        menu.actionSheetStyle = UIBarStyleBlackTranslucent;
        [menu showInView:appDelegate.window];
        [menu release];
    }else{
        [Utils alert:@"预约电话暂无，请使用在线预约，谢谢"];
    }
}

// 酒店详情网络请求
-(void) getHoteldetail:(NSString *)hotelId
{
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    NSDate *curDate=[NSDate date];
    NSString *checkInDate=[TimeUtils displayDateWithNSDate:[curDate dateByAddingTimeInterval:24*3600] formatter:@"yyyy-MM-dd"];//明天
    NSString *checkOutDate=[TimeUtils displayDateWithNSDate:[curDate dateByAddingTimeInterval:2*24*3600] formatter:@"yyyy-MM-dd"];//后天
	[hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
    
    if (hoteldetailRequest) {
        [hoteldetailRequest cancel];
        [hoteldetailRequest release],hoteldetailRequest = nil;
    }
    
    hoteldetailRequest = [[HttpUtil alloc] init];
    [hoteldetailRequest sendSynchronousRequest:HOTELSEARCH PostContent:[hoteldetail requesString:YES] CachePolicy:CachePolicyHotelDetail Delegate:self];
}


#pragma mark -
#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex==0) {
		NSString *urlString = [NSString stringWithFormat:@"tel://%@", self.phoneNum];
		if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:urlString]]) {
			[PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
            if (UMENG) {
                //团购电话预约
                [MobClick event:Event_GrouponAppointment];
            }
            UMENG_EVENT(UEvent_Groupon_Detail_Appointment)
		}
	}
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    if(util == hoteldetailRequest)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root])
        {
            return;
        }
        
        HotelInfoViewController *hivc = [[HotelInfoViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店详情" style:_NavOnlyBackBtnStyle_];
        [hivc setHotelInfoWebByData:root type:HotelInfoTypeNativeFromGroupon];
        [self.navigationController pushViewController:hivc animated:YES];
        [hivc release];
    }
}


@end