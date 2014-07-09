//
//  FlightOrderHistoryDetailFlightInfoViewController.m
//  ElongClient
//
//  Created by WangHaibin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightOrderHistoryDetailFlightInfoViewController.h"


@implementation FlightOrderHistoryDetailFlightInfoViewController
@synthesize airlinesLabel;

@synthesize departTimeLabel;
@synthesize arrivalTimeLabel;
@synthesize ticketStateLabel;
@synthesize stoplabel;
@synthesize departStationLabel;
@synthesize arriveStationLabel;
@synthesize capinLabel;
@synthesize goOrBackBg;
@synthesize goOrBackTypeLabel;
@synthesize delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)goRule:(id)sender{
    if([delegate respondsToSelector:@selector(reviewRule:)]){
        [delegate reviewRule:self.view.tag];
    }
}

- (void)dealloc {
    
	[airlinesLabel release];
	
	[departTimeLabel release];
	[arrivalTimeLabel release];
	[ticketStateLabel release];
    [departStationLabel release];
    [arriveStationLabel release];
    [capinLabel release];
    [goOrBackTypeLabel release];
    [goOrBackBg release];
    
	[super dealloc];
}


@end
