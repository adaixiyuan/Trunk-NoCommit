    //
//  DiscountCityChooseVCtr.m
//  ElongClient
//
//  Created by haibo on 12-2-7.
//  Copyright 2012 elong. All rights reserved.
//

#import "DiscountCityChooseVCtr.h"
#import "SearchBarView.h"

#define kCityLabelTag 2343

@interface DiscountCityChooseVCtr ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *indexArray;
@property (nonatomic, retain) NSMutableDictionary *paramDic;
@property (nonatomic, retain) NSMutableArray *filterListContent;			// 搜索联想列表

@end


@implementation DiscountCityChooseVCtr

@synthesize delegate;
@synthesize dataArray;
@synthesize indexArray;
@synthesize paramDic;
@synthesize filterListContent;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.dataArray	= nil;
	self.indexArray = nil;
	self.paramDic	= nil;
	self.filterListContent = nil;
	
	[cities					 release];
	[searchDisplayController release];
	[localCityDic			 release];
	[cityIndexDic			 release];
	[allLocalCities			 release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Initialization

- (id)initWithCities:(NSArray *)cityArray {
	if (self = [super initWithTopImagePath:@"" andTitle:@"城市列表" style:_NavNormalBtnStyle_]) {
        cities = [[NSArray alloc] initWithArray:cityArray];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hotelcity" ofType:@"plist"];
        localCityDic		= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        cityIndexDic		= [[NSMutableDictionary alloc] initWithCapacity:2];
        allLocalCities		= [[NSMutableArray alloc] initWithCapacity:2];
        self.filterListContent	= [NSMutableArray arrayWithCapacity:2];
        
        [self performSelector:@selector(prepareData)];
        
        if ([cities count] > 0) {
            [self performSelector:@selector(addSearchBar)];
            [self performSelector:@selector(addTable)];
        }
        else {
            [self.view showTipMessage:@"未搜索到城市列表"];
        }
	}
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)addSearchBar {
	UISearchBar *searchBar	= [[SearchBarView alloc] initWithFrame:CGRectMake(0, 2, 320, NAVIGATION_BAR_HEIGHT)];  
	searchBar.delegate		= self;
	searchBar.translucent	= YES;
	searchBar.placeholder	= @"城市名";
	
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];  
    [searchDisplayController setDelegate:self];  
    [searchDisplayController setSearchResultsDataSource:self];  
    [searchDisplayController setSearchResultsDelegate:self];
	searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[searchBar release];
	
	[self.view insertSubview:searchDisplayController.searchBar atIndex:0];
}


- (void)addTable {
	UITableView *citysTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 2, 320, SCREEN_HEIGHT - 110) style:UITableViewStylePlain];
	citysTable.dataSource	= self;
	citysTable.delegate		= self;
	citysTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view insertSubview:citysTable atIndex:0];
	[citysTable release];
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


- (NSString *)getFirstCharOfPinYinFromString:(NSString *)sourceStr {
	NSArray *keyArray = nil;
	
	for (NSArray *array in [localCityDic allValues]) {
		for (NSArray *subArray in array) {
			NSString *cityName = [subArray safeObjectAtIndex:0];
			NSComparisonResult result;
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
	
	return nil;
}


- (void)prepareData {
	self.paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
	self.indexArray = [NSMutableArray arrayWithCapacity:2];
	
	NSMutableSet *set = [NSMutableSet setWithCapacity:2];
	for (NSDictionary *dic in cities) {
		NSString *cityName = [dic safeObjectForKey:CITYNAME_GROUPON];
		NSString *firstStr = [self getFirstCharOfPinYinFromString:cityName];
		[cityIndexDic safeSetObject:dic forKey:[dic safeObjectForKey:CITYNAME_GROUPON]];
		
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
		}
	}
	
	[indexArray addObjectsFromArray:[[set allObjects] sortedArrayUsingSelector:@selector(compare:)]];
}

#pragma mark -
#pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
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
	
	UIView* mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	mview.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
	
	UILabel *headerview = [[UILabel alloc] initWithFrame:CGRectMake(9, -2, 320, 27)];
	headerview.backgroundColor	= [UIColor clearColor];
	headerview.alpha			= 0.9;
	headerview.text				= [NSString stringWithFormat:@"    %@",[indexArray safeObjectAtIndex:section]];
	headerview.font				= FONTBOLD1;
	headerview.textColor		= COLOR_NAV_TITLE;
	headerview.textAlignment	= UITextAlignmentLeft;
	[mview addSubview:headerview];
	[headerview release];
	
	return [mview autorelease];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;	
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == searchDisplayController.searchResultsTableView) {
		return nil;
	}
	return indexArray;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 38)];
		// bg
		UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		coverBtn.frame = CGRectInset(backView.frame, 15, 0);
		[coverBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
		[backView addSubview:coverBtn];
		
		// dashed
		[cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(15, 39, BOTTOM_BUTTON_WIDTH, 1)]];
		
		cell.selectedBackgroundView = backView;
		[backView release];
		
		UILabel *titleLabel			= [[UILabel alloc] init];
		titleLabel.font				= FONT_B16;
		titleLabel.tag				= kCityLabelTag;
		titleLabel.backgroundColor	= [UIColor clearColor];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
    }
	
	NSDictionary *dic;
	if (tableView == searchDisplayController.searchResultsTableView) {
		dic = [filterListContent safeObjectAtIndex:indexPath.row];
	}
	else {
		dic = [[paramDic safeObjectForKey:[indexArray safeObjectAtIndex:indexPath.section]] safeObjectAtIndex:indexPath.row];
	}
	
	// 城市
	UILabel *titleLabel	= (UILabel *)[cell.contentView viewWithTag:kCityLabelTag]; 
	titleLabel.text		= [dic safeObjectForKey:CITYNAME_GROUPON];
	CGSize titleSize	= [titleLabel.text sizeWithFont:FONT_B16];
	titleLabel.frame	= CGRectMake(20, 10, titleSize.width, 20);
    
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 以选择城市重新进行搜索
	NSDictionary *dic;
	if (tableView == searchDisplayController.searchResultsTableView) {
		dic = [filterListContent safeObjectAtIndex:indexPath.row];
	}
	else {
		dic = [[paramDic safeObjectForKey:[indexArray safeObjectAtIndex:indexPath.section]] safeObjectAtIndex:indexPath.row];
	}
	
	[delegate getDiscountCity:[dic safeObjectForKey:CITYNAME_GROUPON]];
	
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterForSearchString:searchString];
	
    return YES;
}


@end
