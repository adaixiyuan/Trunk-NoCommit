//
//  SelectType.m
//  ElongClient
//
//  Created by dengfang on 11-2-9.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectTable.h"
#import "SelectTableCell.h"
#import "ElongClientAppDelegate.h"
#import "Utils.h"
#import "FlightDataDefine.h"

#import "FlightSearch.h"
#import "AddFlightCustomer.h"
#import "FlightList.h"

#import "AddAndEditCustomer.h"
#import "AddAndEditCard.h"

#import "HotelSearch.h"

#import "GrouponOrderHistoryController.h"
#import "FlightOrderHistory.h"

#define SELECT_TABLE_CELL_HEIGHT 45

@interface  SelectTable ()

@property (nonatomic, retain) NSIndexPath *lastPath;
@property (nonatomic, copy)	  NSString    *selectedStr;

@end


@implementation SelectTable

@synthesize m_iSelectedTable;
@synthesize m_iFrom;
@synthesize m_iMaxNum;
@synthesize lastPath;
@synthesize isShow;
@synthesize selectedStr;
@synthesize delegate;
@synthesize tabView;
@synthesize addtionHeight;

- (void)showSelectTable:(UIViewController *)controller {
	isShow = YES;
	
	if (self.m_iMaxNum <= SELECT_TABLE_DATA_MAX_NUM) {
		[tabView setFrame:CGRectMake(5, dpViewTopBar.view.frame.size.height +5, SCREEN_WIDTH -10, SELECT_TABLE_DATA_MAX_NUM * SELECT_TABLE_CELL_HEIGHT)];
		[Utils animationView:self.view
					   fromX:0
					   fromY:SCREEN_HEIGHT
						 toX:0
						 toY:SCREEN_HEIGHT -STATUS_BAR_HEIGHT -NAVIGATION_BAR_HEIGHT -self.view.frame.size.height + addtionHeight
					   delay:0.0f
					duration:SHOW_WINDOWS_DEFAULT_DURATION];
	} else {
		[tabView setFrame:CGRectMake(5, dpViewTopBar.view.frame.size.height +5, SCREEN_WIDTH -10, MAINCONTENTHEIGHT - 5)];
        
        if (IOSVersion_7) {
            self.transitioningDelegate = [ModalAnimationContainer shared];
            self.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [controller.navigationController presentViewController:self animated:YES completion:nil];
        }else{
            [controller.navigationController presentModalViewController:self animated:YES];
        }
	}
}

- (void)updateDataArray:(NSMutableArray *)array {
	[selectedDictionary removeAllObjects];
	for (int i=0;i< [dataArray count]; i++) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
		for (int j=0; j<[array count]; j++) {
			if ([[dataArray safeObjectAtIndex:i] isEqualToString:[array safeObjectAtIndex:j]]) {
				//if ([dDictionary safeObjectForKey:path]!=nil) {
				[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:i] forKey:path];
				//}
			}
		}
	}	
	if ([selectedDictionary count] == [dataArray count] -1) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
		[selectedDictionary safeSetObject:@"全部" forKey:path];
	}

	[tabView reloadData];
}


- (void)setDisplayName:(NSString *)nameStr {
	[selectedDictionary removeAllObjects];
	[selectedDictionary safeSetObject:nameStr forKey:[NSIndexPath indexPathForRow:[dataArray indexOfObject:nameStr] inSection:0]];
	[tabView reloadData];
}
- (void)setselectedrowoftable:(NSString*)selected_index;
{
    int row = -1;
    if (SelectedTableRailwayDeparture == m_iSelectedTable ||SelectedTableRailwayArrival == m_iSelectedTable) {
       if ([selected_index isEqualToString:@"不限"]) {
           row = 0;
       }
       else  if ([selected_index isEqualToString:@"(6-12)AM"]) {
           row = 1;
       }
       else  if ([selected_index isEqualToString:@"(12-18)PM"]) {
           row = 2;
       }
       else  if ([selected_index isEqualToString:@"(18-6)PM"]) {
           row = 3;
       }
    }
    if (m_iSelectedTable == SelectedTableClass) {
        if ([selected_index isEqualToString:@"不限仓位"]) {
            row = 0;
        }
        else  if ([selected_index isEqualToString:@"经济舱"]) {
            row = 1;
        }
        else  if ([selected_index isEqualToString:@"商务舱"]) {
            row = 2;
        }
        else  if ([selected_index isEqualToString:@"头等舱"]) {
            row = 3;
        }
    }
    if (row>=0) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
        [selectedDictionary removeAllObjects];
        [selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:[path row]] forKey:path];
        m_iTable = [path row];
        [tabView reloadData];
    }

}

- (id)init:(int)table {    
	if ((self = [super init])) {
		//DATA
		m_iSelectedTable = table;
		isShow = NO;
		m_iMaxNum = [dataArray count];
		selectedDictionary = [[NSMutableDictionary alloc] init];
		
		if (m_iSelectedTable == SelectedTableClass) {
//			dataArray = [[NSMutableArray alloc] initWithObjects:@"不限舱位", @"经济舱", @"商务舱", @"头等舱", nil];
            dataArray = [[NSMutableArray alloc] initWithObjects:@"经济舱", @"商务舱", @"头等舱", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择舱位"] autorelease]];
			
		} else if (m_iSelectedTable == SelectedTableCertificate) {
			BOOL isMuX = NO;
			if (m_iFrom == FromAddFlightCustomer){
				Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
				if ([[flight1 getAirCorpCode] isEqualToString:@"MU"] && [[flight1 getClassTag] isEqualToString:@"X"]) {
					isMuX = YES;
				}
				if (!isMuX && [[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
					Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
					if ([[flight2 getAirCorpCode] isEqualToString:@"MU"] && [[flight2 getClassTag] isEqualToString:@"X"]) {
						isMuX = YES;
					}
				}
			}

			if (m_iFrom == FromAddFlightCustomer) {
				if (isMuX) {
					dataArray = [[NSMutableArray alloc] initWithObjects:@"身份证", @"军人证", nil];
				}
				else {
					dataArray = [[NSMutableArray alloc] initWithObjects:@"身份证", @"军人证", @"回乡证", @"港澳通行证", @"护照", @"其它", @"台胞证", nil];
				}
			}
			else if (m_iFrom == FromAddCustomer) {
				dataArray = [[NSMutableArray alloc] initWithObjects:@"身份证", @"军人证", @"回乡证", @"港澳通行证", @"护照", @"其它", @"台胞证", nil];
			}
			else if (m_iFrom == FromAddAndEditCard) {
				dataArray = [[NSMutableArray alloc] initWithObjects:@"身份证", @"护照", @"其它", nil];
			}
			else {
				dataArray = [[NSMutableArray alloc] initWithObjects:@"身份证", @"护照", @"其它", nil];
			}
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择证件类型"] autorelease]];
			
		} else if (m_iSelectedTable == SelectedTableBank) {
			dataArray = [[NSMutableArray alloc] initWithObjects:@"招商银行", @"中信银行", @"交通银行", @"中国银行", @"建设银行", @"VISA卡", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择发卡行"] autorelease]];
			
		} else if (m_iSelectedTable == SelectedTableGroupOrder) {
			dataArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"未支付", @"已支付", @"取消", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"订单状态"] autorelease]];
		}
		else if(m_iSelectedTable == SelectedTableHotelOrder){
			dataArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"入住", @"确认", @"取消", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"订单状态"] autorelease]];
			 //from:FromHotelOrder
		}
		else if(m_iSelectedTable == SelectedTableFlightOrder){
			dataArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"确认", @"出票", @"取消", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"订单状态"] autorelease]];
			
		}
		else if(m_iSelectedTable == SelectedTableGroupon){
			dataArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"已激活", @"已使用", @"已过期", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择消费券查询类型"] autorelease]];
		}
        else if(m_iSelectedTable == SelectedTableAirLineSort){
            dataArray = [[NSMutableArray alloc] initWithObjects:@"时间从早到晚", @"时间从晚到早", @"价格从低到高", @"价格从高到低", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"排序"] autorelease]];
        }
		
		else if (m_iSelectedTable == SelectedTableAirlines) {
		} else if (m_iSelectedTable == SelectedTableStarLevel) {
			dataArray = [[NSMutableArray alloc] initWithObjects:@"不限", @"五星", @"四星", @"三星",@"三星以下",nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择酒店星级"] autorelease]];
		}
		else if (SelectedTableRailwayDeparture == m_iSelectedTable) {
			dataArray		= [[NSMutableArray alloc] initWithObjects:
							   STRING_NOLIMIT,
							   STRING_MORNING,
							   STRING_AFTERNOON,
							   STRING_NIGHT,nil];
			dpViewTopBar	= [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"出发时间选择"] autorelease]];
		}
		else if (SelectedTableRailwayArrival == m_iSelectedTable) {
			dataArray		= [[NSMutableArray alloc] initWithObjects:
							   STRING_NOLIMIT,
							   STRING_MORNING,
							   STRING_AFTERNOON,
							   STRING_NIGHT,nil];
			dpViewTopBar	= [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"到达时间选择"] autorelease]];
		}
		else if (SelectedTableTrain == m_iSelectedTable) {
			dataArray		= [[NSMutableArray alloc] initWithObjects:ALL_TRAIN, G_TRAIN, D_TRAIN, Z_TRAIN, T_TRAIN, K_TRAIN, OTHER_TRAIN, nil];
			dpViewTopBar	= [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"列车筛选"] autorelease]];
			[self updateDataArray:dataArray];
		}
		else if (SelectedTableTrainStation == m_iSelectedTable) {
			dataArray		= [[NSMutableArray alloc] initWithObjects:ALL_TRAIN, G_TRAIN, D_TRAIN, Z_TRAIN, T_TRAIN, K_TRAIN, OTHER_TRAIN, nil];
			dpViewTopBar	= [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"列车筛选"] autorelease]];
			[self updateDataArray:dataArray];
			
			titleArray		= [[NSArray alloc] initWithObjects:@"车型选择", @"车站类型", nil];
			otherDataArray	= [[NSArray alloc] initWithObjects:@"不限", @"始发", @"终到", nil];
			self.lastPath	= [NSIndexPath indexPathForRow:0 inSection:1];
			[selectedDictionary safeSetObject:[otherDataArray safeObjectAtIndex:0] forKey:lastPath];
		}
		else if (SelectedTableInvoice == m_iSelectedTable) {
			dataArray = [[NSMutableArray alloc] initWithObjects:@"会务费", @"会议费", @"旅游费", @"差旅费", @"服务费", @"住宿费", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"发票类型"] autorelease]];
		}
		else if(SelectedTableTrainSort == m_iSelectedTable){
			dataArray = [[NSMutableArray alloc] initWithObjects:@"时间从早到晚",@"时间从晚到早", @"历时从长到短",@"历时从短到长", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"排序"] autorelease]];
		}
		else if(m_iSelectedTable == SelectedTableTrainSortStation){
			dataArray = [[NSMutableArray alloc] initWithObjects:@"时间从早到晚",@"时间从晚到早", nil];
			dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"排序"] autorelease]];
			
		}

		if (m_iSelectedTable == SelectedTableAirlines) {
			for (int i=0; i<[dataArray count]; i++) {
				NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
				[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:i] forKey:path];
			}
		} else {
			NSIndexPath *path = [NSIndexPath indexPathForRow:m_iTable inSection:0];
			[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:m_iTable] forKey:path];
		}
		//UI
		dpViewTopBar.delegate = self;
		int height = [dataArray count] *SELECT_TABLE_CELL_HEIGHT;
        
        BOOL fillerfromflightlist = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[FlightList class]]) {
                fillerfromflightlist = YES;
                break;
            }
        }

		if (m_iMaxNum > SELECT_TABLE_DATA_MAX_NUM) {
            if(!fillerfromflightlist)
                height = (SELECT_TABLE_DATA_MAX_NUM + 4) *SELECT_TABLE_CELL_HEIGHT;
            else
                height = (SELECT_TABLE_DATA_MAX_NUM + 1) *SELECT_TABLE_CELL_HEIGHT;
		}
		if (SelectedTableTrainStation == m_iSelectedTable) {
			m_iMaxNum = 10;
			height = MAINCONTENTHEIGHT - 5;
		}
		
		tabView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH -10, height) style:UITableViewStylePlain];
		tabView.delegate = self;
		tabView.dataSource = self;
		tabView.backgroundColor = [UIColor clearColor];
		tabView.separatorStyle = UITableViewCellSeparatorStyleNone;

		if (m_iSelectedTable != SelectedTableAirlines)  {
			self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, dpViewTopBar.view.frame.size.height +tabView.frame.size.height +10)] autorelease];
			self.view.backgroundColor = [UIColor whiteColor];
		}
		else {
			self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, tabView.frame.size.height +10)] autorelease];
		}

		if (m_iSelectedTable != SelectedTableAirlines) {
			[self.view addSubview:dpViewTopBar.view];
		}

		[self.view addSubview:tabView];
		
		// top shadow
		UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, 320, 15)];
		topShadow.image = [UIImage noCacheImageNamed:@"selecTable_shadow.png"];
		if (m_iSelectedTable != SelectedTableAirlines) {
			[self.view addSubview:topShadow];
		}

		[topShadow release];
	}
	return self;
}

- (id)initWithType:(SelectedTable)table {
	return [self init:table];
}

- (id)init:(int)table from:(int)from {
	m_iFrom = from;
	return [self init:table];
}

- (id)init:(int)table iSelect:(int)iSelect {
	m_iTable = iSelect;
	return [self init:table];
}

- (id)init:(int)table iSelect:(int)iSelect saved:(BOOL)saved{
	m_iTable = iSelect;
	m_Saved = saved;
	return [self init:table];
}

- (id)init:(int)table from:(int)from data:(NSMutableArray *)array {
    if (self = [super init]) {
        if (table == SelectedTableAirlines) {
            dataArray = [[NSMutableArray alloc] init];
            iconNameArray = [[NSMutableArray alloc] init];
            [dataArray addObject:@"全部"];
            [iconNameArray addObject:@""];
            for (int i=0; i<[array count]; i++) {
                [dataArray addObject:[array safeObjectAtIndex:i]];
                [iconNameArray addObject:@""];
            }
            for (int i=0; i<[dataArray count]; i++) {
                [iconNameArray replaceObjectAtIndex:i withObject:[Utils getAirCorpPicName:[dataArray safeObjectAtIndex:i]]];
            }
        }

    }
    return [self init:table from:from];
}

- (id)initWithCard:(NSMutableArray *)array {
	if ((self = [super init])) {
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, dpViewTopBar.view.frame.size.height +tabView.frame.size.height +10)] autorelease];
		
		self.view.backgroundColor = [UIColor whiteColor];
		UIImageView *shaowView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
		[shaowView setFrame:CGRectMake(0, 0, 320, 11)];
		[self.view addSubview:shaowView];
		[shaowView release];
		m_iSelectedTable = SelectedTableBank;
		m_iFrom = FromAddCard;
		dataArray = [[NSMutableArray alloc] init];
		[dataArray addObjectsFromArray:array];
		dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择发卡行"] autorelease]];
		
		m_iTable = 0;
		m_iMaxNum = [dataArray count];
		selectedDictionary = [[NSMutableDictionary alloc] init];
		
		dpViewTopBar.delegate = self;

		tabView = [[UITableView alloc] initWithFrame:CGRectMake(5, dpViewTopBar.view.frame.size.height +5, SCREEN_WIDTH -10, 406) style:UITableViewStylePlain];
		tabView.delegate = self;
		tabView.dataSource = self;
		tabView.backgroundColor = [UIColor clearColor];
		tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		
		[self.view addSubview:dpViewTopBar.view];
		[self.view addSubview:tabView];
		
		// top shadow
		UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, 320, 15)];
		topShadow.image = [UIImage noCacheImageNamed:@"selecTable_shadow.png"];
		[self.view addSubview:topShadow];
		[topShadow release];
	}
	
	return self;
}

- (void)dealloc {
	self.lastPath	 = nil;
	self.selectedStr = nil;
	
	[dpViewTopBar release];
	[tabView release];
	if ([iconNameArray retainCount] > 0) {
		[iconNameArray release];
	}
	[dataArray release];
	[titleArray release];
	[otherDataArray release];
	[selectedDictionary release];
    [super dealloc];
}

#pragma mark -
#pragma mark appDelegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (SelectedTableTrainStation == m_iSelectedTable) {
		return 2;
	}
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? [dataArray count] : [otherDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return SELECT_TABLE_CELL_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (m_iSelectedTable == SelectedTableTrainStation) {
		return [titleArray safeObjectAtIndex:section];
	}
	
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    SelectTableCell *cell = (SelectTableCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MultiSelectTableCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SelectTableCell class]]) {
                cell = (SelectTableCell *)oneObject;
				cell.backgroundColor = [UIColor clearColor];
				cell.contentView.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(15, SELECT_TABLE_CELL_HEIGHT - 1, tableView.frame.size.width - 30, 1)]];
			}
		}
    }
	//set cell
    NSUInteger row = [indexPath row];
	if (m_iSelectedTable == SelectedTableAirlines) {
		cell.selectImgView.frame = CGRectMake(20, cell.selectImgView.frame.origin.y,
											  cell.selectImgView.frame.size.width, cell.selectImgView.frame.size.height);
		cell.iconImgView.image = [UIImage imageNamed:[iconNameArray safeObjectAtIndex:row]];
	} else {
		cell.selectImgView.frame = CGRectMake(20, cell.selectImgView.frame.origin.y,
											  cell.selectImgView.frame.size.width, cell.selectImgView.frame.size.height);
	}
	
	if (m_iSelectedTable == SelectedTableHotelOrder){
		UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 14, 14)];
		
		switch (row) {
			case 0:
				cell.stateImageView.hidden = YES;
				break;

			case 1:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_active.png"]];
				
			}
				break;
				
			case 2:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_used.png"]];
				//[cell.contentView addSubview:imageview];
			}
				break;
				
			case 3:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_cancel.png"]];
				//[cell.contentView addSubview:imageview];
			}
				break;


			default:
				break;
		}
		
		[imageview release];
		
	}
	else if(m_iSelectedTable == SelectedTableFlightOrder){
		
			UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 14, 14)];
			
			switch (row) {
				case 0:
					cell.stateImageView.hidden = YES;
					break;
				case 1:
				{
					cell.stateImageView.hidden = NO;
					[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_used.png"]];
					//[cell.contentView addSubview:imageview];
				}
					break;
					
				case 2:
				{
					cell.stateImageView.hidden = NO;
					[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_active.png"]];
					//[cell.contentView addSubview:imageview];
				}
					break;
					
				case 3:
				{
					cell.stateImageView.hidden = NO;
					[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_cancel.png"]];
					//[cell.contentView addSubview:imageview];
				}
					break;
					
					
				default:
					break;
			}
			
			[imageview release];
	}
	else if(m_iSelectedTable == SelectedTableGroupOrder){
		UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 14, 14)];
		
		switch (row) {
			case 0:
				cell.stateImageView.hidden = YES;
				break;

			case 1:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_used.png"]];
				//[cell.contentView addSubview:imageview];
			}
				break;
				
			case 2:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_active.png"]];
				//[cell.contentView addSubview:imageview];
			}
				break;
				
			case 3:
			{
				cell.stateImageView.hidden = NO;
				[cell.stateImageView setImage:[UIImage noCacheImageNamed:@"ico_orderstate_cancel.png"]];
				//[cell.contentView addSubview:imageview];
			}
				break;
				
				
			default:
				break;
		}
		
		[imageview release];
		
		
	}
	
	//select
	if (selectedDictionary != nil && [selectedDictionary count] != 0) {
		if ([[selectedDictionary safeObjectForKey:indexPath] isEqualToString:[dataArray safeObjectAtIndex:row]] ||
			(otherDataArray && [selectedDictionary safeObjectForKey:indexPath] == [otherDataArray safeObjectAtIndex:row])) {
			cell.isSelected = YES;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
		} else {
			cell.isSelected = NO;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
		}
		cell.typeLabel.text = [dataArray safeObjectAtIndex:row];
	} else {
		cell.isSelected = NO;
		cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
		cell.typeLabel.text = [dataArray safeObjectAtIndex:row];
	}
	
	if (indexPath.section == 1) {
		cell.typeLabel.text = [otherDataArray safeObjectAtIndex:row];
	}

    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SelectTableCell *cell = (SelectTableCell *)[tableView cellForRowAtIndexPath:indexPath];
	if (m_iSelectedTable == SelectedTableAirlines ||
		SelectedTableTrain == m_iSelectedTable ||
		(SelectedTableTrainStation == m_iSelectedTable && indexPath.section == 0)) {
		if ([indexPath row] == 0) {
			// 选中“全部”，将其它选项都选中，取消“全部“，则相反操作
			if (cell.isSelected) {
				for (int i=0; i<[dataArray count]; i++) {
					NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
					SelectTableCell *cellAll = (SelectTableCell *)[tableView cellForRowAtIndexPath:path];
					cellAll.isSelected = NO;
					[selectedDictionary removeObjectForKey:path];
					cellAll.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
				}
			} else {
				for (int i=0; i<[dataArray count]; i++) {
					NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
					SelectTableCell *cellAll = (SelectTableCell *)[tableView cellForRowAtIndexPath:path];
					cellAll.isSelected = YES;
					[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:i] forKey:path];
					cellAll.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
				}
			}
		} else {
			if (cell.isSelected) {
				cell.isSelected = NO;
				[selectedDictionary removeObjectForKey:indexPath];
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
				
				// 任意选项取消选择后，也取消”全部“的选中状态
				NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
				SelectTableCell *cellAll = (SelectTableCell *)[tableView cellForRowAtIndexPath:path];
				cellAll.isSelected = NO;
				[selectedDictionary removeObjectForKey:path];
				cellAll.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
				
			} else {
				cell.isSelected = YES;
				[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
				
				// 选择了除“全部”外的所有选项，自动选中“全部”
				if ([selectedDictionary count] == [dataArray count] - 1) {
					NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
					SelectTableCell *cellAll = (SelectTableCell *)[tableView cellForRowAtIndexPath:path];
					cellAll.isSelected = YES;
					[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:0] forKey:path];
					cellAll.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
				}
			}
		}
		//[tabView reloadData];
		
	}
	else if (SelectedTableTrainStation == m_iSelectedTable && indexPath.section == 1) {
		if (cell.isSelected == NO) {
			cell.isSelected = YES;
			[selectedDictionary safeSetObject:[otherDataArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
			
			[selectedDictionary removeObjectForKey:lastPath];
			SelectTableCell *lastCell = (SelectTableCell *)[tableView cellForRowAtIndexPath:lastPath];
			lastCell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			lastCell.isSelected = NO;
			
			self.lastPath = indexPath;
		}
	}
	else {
		if (cell.isSelected == NO) {
			cell.isSelected = YES;
			[selectedDictionary removeAllObjects];
			[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
			
			m_iTable = [indexPath row];
			[tabView reloadData];
		}
	}
}

#pragma mark DPViewTopBarDelegate

- (BOOL)checkSelectedValue {
	// 检测是否至少选中一个搜索条件
	if (SelectedTableTrainStation == m_iSelectedTable) {
		// 车站查询的筛选界面需要2个搜索条件
		return [[selectedDictionary allValues] count] > 1 ? YES : NO;
	}
	else {
		// 其它的只需要一个条件
		return [[selectedDictionary allValues] count] > 0 ? YES : NO;
	}
}


- (void)noChooseTip {
	// 没有选择搜索条件的提示(多选页面才有)
	if (SelectedTableAirlines == m_iSelectedTable) {
		[Utils alert:@"您没有选择航空公司"];
	}
	else if (SelectedTableTrain == m_iSelectedTable ||
			 SelectedTableTrainStation == m_iSelectedTable) {
		[Utils alert:@"您没有选择车型"];
	}
}


- (void)dpViewLeftBtnPressed {
	isShow = NO;
	
	if (m_iMaxNum <= SELECT_TABLE_DATA_MAX_NUM) {
		[Utils animationView:self.view
					   fromX:0
					   fromY:SCREEN_HEIGHT -STATUS_BAR_HEIGHT -NAVIGATION_BAR_HEIGHT -self.view.frame.size.height + addtionHeight
						 toX:0
						 toY:SCREEN_HEIGHT
					   delay:0.0f
					duration:SHOW_WINDOWS_DEFAULT_DURATION];
		if (m_iSelectedTable == SelectedTableGroupOrder && m_iFrom == FromGrouponOrder) {
			ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
			GrouponOrderHistoryController *controller = (GrouponOrderHistoryController *)[appDelegate.navigationController topViewController];
			if ([controller.currentDisArray count] == 0) {
				[controller noListTip];
			}
		}
	} else {
		ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        if (IOSVersion_7) {
            [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [appDelegate.navigationController dismissModalViewControllerAnimated:YES];
        }
	}
}

- (void)dpViewRightBtnPressed {
	isShow = NO;
	if ([self checkSelectedValue]) {
		ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (m_iSelectedTable == SelectedTableClass) {
			FlightSearch *controller = (FlightSearch *)[appDelegate.navigationController topViewController];
			controller.classLabel.text = [dataArray safeObjectAtIndex:m_iTable];
			if (m_Saved) {
				[[SettingManager instanse] setClassType:controller.classLabel.text];
			}
			
			controller.m_iClassType = m_iTable;
			
		}
		else if(SelectedTableTrainSort == m_iSelectedTable && m_iFrom == FromTrainSort){
			//TrainListViewController* controller = (TrainListViewController*)[appDelegate.navigationController topViewController];
			//[controller segmentedClick:m_iTable];
		}
		else if(m_iSelectedTable == SelectedTableTrainSortStation&&m_iFrom ==FromTrainSortStation){
			//TrainListViewController* controller = (TrainListViewController*)[appDelegate.navigationController topViewController];
			//[controller segmentedClick:m_iTable];
		}else if(m_iSelectedTable == SelectedTableAirLineSort && m_iFrom == FromAirLineSort){
			//FlightList* controller = (FlightList*)[appDelegate.navigationController topViewController];
//			[controller segmentedClick:m_iTable];
		}
		 else if (m_iSelectedTable == SelectedTableCertificate && m_iFrom == FromAddCustomer) {
			AddAndEditCustomer *controller = (AddAndEditCustomer *)[appDelegate.navigationController topViewController];
			controller.inputIdTypeName.text = [dataArray safeObjectAtIndex:m_iTable];
			
		} else if (m_iSelectedTable == SelectedTableCertificate && m_iFrom == FromAddAndEditCard) {
			//AddAndEditCard *controller = (AddAndEditCard *)[appDelegate.navigationController topViewController];
			//controller.typeLabel.text = [dataArray safeObjectAtIndex:m_iTable];
			
		} else if (m_iSelectedTable == SelectedTableBank && m_iFrom == FromAddAndEditCard) {
			//AddAndEditCard *controller = (AddAndEditCard *)[appDelegate.navigationController topViewController];
			//controller.bankLabel.text = [dataArray safeObjectAtIndex:m_iTable];
			
		} else if (m_iSelectedTable == SelectedTableAirlines) {
            BOOL fillerfromflightlist = NO;
            for (UIViewController *controller in appDelegate.navigationController.viewControllers) {
                if ([controller isKindOfClass:[FlightList class]]) {
                    fillerfromflightlist = YES;
                    break;
                }
            }
            
			FlightList *controller = (FlightList *)[appDelegate.navigationController topViewController];
			[controller.dataSourceArray removeAllObjects];
			if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
				if ([[FlightData getFArrayGo] count] > 0) {
					for (int j=0; j<[[FlightData getFArrayGo] count]; j++) {
						Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:j];
						
						for (int i=0;i<[iconNameArray count]; i++) {
							NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
							SelectTableCell *cell = (SelectTableCell *)[tabView cellForRowAtIndexPath:path];
							
							if (cell.isSelected && [cell.typeLabel.text isEqualToString:[flight getAirCorpName]]) {
								
								[controller.dataSourceArray addObject:flight];
							}
						}
					}
				}
			} else {
				if ([[FlightData getFArrayReturn] count] > 0) {
					for (int j=0; j<[[FlightData getFArrayReturn] count]; j++) {
						Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:j];
						
						for (int i=0;i<[iconNameArray count]; i++) {
							NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
							SelectTableCell *cell = (SelectTableCell *)[tabView cellForRowAtIndexPath:path];
							
							if (cell.isSelected && [cell.typeLabel.text isEqualToString:[flight getAirCorpName]]) {
								
								[controller.dataSourceArray addObject:flight];
							}
						}
					}
				}
			}
			[controller.tabView reloadData];
			[controller updateAirPortArray];
			[controller selectedIndex:controller.currentOrder];
			
            ElongClientAppDelegate *delegate1 = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate1.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

            
            if (IOSVersion_7) {
                [delegate1.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [delegate1.navigationController dismissModalViewControllerAnimated:YES];
            }
		}
		
		[delegate getParamStrings:[selectedDictionary allValues]];
		
		if (m_iMaxNum <= SELECT_TABLE_DATA_MAX_NUM) {
			if (m_iSelectedTable != SelectedTableAirlines) {
				[Utils animationView:self.view
							   fromX:0
							   fromY:SCREEN_HEIGHT -STATUS_BAR_HEIGHT -NAVIGATION_BAR_HEIGHT -self.view.frame.size.height
								 toX:0
								 toY:SCREEN_HEIGHT
							   delay:0.0f
							duration:SHOW_WINDOWS_DEFAULT_DURATION];
			}
			
		} else {
			appDelegate.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            if (IOSVersion_7) {
                [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [appDelegate.navigationController dismissModalViewControllerAnimated:YES];
            }
		}

	}
	else {
		[self noChooseTip];
		
	}

	
	

	
}

@end
