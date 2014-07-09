//
//  FlightAirPortTable.m
//  ElongClient
//
//  Created by dengfang on 11-2-23.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightAirPortTable.h"
#import "SelectTableCell.h"
#import "FlightList.h"
#import "FlightDataDefine.h"

#define AIR_PORT_CELL_HEIGHT 45

@implementation FlightAirPortTable

- (void)showSelectTable:(UIViewController *)controller {
	if (m_iMaxNum <= AIR_PORT_DATA_MAX_NUM) {
		[Utils animationView:self.view
					   fromX:0
					   fromY:SCREEN_HEIGHT
						 toX:0
						 toY:SCREEN_HEIGHT -STATUS_BAR_HEIGHT -NAVIGATION_BAR_HEIGHT -self.view.frame.size.height
					   delay:0.0f
					duration:SHOW_WINDOWS_DEFAULT_DURATION];
	} else {
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



- (void)updateDepartArray:(NSMutableArray *)departArray arrivalArray:(NSMutableArray *)arrivalArray {
	
	[dDictionary removeAllObjects];
	
	
	for (int i=0;i< [dArray count]; i++) {
		
		NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
		for (int j=0; j<[departArray count]; j++) {
			
			if ([[dArray safeObjectAtIndex:i] isEqualToString:[departArray safeObjectAtIndex:j]]) {
				//if ([dDictionary safeObjectForKey:path]!=nil) {
					[dDictionary safeSetObject:[dArray safeObjectAtIndex:i] forKey:path];
				//}
			}
		}
	}
		[aDictionary removeAllObjects];
	
	for (int i=0;i< [aArray count]; i++) {
		
		NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
		for (int j=0; j<[arrivalArray count]; j++) {
			if ([[aArray safeObjectAtIndex:i] isEqualToString:[arrivalArray safeObjectAtIndex:j]]) {
				[aDictionary safeSetObject:[aArray safeObjectAtIndex:i] forKey:path];
			}
		}
	}
	
	[dTabView reloadData];
	[aTabView reloadData];
}

- (id)initWithDepartArray:(NSMutableArray *)departArray arrivalArray:(NSMutableArray *)arrivalArray {
	if ((self = [super init])) {
		//data
		m_iState = SelectStateDepart;
		dArray = [[NSMutableArray alloc] initWithArray:departArray];
		aArray = [[NSMutableArray alloc] initWithArray:arrivalArray];
		
		dDictionary = [[NSMutableDictionary alloc] init];
		dSelectRowArray = [[NSMutableArray alloc] init];
		for (int i=0; i<[dArray count]; i++) {
			NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
			[dDictionary safeSetObject:[dArray safeObjectAtIndex:i] forKey:path];
			[dSelectRowArray addObject:[NSNumber numberWithInt:[path row]]];
		}
		aDictionary = [[NSMutableDictionary alloc] init];
		aSelectRowArray = [[NSMutableArray alloc] init];
		for (int i=0; i<[aArray count]; i++) {
			NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
			[aDictionary safeSetObject:[aArray safeObjectAtIndex:i] forKey:path];
			[aSelectRowArray addObject:[NSNumber numberWithInt:[path row]]];
		}
		
		
		//UI
		//title
		self.view = [[[UIView alloc] init] autorelease];
		UIImageView *shaowView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
		[shaowView setFrame:CGRectMake(0, 0, 320, 11)];
		//[self.view addSubview:shaowView];
		[shaowView release];
		//dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择机场"] autorelease]];
//		dpViewTopBar.delegate = self;
		//[self.view addSubview:dpViewTopBar.view];
		
		// 添加选择器
		NSArray *titleArray = [NSArray arrayWithObjects:@"起飞机场", @"到达机场", nil];
		
		CustomSegmented *seg = [[CustomSegmented alloc] initCommanSegmentedWithTitles:titleArray
																		  normalIcons:nil 
																	   highlightIcons:nil];
		seg.frame = CGRectOffset(seg.frame, 0, -10);
		seg.delegate		= self;
		seg.selectedIndex	= 0;
		[self.view addSubview:seg];
		[seg release];
		
		if ([dArray count] >= [aArray count]) {
			m_iMaxNum = [dArray count];
		} else {
			m_iMaxNum = [aArray count];
		}
		int h1 = [dArray count] *AIR_PORT_CELL_HEIGHT;
		int h2 = [aArray count] *AIR_PORT_CELL_HEIGHT;
		if (m_iMaxNum > AIR_PORT_DATA_MAX_NUM) {
			h1 = (AIR_PORT_DATA_MAX_NUM +1) *AIR_PORT_CELL_HEIGHT;
			h2 = h1;
		}
		dTabView = [[UITableView alloc] initWithFrame:CGRectMake(5, 60, SCREEN_WIDTH -10, h1) style:UITableViewStylePlain];
		dTabView.delegate = self;
		dTabView.dataSource = self;
		dTabView.hidden = NO;
		dTabView.backgroundColor = [UIColor clearColor];
		dTabView.separatorStyle = UITableViewCellSelectionStyleNone;
		[self.view addSubview:dTabView];
		
		aTabView = [[UITableView alloc] initWithFrame:CGRectMake(5, 60, SCREEN_WIDTH -10, h2) style:UITableViewStylePlain];
		aTabView.delegate = self;
		aTabView.dataSource = self;
		aTabView.hidden = YES;
		aTabView.backgroundColor = [UIColor clearColor];
		aTabView.separatorStyle = UITableViewCellSelectionStyleNone;
		[self.view addSubview:aTabView];
		
		int h = (h1 >= h2) ? h1 : h2;
		self.view.frame = CGRectMake(0,88, SCREEN_WIDTH, dTabView.frame.origin.y +h +10);
	}
	return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[dpViewTopBar release];
	[dTabView release];
	[aTabView release];
	[dArray release];
	[aArray release];
	[dDictionary release];
	[aDictionary release];
	[dSelectRowArray release];
	[aSelectRowArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (m_iState == SelectStateDepart) {
		return [dArray count];
	}
	return [aArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return AIR_PORT_CELL_HEIGHT;
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
				[cell.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(15, AIR_PORT_CELL_HEIGHT - 1, tableView.frame.size.width - 30, 1)]];
			}
		}
    }
	//set cell
    NSUInteger row = [indexPath row];
	//select
	if (m_iState == SelectStateDepart) {
		if (dDictionary != nil && [dDictionary count] != 0) {
			if ([dDictionary safeObjectForKey:indexPath] == [dArray safeObjectAtIndex:row]) {
				cell.isSelected = YES;
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
			} else {
				cell.isSelected = NO;
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			}
			cell.typeLabel.text = [dArray safeObjectAtIndex:row];
		}else {
			cell.isSelected = NO;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			cell.typeLabel.text = [dArray safeObjectAtIndex:row];
		}

	} else {
		if (aDictionary != nil && [aDictionary count] != 0) {
			if ([aDictionary safeObjectForKey:indexPath] == [aArray safeObjectAtIndex:row]) {
				cell.isSelected = YES;
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
			} else {
				cell.isSelected = NO;
				cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			}
			cell.typeLabel.text = [aArray safeObjectAtIndex:row];
		}else {
			cell.isSelected = NO;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			cell.typeLabel.text = [aArray safeObjectAtIndex:row];
		}

	}
    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SelectTableCell *cell = (SelectTableCell *)[tableView cellForRowAtIndexPath:indexPath];
	if (m_iState == SelectStateDepart) {
		if (cell.isSelected) {
			cell.isSelected = NO;
			[dDictionary removeObjectForKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			
		} else {
			cell.isSelected = YES;
			[dDictionary safeSetObject:[dArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
		}
		[dTabView reloadData];
	} else {
		if (cell.isSelected) {
			cell.isSelected = NO;
			[aDictionary removeObjectForKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
			
		} else {
			cell.isSelected = YES;
			[aDictionary safeSetObject:[aArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
			cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
		}
		[aTabView reloadData];
	}
}

#pragma mark -
#pragma mark CustomSegmented Delegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index {
	switch (index) {
		case 0:
			dTabView.hidden = NO;
			aTabView.hidden = YES;
			m_iState = SelectStateDepart;
			[dTabView reloadData];
			break;
		case 1:
			dTabView.hidden = YES;
			aTabView.hidden = NO;
			m_iState = SelectStateArrival;
			[aTabView reloadData];
			break;
	}
}

#pragma mark DPViewTopBarDelegate
-(BOOL)containVaule:(NSArray *)array city:(NSString *)city{
	
	for (NSString *s in array) {
		if ([s isEqualToString:city]) {
			return YES;
		}
	}
	return NO;
}


- (void)dpViewLeftBtnPressed {
	if (m_iMaxNum <= AIR_PORT_DATA_MAX_NUM) {
		[Utils animationView:self.view
					   fromX:0
					   fromY:SCREEN_HEIGHT -STATUS_BAR_HEIGHT -NAVIGATION_BAR_HEIGHT -self.view.frame.size.height
						 toX:0
						 toY:SCREEN_HEIGHT
					   delay:0.0f
					duration:SHOW_WINDOWS_DEFAULT_DURATION];
	} else {
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		delegate.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        if (IOSVersion_7) {
            [delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [delegate.navigationController dismissModalViewControllerAnimated:YES];
        }
	}
}


- (BOOL)dpViewRightBtnPressed {
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    id vc = [delegate.navigationController topViewController];
    if ([vc isKindOfClass:[FlightList class]]) {
        FlightList *controller = (FlightList *)[delegate.navigationController topViewController];
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
            if ([[FlightData getFArrayGo] count] > 0) {
                
                NSMutableDictionary *temp=[NSMutableDictionary dictionaryWithCapacity:2];
                NSMutableArray *temparray1=[NSMutableArray arrayWithCapacity:2];
                
                for (int j=0; j<[dArray count]; j++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                    SelectTableCell *cell = (SelectTableCell *)[dTabView cellForRowAtIndexPath:path];
                    if (cell.isSelected) {
                        [temparray1 addObject:[dArray safeObjectAtIndex:j]/*cell.typeLabel.text*/];
                    }
                }
                
                if ([temparray1 count] == 0) {
                    [Utils alert:@"您没有选择起飞机场"];
                    return NO;
                }
                
                [temp safeSetObject:temparray1 forKey:@"df"];
                
                NSMutableArray *temparray2=[NSMutableArray arrayWithCapacity:2];
                
                for (int j=0; j<[aArray count]; j++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                    SelectTableCell *cell = (SelectTableCell *)[aTabView cellForRowAtIndexPath:path];
                    if (cell.isSelected) {
                        [temparray2 addObject:[aArray safeObjectAtIndex:j]/*cell.typeLabel.text*/];
                    }
                }
                
                if ([temparray2 count] == 0) {
                    [Utils alert:@"您没有选择到达机场"];
                    return NO;
                }
                
                [temp safeSetObject:temparray2 forKey:@"af"];
                
                [controller.dataSourceArray removeAllObjects];
                
                for (int j=0; j<[[FlightData getFArrayGo] count]; j++) {
                    
                    Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:j];
                    
                    if ([self containVaule:[temp safeObjectForKey:@"df"] city:[flight getDepartAirport]]&&
                        [self containVaule:[temp safeObjectForKey:@"af"] city:[flight getArriveAirport]]
                        ) {
                        
                        [controller.dataSourceArray addObject:flight];
                    }
                    
                }
            }
            
        } else {
            if ([[FlightData getFArrayReturn] count] > 0) {
                NSMutableDictionary *temp=[NSMutableDictionary dictionaryWithCapacity:2];
                NSMutableArray *temparray1=[NSMutableArray arrayWithCapacity:2];
                
                for (int j=0; j<[dArray count]; j++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                    SelectTableCell *cell = (SelectTableCell *)[dTabView cellForRowAtIndexPath:path];
                    if (cell.isSelected) {
                        [temparray1 addObject:cell.typeLabel.text];
                    }
                }
                
                if ([temparray1 count] == 0) {
                    [Utils alert:@"您没有选择起飞机场"];
                    return NO;
                }
                
                [temp safeSetObject:temparray1 forKey:@"df"];
                
                NSMutableArray *temparray2=[NSMutableArray arrayWithCapacity:2];
                
                for (int j=0; j<[aArray count]; j++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                    SelectTableCell *cell = (SelectTableCell *)[aTabView cellForRowAtIndexPath:path];
                    if (cell.isSelected) {
                        [temparray2 addObject:cell.typeLabel.text];
                    }
                }
                
                if ([temparray2 count] == 0) {
                    [Utils alert:@"您没有选择到达机场"];
                    return NO;
                }
                
                [temp safeSetObject:temparray2 forKey:@"af"];
                
                for (int j=0; j<[[FlightData getFArrayReturn] count]; j++) {
                    
                    Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:j];
                    
                    if ([self containVaule:[temp safeObjectForKey:@"df"] city:[flight getDepartAirport]]&&
                        [self containVaule:[temp safeObjectForKey:@"af"] city:[flight getArriveAirport]]
                        ) {
                        
                        [controller.dataSourceArray addObject:flight];
                    }	
                }
            }
        }
        [controller selectedIndex:controller.currentOrder];
        [controller.tabView reloadData];
        [controller updateAirCorpArray];
        
        ElongClientAppDelegate *delegate1 = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate1.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        if (IOSVersion_7) {
            [delegate1.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [delegate1.navigationController dismissModalViewControllerAnimated:YES];
        }
    }
	
	return YES;
}

@end
