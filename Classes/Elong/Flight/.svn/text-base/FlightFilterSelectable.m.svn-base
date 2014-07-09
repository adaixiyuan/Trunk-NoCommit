//
//  FlightFillerSelectable.m
//  ElongClient
//
//  Created by li dechen on 12-1-7.
//  Copyright 2012年 elong. All rights reserved.
//

#import "FlightFilterSelectable.h"
#import "FlightList.h"
#import "FlightDataDefine.h"
#import "Flight.h"

#define MAXCOUNT        (SCREEN_4_INCH ? 6 : 5)

@interface FlightFilterSelectable ()

@property (nonatomic, retain) NSMutableArray *airlinesArray;
@property (nonatomic, retain) NSMutableArray *departArray;
@property (nonatomic, retain) NSMutableArray *arrivalArray;
@property (nonatomic, retain) NSMutableArray *sorArray;

@end

@implementation FlightFilterSelectable

@synthesize selectTable;
@synthesize airPortTable;
@synthesize airlinesArray;
@synthesize departArray;
@synthesize arrivalArray;
@synthesize sorArray;

- (void)showSelectTable:(UIViewController *)controller {
	
	flight = controller;
	
    if (!isShowing) {
        if ([airlinesArray count] > MAXCOUNT) {
            if (IOSVersion_7) {
                self.transitioningDelegate = [ModalAnimationContainer shared];
                self.modalPresentationStyle = UIModalPresentationCustom;
            }
            if (IOSVersion_7) {
                [controller presentViewController:self animated:YES completion:nil];
            }else{
                [controller presentModalViewController:self animated:YES];
            }
        }
        else {
            [Utils animationView:self.view
                           fromX:0
                           fromY:SCREEN_HEIGHT
                             toX:0
                             toY:MAINCONTENTHEIGHT -self.view.frame.size.height
                           delay:0.0f
                        duration:0.3f];
        }
        
        isShowing = YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.sorArray = nil;
	self.airlinesArray = nil;
	self.departArray = nil;
	self.arrivalArray = nil;
	
	[selectTable release];
	[airPortTable release];
	[dpViewTopBar release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	SFRelease(selectTable);
	SFRelease(airPortTable);
	SFRelease(dpViewTopBar);
}

#pragma mark - View lifecycle

- (id)init:(NSMutableArray*)airArray port:(NSMutableArray*)port Array:(NSMutableArray*)arrivalay datasources:(NSMutableArray*)sourceArray{
	if (self = [super init]) {
        isShowing = NO;
        
		self.airlinesArray = airArray;
		self.departArray = port;
		self.arrivalArray = arrivalay;
		self.sorArray = sourceArray;
	}
	
	return self;	
}


- (void)resetAirs:(NSMutableArray*)airArray port:(NSMutableArray*)port Array:(NSMutableArray*)arrivalay datasources:(NSMutableArray*)sourceArray {
	self.airlinesArray = airArray;
	self.departArray = port;
	self.arrivalArray = arrivalay;
	self.sorArray = sourceArray;
}


-(void)addHeaderView{
	// 添加选择器
	NSArray *titleArray = [NSArray arrayWithObjects:@"航空公司", @"机  场", nil];
	
	CustomSegmented *seg = [[CustomSegmented alloc] initCommanSegmentedWithTitles:titleArray
																	  normalIcons:nil 
																   highlightIcons:nil];
	seg.delegate		= self;
	seg.selectedIndex	= 0;
	seg.frame = CGRectOffset(seg.frame, 0, 38);
	[self.view addSubview:seg];
	[seg release];
}

#pragma mark -
#pragma mark CustomSegmented Delegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index {
	switch (index) {
		case 0:
		{
			m_iType = 0;
			airPortTable.view.hidden = YES;
			selectTable.view.hidden = NO;
		}
			
			break;
		case 1:
		{
			m_iType = 1;
			airPortTable.view.hidden = NO;
			selectTable.view.hidden = YES;
		}
			
			break;
	}
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44+80+45*([airlinesArray count]+1))] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self addHeaderView];
	
	UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, SCREEN_WIDTH, 15)];
	topShadow.image = [UIImage noCacheImageNamed:@"selecTable_shadow.png"];
	[self.view addSubview:topShadow];
	[topShadow release];
    
    selectTable = [[SelectTable alloc] init:SelectedTableAirlines from:FromFlightList data:airlinesArray];
	selectTable.view.frame = CGRectMake(0, 100, SCREEN_WIDTH, selectTable.view.frame.size.height);

	[self.view addSubview:selectTable.view];
	
	airPortTable = [[FlightAirPortTable alloc] initWithDepartArray:departArray arrivalArray:arrivalArray];
	airPortTable.view.frame = CGRectMake(0, 100, SCREEN_WIDTH, airPortTable.view.frame.size.height);
	[self.view addSubview:airPortTable.view];
	airPortTable.view.hidden = YES;
	
	dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"筛选"] autorelease]];
	dpViewTopBar.delegate = self;
	[self.view addSubview:dpViewTopBar.view];
}


- (void)dpViewLeftBtnPressed{
    if (isShowing) {
        if ([airlinesArray count] > MAXCOUNT) {
            if (IOSVersion_7) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self dismissModalViewControllerAnimated:YES];
            }
        }
        else {
            [Utils animationView:self.view
                           fromX:0
                           fromY:MAINCONTENTHEIGHT -self.view.frame.size.height
                             toX:0
                             toY:SCREEN_HEIGHT
                           delay:0.0f
                        duration:0.3f];
        }
        
        isShowing = NO;
    }
}
- (void)dpViewRightBtnPressed{
	//根据tab 去处理不同的事件
	if (m_iType == 0) {
		if (![selectTable checkSelectedValue]) {
			[selectTable noChooseTip];
			return;
		}
		
		[selectTable dpViewRightBtnPressed];
		[self dpViewLeftBtnPressed];

	}
	else if(m_iType == 1){
		if ([airPortTable dpViewRightBtnPressed]) {
			[self dpViewLeftBtnPressed];
		}
	}
}

- (NSMutableArray *)getAirlinesArray:(NSMutableArray *)Array {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *aflight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[aflight getAirCorpName] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[aflight getAirCorpName]];
		}
	}
	
	
	return [array autorelease];
}
- (NSMutableArray *)getDepartArray:(NSMutableArray *)Array {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *aflight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[aflight getDepartAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[aflight getDepartAirport]];
		}
	}
	
	return [array autorelease];
}

- (NSMutableArray *)getArrivalArray:(NSMutableArray *)Array {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *aflight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[aflight getArriveAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[aflight getArriveAirport]];
		}
	}
	
	return [array autorelease];
}


- (void)updateAirCorpArray {
	[selectTable updateDataArray:[self getAirlinesArray:sorArray]];
}

- (void)updateAirPortArray {
	[airPortTable updateDepartArray:[self getDepartArray:sorArray] arrivalArray:[self getArrivalArray:sorArray]];
}
 

@end
