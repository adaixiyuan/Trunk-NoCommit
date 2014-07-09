    //
//  SubConditionDisplayViewController.m
//  ElongClient
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import "SubConditionDisplayViewController.h"
#import "HotelConditionRequest.h"
#import "HotelSearch.h"
#import "Utils.h"
#import "HotelSearchConditionViewCtrontroller.h"
#import "HotelSearchFilterController.h"

@implementation SubConditionDisplayViewController
@synthesize keyTable;
#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    keyTable.delegate = nil;
    self.locationTitle = nil;
    self.keywordFilter = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[datas release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)dataArray navShadowHidden:(BOOL)hidden
{
	if (self = [super initWithTopImagePath:imgPath andTitle:titleString style:_NavOnlyBackBtnStyle_ navShadowHidden:hidden]) {
		datas = [[NSArray alloc] initWithArray:dataArray];
		currentRow = -1;
		lastRow = currentRow;
        _hotelKeywordType = hotelKeywordType;
        
		UILabel *textLabel = nil;
		if([datas count]==0){
			if(hotelKeywordType == HotelKeywordTypeBusiness){
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无商圈数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
			}
			else if(hotelKeywordType == HotelKeywordTypeDistrict){
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无行政区数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
			}else if(hotelKeywordType == HotelKeywordTypeBrand){
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无品牌数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
            }
			[self.view addSubview:textLabel];
			[textLabel release];
		}
		
	}
	self.view.backgroundColor=[UIColor whiteColor];
    
	return self;
}

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)dataArray
{
	if (self = [super initWithTopImagePath:imgPath andTitle:titleString style:_NavOnlyBackBtnStyle_]) {
		datas = [[NSArray alloc] initWithArray:dataArray];
		currentRow = -1;
		lastRow = currentRow;
        _hotelKeywordType = hotelKeywordType;
		UILabel *textLabel = nil;
		if([datas count]==0){
			if(hotelKeywordType == HotelKeywordTypeBusiness){
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无商圈数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
			}
			else if(hotelKeywordType == HotelKeywordTypeDistrict){
				textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无行政区数据"];
				[textLabel setTextAlignment:UITextAlignmentCenter];
			}else if(hotelKeywordType == HotelKeywordTypeBrand){
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 158, 250, 50)];
				[textLabel setFont:[UIFont boldSystemFontOfSize:16]];
				[textLabel setText:@"该城市暂无品牌数据"];
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

- (void)viewDidLoad{
	[super viewDidLoad];
	
	// add Table
	keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
	keyTable.dataSource		= self;
	keyTable.delegate		= self;
    keyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    keyTable.backgroundColor=[UIColor clearColor];
	[self.view addSubview:keyTable];
	[keyTable release];
    
    self.view.backgroundColor=[UIColor whiteColor];
	
	[self performSelector:@selector(fillData) withObject:nil afterDelay:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTI_HOTELFILTER_REGIONCHANGE object:nil];
}

- (void) refreshData{
    [self fillData];
}

- (void)fillData{
	// 如果以前选中过，显示选中的项目
    JHotelKeywordFilter *keywordfilter = self.keywordFilter;
	
	for (NSDictionary *dic in datas) {
        // 行政区或商圈
        if (keywordfilter) {
            if (keywordfilter.keywordType == _hotelKeywordType) {
                if ([[dic objectForKey:DATANAME_HOTEL] isEqualToString:keywordfilter.keyword]) {
                    currentRow = [datas indexOfObject:dic];
                    lastRow = currentRow;
                    [keyTable reloadData];
                }
            }
        }else{
            currentRow = -1;
            lastRow = currentRow;
            [keyTable reloadData];
        }
	}
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return HSC_CELL_HEGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
	
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (!cell) {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey 
											   height:HSC_CELL_HEGHT 
												style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.minimumFontSize=12;
        cell.textLabel.numberOfLines=1;
        cell.textLabel.frame=CGRectMake(60, cell.textLabel.frame.origin.y, BOTTOM_BUTTON_WIDTH-35, cell.textLabel.frame.size.height);
	}
    
    NSDictionary *dic	= [datas safeObjectAtIndex:indexPath.row];
	cell.textLabel.text	= [dic safeObjectForKey:DATANAME_HOTEL];
	
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// 勾选选中项
	if (indexPath.row != lastRow) {
		currentRow = indexPath.row;
		
		CommonCell *lastCell = (CommonCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
		lastCell.cellImage.highlighted = NO;
		
		CommonCell *cell = (CommonCell *)[tableView cellForRowAtIndexPath:indexPath];
		cell.cellImage.highlighted = YES;
		
		lastRow = currentRow;
        
        if ([self.delegate respondsToSelector:@selector(subConditionDisplayViewController:didSelect:)]) {
            JHotelKeywordFilter *keywordFilter = [[[JHotelKeywordFilter alloc] init] autorelease];
            keywordFilter.keywordType = _hotelKeywordType;
            keywordFilter.keyword = [[datas safeObjectAtIndex:currentRow] objectForKey:DATANAME_HOTEL];
            if (_hotelKeywordType == HotelKeywordTypeSubwayStation || _hotelKeywordType == HotelKeywordTypeAirportAndRailwayStation) {
                keywordFilter.lat = [[[datas safeObjectAtIndex:currentRow] objectForKey:@"Lat"] floatValue];
                keywordFilter.lng = [[[datas safeObjectAtIndex:currentRow] objectForKey:@"Lng"] floatValue];
            }else if(_hotelKeywordType == HotelKeywordTypeBrand){
                keywordFilter.pid = [[[datas safeObjectAtIndex:currentRow] objectForKey:@"DataID"] integerValue];
            }
            
            [self.delegate subConditionDisplayViewController:self didSelect:keywordFilter];
        }
	}
}

@end
