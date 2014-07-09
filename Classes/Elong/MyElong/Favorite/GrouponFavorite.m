//
//  GrouponFavorite.m
//  ElongClient
//
//  Created by Dawn on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponFavorite.h"
#import "MyElongCenter.h"
#import "Utils.h"
#import "GrouponItemCell.h"
#import "UIImageView+WebCache.h"
#import "HotelPostManager.h"
#import "JDeleteGrouponFavorite.h"
#import "GDetailRequest.h"
#import "GrouponDetailViewController.h"
#import "GListRequest.h"

static int TABLE_HEIGHT		= 120;

@interface GrouponFavorite ()
@property (nonatomic,retain) UIButton *morebutton;
@property (nonatomic,copy) NSString *cityName;
@end

@implementation GrouponFavorite

@synthesize totalCount = _totalCount;
@synthesize morebutton;
@synthesize grouponArray;

@synthesize isSkipLogin;

- (void) dealloc{
    favoriteTableView.delegate=nil;
    self.morebutton = nil;
    self.grouponArray = nil;
    if (moreFavRequest) {
        [moreFavRequest cancel];
        [moreFavRequest release],moreFavRequest = nil;
    }
    if (deleteFavRequest) {
        [deleteFavRequest cancel];
        [deleteFavRequest release],deleteFavRequest = nil;
    }
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release],detailRequest = nil;
    }
    
    [_cityName release];
    [super dealloc];
}

- (id)initWithEditStyle:(BOOL)canEdit grouponDict:(NSDictionary *)grouponDict{
	if (self = [super initWithTopImagePath:nil andTitle:@"收藏团购" style:_NavOnlyBackBtnStyle_]) {
		editState = canEdit;
		self.isSkipLogin = NO;

        self.grouponArray = [NSMutableArray arrayWithArray:[grouponDict objectForKey:@"GrouponFavorites"]];
        
        self.totalCount = [[grouponDict objectForKey:@"TotalCount"] intValue];
    
        
		if (editState) {
			self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
		}
        
        [favoriteTableView reloadData];
        [self refreshNavRightBtnStatus];
	}
	
	return self;
}
- (void)back{
    GListRequest *cityListReq	= [GListRequest shared];
    cityListReq.cityName = _cityName;       //记录cityname，在back时，将其还原，为防止cityid丢失。导致团购列表其他功能不可用
    
	if (isSkipLogin) {
		NSArray *navCtrls = self.navigationController.viewControllers;
		[self.navigationController popToViewController:[navCtrls safeObjectAtIndex:[navCtrls count] - 3] animated:YES];
	}
	else {
		[super back];
	}
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



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //table view
	favoriteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
	favoriteTableView.delegate = self;
	favoriteTableView.dataSource = self;
	favoriteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//favoriteTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
    favoriteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
	[self.view addSubview:favoriteTableView];
    
    [favoriteTableView release];
	
    m_blogView = [Utils addView:@"您还未收藏团购产品"];
    
	[self.view addSubview:m_blogView];
	currentRow = -1;

    GListRequest *cityListReq	= [GListRequest shared];
    _cityName = [cityListReq.cityName copy];       //记录cityname，在back时，将其还原
}

- (void) setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
    GrouponFavoriteRequest *jghf=[HotelPostManager grouponFav];
    if (self.grouponArray.count < self.totalCount && self.grouponArray.count > 0 && self.grouponArray.count >= jghf.pageSize) {
        self.morebutton = [UIButton uniformMoreButtonWithTitle:@"更多团购订单"
                                                        Target:self
                                                        Action:@selector(clickMorehotel:)
                                                         Frame:CGRectMake(0, 0, 320, 44)];
        favoriteTableView.tableFooterView = self.morebutton;
    }
    
}

-(void) refreshNavRightBtnStatus
{
	if([self.grouponArray count] == 0){
		[self.navigationItem.rightBarButtonItem.customView setHidden:YES];
	}
	else {
		[self.navigationItem.rightBarButtonItem.customView setHidden:NO];
	}
	
}

- (void)clickMorehotel:(id)sender{
    //更多收藏
    GrouponFavoriteRequest *jghf=[HotelPostManager grouponFav];
    [jghf nextPage];
    
    if (moreFavRequest) {
        [moreFavRequest cancel];
        [moreFavRequest release],moreFavRequest = nil;
    }
    moreFavRequest = [[HttpUtil alloc] init];
    
    [moreFavRequest connectWithURLString:GROUPON_SEARCH
                                 Content:[jghf request]
                            StartLoading:YES
                              EndLoading:YES
                                Delegate:self];
}

// 为每个酒店页填充数据
- (void)setDataAtIndex:(NSInteger)index ForView:(GrouponItemCell *)gView {
    if (index < [self.grouponArray count]) {
        NSDictionary *gDic = [self.grouponArray safeObjectAtIndex:index];
        
        // 设置酒店名
        [gView setHotelName:[NSString stringWithFormat:@"%@", [gDic safeObjectForKey:PRODNAME_GROUPON]]];
        
        int starLevel = [[gDic safeObjectForKey:@"Star"] intValue];
        if (starLevel < 3) {
            starLevel = 0;
        }
        [gView setStarLbl:starLevel];
        
        // 设置团购卖价
        [gView setSalePrice:[NSString stringWithFormat:@"%@",[[gDic safeObjectForKey:SALEPRICE_GROUPON] roundNumberToString]]];
        
        // 设置团购数量
        int grouponNum = 0;
        if (!OBJECTISNULL([gDic safeObjectForKey:SALENUMS_GROUPON])) {
            grouponNum = [[gDic safeObjectForKey:SALENUMS_GROUPON] intValue];
        }
        
        if (grouponNum == 0) {
            [gView setGrouponNum:@"抢购第一单"];
        }else{
            [gView setGrouponNum:[NSString stringWithFormat:@"%@人购买",[gDic safeObjectForKey:SALENUMS_GROUPON]]];
        }
        
        // 原价
        [gView setOrgPrice:[NSString stringWithFormat:@"%@",[[gDic safeObjectForKey:SHOWPRICE_GROUPON] roundNumberToString]]];
        
        
        // 设置地标
        NSMutableString *hotelAreaString = [NSMutableString stringWithCapacity:2];
       
        NSString *districtName = [gDic safeObjectForKey:@"DistrictName"];
        if (STRINGHASVALUE(districtName)) {
            [hotelAreaString appendString:districtName];
        }
        
        NSString *bizSectionName = [gDic safeObjectForKey:@"BizSectionName"];
        if (STRINGHASVALUE(bizSectionName)) {
            [hotelAreaString appendFormat:@" %@", bizSectionName];
        }
        
        [gView setPoi:hotelAreaString];
        
        //手机专项
        int mobileProductType=[[gDic safeObjectForKey:MOBILEPRODUCTTYPE_GROUPON] intValue];
        [gView setDiscountImgTmp:mobileProductType==1];
    
        gView.hotelId               = [NSString stringWithFormat:@"%@", [gDic safeObjectForKey:PRODID_GROUPON]];
        
        gView.hotelImageView.image = nil;
        NSString *imageUrl = [gDic safeObjectForKey:@"PhotoUrl"];
        [gView.hotelImageView setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"]
                                      options:SDWebImageCacheMemoryOnly];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate、UITableViewDataSource

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
	
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	if (self.grouponArray == nil || self.grouponArray.count == 0) {
		m_blogView.hidden = NO;
		if (!favoriteTableView.editing) {
			[self.navigationItem.rightBarButtonItem.customView setHidden:YES];
		}
		return 0;
	}
	m_blogView.hidden = YES;
	[self.navigationItem.rightBarButtonItem.customView setHidden:NO];
    
	return self.grouponArray.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"grouponItemCell";
	GrouponItemCell *cell		= [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell) {
        cell = [[[GrouponItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
	}
	
    // cell 赋值
	[self setDataAtIndex:indexPath.row ForView:cell];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    currentRow = row;
	
    id prodId = [[self.grouponArray safeObjectAtIndex:row] safeObjectForKey:PRODID_GROUPON];
    
    if (![prodId isEqual:[NSNull null]] && [prodId intValue] != 0) {
        GDetailRequest *gDReq = [GDetailRequest shared];
        [gDReq setProdId:prodId];
        
        if (detailRequest) {
            [detailRequest cancel];
            [detailRequest release],detailRequest = nil;
        }
        
        GListRequest *cityListReq	= [GListRequest shared];
        cityListReq.cityName = @"";     //主动置为空，以防止CityID在列表被改变时，查找不到该团购酒店（cityID在更换城市时会被改变）
        
        detailRequest = [[HttpUtil alloc] init];
        [detailRequest connectWithURLString:GROUPON_SEARCH
                                       Content:[gDReq grouponDetailCompress:YES]
                                  StartLoading:YES
                                    EndLoading:YES
                                      Delegate:self];
    }
	else {
        [PublicMethods showAlertTitle:@"该团购已失效" Message:@"请选择其它酒店"];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
		favoriteTableView.tableFooterView) {
		// 滚到底向上拉，并且有更多按钮时，申请更多数据
		[self clickMorehotel:nil];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
	
	//Post delete
	JDeleteGrouponFavorite *jdelGF=[MyElongPostManager deleteGF];
	[jdelGF clearBuildData];
	[jdelGF setProdId:[[self.grouponArray safeObjectAtIndex:row] safeObjectForKey:PRODID_GROUPON]];
	
    if (deleteFavRequest) {
        [deleteFavRequest cancel];
        [deleteFavRequest release],deleteFavRequest = nil;
    }
    
    deleteFavRequest = [[HttpUtil alloc] init];
    [deleteFavRequest connectWithURLString:GROUPON_SEARCH
                                 Content:[jdelGF requesString:YES]
                            StartLoading:YES
                              EndLoading:YES
                                Delegate:self];
    
    
    currentRow = row;

    // 删除
    [self.grouponArray removeObjectAtIndex:currentRow];
    [favoriteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:currentRow inSection:0]]
                             withRowAnimation:UITableViewRowAnimationFade];
    
    [self refreshNavRightBtnStatus];
	
}



#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    if (util == moreFavRequest) {
        
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([root objectForKey:@"GrouponFavorites"] == [NSNull null]) {
            
        }else {
            NSInteger orgNum = self.grouponArray.count;
            [self.grouponArray addObjectsFromArray:[root objectForKey:@"GrouponFavorites"]];
            NSInteger nowNum = self.grouponArray.count;
            self.totalCount = [[root objectForKey:@"TotalCount"] intValue];
            
            if (self.grouponArray.count < self.totalCount && orgNum != nowNum) {
                favoriteTableView.tableFooterView = self.morebutton;
            }else{
                favoriteTableView.tableFooterView = nil;
            }
            
            [favoriteTableView reloadData];
        }
    }else if(util == deleteFavRequest){
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        
        
    }else if(detailRequest == util){
        // 进入详情页面
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        NSMutableDictionary *mRoot = [NSMutableDictionary dictionaryWithDictionary:root];  
        
        GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:mRoot];
        NSDictionary *dict = [self.grouponArray safeObjectAtIndex:currentRow];
        controller.salesNum = [[dict safeObjectForKey:@"SaleNums"] intValue];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}
@end
