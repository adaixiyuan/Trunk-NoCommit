//
//  GrouponCityChooseViewController.m
//  ElongClient
//
//  Created by haibo on 11-11-3.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponCityChooseViewController.h"
#import "GrouponHomeViewController.h"
#import "GListRequest.h"
#import "Utils.h"
#import "SearchBarView.h"

#define kCityLabelTag	235
#define kNumberLabelTag 236
#define kGPSTag         237
#define kCellTopLineTag 238

@interface GrouponCityChooseViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *indexArray;
@property (nonatomic, retain) NSMutableDictionary *paramDic;
@property (nonatomic, retain) NSMutableArray *filterListContent;			// 搜索联想列表

@end


@implementation GrouponCityChooseViewController

@synthesize root;
@synthesize dataArray;
@synthesize indexArray;
@synthesize paramDic;
@synthesize filterListContent;
@synthesize indexBar = _indexBar;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.dataArray	= nil;
	self.indexArray = nil;
	self.paramDic	= nil;
	self.filterListContent = nil;
    searchBar.delegate=nil;
    citysTable.delegate=nil;
    searchDisplayController.delegate=nil;
    SFRelease(_indexBar);
	
	[searchDisplayController release];
	[localCityDic			 release];
	[cityIndexDic			 release];
	[allLocalCities			 release];
    [navBar release];
    [citysTable release];
	
    [super dealloc];
}


- (id)init {
	if (self = [super initWithTopImagePath:nil andTitle:@"团购城市" style:_NavOnlyBackBtnStyle_]) {
        // 数据初始化
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hotelcity" ofType:@"plist"];
		localCityDic		= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
		allLocalCities		= [[NSMutableArray alloc] initWithCapacity:2];
		cityIndexDic		= [[NSMutableDictionary alloc] initWithCapacity:2];
		self.filterListContent	= [NSMutableArray arrayWithCapacity:2];
		
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* GrouponCityName = [defaults objectForKey:@"GrouponCityName"];
        if (STRINGHASVALUE(GrouponCityName)) {
            lastcity = GrouponCityName;
        }
        else {
            lastcity = nil;
        }
        
		[self makeCityIndexDicWithArray];
		[self prepareData];
        
        // 界面初始化
        if([UIDevice currentDevice].systemVersion.floatValue >=7.0)
        {
            initY += 20;   // 状态栏高度
        }
        
        [self addSearchBar];
        [self addTableView];
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(back)];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* GrouponCityName = [defaults objectForKey:@"GrouponCityName"];
    if (STRINGHASVALUE(GrouponCityName)) {
        lastcity = GrouponCityName;
    }
    else {
        lastcity = nil;
    }
    if (lastcity) {
        if (![[indexArray safeObjectAtIndex:1] isEqual:@"上次搜索"]) {
            [indexArray insertObject:@"上次搜索" atIndex:1];
        }
        
        NSArray *array	 = [[GListRequest shared] grouponCitys];
        NSMutableArray *lastCityArray = [NSMutableArray arrayWithCapacity:2];
        for (NSDictionary *dic in array) {
            NSString *cityName = [dic safeObjectForKey:CITYNAME_GROUPON];
            NSString *firstStr = [self getFirstCharOfPinYinFromString:cityName];
            if (STRINGHASVALUE(firstStr)) {
                // 添加上次搜索城市的数据
                if ([lastcity isEqualToString:cityName]) {
                    [lastCityArray addObject:dic];
                    break;
                }
            }
        }
        if ([lastCityArray count] > 0) {
            [paramDic safeSetObject:lastCityArray forKey:[indexArray safeObjectAtIndex:1]];
        }
        
    }
    
    [citysTable reloadData];
    citysTable.contentOffset = CGPointMake(0.0, 0.0);
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)getFirstCharOfPinYinFromString:(NSString *)sourceStr {
	NSArray *keyArray = nil;
	for (NSArray *array in [localCityDic allValues]) {
		for (NSArray *subArray in array) {
			NSString *cityName = [subArray safeObjectAtIndex:0];
			NSComparisonResult result;
			if(cityName!=NULL && sourceStr != NULL&& ![sourceStr isEqual:[NSNull null]]){
				if (cityName.length > sourceStr.length) {
					result = [cityName compare:sourceStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, sourceStr.length)];
				}
				else {
					result = [sourceStr compare:cityName options:NSCaseInsensitiveSearch range:NSMakeRange(0, cityName.length)];
				}
				
				if (result == NSOrderedSame) {
					keyArray = [localCityDic allKeysForObject:array];
					[allLocalCities addObject:cityName];
					
					for (NSString *str in keyArray) {
						if (ENWORDISRIGHT(str)) {
							// 不返回酒店的热门城市
							return str;
						}
					}
				}
			}
			
		}
	}
	
	return nil;
}


- (void)makeCityIndexDicWithArray {
	// 生成新的城市－数据对应字典
	for (NSDictionary *dic in [[GListRequest shared] grouponCitys]) {
		[cityIndexDic safeSetObject:dic forKey:[dic safeObjectForKey:CITYNAME_GROUPON]];
	}
}

//得到热门城市数据
+(NSArray *) getHotArrays
{
    return [NSArray arrayWithObjects:
            @"北京",
            @"上海",
            @"三亚",
            @"杭州",
            @"广州",
            @"深圳",
            @"成都",
            @"厦门",
            @"西安",
            @"苏州",
            @"南京",
            @"武汉", nil];
}

// 准备城市列表数据
- (void)prepareData {
	NSArray *array	 = [[GListRequest shared] grouponCitys];

	NSArray *hotKeys = [GrouponCityChooseViewController getHotArrays];
	self.paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
	
	// 热门城市列表写在本地
	self.indexArray = [NSMutableArray arrayWithObject:@"热门"];
	NSMutableArray *hotCityArray = [NSMutableArray arrayWithCapacity:2];
	NSMutableArray *lastCityArray = [NSMutableArray arrayWithCapacity:2];
	for (int i = 0; i < [hotKeys count]; i ++) {
		[hotCityArray addObject:[NSNull null]];
	}
	
	NSMutableSet *set = [NSMutableSet setWithCapacity:2];
	for (NSDictionary *dic in array) {
		NSString *cityName = [dic safeObjectForKey:CITYNAME_GROUPON];
		NSString *firstStr = [self getFirstCharOfPinYinFromString:cityName];
		
		if (STRINGHASVALUE(firstStr)) {
			[set addObject:firstStr];
			
			// 添加正常城市的数据
			NSMutableArray *cityArray = [paramDic safeObjectForKey:firstStr];
			if (cityArray) {
				if (![cityArray containsObject:dic]) {
					[cityArray addObject:dic];
				}
			}
			else {
				cityArray = [NSMutableArray arrayWithCapacity:2];
				[cityArray addObject:dic];
				[paramDic safeSetObject:cityArray forKey:firstStr];
			}
			
			// 添加热门城市的数据
			if ([hotKeys containsObject:cityName]) {
				[hotCityArray replaceObjectAtIndex:[hotKeys indexOfObject:cityName] withObject:dic];
			}
            // 添加上次搜索城市的数据
			if ([lastcity isEqualToString:cityName]) {
				[lastCityArray addObject:dic];
			}
		}
	}
	
	// 为防止无法取到热门城市的异常情况，做另一个数组过滤
	NSMutableArray *hotArray = [NSMutableArray arrayWithCapacity:2];
	for (NSDictionary *dic in hotCityArray) {
		if ([dic isKindOfClass:[NSDictionary class]]) {
			[hotArray addObject:dic];
		}
	}
	
	if ([hotArray count] > 0) {
		[paramDic safeSetObject:hotArray forKey:[indexArray safeObjectAtIndex:0]];
	}
	else {
		// 没有任何热门城市时移除索引
		[indexArray removeObjectAtIndex:0];
	}
	[indexArray addObjectsFromArray:[[set allObjects] sortedArrayUsingSelector:@selector(compare:)]];

    if (STRINGHASVALUE(lastcity)) {
        [indexArray insertObject:@"上次搜索" atIndex:0];
    }
    
    if ([lastCityArray count] > 0) {
		[paramDic safeSetObject:lastCityArray forKey:[indexArray safeObjectAtIndex:0]];
	}
    
    // 当前位置
    [indexArray insertObject:@"当前位置" atIndex:0];
    NSDictionary *locationDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"CityID",@"当前位置",@"CityName", nil];
    [paramDic safeSetObject:[NSArray arrayWithObjects:locationDict, nil] forKey:[indexArray safeObjectAtIndex:0]];
}


- (void)addSearchBar {
	searchBar	= [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, NAVIGATION_BAR_HEIGHT)];
	searchBar.delegate		= self;
	searchBar.placeholder	= @"城市名";
    
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchDisplayController setDelegate:self];  
    [searchDisplayController setSearchResultsDataSource:self];  
    [searchDisplayController setSearchResultsDelegate:self];
	searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[searchBar release];
	
	[self.view insertSubview:searchDisplayController.searchBar atIndex:0];
}

- (void)addTableView {
    citysTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width-indexBarWidth, SCREEN_HEIGHT - 20 - 44 - 44) style:UITableViewStylePlain];
	citysTable.dataSource	= self;
	citysTable.delegate		= self;
	citysTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (IOSVersion_7) {
        citysTable.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    citysTable.showsVerticalScrollIndicator = NO;
	[self.view insertSubview:citysTable atIndex:0];
	
    [self performSelector:@selector(layoutTableView) withObject:nil afterDelay:0.3];
    
}

- (void) layoutTableView{
    if (IOSVersion_7) {
        for (UIView *view in citysTable.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
                if ([view respondsToSelector:@selector(setFont:)]) {
                    [view performSelector:@selector(setFont:) withObject:[UIFont boldSystemFontOfSize:11.0f]];
                    [citysTable reloadData];
                }
            }
        }
    }
}

- (void)back {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)filterForSearchString:(NSString*)searchText {
	[filterListContent removeAllObjects]; 
	
	if (STRINGHASVALUE(searchText)) {
		for (NSArray *array in [localCityDic allValues]) {
			for (NSArray *city in array) {
				if ([city count] < 4) {
					// 跳过热门城市没有缩写的特殊情况
					break;
				}
				
				NSComparisonResult result = [[city safeObjectAtIndex:0] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				NSComparisonResult result1 = [[city safeObjectAtIndex:1] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				NSComparisonResult result2 = [[city safeObjectAtIndex:2] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result == NSOrderedSame || result1 == NSOrderedSame || result2 == NSOrderedSame) {
					NSString *cityName = [city safeObjectAtIndex:0];
					if ([allLocalCities containsObject:cityName]) {
						if ([cityIndexDic safeObjectForKey:cityName]) {
							[filterListContent addObject:[cityIndexDic safeObjectForKey:cityName]];
						}
					}
				}
				
				// 香港、澳门等特殊城市，需要多加英文名
				if ([city count] > 4) {
					NSComparisonResult result3 = [[city safeObjectAtIndex:3] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
					NSComparisonResult result4 = [[city safeObjectAtIndex:4] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
					if (result3 == NSOrderedSame || result4 == NSOrderedSame) {
						NSString *cityName = [city safeObjectAtIndex:0];
						if ([allLocalCities containsObject:cityName]) {
							[filterListContent addObject:[cityIndexDic safeObjectForKey:cityName]];
						}
					}
				}
			}
		}
	}
	
	// 按数量排序
	NSSortDescriptor * sortDes = [[[NSSortDescriptor alloc] initWithKey:GROUPONCOUNT_GROUPON ascending:NO] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	self.filterListContent = [NSMutableArray arrayWithArray:[filterListContent sortedArrayUsingDescriptors:descriptors]];
}


- (void)searchGrouponListForCity:(NSString *)cityName {
	// 按城市名查询团购项目
	[root researchGrouponListByCity:cityName isFirstRequst:NO];
	
	[self back];
}


#pragma mark -
#pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    [_indexBar setIndexes:indexArray];
	if (tableView == searchDisplayController.searchResultsTableView) {
		return 1;
	}
    return [indexArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (tableView == searchDisplayController.searchResultsTableView) {
		return [filterListContent count];
	}
    return [[paramDic safeObjectForKey:[indexArray safeObjectAtIndex:section]] count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return nil;
	}
    
    UIView* mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    mview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
	
	UILabel *headerview=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, SCREEN_WIDTH, 24)];
	headerview.backgroundColor=[UIColor clearColor];
	headerview.text=[NSString stringWithFormat:@"%@",[indexArray safeObjectAtIndex:section]];
	headerview.font= FONT_B15;
    headerview.textColor =  RGBACOLOR(52, 52, 52, 1);
    headerview.textAlignment=UITextAlignmentLeft;
	[mview addSubview:headerview];
	[headerview release];
    
	
	return [mview autorelease];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        if (section == 0) {
            return 24;
        }else if(section == 1){
            NSArray *lastCityArray = [paramDic safeObjectForKey:[self.indexArray safeObjectAtIndex:1]];
            if (lastCityArray.count) {
                return 24;
            }else{
                return 0;
            }
        }else{
            return 24;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == searchDisplayController.searchResultsTableView) {
		return nil;
	}
    
    NSMutableArray *temparray = [NSMutableArray arrayWithArray:indexArray];
    [temparray replaceObjectAtIndex:0 withObject:@""];
    return temparray;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
		
		UILabel *titleLabel			= [[UILabel alloc] init];
        titleLabel.textColor        = RGBACOLOR(52, 52, 52, 1);
		titleLabel.font             = FONT_15;
		titleLabel.tag				= kCityLabelTag;
		titleLabel.backgroundColor	= [UIColor clearColor];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
		
		UILabel *valueLabel			= [[UILabel alloc] init];
		valueLabel.font				= FONT_15;
		valueLabel.tag				= kNumberLabelTag;
		valueLabel.textColor		= RGBACOLOR(52, 52, 52, 1);
		valueLabel.backgroundColor	= [UIColor clearColor];
		[cell.contentView addSubview:valueLabel];
		[valueLabel release];
        
        UIImageView *gpsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        gpsView.image = [UIImage noCacheImageNamed:@"elong_gps_h.png"];
        [cell.contentView addSubview:gpsView];
        gpsView.contentMode = UIViewContentModeCenter;
        [gpsView release];
        gpsView.tag = kGPSTag;
        gpsView.hidden = YES;
        
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 40 - SCREEN_SCALE, SCREEN_WIDTH - 17, SCREEN_SCALE)];
        splitView.image= [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:splitView];
        splitView.tag = kCellTopLineTag;
        [splitView release];
    }
    UIImageView *splitView = (UIImageView *)[cell viewWithTag:kCellTopLineTag];
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        splitView.hidden = YES;
    }else{
        splitView.hidden = NO;
    }
    UILabel *titleLabel	= (UILabel *)[cell.contentView viewWithTag:kCityLabelTag];
    UILabel *valueLabel	= (UILabel *)[cell.contentView viewWithTag:kNumberLabelTag];
    
    UIImageView *gpsView = (UIImageView *)[cell viewWithTag:kGPSTag];
    if (indexPath.section == 0 && indexPath.row == 0) {
        gpsView.hidden = NO;
    }else{
        gpsView.hidden = YES;
    }
    if (searchDisplayController.searchResultsTableView == tableView) {
        gpsView.hidden = YES;
    }
	
	NSDictionary *dic;
	if (tableView == searchDisplayController.searchResultsTableView) {
		dic = [filterListContent safeObjectAtIndex:indexPath.row];
	}
	else {
		dic = [[paramDic safeObjectForKey:[indexArray safeObjectAtIndex:indexPath.section]] safeObjectAtIndex:indexPath.row];
	}

	// 团购城市
	titleLabel.text		= [dic safeObjectForKey:CITYNAME_GROUPON];
	
	
    if ([titleLabel.text isEqualToString:@"当前位置"]) {
        PositioningManager *positionManager = [PositioningManager shared];
        NSString *city = [positionManager getAddressName];
        if (city == nil || [city isEqualToString:@""]) {
            city = @"尚未获取位置信息";
        }
        titleLabel.text = city;
    }
    
    CGSize titleSize	= [titleLabel.text sizeWithFont:FONT_B16];
	titleLabel.frame	= CGRectMake(17, 10, titleSize.width, 20);
    
    // 团购数量
    if ([dic safeObjectForKey:GROUPONCOUNT_GROUPON]) {
        valueLabel.text		= [NSString stringWithFormat:@"(%@)",[dic safeObjectForKey:GROUPONCOUNT_GROUPON]];
    }else{
        valueLabel.text		= @"";
    }
	
	CGSize valueSize	= [valueLabel.text sizeWithFont:FONT_16];
	valueLabel.frame	= CGRectMake(20 + titleSize.width, 10, valueSize.width, 20);
    
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = [UIColor blackColor];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    // 以选择城市重新进行搜索
	NSDictionary *dic = nil;
    NSString *cityname = nil;
	if (tableView == searchDisplayController.searchResultsTableView)
    {
		dic = [filterListContent safeObjectAtIndex:indexPath.row];
        cityname = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:CITYNAME_GROUPON]];
        
        [searchDisplayController setActive:NO animated:NO];
	}
	else {
		dic = [[paramDic safeObjectForKey:[indexArray safeObjectAtIndex:indexPath.section]] safeObjectAtIndex:indexPath.row];
        if (indexPath.section != 0) {
            // 当前位置不做记录
            cityname = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:CITYNAME_GROUPON]];
        }
	}
    
	if (cityname) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cityname  forKey:@"GrouponCityName"];
        [defaults synchronize];
    }
    

	[self searchGrouponListForCity:cityname];
}

#pragma mark - indexBar Delegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if ([citysTable numberOfSections] > index && index > -1){   // 校验
        [citysTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:NO];
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = RGBACOLOR(248, 248, 248, 1);
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = [UIColor blackColor];
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterForSearchString:searchString];
	
    return YES;
}


#pragma mark -
#pragma mark UISearchBar delegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
	[self searchGrouponListForCity:searchBar_.text];
    [searchDisplayController setActive:NO animated:NO];
}

@end

