//
//  ArriveTime.m
//  ElongClient
//
//  Created by bin xing on 11-1-16.
//  Copyright 2011 DP. All rights reserved.
//

#import "ArriveTime.h"
#import "ArriveTimeCell.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelSearch.h"
#import "ElongClientAppDelegate.h"

@interface ArriveTime ()

@property (nonatomic, retain) NSIndexPath    *lastIndexPath;

@end

@implementation ArriveTime

@synthesize lastIndexPath;
@synthesize dataSource;

-(id)initWithFillHotelOrder:(FillHotelOrder *)controler{
	if (self=[super init]) {
		self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		
		dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"选择房间保留时间"] autorelease]];
		dpViewTopBar.delegate=self;
		parentController=controler;
		defaultTableView = [[UITableView alloc] 
							initWithFrame:CGRectMake(0, 44+10, 320, SCREEN_HEIGHT-44-20-20)
							style:UITableViewStylePlain];
		
		defaultTableView.backgroundColor = [UIColor whiteColor];
		defaultTableView.delegate=self;
		defaultTableView.dataSource=self;
		defaultTableView.separatorStyle = UITableViewCellSelectionStyleNone;
		
		[self.view addSubview:defaultTableView];
		[self.view addSubview:dpViewTopBar.view];
	}
	return self;
}

-(void)loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	UIImageView *shaowView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
	[shaowView setFrame:CGRectMake(0, 0, 320, 11)];
	[self.view addSubview:shaowView];
	[shaowView release];
	
}


- (void)setArriveTime:(NSString *)timeStr {
	for (NSString *dateTime in dataSource) {
		if ([dateTime isEqualToString:timeStr]) {
			self.lastIndexPath = [NSIndexPath indexPathForRow:[dataSource indexOfObject:dateTime] inSection:0];
			[defaultTableView reloadData];
			break;
		}
	}
}


- (void)setArriveTimes:(NSMutableArray *)times {
	self.dataSource = times;
	[defaultTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"ArriveTimeCellIdentifier";
	NSInteger row = [indexPath row];
	
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:CellIdentifier height:HSC_CELL_HEGHT style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSString *customer = [dataSource safeObjectAtIndex:row];
	cell.textLabel.text = customer;
	
	if ([indexPath isEqual:lastIndexPath]) {
		cell.cellImage.highlighted = YES;
	}else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return HSC_CELL_HEGHT;
	
}
- (void) deselect
{	
	[defaultTableView deselectRowAtIndexPath:[defaultTableView indexPathForSelectedRow] animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	if (![newIndexPath isEqual:lastIndexPath])
    {
		CommonCell *oldCell = (CommonCell *)[tableView cellForRowAtIndexPath: 
											 lastIndexPath]; 
		oldCell.cellImage.highlighted = NO;
		
        CommonCell *newCell = (CommonCell *)[tableView cellForRowAtIndexPath:
											 newIndexPath];
		
		newCell.cellImage.highlighted = YES;
		
        self.lastIndexPath = newIndexPath;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [dataSource count];
}

- (void)dpViewLeftBtnPressed {
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (IOSVersion_7) {
        [delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [delegate.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)dpViewRightBtnPressed {
    /*
	parentController.timeRangeLabel.text=[dataSource safeObjectAtIndex:[lastIndexPath row]];
	parentController.current_ArriveTimeIndex=[lastIndexPath row];
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.navigationController dismissModalViewControllerAnimated:YES];
	*/
}


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
	[dpViewTopBar release];
	[defaultTableView release];
	[dataSource release];
	self.lastIndexPath = nil;
	
    [super dealloc];
}


- (NSArray *)arriveTimeIndex {
	NSArray	*arriveTimeIndex = [NSArray arrayWithObjects:
								[NSNumber numberWithInt:6],
								[NSNumber numberWithInt:7],
								[NSNumber numberWithInt:8],
								[NSNumber numberWithInt:9],
								[NSNumber numberWithInt:10],
								[NSNumber numberWithInt:11],
								[NSNumber numberWithInt:12],
								[NSNumber numberWithInt:13],
								[NSNumber numberWithInt:14],
								[NSNumber numberWithInt:15],
								[NSNumber numberWithInt:16],
								[NSNumber numberWithInt:17],
								[NSNumber numberWithInt:18],
								[NSNumber numberWithInt:19],
								[NSNumber numberWithInt:20],
								[NSNumber numberWithInt:21],
								[NSNumber numberWithInt:22],
								[NSNumber numberWithInt:23],
								[NSNumber numberWithInt:0],
								[NSNumber numberWithInt:1],
								[NSNumber numberWithInt:2],
								[NSNumber numberWithInt:3],
								nil];
	
	return arriveTimeIndex;
}

- (NSMutableArray *)arriveTimeLabel {
	NSMutableArray *arriveTimeLabel = [NSMutableArray arrayWithObjects:
									   @"6:00-9:00", 
									   @"7:00-10:00",
									   @"8:00-11:00", 
									   @"9:00-12:00", 
									   @"10:00-13:00",
									   @"11:00-14:00",
									   @"12:00-15:00",
									   @"13:00-16:00", 
									   @"14:00-17:00", 
									   @"15:00-18:00",
									   @"16:00-19:00",
									   @"17:00-20:00", 
									   @"18:00-21:00", 
									   @"19:00-22:00",
									   @"20:00-23:00",
									   @"21:00-23:59", 
									   @"22:00-次日1:00", 
									   @"23:00-次日2:00",
									   @"23:59-次日3:00",
									   @"次日01:00-4:00",
									   @"次日02:00-5:00",
									   @"次日03:00-6:00",nil];
	
	return arriveTimeLabel;
}


- (NSMutableArray *)arriveTimeValue {
	NSMutableArray *arriveTimeValue = [NSMutableArray arrayWithObjects:
									   [NSValue valueWithRange:NSMakeRange(6*60*60, 9*60*60-6*60*60)],
									   [NSValue valueWithRange:NSMakeRange(7*60*60, 10*60*60-7*60*60)],
									   [NSValue valueWithRange:NSMakeRange(8*60*60, 11*60*60-8*60*60)],
									   [NSValue valueWithRange:NSMakeRange(9*60*60, 12*60*60-9*60*60)],
									   [NSValue valueWithRange:NSMakeRange(10*60*60,13*60*60-10*60*60)],
									   [NSValue valueWithRange:NSMakeRange(11*60*60, 14*60*60-11*60*60)],
									   [NSValue valueWithRange:NSMakeRange(12*60*60, 15*60*60-12*60*60)],
									   [NSValue valueWithRange:NSMakeRange(13*60*60, 16*60*60-13*60*60)],
									   [NSValue valueWithRange:NSMakeRange(14*60*60, 17*60*60-14*60*60)],
									   [NSValue valueWithRange:NSMakeRange(15*60*60, 18*60*60-15*60*60)],
									   [NSValue valueWithRange:NSMakeRange(16*60*60, 19*60*60-16*60*60)],
									   [NSValue valueWithRange:NSMakeRange(17*60*60, 20*60*60-17*60*60)],
									   [NSValue valueWithRange:NSMakeRange(18*60*60, 21*60*60-18*60*60)],
									   [NSValue valueWithRange:NSMakeRange(19*60*60, 22*60*60-19*60*60)],
									   [NSValue valueWithRange:NSMakeRange(20*60*60, 23*60*60-20*60*60)],
									   [NSValue valueWithRange:NSMakeRange(21*60*60, 24*60*60-60-21*60*60)],
									   [NSValue valueWithRange:NSMakeRange(22*60*60, 25*60*60-22*60*60)],
									   [NSValue valueWithRange:NSMakeRange(23*60*60, 26*60*60-23*60*60)],
									   [NSValue valueWithRange:NSMakeRange(24*60*60-60, 27*60*60-24*60*60+60)],
									   [NSValue valueWithRange:NSMakeRange(25*60*60, 28*60*60-25*60*60)],
									   [NSValue valueWithRange:NSMakeRange(26*60*60, 29*60*60-26*60*60)],
									   [NSValue valueWithRange:NSMakeRange(27*60*60, 30*60*60-27*60*60)],
									   nil];
	
	return arriveTimeValue;
}


@end