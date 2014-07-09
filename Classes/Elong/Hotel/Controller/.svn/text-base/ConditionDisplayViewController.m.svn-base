    //
//  ConditionDisplayViewController.m
//  ElongClient
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import "ConditionDisplayViewController.h"
#import "HotelConditionRequest.h"
#import "SubConditionDisplayViewController.h"

#define kTitleTag	6477
#define kTopSplitViewTag 6479
#define kBottomSplitViewTag 6480
@implementation ConditionDisplayViewController

@synthesize typeStr;

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
    
    self.keyTable.delegate=nil;
    self.delegate = nil;
	[datas release];
	self.keywordFilter = nil;
	self.typeStr = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)array navShadowHidden:(BOOL)hidden {
    if (self = [super initWithTopImagePath:imgPath andTitle:titleString style:_NavOnlyBackBtnStyle_ navShadowHidden:YES]) {
		datas = [[NSArray alloc] initWithArray:array];
		_hotelKeywordType = hotelKeywordType;
        
		UILabel *textLabel = nil;
		if([datas count]==0){
			if(hotelKeywordType == HotelKeywordTypeSubwayStation){
				textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无地铁数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
				
				
			}else if(hotelKeywordType == HotelKeywordTypeAirportAndRailwayStation){
				textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无交通枢纽数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
				
			}
			[self.view addSubview:textLabel];
			[textLabel release];
		}
	}
	self.view.backgroundColor=[UIColor whiteColor];
	return self;
}

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)array {
	if (self = [super initWithTopImagePath:imgPath andTitle:titleString style:_NavOnlyBackBtnStyle_]) {
		datas = [[NSArray alloc] initWithArray:array];
		_hotelKeywordType = hotelKeywordType;
        
		UILabel *textLabel = nil;
		if([datas count]==0){
			if(hotelKeywordType == HotelKeywordTypeSubwayStation){
				textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无地铁数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
				
				
			}else if(hotelKeywordType == HotelKeywordTypeAirportAndRailwayStation){
				textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无交通枢纽数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
				
			}
			[self.view addSubview:textLabel];
			[textLabel release];
		}
	}
	self.view.backgroundColor=[UIColor whiteColor];
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// add Table
	UITableView *keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
	keyTable.dataSource		= self;
	keyTable.delegate		= self;
    keyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    keyTable.backgroundColor=[UIColor clearColor];
	[self.view addSubview:keyTable];
    self.keyTable = keyTable;
	[keyTable release];
    
    self.view.backgroundColor=[UIColor whiteColor];
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datas count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return HSC_CELL_HEGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectTableCellKey] autorelease];
        
        // condition
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, HSC_CELL_HEGHT)];
        titleLbl.font			 = FONT_15;
        titleLbl.tag			 = kTitleTag;
        titleLbl.lineBreakMode = UILineBreakModeMiddleTruncation;
        titleLbl.textColor	 =  RGBACOLOR(52, 52, 52, 1);
        [cell.contentView addSubview:titleLbl];
        [titleLbl release];
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
    
        UIImageView *bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HSC_CELL_HEGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        bottomSplitView.tag = kBottomSplitViewTag;
        [cell.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 16, 0, 8, HSC_CELL_HEGHT)];
        arrow.contentMode =  UIViewContentModeCenter;
        arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [cell.contentView addSubview:arrow];
        [arrow release];
    }

	
    UILabel *conditionField = (UILabel *)[cell.contentView viewWithTag:kTitleTag];
    
	NSDictionary *dic	= [datas safeObjectAtIndex:indexPath.row];
	conditionField.text	= [dic safeObjectForKey:TAGNAME_HOTEL];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// 根据当前页的类型获取下一页的数据
	HotelConditionRequest *searchReq = [HotelConditionRequest shared];
	NSArray *metroArray = searchReq.metroArray;
	NSArray *trafficArray = searchReq.trafficArray;
	
	// 数据源
	NSArray *typeArray	 = [self.typeStr isEqualToString:SUBWAY_STATION] ? metroArray : trafficArray;
	// 与标题对应的字段
	NSDictionary *dic	 = [datas safeObjectAtIndex:indexPath.row];
	NSString *subTypeStr = [dic safeObjectForKey:TAGID_HOTEL];
	
	NSMutableArray *subDatas = [NSMutableArray arrayWithCapacity:2];
	for (NSDictionary *dic in typeArray) {
		if ([[dic safeObjectForKey:TAGID_HOTEL] isEqualToString:subTypeStr]) {
			[subDatas addObject:dic];
		};
	}
    
    NSDictionary *temp = [datas safeObjectAtIndex:indexPath.row];
	
	SubConditionDisplayViewController *controller = [[SubConditionDisplayViewController alloc] initWithIconPath:nil
																										  Title:[dic safeObjectForKey:TAGNAME_HOTEL]
                                                                                               hotelKeywordType:_hotelKeywordType
																										  Datas:subDatas navShadowHidden:YES];
    controller.delegate = self;
    controller.keywordFilter = self.keywordFilter;
    
    controller.locationTitle = [temp safeObjectForKey:TAGNAME_HOTEL];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
#pragma mark SubConditionDisplayViewControllerDelegate

- (void) subConditionDisplayViewController:(SubConditionDisplayViewController *)subConditionDisplayVC didSelect:(JHotelKeywordFilter *)locationInfo{
    if ([self.delegate respondsToSelector:@selector(conditionDisplayViewController:didSelect:)]) {
        [self.delegate conditionDisplayViewController:self didSelect:locationInfo];
    }
}


@end
